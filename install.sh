#!/bin/bash

COLOR_NC='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'

printf "Creating links to dotfiles"
printf "\n"

#cd ~/
# ln -s dotfiles/.bash_profile 
# ln -s dotfiles/.vimrc 
# ln -s dotfiles/.inputrc
# ln -s dotfiles/vim .vim
# ln -s dotfiles/.rprofile

printf "Initializing and updating git submodules..."
printf "\n"

#if (cd $(dirname $0) && git submodule sync &> /dev/null && git submodule update --init &> /dev/null); then
#  printf "\r$COLOR_GREEN"
#  printf "Submodules successfully initialized & updated.\n"
#else
#  printf "\r$COLOR_YELLOW"
#  printf "Submodules could not be initialized/updated.\n"
#fi

printf $COLOR_NC
