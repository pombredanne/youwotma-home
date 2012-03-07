#!/bin/sh

echo $# $@ >> ~/tmp/test

if [ ! -e "$1" ]
then
    echo "copy"
elif [ `stat -c%s "$1"` -lt 10 ]
then
    cnts=`cat "$1"`
    if [ x$cnts = xseen ]
    then
        echo "remove"
    elif [ x$cnts = xpadres ]
    then
        echo "noop"
    else
        echo "copy"
    fi
else
    sub=${1%.*}.srt
    if [ -e "$sub" ] && [ `stat -c%s "$sub"` -gt 10 ]
    then
        echo "noop"
    else
        echo "sub"
    fi
fi
