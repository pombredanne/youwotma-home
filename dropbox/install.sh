#!/bin/sh

confirm "install dropbox" && {
    cd ~/tmp/
    sudo wget -O /usr/bin/dropbox.py "http://www.dropbox.com/download?dl=packages/dropbox.py"
    sudo chmod +x /usr/bin/dropbox.py
    # TODO Install daemon
}
