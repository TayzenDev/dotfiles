# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/): each top-level folder is a package mirroring `$HOME`.

## Setup on a new Mac

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow rcmdnk/file/brew-file
git clone <this repo> ~/dotfiles && cd ~/dotfiles
stow brew zsh tmux git ghostty sesh workmux scripts claude
brew file install
```

tmux plugins (tpm) and zsh plugins (antidote) install themselves on first launch.

## Packages

- `brew`: Brewfile used by `brew file` (updated automatically on `brew install`)
- `zsh`: `.zshrc`, `.zprofile`, `.zshenv`, antidote plugin list
- `git`: global git identity (GitHub noreply email), gh credential helper
- `tmux`: tmux config, gitmux, window names with AI agent session titles and workmux status, `prefix + a` agents dashboard, `prefix + A` next agent needing you, `prefix + G`/`D` lazygit/lazydocker popups
- `sesh`: built-in picker (`prefix + T`) with preview and agent windows (status + session title)
- `workmux`: status tracking only (hooks via `workmux setup --hooks`, Claude plugin `workmux-status`); worktrees are created by the `/wt` skill
- `scripts`: personal commands in `~/scripts` (on `PATH` via `.zshenv`): `tm` attaches to the most recent tmux session, else creates `default`; `tkill` kills tmux sessions (args or fzf multi-select); `gclean` deletes merged/gone branches and their worktrees; `port [n]` lists listeners or kills the one on a port; `tip` shows one script's `# tip:` lines through cowsay in every new shell
- `ghostty`: starts in tmux via `tm`, Pale Night Hc theme, tab shortcuts (cmd+t/w/1-9, cmd+shift+[ ]) mapped to tmux windows
- `claude`: Claude Code user settings (`~/.claude/settings.json`: dark theme, workmux marketplace and `workmux-status` plugin), skills (`/recap` copies a conversation summary to the clipboard; `/wt` grills you on a dev task, writes a spec and launches it with `workmux add` in a new worktree, where `wt-run` implements, tests, reviews in a fresh context with at most 3 fix rounds and opens the PR) and status line script (`statusline.sh`: model, context fill, 5h and weekly subscription usage with reset times)
