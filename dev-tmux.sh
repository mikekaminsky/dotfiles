#!/bin/sh
# dev-tmux: open a development window -- editor on the left; right side stacked
# with claude (2/3, top, tagged @role=claude for claude-gather) and a shell
# (1/3, bottom). Focus ends on the claude pane.
#
# Keeps work in ONE tmux session by default so claude-gather (prefix+G) can see
# every claude pane:
#   - inside tmux:               lay out the current window
#   - outside, one session:      add a new window to it, then attach
#   - outside, several sessions: prompt which to attach to (showing window
#                                counts), add a new window to it, then attach
#   - outside, no server:        create the session, lay out window 1, attach
#   - with --new / -n:           force a brand-new, separate session
#
# Targets are always session ids ($N) / window ids (@N), never names: a numeric
# session name like "0" is read by tmux as an index, so `new-window -t 0` fails
# and returns an empty id -- which previously made layout clobber the current
# window. layout() refuses an empty target for the same reason.
#
# Test seams (default to real behavior): $TMUX_BIN is the tmux command;
# $DEV_TMUX_EDITOR / $DEV_TMUX_CLAUDE are the commands launched in the panes.
set -u

TMUX_BIN="${TMUX_BIN:-tmux}"
EDITOR_CMD="${DEV_TMUX_EDITOR:-vim}"
CLAUDE_CMD="${DEV_TMUX_CLAUDE:-claude}"

layout() { # layout <target-window-id>: editor left, claude top-right, shell bottom-right
  t="$1"
  [ -n "$t" ] || { echo "dev-tmux: refusing to lay out an empty target" >&2; exit 1; }
  $TMUX_BIN split-window -h -t "$t"
  $TMUX_BIN select-pane -L -t "$t"
  $TMUX_BIN send-keys -t "$t" "$EDITOR_CMD" Enter
  $TMUX_BIN select-pane -R -t "$t"
  $TMUX_BIN split-window -v -l 33% -t "$t"
  $TMUX_BIN select-pane -U -t "$t"
  cp=$($TMUX_BIN display-message -p -t "$t" '#{pane_id}')
  $TMUX_BIN set-option -p -t "$cp" @role claude
  $TMUX_BIN send-keys -t "$cp" "$CLAUDE_CMD" Enter
}

# Echo the chosen session id; menu and prompt go to stderr so they don't
# pollute the captured value. Re-prompts until a valid number is entered.
choose_session() {
  list=$($TMUX_BIN list-sessions -F '#{session_id} #{session_name} #{session_windows}')
  while :; do
    printf 'Multiple tmux sessions:\n' >&2
    printf '%s\n' "$list" | awk '{printf "  %d) %s (%s %s)\n", NR, $2, $3, ($3==1?"window":"windows")}' >&2
    printf 'Attach to which? ' >&2
    read -r choice || return 1
    sel=$(printf '%s\n' "$list" | awk -v n="$choice" 'NR==n{print $1}')
    [ -n "$sel" ] && { printf '%s\n' "$sel"; return 0; }
    printf 'Invalid selection.\n' >&2
  done
}

add_window_and_attach() { # add a dev window to session-id $1, then attach
  sid="$1"
  win=$($TMUX_BIN new-window -t "$sid" -P -F '#{window_id}')
  layout "$win"
  $TMUX_BIN -2 attach-session -d -t "$sid"
}

new_session=false
case "${1:-}" in
  -n|--new) new_session=true ;;
  "") ;;
  *) echo "usage: dev-tmux [--new|-n]" >&2; exit 2 ;;
esac

if [ "$new_session" = true ]; then
  # Force a brand-new, separate session.
  win=$($TMUX_BIN new-session -d -P -F '#{window_id}')
  layout "$win"
  if [ -n "${TMUX:-}" ]; then
    $TMUX_BIN switch-client -t "$win"
  else
    $TMUX_BIN -2 attach-session -d -t "$win"
  fi
elif [ -n "${TMUX:-}" ]; then
  # Already inside tmux: lay out the current window (you've already made it).
  layout "$($TMUX_BIN display-message -p '#{window_id}')"
elif $TMUX_BIN ls >/dev/null 2>&1; then
  # Outside tmux, a session exists: add a dev window to it and attach. With
  # several sessions, ask which one.
  if [ "$($TMUX_BIN list-sessions | wc -l | tr -d ' ')" -gt 1 ]; then
    sid=$(choose_session) || { echo "dev-tmux: no session selected" >&2; exit 1; }
  else
    sid=$($TMUX_BIN list-sessions -F '#{session_id}' | head -1)
  fi
  add_window_and_attach "$sid"
else
  # Outside tmux, no server running: create the session, lay out window 1, attach.
  win=$($TMUX_BIN new-session -d -P -F '#{window_id}')
  layout "$win"
  $TMUX_BIN -2 attach-session -d -t "$win"
fi
