# Handy Aliases
export EDITOR="vim"
alias gs="git status"
alias ga="git add"
alias gc="git commit -v"
alias gcm="git commit -m"
alias gco="git checkout"
alias gp="git pull --rebase"
alias gmmro="git merge master -s recursive -X ours"
alias v="mvim"
alias be="bundle exec"
alias r="r --no-save"
alias R="r --no-save"
alias weather="curl -4 http://wttr.in/New_York"
alias moon="curl -4 http://wttr.in/Moon"
alias password="python -c 'import uuid; print(uuid.uuid4().hex.title())'"

# Better Colors
export CLICOLOR=1
export LS_COLORS=exfxcxdxbxegedabagacad

# Basic terminal interactions
export HISTCONTROL=erasedups  # Removes duplicate entires
export HISTSIZE=100000  # Increase command history
export HISTFILESIZE=1000000000
shopt -s histappend  # Ensures all history is saved
# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
#PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND} history -n" #Record history at every command

alias hgrep='history|grep --color' # Search history


set completion-ignore-case on

# Handy functions
cd() { builtin cd "$@"; ls; }

function cpwd {
  pwd | tr -d '\n' | pbcopy
}

function pshead {
  ps aux | head -1; ps aux | grep "\b$1\b"
}

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Command Line Git Status
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
export -f parse_git_branch
export PS1="\W \[\033[33m\]\$(parse_git_branch)∆†∆\[\033[00m\]\[\033[00m\] "

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
source /usr/local/opt/autoenv/activate.sh

# Python crap
export PYTHONSTARTUP=$HOME/.pystartup

# Ruby crap
eval "$(rbenv init -)"

# R crap
export R_HISTFILE=~/.Rhistory

# Set up virtual environments
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

# Source local configurations
[ -f ~/.bashrc_local ] && . ~/.bashrc_local
[ -f ~/.bash_profile.local ] && . ~/.bash_profile.local
