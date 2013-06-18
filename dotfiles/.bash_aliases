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

# J2
export JPY=/home/carl/dev/youwotma-home/j2/j.py
/home/carl/dev/youwotma-home/j2/j.sh          # provides the j() function

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

export PATH=$HOME/dev/invenio-devscripts:/opt/invenio/bin:$PATH
export CFG_INVENIO_HOSTNAME=precise32
export CFG_INVENIO_DOMAINNAME=localhost
export CFG_INVENIO_ADMIN=dbengoar@cern.ch
export CFG_INVENIO_SRCDIR=~/dev/invenio
export CFG_INVENIO_PREFIX=/opt/invenio
export CFG_INVENIO_PORT_HTTP=80
export CFG_INVENIO_PORT_HTTPS=443
export CFG_INVENIO_USER=carl
export CFG_INVENIO_ADMIN=dbengoar@cern.ch
export CFG_INVENIO_DATABASE_NAME=invenio
export CFG_INVENIO_DATABASE_USER=invenio
export CFG_INVENIO_APACHECTL=/etc/init.d/apache2
export CFG_INVENIO_MYSQLCTL=/etc/init.d/mysql
export CFG_INVENIO_VIRTUALENVS=~/.virtualenvs 
export CFG_INVENIO_BIBSCHED_USER=carl

