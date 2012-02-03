#!/bin/bash
set -e

st=" "

/home/carl/dev/ratpoison/wallpaper.sh &

/home/carl/dev/ratpoison/xflux  -l 36.6 -g -4.5

set +e
sudo /home/carl/dev/ratpoison/startup-root.sh
set -e

/usr/bin/firefox &

if [ `cat /home/carl/.pcname` == "portatil" ]
then
    xinput set-prop 12 "Synaptics Tap Time" 0 || xinput set-prop 14 "Synaptics Tap Time" 0
fi

ratpoison -c 'echo Todo iniciado'

