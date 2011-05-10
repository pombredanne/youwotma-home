#!/bin/sh
set -e
sudo /home/carl/dev/ratpoison/startup-root.sh

ratpoison -c 'echo Iniciando dropbox...'
dropboxd &
xinput set-prop 12 "Synaptics Tap Time" 0
ratpoison -c 'echo Todo iniciado'

