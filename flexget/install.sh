#!/bin/bash

confirm "isntall flexget" && {
    sudo pip install flexget
    sudo pip install transmissionrpc
    [ -d ~/.flexget ] || mkdir ~/.flexget
    cp config.yml ~/.flexget
}
