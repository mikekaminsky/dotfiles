#Michael's Dotfiles

To Install:
___________________

Clone repository

Rename any dotfiles you are currently using (e.g., .rprofile, .vimrc, .bash_profile) to have the .local suffix (e.g., .rprofile.local)

Create symlinks

```
cd ~
ln -s workspace/dotfiles/vim .vim
ln -s workspace/dotfiles/.vimrc .vimrc
ln -s workspace/dotfiles/.bash_profile .bash_profile
ln -s workspace/dotfiles/.inputrc .inputrc
ln -s workspace/dotfiles/.pystartup .pystartup
ln -s workspace/dotfiles/.psqlrc .psqlrc
ln -s workspace/dotfiles/.rprofile .rprofile
```

Install submodules

```
cd ~/workspace/dotfiles
git submodule sync
git submodule update --init
```

Install other things (optional).
```
#Install brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#Install cask
brew install caskroom/cask/brew-cask

#Install CLI utilities
brew install git
brew install macvim
brew install markdown
brew install autoenv
brew install postgresql
brew install the_silver_searcher
brew install tig
brew install python
brew tap homebrew/science
brew install r
brew install watch
brew install pandoc
brew install htop
brew install tree
brew install wget
brew tap tldr-pages/tldr
brew install tldr

#Install Other Applications
brew cask install spectacle
brew cask install alfred  
brew cask install dash
brew cask install evernote
brew cask install slack
brew cask install caffeine
brew cask install mactex
brew cask install karabiner
```


To Do:
___________________

1. Finish install.sh (set up links)
