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
alias shutupvim='rm -v ~/tmp/*.sw* /var/tmp/*.sw*'

export CLICOLOR=1
export LS_COLORS=exfxcxdxbxegedabagacad

cd() { builtin cd "$@"; ls; }

export HISTCONTROL=erasedups  # Removes duplicate entires
export HISTSIZE=10000  # Increase command history
shopt -s histappend  # Ensures all history is saved
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND} history -n" #Record history at every command


set completion-ignore-case on

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
export -f parse_git_branch
export PS1="\W \[\033[33m\]\$(parse_git_branch)∆†∆\[\033[00m\]\[\033[00m\] "

export R_HISTFILE=~/.Rhistory

[ -f ~/.bashrc_local ] && . ~/.bashrc_local
[ -f ~/.bash_profile.local ] && . ~/.bash_profile.local

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
source /usr/local/opt/autoenv/activate.sh

function cpwd {
  pwd | tr -d '\n' | pbcopy
}

function pshead {
  ps aux | head -1; ps aux | grep "\b$1\b"
}

git config --global pull.rebase true

export PYTHONSTARTUP=$HOME/.pystartup

source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
