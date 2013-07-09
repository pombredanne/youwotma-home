#!/bin/bash

confirm "install oh-my-zsh" && {
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    mkln bengoa.zsh-theme ~/.oh-my-zsh/themes/bengoa.zsh-theme
    mkln .zshrc ~/.zshrc
    chsh -s /bin/zsh
}

