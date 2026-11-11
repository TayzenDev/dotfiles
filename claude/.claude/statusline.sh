#!/usr/bin/env bash
# Claude Code status line: git branch/worktree, context fill, 5h window and weekly
# subscription usage.
# Reads the session JSON Claude Code sends on stdin.
# Styled like the default starship prompt: bold ANSI colors (so the Ghostty theme
# palette applies), plain connector words, dimmed secondary info.

input=$(cat)
dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")

# Branch (or short SHA when detached); in a linked worktree, also its directory name.
branch= worktree=
if [ -n "$dir" ] && git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null; then
  branch=$(git -C "$dir" symbolic-ref --short -q HEAD || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  if [ "$(git -C "$dir" rev-parse --git-dir)" != "$(git -C "$dir" rev-parse --git-common-dir)" ]; then
    worktree=$(basename "$(git -C "$dir" rev-parse --show-toplevel)")
  fi
fi

jq -r --arg branch "$branch" --arg worktree "$worktree" '
  def style(code): "\u001b[" + code + "m" + . + "\u001b[0m";
  def level(p): if p >= 80 then "1;31" elif p >= 50 then "1;33" else "1;32" end;
  def pct(p): p as $p | ($p | floor | tostring) + "%" | style(level($p));
  def epoch: if type == "number" then . else (sub("\\.[0-9]+"; "") | sub("(\\+00:00)?$"; "") | sub("Z?$"; "Z") | fromdateiso8601) end;
  def reset(fmt): (.resets_at // empty | try (epoch | strflocaltime(fmt)) catch empty) as $t | " " + ("until " + $t | style("90"));

  [
    (.model.display_name // empty | style("1;35")),
    ($branch | select(. != "") | ("\ue0a0 " + .) | style("1;35")
      + (if $worktree != "" then " " + ("(" + $worktree + ")" | style("90")) else "" end)),
    (.context_window.used_percentage // empty | "ctx " + pct(.)),
    (.rate_limits.five_hour // empty | select(.used_percentage != null)
      | "5h " + pct(.used_percentage) + reset("%H:%M")),
    (.rate_limits.seven_day // empty | select(.used_percentage != null)
      | "7d " + pct(.used_percentage) + reset("%a %H:%M"))
  ] | join(" " + ("·" | style("90")) + " ")
' <<<"$input"