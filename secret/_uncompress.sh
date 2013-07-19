#!/bin/bash
set -e
# Uncompress functions, this will be packed on top of the uncompression script

echo "Installing system..."

export TMPDIR=`mktemp -d /tmp/selfextract.XXXXXX`

ARCHIVE=`awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' $0`

echo "Extracting files..."
tail -n+$ARCHIVE $0 | tar xzv -C "$TMPDIR"

CDIR=`pwd`
cd "$TMPDIR"



install_firefox_profile(){
    echo "Installing firefox profile..."
    [ -e $HOME/.mozilla/firefox/profiles.ini ] && mv $HOME/.mozilla/firefox/profiles.ini $HOME/.mozilla/firefox/profiles.ini.bak
    [ -d $HOME/.mozilla/firefox/ffxdefault ] && {
        echo "ffxdefault profile already exists"
        echo "Moving to new location"
        mv $HOME/.mozilla/firefox/ffxdefault $HOME/.mozilla/firefox/ffxdefault.bak
    }
    mv -b firefox/profiles.ini /home/carl/.mozilla/firefox/profiles.ini
}

install_ssh(){
    echo "Installing ssh files..."
    cd ssh
    for file in *
    do
        [ -e "$HOME/.ssh/$file" ] && {
            echo "$file exists, backing up"
            mv "$HOME/.ssh/$file" "$HOME/.ssh/$file.bak"
        }
        mv "$file" "$HOME/.ssh/$file"
    done
    cd ..
}

install_mpdscribbe(){
    cd mpd
    sudo mv -b mpdscribble.conf /etc/mpdscribble.conf
    sudo chmod 640 /etc/mpdscribble.conf
    cd ..
}

clone_repos(){
    mkdir -p /home/carl/dev/
    cd /home/carl/dev/
    which git || {
        echo "Git not installed, install git first... (press a key to continue)"
        read
    }
    git clone "git@github.com:YouWoTMA/youwotma-home.git"
    cd youwotma-home
    bash ppa-laptop
    apt-get install `cat paquetes-laptop`
    ./install.sh
    cd "$TMPDIR"
}

wicd(){
    sudo mkdir -p /etc/wicd
    for setting in wireless wired manager
    do
        sudo mv -b "wicd/$setting-settings.conf" "/etc/wicd/$setting-settings.conf"
        sudo chmod 600 "/etc/wicd/$setting-settings.conf"
    done
}

lftp(){
    sudo mkdir -p ~/.lftp/
    for file in bookmarks cwd_history rl_history
    do
        mv -b "lftp/$file" "~/.lftp/$file"
        chmod 600 "~/.lftp/$file"
    done
}

skype(){
    [ -e ~/.Skype/ ] && mv ~/.Skype/ ~/Skype_bak
    mv skype ~/.Skype/
}

dropbox(){
    sudo mkdir -p ~/.dropbox/
    for file in config.db config.dbx
    do
        mv -b "dropbox/$file" "~/.dropbox/$file"
        chmod 600 "~/.dropbox/$file"
    done
}

cleanup(){
    echo "Deleteng tmp files"
    cd "$CDIR"
    rm -rf "$TMPDIR"

    exit 0
}

