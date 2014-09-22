export EDITOR="vim"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gp="git pull --rebase"
alias gmmro="git merge master -s recursive -X ours"
alias v="mvim"
alias be="bundle exec"
alias r="r --no-save"
alias R="r --no-save"

export CLICOLOR=1
export LS_COLORS=exfxcxdxbxegedabagacad

cd() { builtin cd "$@"; ls; }

export HISTCONTROL=erasedups  # Removes duplicate entires
export HISTSIZE=10000  # Increase command history
shopt -s histappend  # Ensures all history is saved
PROMPT_COMMAND='history -a' #Record history at every command

set completion-ignore-case on

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
export -f parse_git_branch
export PS1="\W \[\033[33m\]\$(parse_git_branch)∆†∆\[\033[00m\]\[\033[00m\] "

export R_HISTFILE=~/.Rhistory

[ -f ~/.bashrc_local ] && . ~/.bashrc_local
[ -f ~/.bash_profile.local ] && . ~/.bash_profile.local
