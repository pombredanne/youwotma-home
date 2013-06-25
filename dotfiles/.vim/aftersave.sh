#!/bin/bash

if [[ $1 == *.scss ]]
then
    /home/carl/dev/scripts/compilescss.py "$1"
#elif [[ $1 == *.less ]]
#then
#    /home/carl/dev/scripts/compileless.py "$1"
fi




if [[ $1 == /home/carl/dev/bacardi/* ]]
then
    restart-browsers
elif [[ $1 == /home/carl/dev/instabed/* ]]
then
    restart-browsers
elif [[ $1 == /home/carl/dev/poi/* ]]
then
    restart-browsers
#elif [[ $1 == /home/carl/dev/throuthemirror/* ]]
#then
    #restart-browsers
elif [[ $1 == /home/carl/dev/4sq/* ]]
then
    scp $1 hoyga:/var/www/4sq &
elif [[ $1 == /home/carl/dev/Iris/irisapp/* ]]
then
    cd /home/carl/dev/Iris/irisapp/
    ./run.sh &
fi

