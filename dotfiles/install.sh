#!/bin/bash

DOTFILES_ROOT=`pwd`

lnhome(){
    cd ~
    destination="$DOTFILES_ROOT/$1"
    if [ -L $1 ]
    then
        if [ x`readlink $1` == "x$destination" ]
        then
            echo "$PREOK Enlace simbolico ya existente y correcto: $1"
        else
            echo "$PREOK Enlace simbolico $1 apuntando a "`readlink $1`", cambiando a $destination"
            rm -I $1
            ln -s $destination $1
        fi
    else
        if [ -e $1 ]
        then
            echo "Enlace existente $1, Borrar?"
            sudo rm -i $1
        fi

        if [ -e $1 ]
        then
            echo "$PREFAIL Archivo existente $1"
        else
            echo "$PREOK Creando enlace $1"
            ln -s $destination $1
        fi
    fi
}

lnhome .bashrc
lnhome .ratpoisonrc
lnhome .vim
lnhome .vimperatorrc
lnhome .vimperator
lnhome .vimrc
lnhome .bash_aliases
lnhome .inputrc

