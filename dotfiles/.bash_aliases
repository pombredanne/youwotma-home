#!/bin/sh

say() { if [[ "${1}" =~ -[a-z]{2} ]]; then local lang=${1#-}; local text="${*#$1}"; else local lang=${LANG%_*}; local text="$*";fi; mplayer "http://translate.google.com/translate_tts?ie=UTF-8&tl=${lang}&q=${text}" &> /dev/null ; }

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
