#!/bin/sh
echo "install youtube-dl? (y/n)"
read FXINSTALL
if [ x"$FXINSTALL" = "xy" ]
then
    sudo wget -O /usr/bin/youtube-dl 'https://raw.github.com/rg3/youtube-dl/master/youtube-dl'
    sudo chmod +x /usr/bin/youtube-dl
fi

