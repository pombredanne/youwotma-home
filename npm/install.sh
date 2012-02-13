#!/bin/bash

confirm "install npm" && {
    curl http://npmjs.org/install.sh | sudo sh
    sudo npm install --global jshint
}

