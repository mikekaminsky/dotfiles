#!/bin/sh
tmux new-session -d 'vim'
tmux split-window -h 
tmux split-window -v -p 25
tmux -2 attach-session -d 
tmux selectp -t 0
