#!/bin/sh

cd ~/Music
s3cmd sync . s3://bengoa/musica/

