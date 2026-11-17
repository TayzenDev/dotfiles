#!/usr/bin/env bash
# SessionStart hook: remember the session id on the tmux pane, so that
# tmux/.config/tmux/scripts/claude-sessions can resume it after a tmux-resurrect restore.
# Fires again on /clear, /resume and compaction, which keeps the id current.

[ -n "$TMUX_PANE" ] || exit 0

id=$(jq -r '.session_id // empty')
[ -n "$id" ] && tmux set -p -t "$TMUX_PANE" @claude-session "$id"
exit 0
