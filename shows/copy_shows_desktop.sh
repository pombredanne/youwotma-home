#!/bin/bash

set -e

while ! ping -c 1 192.168.0.50
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
    ssh laptop $ARGS < /dev/null
    return $?
}

cd /var/lib/transmission-daemon/downloads/
find . -size +50M -and \( -iname "*.avi" -or -iname "*.mkv" -or -iname "*.mp4" \) | while read show
do
    sub=${show%.*}.srt
    name=`basename "$show"`
    subname=`basename "$sub"`
    remoteshow="/home/carl/Downloads/shows/$name"
    remotesub="/home/carl/Downloads/shows/$subname"
    action=x`sshp show_status "$remoteshow"`
    echo "$name => $action"
    if [ $action = xcopy ]
    then
        [ -e "$sub" ] && scp "$sub" laptop:/home/carl/Downloads/shows/
        scp "$show" laptop:/home/carl/Downloads/shows/
    elif [ $action = xremove ]
    then
        sshp rm -f "$remoteshow" "$remotesub" || echo "imposible borrar $show del portatil"
        rm "$show" || echo "Imposible borrar $show"
        [ -e "$sub" ] && rm "$sub"
    elif [ $action = xsub ]
    then
        [ -e "$sub" ] && scp "$sub" laptop:/home/carl/Downloads/shows/
    elif [ ! $action = xnoop ]
    then
        echo "Unknown show status $action"
        exit 1
    fi
done
