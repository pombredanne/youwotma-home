#!/bin/sh
set -e

st=" "

/home/carl/dev/ratpoison/wallpaper.sh &

sudo /home/carl/dev/ratpoison/startup-root.sh

firefox &

ratpoison -c 'echo Iniciando dropbox...'

xinput set-prop 12 "Synaptics Tap Time" 0 || xinput set-prop 14 "Synaptics Tap Time" 0
ratpoison -c 'echo Todo iniciado'

