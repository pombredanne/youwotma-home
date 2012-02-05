#!/bin/bash

export ip=192.168.0.44

set -e

while ! ping -c 1 $ip
do
    echo "waiting for laptop..."
done

escape() {
    printf %q "$1"
}

sshp(){
    ARGS=""
    for (( i = 1; i <= $# ; i++ )); do
        eval ARG=\${$i}
        ARGS="$ARGS $(escape "$ARG")"
    done
    ssh $ip $ARGS < /dev/null
    return $?
}

cd /home/carl/Downloads/shows/
find . -iname "*.padres" | while read show
do
    echo "$show"
    show=${show%.padres}
    sub=${show%.*}.srt
    name=`basename "$show"`
    subname=`basename "$sub"`

    [ -e "$sub" ] && scp "$sub" $ip:Escritorio/Peliculas
    scp "$show" $ip:Escritorio/Peliculas
done
