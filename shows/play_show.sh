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

if [ "x$PLAYER" = x ]
then
    PLAYER=`zenity --list --text 'THE GAME' --column player 'smplayer' 'mplayer' 'vlc'`
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
elif [ "x$PLAYER" = xsmplayer ]
then
    smplayer -fullscreen -sub "$sub" "$show"
elif [ "x$PLAYER" = xvlc ]
then
    vlc --fullscreen --alsa-audio-device hdmi --sub-file "$sub" "$show"
else
    echo "invalid player $PLAYER"
fi

ratpoison -c 'focusleft'



ac=`zenity --list --text 'THE GAME' --column action 'nothing' 'padres' 'borrar'`

if [ x"$ac" = xpadres ]
then
    touch "$show".padres
    rm "$sub"
elif [ x"$ac" = xborrar ]
then
    echo "seen" > "$show"
    rm "$sub"
fi

