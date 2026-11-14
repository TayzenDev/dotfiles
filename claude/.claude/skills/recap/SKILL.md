---
name: recap
description: Compile the recent conversation (decisions, reasons, next steps) into shareable Markdown and copy it to the macOS clipboard. Use when the user asks for a recap, summary or write-up of what was decided to paste into notes, Notion or a message.
argument-hint: "[scope or focus, e.g. \"last 3 exchanges\" or \"tmux shortcuts\"]"
allowed-tools: Bash(pbcopy:*)
---

# Recap to clipboard

Turn the recent conversation into a Markdown note a colleague can read without
having seen the conversation, then copy it to the clipboard.

## Scope

- `$ARGUMENTS` narrows the scope (a number of exchanges, a topic). Without it,
  cover the current topic: go back to where it started, not the whole session.
- Keep what was decided and why. Leave out dead ends, tool output and back-and-forth,
  unless a rejected option matters for understanding the choice.

## Content

Write in the language the conversation is held in. Structure, dropping empty sections:

```markdown
# <Short title naming the subject>

<One or two sentences: context and goal.>

## Decisions
- **<Decision>**: <what, and why in a few words>

## Changes
- <What changed, where (repo / file / tool), commit or PR if any>

## Open questions / next steps
- [ ] <Action or open point>
```

- Self-contained: no "as said above", no "you"/"I" from the chat; name things explicitly.
- Paste-friendly for Notion, Slack and note apps: headings, bullets, bold, inline
  code, fenced code blocks only when the snippet matters. No HTML, no footnotes.
- Repo-relative paths, never absolute paths under the home directory.
- Concise: a recap, not a transcript. Facts only, nothing the conversation didn't establish.

## Copy

Pipe the Markdown to `pbcopy` with a quoted heredoc so nothing is expanded:

```bash
pbcopy <<'RECAP_EOF'
...markdown...
RECAP_EOF
```

Then reply with one line confirming it is in the clipboard, followed by the Markdown
so the user can check it.
