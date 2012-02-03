#!/bin/sh
set -e

./ensure_gpg.sh
cd ~/.ssh

tar -cvzf ssh.tar.gz id_rsa id_dsa id_rsa.pub id_dsa.pub config bengoa.pem

gpg -r "David Bengoa" -e ssh.tar.gz
rm ssh.tar.gz

s3cmd put ssh.tar.gz.gpg s3://bengoa
rm ssh.tar.gz.gpg
