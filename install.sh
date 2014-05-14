#!/bin/bash

printf "Creating links to dotfiles"
cd ~/
ln -s dotfiles/.bash_profile 
ln -s dotfiles/.vimrc 

printf "Initializing and updating git submodules..."
if (cd $(dirname $0) && git submodule sync &> /dev/null && git submodule update --init &> /dev/null); then
  printf "\r$COLOR_GREEN"
  printf "Submodules successfully initialized & updated.\n"
else
  printf "\r$COLOR_YELLOW"
  printf "Submodules could not be initialized/updated.\n"
fi

#Install pathogen
#mkdir -p ~/.
