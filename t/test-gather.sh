#!/bin/sh
# Test harness for claude-gather.sh.
#
# Runs entirely against an isolated tmux server (tmux -L gathertest) with its
# own socket, so it never reads or mutates the user's real tmux session.
# Identity is proven via pane ids (%N), which tmux keeps stable across
# join-pane/break-pane -- so "same pane id in the right window" means the exact
# same pane (process + scrollback) was moved correctly.

set -u

HERE=$(cd "$(dirname "$0")/.." && pwd)
SCRIPT="$HERE/claude-gather.sh"

SOCK=gathertest
T="tmux -L $SOCK"
SESSION=gtest

# claude-gather.sh talks to tmux through $TMUX_BIN and finds the target session
# via $GATHER_SESSION -- both overridden here to hit the isolated server.
export TMUX_BIN="$T"
export GATHER_SESSION="$SESSION"

pass=0
fail=0
ok() { pass=$((pass + 1)); printf '  ok   %s\n' "$1"; }
no() { fail=$((fail + 1)); printf '  FAIL %s\n' "$1"; }
check() { # check <desc> <actual> <expected>
  if [ "$2" = "$3" ]; then ok "$1"; else no "$1 (got '$2', want '$3')"; fi
}

cleanup() { $T kill-server 2>/dev/null; }
trap cleanup EXIT

# --- tmux query helpers (isolated server) ---------------------------------
win_of()    { $T list-panes -s -t "$SESSION" -F '#{@marker} #{window_id}' | awk -v m="$1" '$1==m{print $2}'; }
pane_of()   { $T list-panes -s -t "$SESSION" -F '#{@marker} #{pane_id}'   | awk -v m="$1" '$1==m{print $2}'; }
layout_of() { $T display-message -p -t "$1" '#{window_layout}'; }
active_win(){ $T display-message -p -t "$SESSION" '#{window_id}'; }
win_exists(){ $T list-windows -t "$SESSION" -F '#{window_id}' | grep -qx "$1"; }
hub_id()    { $T show-options -t "$SESSION" -v @claude_hub 2>/dev/null; }
pane_count(){ $T list-panes -t "$1" 2>/dev/null | wc -l | tr -d ' '; }

# Build one window matching dev-tmux's shape: shell left, a @role=claude pane
# top-right (marked so we can track it), shell bottom-right.
build_window() { # build_window <window-target> <marker>
  win="$1"; m="$2"
  $T split-window -h -t "$win"
  $T split-window -v -l 33% -t "$win"
  $T select-pane -U -t "$win"
  cp=$($T display-message -p -t "$win" '#{pane_id}')   # active == top-right
  $T set-option -p -t "$cp" @role claude
  $T set-option -p -t "$cp" @marker "$m"
}

fixture() { # fixture [notag]  -- 3 windows; with a claude pane each unless notag
  $T kill-server 2>/dev/null
  $T new-session -d -s "$SESSION" -x 200 -y 50 -n w1
  $T new-window -t "$SESSION" -n w2
  $T new-window -t "$SESSION" -n w3
  if [ "${1:-}" != notag ]; then
    build_window "$SESSION:w1" A
    build_window "$SESSION:w2" B
    build_window "$SESSION:w3" C
  fi
}

# ==========================================================================
# Happy path. A is the first claude pane (break-pane path); B is a later one
# (join-pane path) -- covering both code paths without testing all three.
echo "== gather then un-gather =="
fixture
oa_win=$(win_of A); ob_win=$(win_of B)
oa_pane=$(pane_of A)
oa_lay=$(layout_of "$oa_win")

sh "$SCRIPT" gather
hub=$(hub_id)
check "gather sets hub flag"          "$([ -n "$hub" ] && echo yes)" "yes"
check "all 3 panes land in hub"       "$(pane_count "$hub")" "3"
check "first pane (break) in hub"     "$(win_of A)" "$hub"
check "later pane (join) in hub"      "$(win_of B)" "$hub"
check "gather switches to hub"        "$(active_win)" "$hub"

sh "$SCRIPT" ungather
check "ungather clears hub flag"      "$(hub_id)" ""
check "hub window destroyed"          "$(win_exists "$hub" && echo live || echo gone)" "gone"
check "first pane back home"          "$(win_of A)" "$oa_win"
check "later pane back home"          "$(win_of B)" "$ob_win"
check "pane identity preserved"       "$(pane_of A)" "$oa_pane"
check "home layout restored exactly"  "$(layout_of "$oa_win")" "$oa_lay"

echo "== toggle alternates =="
fixture
sh "$SCRIPT" toggle; check "toggle gathers"    "$([ -n "$(hub_id)" ] && echo yes)" "yes"
sh "$SCRIPT" toggle; check "toggle un-gathers"  "$(hub_id)" ""

echo "== edge: un-gather with nothing gathered =="
fixture
oa_win=$(win_of A)
sh "$SCRIPT" ungather; rc=$?
check "no-op ungather exits 0"        "$rc" "0"
check "no-op leaves panes home"       "$(win_of A)" "$oa_win"

echo "== edge: gather with no claude panes =="
fixture notag
sh "$SCRIPT" gather; rc=$?
check "empty gather exits 0"          "$rc" "0"
check "empty gather makes no hub"     "$(hub_id)" ""

echo "== edge: double gather is a no-op =="
fixture
sh "$SCRIPT" gather; hub=$(hub_id)
sh "$SCRIPT" gather; rc=$?
check "double gather exits 0"         "$rc" "0"
check "double gather changes nothing" "$(hub_id)" "$hub"

echo "== edge: home window closed -> orphan rescue =="
fixture
ob_win=$(win_of B)
sh "$SCRIPT" gather
$T kill-window -t "$ob_win"           # B's home disappears
sh "$SCRIPT" ungather; rc=$?
check "orphan rescue exits 0"         "$rc" "0"
check "orphan rehomed to live window" \
  "$([ -n "$(win_of B)" ] && [ "$(win_of B)" != "$ob_win" ] && echo yes)" "yes"

# ==========================================================================
echo
echo "RESULT: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
