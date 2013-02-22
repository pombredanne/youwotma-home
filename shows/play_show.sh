#!/bin/bash

FOLDER=/var/lib/transmission-daemon/downloads

set -e

source /home/carl/dev/youwotma-home/utils.sh

if [ $# = 1 ]
then
    show=$1
else
    cd "$FOLDER"
    ranger --choosefile=/tmp/playshow "$FOLDER"
    if [ -f /tmp/playshow ]
    then
        show=`cat /tmp/playshow`
        rm /tmp/playshow
    else
        exit 1
    fi
fi

echo "$show"

if [ "x$PLAYER" = x ]
then
    PLAYER=`zenity --list --text 'THE GAME' --column player 'smplayer' 'mplayer' 'vlc' 'nexus7' 'skip'`
fi


display_count=`disper -l | wc -l`
display_count=$((display_count/2))

if true && [ $display_count -gt 1 ] && [ "x$PLAYER" != xnexus7 ] && [ "x$PLAYER" != xskip ]
then
    disper -d auto -e
    ratpoison -c 'only'
    ratpoison -c 'hsplit'
    ratpoison -c 'focusright'
fi

sub=${show%.*}.srt
if [ "x$PLAYER" = xmplayer ]
then
    ((display_count > 1)) && audioparm="-ao alsa:device=hw=0.3"
    mplayer "$show" -fstype fullscreen $audioparm
    reset
elif [ "x$PLAYER" = xsmplayer ]
then
    smplayer -close-at-end -fullscreen -sub "$sub" "$show"
elif [ "x$PLAYER" = xvlc ]
then
    ((display_count > 1)) && audioparm="--alsa-audio-device hdmi"
    vlc --fullscreen --play-and-exit $audioparm --sub-file "$sub" "$show"
elif [ "x$PLAYER" = xnexus7 ]
then
    sub_base=`basename "$sub"`
    show_base=`basename "$show"`
    mtp-sendfile "$sub" "$sub_base"
    mtp-sendfile "$show" "$show_base"
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
    echo "padres" > "$show"
elif [ x"$ac" = xborrar ]
then
    #echo "seen" > "$show"
    sudo rm "$show" "$sub"
elif [ x"$ac" = xver ]
then
    PLAYER="$PLAYER" play_show "$show"
fi

