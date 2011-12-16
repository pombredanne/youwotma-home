#!/bin/sh
confirm "install firefox/thunderbird" && {

    FIREFOX_URL=`python mozurl.py firefox`
    THUNDER_URL=`python mozurl.py thunderbird`

    cd ~/tmp/

    wget "$FIREFOX_URL" -O firefox.tar.bz2
    wget "$THUNDER_URL" -O thunder.tar.bz2

    tar -xvjf firefox.tar.bz2
    tar -xvjf thunder.tar.bz2
    rm firefox.tar.bz2 thunder.tar.bz2

    [ -e /usr/lib/firefox/ ] && sudo rm -r /usr/lib/firefox/
    [ -e /usr/lib/thunderbird/ ] && sudo rm -r /usr/lib/thunderbird/
    sudo mv firefox /usr/lib/
    sudo mv thunderbird /usr/lib/

    cd /usr/bin/
    sudo rm -f firefox
    sudo rm -f thunderbird


    sudo ln -s ../lib/thunderbird/thunderbird thunderbird
    sudo ln -s ../lib/firefox/firefox firefox

}
