#!/bin/sh

install_mozilla(){
    URL=`python mozurl.py "$1" "$2"`
    print $URL
    cd ~/tmp/
    wget "$URL" -O firefox.tar.bz2
    tar -xvjf firefox.tar.bz2
    rm firefox.tar.bz2
    [ -e "/usr/lib/$1/" ] && sudo rm -r "/usr/lib/$1/"
    sudo mv $1 /usr/lib/
    cd /usr/bin/
    sudo rm -f $1
    sudo ln -s ../lib/$1/$1 $1
}

confirm "install firefox" && install_mozilla firefox beta
confirm "install thunderbird" && install_mozilla thunderbird nightly

sudo aptitude hold firefox || echo "holding firefox failled"
sudo aptitude hold firefox-gnome-support || echo "holding firefox failled"
sudo aptitude hold firefox-globalmenu || echo "holding firefox failled"
sudo aptitude hold firefox-locale-en || echo "holding firefox failled"
sudo aptitude hold thunderbird || echo "holding thunderbird failled"

sudo update-alternatives --set x-www-browser /usr/bin/firefox
sudo update-alternatives --set gnome-www-browser /usr/bin/firefox

