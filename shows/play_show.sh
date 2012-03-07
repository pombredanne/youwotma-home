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
    PLAYER=`zenity --list --text 'THE GAME' --column player 'smplayer' 'mplayer' 'vlc' 'skip'`
fi

disper -d auto -e
ratpoison -c 'only'
ratpoison -c 'hsplit'
ratpoison -c 'focusright'

sub=${show%.*}.srt
if [ "x$PLAYER" = xmplayer ]
then
    mplayer "$show" -fstype fullscreen -ao alsa:device=hw=0.3
    reset
elif [ "x$PLAYER" = xsmplayer ]
then
    smplayer -close-at-end -fullscreen -sub "$sub" "$show"
elif [ "x$PLAYER" = xvlc ]
then
    vlc --fullscreen --play-and-exit --alsa-audio-device hdmi --sub-file "$sub" "$show"
elif [ "x$PLAYER" = xskip ]
then
    echo "Skipping playing..."
else
    echo "invalid player $PLAYER"
fi

ratpoison -c 'focusleft'



ac=`zenity --list --text 'THE GAME' --column action 'nothing' 'padres' 'borrar' 'ver'`

if [ x"$ac" = xpadres ]
then
    rm "$sub"
    mv "$show" padres
    echo "padres" > show
elif [ x"$ac" = xborrar ]
then
    echo "seen" > "$show"
    rm "$sub"
elif [ x"$ac" = xver ]
then
    PLAYER="$PLAYER" play_show "$show"
fi

