#!/bin/sh
# Gather every claude pane (tagged `@role claude` by dev-tmux) in the current
# tmux session into one tiled "claude-hub" window -- or send them back to the
# windows they came from. Bound to a single toggle key in tmux.conf.
#
# Reversibility: before moving a pane we stamp its origin window id and that
# window's layout onto the pane (`@home_win`, `@home_layout`). Pane options
# travel with the pane across join-pane/break-pane and pane ids stay stable,
# so un-gather can put each pane back exactly and restore the home layout.
#
# Testability: all tmux calls go through $TMUX_BIN (default "tmux") and the
# target session via $GATHER_SESSION, so the test harness can point both at an
# isolated `tmux -L gathertest` server. $TMUX_BIN is intentionally unquoted on
# use so a value like "tmux -L gathertest" word-splits into command + args.

set -u

TMUX_BIN="${TMUX_BIN:-tmux}"
HUB_NAME=claude-hub

session() { echo "${GATHER_SESSION:-$($TMUX_BIN display-message -p '#{session_name}')}"; }
claude_panes() { # pane ids of @role=claude panes in the session
  $TMUX_BIN list-panes -s -t "$1" -F '#{pane_id} #{@role}' | awk '$2=="claude"{print $1}'
}
gathered_panes() { # claude panes that carry an @home_win stamp (i.e. were moved)
  $TMUX_BIN list-panes -s -t "$1" -F '#{pane_id} #{@role} #{@home_win}' \
    | awk '$2=="claude" && $3!=""{print $1}'
}
hub_id() { $TMUX_BIN show-options -t "$1" -v @claude_hub 2>/dev/null; }
win_exists() { $TMUX_BIN list-windows -t "$1" -F '#{window_id}' | grep -qx "$2"; }

# Restore window $1 to saved layout $2. select-layout fixes the cell geometry
# but fills cells in pane-index order, ignoring the pane ids baked into the
# layout string -- so a rejoined pane lands in the wrong cell. We then sort the
# panes into the layout's leaf order with swap-pane. Leaf pane ids are the
# `WxH,X,Y,ID` quads (containers end in `{`/`[`, so have no trailing ,ID).
restore_layout() {
  win="$1"; lay="$2"
  $TMUX_BIN select-layout -t "$win" "$lay"
  desired=$(printf '%s\n' "$lay" | grep -oE '[0-9]+x[0-9]+,[0-9]+,[0-9]+,[0-9]+' | sed -E 's/.*,//')
  i=1
  for d in $desired; do
    if $TMUX_BIN list-panes -t "$win" -F '#{pane_id}' | grep -qx "%$d"; then
      cur=$($TMUX_BIN list-panes -t "$win" -F '#{pane_id}' | sed -n "${i}p")
      [ "%$d" != "$cur" ] && $TMUX_BIN swap-pane -d -s "%$d" -t "$cur"
    fi
    i=$((i + 1))
  done
}

gather() {
  s="$1"
  if [ -n "$(hub_id "$s")" ]; then
    $TMUX_BIN display-message "claude-gather: already gathered"
    return 0
  fi
  panes=$(claude_panes "$s")
  if [ -z "$panes" ]; then
    $TMUX_BIN display-message "claude-gather: no claude panes to gather"
    return 0
  fi

  # Stamp every pane's origin BEFORE moving any, so layouts capture the
  # intact home windows.
  for p in $panes; do
    win=$($TMUX_BIN display-message -p -t "$p" '#{window_id}')
    lay=$($TMUX_BIN display-message -p -t "$p" '#{window_layout}')
    $TMUX_BIN set-option -p -t "$p" @home_win "$win"
    $TMUX_BIN set-option -p -t "$p" @home_layout "$lay"
  done

  # First pane becomes the hub window; the rest join it.
  # shellcheck disable=SC2086
  set -- $panes
  first="$1"; shift
  $TMUX_BIN break-pane -d -s "$first" -n "$HUB_NAME"
  hub=$($TMUX_BIN display-message -p -t "$first" '#{window_id}')
  for p in "$@"; do
    $TMUX_BIN join-pane -d -s "$p" -t "$hub"
  done
  $TMUX_BIN select-layout -t "$hub" tiled
  $TMUX_BIN set-option -t "$s" @claude_hub "$hub"
  $TMUX_BIN select-window -t "$hub"
}

ungather() {
  s="$1"
  panes=$(gathered_panes "$s")
  if [ -z "$panes" ]; then
    $TMUX_BIN display-message "claude-gather: nothing to un-gather"
    $TMUX_BIN set-option -u -t "$s" @claude_hub 2>/dev/null || true
    return 0
  fi
  for p in $panes; do
    home=$($TMUX_BIN show-options -p -t "$p" -v @home_win)
    lay=$($TMUX_BIN show-options -p -t "$p" -v @home_layout)
    if win_exists "$s" "$home"; then
      $TMUX_BIN join-pane -d -s "$p" -t "$home"
      restore_layout "$home" "$lay"
    else
      # Home window is gone: rescue the pane into its own window rather
      # than lose it.
      $TMUX_BIN break-pane -d -s "$p" -n claude-orphan
    fi
    $TMUX_BIN set-option -p -u -t "$p" @home_win
    $TMUX_BIN set-option -p -u -t "$p" @home_layout
  done
  $TMUX_BIN set-option -u -t "$s" @claude_hub 2>/dev/null || true
}

cmd="${1:-toggle}"
s=$(session)
case "$cmd" in
  gather)   gather "$s" ;;
  ungather) ungather "$s" ;;
  toggle)   if [ -n "$(hub_id "$s")" ]; then ungather "$s"; else gather "$s"; fi ;;
  *) echo "usage: claude-gather.sh [gather|ungather|toggle]" >&2; exit 2 ;;
esac
