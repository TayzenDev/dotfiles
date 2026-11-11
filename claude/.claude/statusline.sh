#!/usr/bin/env bash
# Claude Code status line: context fill, 5h window and weekly subscription usage.
# Reads the session JSON Claude Code sends on stdin.

jq -r '
  def color(p): if p >= 80 then "\u001b[31m" elif p >= 50 then "\u001b[33m" else "\u001b[32m" end;
  def pct(p): color(p) + (p | floor | tostring) + "%\u001b[0m";
  def epoch: if type == "number" then . else (sub("\\.[0-9]+"; "") | sub("(\\+00:00)?$"; "") | sub("Z?$"; "Z") | fromdateiso8601) end;
  def reset(fmt): (.resets_at // empty | try (epoch | strflocaltime(fmt)) catch empty) as $t | " (" + $t + ")";

  [
    (.model.display_name // empty),
    (.context_window.used_percentage // empty | "ctx " + pct(.)),
    (.rate_limits.five_hour // empty | select(.used_percentage != null)
      | "5h " + pct(.used_percentage) + reset("%H:%M")),
    (.rate_limits.seven_day // empty | select(.used_percentage != null)
      | "7j " + pct(.used_percentage) + reset("%a %H:%M"))
  ] | join(" · ")
'
