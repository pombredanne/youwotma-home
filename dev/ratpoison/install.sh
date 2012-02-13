#!/bin/sh

lnbin youtubesong youtubesong
lnbin ratopen.py ratopen
lnbin browser-restart.py restart-browsers

echo "Añadir la linea"
echo "carl    ALL= PASSWD:ALL, NOPASSWD:/home/carl/dev/ratpoison/startup-root.sh, /home/carl/dev/ratpoison/wifi-gk"
echo "a /etc/sudoers (sudo visudo) si fuera necesario"
confirm "Ejecutar sudo visudo ahora" && sudo visudo

