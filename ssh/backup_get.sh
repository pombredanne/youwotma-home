#!/bin/sh
set -e

./ensure_gpg.sh
cd ~/.ssh

s3cmd get s3://bengoa/ssh.tar.gz.gpg

gpg -r "David Bengoa" -d ssh.tar.gz.gpg > ssh.tar.gz
rm ssh.tar.gz.gpg

tar -xvzf ssh.tar.gz
rm ssh.tar.gz
