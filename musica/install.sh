#!/bin/sh

confirm "download music library?" && {
    [ ! -e ~/Music ] && mkdir ~/Music/
    cd ~/Music
    s3cmd sync s3://bengoa/musica/ .
}


