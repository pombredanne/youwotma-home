#!/bin/sh

confirm "install dropbox" && {
    cd ~/tmp/
    sudo wget -O /usr/bin/dropbox.py "http://www.dropbox.com/download?dl=packages/dropbox.py"
    sudo chmod +x /usr/bin/dropbox.py
    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar -xzf -
}
