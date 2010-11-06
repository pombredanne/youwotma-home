# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Para abrir nuevos buffers en una nueva pestaña de una instancia ya 
# abierta de gvim

alias gvim='gvim --remote-tab-silent'

# Esto lo movi a /etc/env.d/ (gentoo) o /etc/environment
# Lo he dejado aqui para acordarme

# Pone las variables de estado del proxy segun ~/.proxy
if false
then
    proxy=`cat /home/carl/.proxy`
    if [ "$proxy" == "" ]
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
fi
