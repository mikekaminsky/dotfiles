#!/bin/sh
# Test harness for dev-tmux.sh.
#
# Runs against an isolated tmux server (tmux -L devtmuxtest) so it never touches
# the user's real session. Sessions are given NUMERIC names ("0", "9") on
# purpose: that is the real-world condition (tmux's default names) that exposed
# the clobber bug -- non-numeric names like "alpha" hide it, because the bug is
# tmux reading a numeric session name as an index.
#
# dev-tmux.sh exposes test seams (all default to real behavior): $TMUX_BIN is
# the tmux command; $DEV_TMUX_EDITOR / $DEV_TMUX_CLAUDE are the commands sent to
# the panes -- neutralized here so tests never launch a real editor or claude.
# "Inside tmux" is simulated with a non-empty $TMUX (the script only checks
# whether it is set); "outside" by unsetting it. attach-session fails fast
# without a tty, so the attach branches build their windows and we ignore the
# non-zero exit.

set -u

HERE=$(cd "$(dirname "$0")/.." && pwd)
SCRIPT="$HERE/dev-tmux.sh"

SOCK=devtmuxtest
T="tmux -L $SOCK"

export TMUX_BIN="$T"
export DEV_TMUX_EDITOR=true
export DEV_TMUX_CLAUDE=true

pass=0
fail=0
ok() { pass=$((pass + 1)); printf '  ok   %s\n' "$1"; }
no() { fail=$((fail + 1)); printf '  FAIL %s\n' "$1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 (got '$2', want '$3')"; fi; }

cleanup() { $T kill-server 2>/dev/null; }
trap cleanup EXIT

session_count() { $T list-sessions 2>/dev/null | wc -l | tr -d ' '; }
total_windows() { $T list-windows -a 2>/dev/null | wc -l | tr -d ' '; }
total_panes()   { $T list-panes -a 2>/dev/null | wc -l | tr -d ' '; }
claude_count()  { $T list-panes -a -F '#{@role}' 2>/dev/null | grep -cx claude; }

run_outside() { env -u TMUX sh "$SCRIPT" "$@" >/dev/null 2>&1; }
run_inside()  { TMUX=fake-inside sh "$SCRIPT" "$@" >/dev/null 2>&1; }

# Total panes tell us whether a fresh window was built (correct) or an existing
# window was clobbered (bug). One dev window == 3 panes; a leak shows up as a
# missing window and too few total panes.

echo "== outside, no server: create session + lay out window 1 =="
$T kill-server 2>/dev/null
run_outside
check "creates exactly one session" "$(session_count)" "1"
check "one window, 3 panes"         "$(total_panes)" "3"
check "tags one claude pane"        "$(claude_count)" "1"

echo "== outside, one session (numeric name): add a fresh WINDOW, no clobber =="
$T kill-server 2>/dev/null
$T new-session -d -s 0 -x 200 -y 50          # 1 window, 1 pane
run_outside
check "still exactly one session"   "$(session_count)" "1"
check "now two windows"             "$(total_windows)" "2"
check "1 + 3 panes (no clobber)"    "$(total_panes)" "4"
check "tags one claude pane"        "$(claude_count)" "1"

echo "== outside, multiple sessions (numeric names): prompt, build in chosen, no clobber =="
$T kill-server 2>/dev/null
$T new-session -d -s 0 -x 200 -y 50
$T new-session -d -s 9 -x 200 -y 50          # 2 windows, 2 panes total
printf '2\n' | run_outside                   # choose session #2 from the menu
check "still two sessions"          "$(session_count)" "2"
check "one new window created"      "$(total_windows)" "3"
check "2 + 3 panes (no clobber)"    "$(total_panes)" "5"
check "tags one claude pane"        "$(claude_count)" "1"

echo "== --new: force a brand-new separate session =="
$T kill-server 2>/dev/null
$T new-session -d -s 0 -x 200 -y 50
run_outside --new
check "now two sessions"            "$(session_count)" "2"
check "tags one claude pane"        "$(claude_count)" "1"

echo "== inside tmux: lay out the CURRENT window, no new window =="
$T kill-server 2>/dev/null
$T new-session -d -s 0 -x 200 -y 50
before=$(total_windows)
run_inside
check "no new window created"       "$(total_windows)" "$before"
check "current window laid out (3)" "$(total_panes)" "3"
check "tags one claude pane"        "$(claude_count)" "1"

echo "== bad argument is rejected =="
$T kill-server 2>/dev/null
$T new-session -d -s 0
run_outside --bogus; rc=$?
check "bad arg exits 2"             "$rc" "2"

echo
echo "RESULT: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
