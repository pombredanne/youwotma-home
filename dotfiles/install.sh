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
mkdir -p ~/.config/
lnhome .config/ranger

