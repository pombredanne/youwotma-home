#!/bin/sh

ranger() {
   command ranger --fail-unless-cd $@ &&
   cd "$(grep \^\' ~/.config/ranger/bookmarks | cut -b3-)"
}

o(){
    if [ $# = 0 ]
    then
        nautilus --no-desktop "`pwd`"
    elif [ -d "$1" ]
    then
        nautilus --no-desktop "$1"
    else
        gnome-open "$1"
    fi
}


killwicd(){
    kill -9 `ps -A -f | grep wicd | grep -v grep | awk '{ print $2 }'`
}

# Para abrir nuevos buffers en una nueva pestaña de una instancia ya 
# abierta de gvim
alias gvim='gvim --remote-tab-silent'
alias gato=cat
alias ll='ls -lahtr'
alias l='ranger'
alias sas='sudo aptitude search'
alias sai='sudo apt-get install'
alias rm='rm -I'
