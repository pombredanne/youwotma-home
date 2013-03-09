#!/bin/bash

confirm "copy mpd.conf?" && {
    sudo cp mpd.conf /etc/mpd.conf
    mkdir -p ~/.mpd
}

