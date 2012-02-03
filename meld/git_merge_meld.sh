#!/bin/bash

# Handles proper use of Meld from Git. 
# 
# Instead of launching meld with $MERGED as the base revision, this 
# script makes a copy of $BASE and handles copying the result back 
# to $MERGED if the result was saved. 

# As an extra tweak, it also presents branch names (if known) as 
# the file name prefix, instead of just "LOCAL" and "REMOTE".

# To use, place this script in your path, make it executable, then run
#   git config --global merge.tool meldscript
#   git config --global mergetool.meldscript.cmd git_merge_meld.sh $LOCAL $BASE $REMOTE $MERGED

LOCAL="$1"
BASE="$2"
REMOTE="$3"
MERGED="$4"

WORK=$(mktemp -d)
FILE="$(basename $MERGED)"
OUTPUT="$WORK/BASE"
mkdir "$OUTPUT"

# Creates temp file names which are prefixed with the branch name.
# TODO(mrenouf): If branches have no names (merging directly with a 
# revision), then fall back to "REMOTE".

WORK_LOCAL="$WORK/$(git name-rev ORIG_HEAD | cut -d' ' -f 2)"
mkdir "$WORK_LOCAL"

WORK_REMOTE="$WORK/$(git name-rev MERGE_HEAD | cut -d' ' -f 2)"
mkdir "$WORK_REMOTE"

cp "$LOCAL" "$WORK_LOCAL/${FILE}"
cp "$REMOTE" "$WORK_REMOTE/${FILE}"
cp "$BASE" "$OUTPUT/${FILE}"

meld "$WORK_LOCAL/${FILE}" "$OUTPUT/${FILE}" "$WORK_REMOTE/${FILE}"

# meld doesn't appear to have any meaningful exit status
# so just check whether the target was saved, then give
# git an indication of this via exit status from this script

if [[ "$OUTPUT/${FILE}" -nt "$MERGED/${FILE}" ]]; then
  cp "$OUTPUT/${FILE}" "$MERGED"
  rm -rf "$WORK"
  exit 0
fi

rm -rf "$WORK"
exit 255
