#!/bin/bash

lnhome(){
    mkln "$1" ~/"$1"
}

lnhome .bashrc
lnhome .ratpoisonrc
lnhome .vim
lnhome .vimperatorrc
lnhome .vimperator
lnhome .vimrc
lnhome .bash_aliases
lnhome .inputrc
lnhome .sqliterc
lnhome .wgetrc
mkdir -p ~/.config/
lnhome .config/ranger

confirm "Copy wgetrc & 95Proxy (apt-proxy)" && {
    sudo cp wgetrc /etc/
    sudo cp 95Proxy /etc/apt/apt.conf.d/
}

