#Michael's Dotfiles

To Install:
___________________

Clone repository

Rename any dotfiles you are currently using (e.g., .rprofile, .vimrc, .bash_profile) to have the .local suffix (e.g., .rprofile.local)

Create symlinks

```
#Install brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

```bash
#Install CLI utilities
brew install python3
brew install r
brew install fzf
brew install git
brew install direnv
brew install postgresql
brew install tig
brew install ack
brew install tmux
brew install bash-completion
brew install reattach-to-user-namespace
brew install the_silver_searcher
brew install fd
brew install pre-commit
```

```bash
ln -s workspace/dotfiles/vim ~/.vim
ln -s workspace/dotfiles/.vimrc ~/.vimrc
ln -s workspace/dotfiles/.bash_profile ~/.bash_profile
ln -s workspace/dotfiles/.inputrc ~/.inputrc
ln -s workspace/dotfiles/.pystartup ~/.pystartup
ln -s workspace/dotfiles/.psqlrc ~/.psqlrc
ln -s workspace/dotfiles/.rprofile ~/.rprofile
ln -s workspace/dotfiles/gitconfig ~/.gitconfig
ln -s workspace/dotfiles/.gitignore ~/.gitignore
ln -s workspace/dotfiles/tmux.conf ~/.tmux.conf
ln -s workspace/dotfiles/.bash_sessions_disable ~/.bash_sessions_disable
ln -s ~/workspace/dotfiles/dev-tmux.sh /usr/local/bin/dev-tmux.sh
ln -s ~/workspace/dotfiles/aws-ssh.sh /usr/local/bin/aws-ssh.sh
mkdir ~/.config
ln -s ~/workspace/dotfiles/.config/flake8 ~/.config/flake8
```

Get ready to python 

```bash
pip3 install virtualenv
pip3 install virtualenvwrapper
```

Install vim plugins with 

```vim
:PlugInstall
```
