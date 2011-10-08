#!/bin/sh

ranger() {
   command ranger --fail-unless-cd $@ &&
   cd "$(grep \^\' ~/.config/ranger/bookmarks | cut -b3-)"
}


# Para abrir nuevos buffers en una nueva pestaña de una instancia ya 
# abierta de gvim
alias gvim='gvim --remote-tab-silent'
alias gato=cat
alias ll='ls -lahtr'
alias l='ranger'
alias sas='sudo aptitude search'
alias sai='sudo apt-get install'
