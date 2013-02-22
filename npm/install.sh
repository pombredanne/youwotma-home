#!/bin/bash

confirm "install npm" && {
    curl -k https://npmjs.org/install.sh | sudo sh
    sudo npm install --global jshint
}

