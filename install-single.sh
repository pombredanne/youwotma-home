#!/bin/bash

[ ! -x "$1/install.sh" ] && {
    echo "$1/install.sh not found/ insufficient permissions"
    exit 1
}

source utils.sh

cd $1
if [ x"$2" = 'x-y' ]
then
    confirm(){
        return 0
    }
fi

source "install.sh"

