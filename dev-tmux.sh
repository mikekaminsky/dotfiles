#!/bin/sh
tmux new-session -d 
tmux split-window -h 
tmux split-window -v -p 26
tmux select-pane -L
tmux send-keys 'vim' Enter
tmux -2 attach-session -d 
