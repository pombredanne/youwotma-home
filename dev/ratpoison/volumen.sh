#!/bin/sh

#Cambia el volumen, y muestra el nuevo volumen por un mensaje de ratpoison

echo "$1"
if [ "$1" = "up" ]
then
	amixer set Master 1+
elif [ "$1" = "mute" ]
then
	amixer set Master 0
else
	amixer set Master 1-
fi

vol=`amixer get Master | grep "%" | sed -r 's/^.*\[([0-9]+)%.*$/\1/'`
ratpoison -c "echo Volumen: $vol%"
