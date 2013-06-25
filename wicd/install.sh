#!/bin/bash

confirm "config wicd?" && {
    cd /etc/wicd/scripts/postconnect/
    [ ! -e postconnect.sh ] && sudo ln -s  /home/carl/dev/youwotma-home/wicd/postconnect.sh postconnect.sh
    cd ../postdisconnect
    [ ! -e postdisconnect.sh ] && sudo ln -s  /home/carl/dev/youwotma-home/wicd/postdisconnect.sh postdisconnect.sh
}


