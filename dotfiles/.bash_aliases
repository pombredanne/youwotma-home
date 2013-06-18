#!/bin/sh

# Pone las variables de estado del proxy segun ~/.proxy
proxy=`cat /home/carl/.proxy`
if [ "$proxy" = "" ]
then
    unset http_proxy
    unset HTTP_PROXY
    unset ftp_proxy
    unset FTP_PROXY
    unset HTTPS_PROXY
    unset https_proxy
else
    export http_proxy="http://$proxy/"
    export HTTP_PROXY=$http_proxy
    export ftp_proxy="ftp://$proxy/"
    export FTP_PROXY=$ftp_proxy
    export https_proxy="https://$proxy/"
    export HTTPS_PROXY=$https_proxy
fi

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

# J2
export JPY=/home/carl/dev/youwotma-home/j2/j.py
source /home/carl/dev/youwotma-home/j2/j.sh          # provides the j() function

jj_git(){
    case "x${1:0:1}" in
        xp) git pull ;;
        xu) git pull --rebase && git push ;;
        xs) git status ;;
        xd) git diff ;;
    esac
}

jj(){
    case "x${1:0:1}" in
    xm)
        cd ~/dev/smartspace/microverse/
        case "x${1:1:1}" in
            xm) mysql -u miverse -pmiverse miverse ;;
            xc) compound c ;;
            xs) ./serverdevloop.sh ;;
            xg) jj_git ${1:2} ;;
        esac
        ;;
    xg) jj_git "${1:1}" ;;
    xt) cd /var/lib/transmission-daemon/downloads/ ;;
    xW) gvim --remote-tab-silent ~/.worked ;;
    xw) echo `date '+%s'` $@ >> ~/.worked ;;
    esac
}

killwicd(){
    kill -9 `ps -A -f | grep wicd | grep -v grep | awk '{ print $2 }'`
}

grepr(){
    grep -R "$1" .
}

findg(){
    find . | grep "$1"
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

