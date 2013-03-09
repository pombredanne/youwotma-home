#!/bin/bash

confirm "copy transmission settings?" && {
    sudo /etc/init.d/transmission-daemon stop
    sudo cp settings.json /etc/transmission-daemon/settings.json
    sudo /etc/init.d/transmission-daemon start
}

