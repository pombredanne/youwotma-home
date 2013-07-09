# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="bengoa"

COMPLETION_WAITING_DOTS="true"

plugins=(git colored-man command-not-found debian npm pip)

source $ZSH/oh-my-zsh.sh
source ~/.bash_aliases

HISTSIZE=100000
SAVEHIST=100000
setopt INC_APPEND_HISTORY

function track_cmd(){
    echo `date '+%s'` $(pwd) $(current_branch) >> ~/.workedtracking
}

PS1="$PS1$(track_cmd)"

# Customize to your needs...
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

