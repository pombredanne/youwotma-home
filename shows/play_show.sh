#!/bin/bash
set -e

source /home/carl/dev/youwotma-home/utils.sh

if [ $# = 1 ]
then
    show=$1
else
    cd /home/carl/Downloads/shows/
    ranger --choosefile=/tmp/playshow /home/carl/Downloads/shows/
    if [ -f /tmp/playshow ]
    then
        show=`cat /tmp/playshow`
        rm /tmp/playshow
    else
        exit 1
    fi
fi

disper -d auto -e
ratpoison -c 'only'
ratpoison -c 'hsplit'
ratpoison -c 'focusright'

sub=${show%.*}.srt
if [ "x$PLAYER" = xmplayer ]
then
    mplayer "$show" -ao alsa:device=hw=0.3
    reset
else
    smplayer -fullscreen -sub "$sub" "$show"
fi
ratpoison -c 'focusleft'

confirm "marcar como visto" && {
    if confirm "enviar padres"
    then
        touch "$1".padres
    else
        echo "seen" > "$1"
    fi
    rm "$sub"
}
