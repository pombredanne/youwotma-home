#!/bin/bash
set -e

st=" "

/home/carl/dev/ratpoison/wallpaper.sh &

sudo /home/carl/dev/ratpoison/startup-root.sh

firefox &

if [ `cat /home/carl/.pcname` == "portatil" ]
then
    xinput set-prop 12 "Synaptics Tap Time" 0 || xinput set-prop 14 "Synaptics Tap Time" 0
fi

ratpoison -c 'echo Todo iniciado'

