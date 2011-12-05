#!/bin/sh

[ ! -e ~/tmp/ ] && mkdir ~/tmp/
cd ~/tmp

wget 'http://nongnu.org/ranger/ranger-stable.tar.gz'
tar xvf ranger-stable.tar.gz
cd ranger-*
sudo make install
cd ..
sudo rm -r ranger-*
