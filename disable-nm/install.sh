#!/bin/bash
confirm "disable nwtwork manager" && {
    sudo mv /etc/init/network-manager.conf /etc/init/network-manager.conf-disabled
}
