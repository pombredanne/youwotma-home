#!/bin/bash


if [ x"$1" = x"wireless" ] && [ x"$2" = x"alumnos" ]
then
    ratpoison -c "echo Connected alumnos [proxyon]"
    sudo python /home/carl/dev/ratpoison/wifi.py proxy
else
    ratpoison -c "echo Connected: $1 $2 $3 $4 [proxyoff]"
    sudo python /home/carl/dev/ratpoison/wifi.py noproxy
fi

