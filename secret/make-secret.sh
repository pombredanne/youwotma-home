#!/bin/bash
set -e

# This scripts creates a self-extracting bash script with all the
# configurations that I can't publish on github (passwords, etc...)
# To install the configurations in other system, just run the script

source "$HOME/dev/youwotma-home/utils.sh"

TMP=`mktemp -d`
cd "$TMP"

outfile="$HOME/install-secret.sh"

cat "$HOME/dev/youwotma-home/secret/_uncompress.sh" > $outfile

gather_files_install_ssh(){
    mkdir ssh
    for file in authorized_keys config id_dsa id_dsa.pub id_rsa id_rsa.pub
    do
        cp "$HOME/.ssh/$file" ssh
    done
}

gather_files_install_firefox_profile(){
    mkdir firefox
    cp "$HOME/.mozilla/firefox/profiles.ini" firefox
    cp -r "$HOME/.mozilla/firefox/ffxdefault/" firefox

}

gather_files_install_mpdscribbe(){
    mkdir mpd
    sudo cp /etc/mpdscribble.conf mpd
    sudo chmod 666 mpd/mpdscribble.conf
}

gather_files_clone_repos(){
    true
}

gather_files_wicd(){
    mkdir wicd
    for setting in wireless wired manager
    do
        sudo cp "/etc/wicd/$setting-settings.conf" wicd
        sudo chmod 666 "wicd/$setting-settings.conf"
    done
}

gather_files_lftp(){
    mkdir lftp
    for file in bookmarks cwd_history rl_history
    do
        sudo cp "~/.lftp/$file" lftp
        sudo chmod 666 "lftp/$file"
    done
}

gather_files_skype(){
    sudo cp -r ~/.Skype/ skype
}

gather_files_dropbox(){
    mkdir dropbox
    for file in config.db config.dbx
    do
        sudo cp "~/.dropbox/$file" dropbox
        sudo chmod 666 "dropbox/$file"
    done
}

for function in install_ssh clone_repos install_firefox_profile install_mpdscribbe wicd lftp skype dropbox
do
    confirm "$function" && {
        gather_files_$function
        echo "" >> $outfile
        echo "$function" >> $outfile
    }
done

echo "" >> $outfile
echo "cleanup" >> $outfile
echo "" >> $outfile
echo "__ARCHIVE_BELOW__" >> $outfile

echo "compressing archives"
tar -cf payload.tar ./*
gzip payload.tar

cat payload.tar.gz >> $outfile
cd -
rm -r "$TMP"
chmod +x "$outfile"

