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
```

Install submodules

```
  git submodule sync
  git submodule update --init
```

To Do:
___________________

1. Finish install.sh (set up links)
