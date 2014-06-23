#Michael's Dotfiles

To Install:
___________________

Clone repository into your ~/ directory.

Rename any dotfiles you are currently using (e.g., .rprofile, .vimrc, .bash_profile) to have the .local suffix (e.g., .rprofile.local)

Create links from your ~/ directory to the dotfiles directory. ('ln -s dotfiles/.vimrc .vimrc', 'ln -s dotfiles/vim .vim' etc.)

Run 'git submodule sync' and 'git submodule update --init'


To Do:
___________________

1. Finish install.sh (set up links)
