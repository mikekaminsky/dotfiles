export EDITOR="vi"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gmmro="git merge master -s recursive -X ours"
alias v="mvim"


parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
export -f parse_git_branch
export PS1="\W \[\033[33m\]\$(parse_git_branch)\[\033[00m\]\[\033[00m\] "

