#!/usr/bin/env bash
# UserPromptSubmit hook: on the first prompt of a session, ask Haiku for a title of
# at most $max_len characters and set it as the session title. Claude Code then skips
# its own (longer) AI title, and the terminal title / tmux window name follows.

max_len=20

# The nested `claude -p` below would fire this hook again
[ -n "$CLAUDE_SESSION_TITLE_HOOK" ] && exit 0

input=$(cat)
session=$(jq -r '.session_id // empty' <<<"$input")
prompt=$(jq -r '.prompt // empty' <<<"$input")
[ -z "$session" ] || [ -z "$prompt" ] && exit 0
# Slash commands say little about the topic: wait for a real prompt
[[ "$prompt" == /* ]] && exit 0

marker_dir="${TMPDIR:-/tmp}/claude-session-title"
mkdir -p "$marker_dir"
[ -e "$marker_dir/$session" ] && exit 0
touch "$marker_dir/$session"

ask() {
  CLAUDE_SESSION_TITLE_HOOK=1 claude -p --model haiku --no-session-persistence \
    --tools "" --disable-slash-commands --strict-mcp-config \
    --system-prompt "You name coding sessions. Reply with the title only: 1 to 3 words, \
at most $max_len characters including spaces, no quotes, no trailing punctuation, \
no ellipsis, in the language of the request. Shorten words or rephrase to fit; never truncate." \
    "$1" 2>/dev/null | head -n 1 | sed -E 's/^[[:space:]"'\''`]+|[[:space:]"'\''`.]+$//g'
}

request="Title for a session starting with this request:
${prompt:0:2000}"
title=$(ask "$request")
if [ -n "$title" ] && ((${#title} > max_len)); then
  title=$(ask "$request

\"$title\" is ${#title} characters, the limit is $max_len. Give a shorter title.")
fi
[ -z "$title" ] || ((${#title} > max_len)) && exit 0

jq -n --arg t "$title" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", sessionTitle: $t}}'
