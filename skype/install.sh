#!/bin/sh

confirm "install skype" && {
    cd ~/tmp/
    wget 'http://www.skype.com/go/getskype-linux-beta-ubuntu-64' -O skype.deb
    sudo dpkg -i skype.deb
    rm skype.deb
}
