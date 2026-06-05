#!/bin/sh
# Lay out a dev window: editor on the left; right side stacked with
# claude (2/3, top) and a plain shell (1/3, bottom). Focus ends on claude.
layout() {
  tmux split-window -h
  tmux select-pane -L
  tmux send-keys 'vim' Enter
  tmux select-pane -R
  tmux split-window -v -l 33%
  tmux select-pane -U
  tmux set -p @role claude   # tag so it can be found later (see claude-panes tooling)
  tmux send-keys 'claude' Enter
}

if [ -n "$TMUX" ]; then
  # Already inside tmux: lay out the current window.
  layout
else
  # Outside tmux: create a detached session, lay it out, then attach.
  tmux new-session -d
  layout
  tmux -2 attach-session -d
fi
