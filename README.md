# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/): each top-level folder is a package mirroring `$HOME`.

macOS only: paths assume Homebrew in `/opt/homebrew`, and some packages (`rift`, `tdefault`, Brewfile casks) are macOS tools.

## Setup on a new Mac

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow rcmdnk/file/brew-file
git clone <this repo> ~/dotfiles && cd ~/dotfiles
stow brew zsh tmux git ghostty sesh workmux scripts claude rift
brew file install
gh auth login && gh extension install dlvhdr/gh-dash
```

tmux plugins (tpm) and zsh plugins (antidote) install themselves on first launch.

## Packages

- `brew`: Brewfile used by `brew file` (updated automatically on `brew install`)
- `zsh`: `.zshrc`, `.zprofile`, `.zshenv`, antidote plugin list
- `git`: global git identity (GitHub noreply email), gh credential helper, `claude-automode` filter keeping the `autoMode` block of `~/.claude/settings.json` out of the repo (saved in `~/.claude/automode.local.json` and put back on checkout)
- `tmux`: tmux config, gitmux, window names with AI agent session titles and workmux status, `prefix + a` agents dashboard, `prefix + A` next agent needing you, `prefix + G`/`D`/`F`/`P`/`H` lazygit/lazydocker/yazi/gh dash/btop popups
- `sesh`: built-in picker (`prefix + T`) with preview and agent windows (status + session title)
- `workmux`: status tracking only (hooks via `workmux setup --hooks`, Claude plugin `workmux-status`); worktrees are created by the `/wt` skill
- `scripts`: personal commands in `~/scripts` (on `PATH` via `.zshenv`): `tm` attaches to the most recent tmux session, else creates `default`; `tdefault` opens a Ghostty window on the `default` tmux session; `tkill` kills tmux sessions (args or fzf multi-select); `gclean` deletes merged/gone branches and their worktrees; `port [n]` lists listeners or kills the one on a port; `tip` shows one script's `# tip:` lines through cowsay in every new shell
- `ghostty`: starts in tmux via `tm`, Pale Night Hc theme, CaskaydiaCove Nerd Font Mono, 90% opacity with blur, tab shortcuts (cmd+t/w/1-9, cmd+shift+[ ]) mapped to tmux windows
- `rift`: [rift](https://github.com/acsandmann/rift) tiling window manager, AeroSpace-style bindings (alt+hjkl focus, ctrl+[shift]+0-9 workspaces, alt+b/d/c browser/dev/com, alt+shift+tab workspace to other display, alt+m workspaces overview, alt+enter Ghostty on the default tmux session, alt+ctrl+1-5 layouts), current workspace in the menu bar, apps auto-assigned to named workspaces, 3-finger swipe between workspaces, white border on the active window (JankyBorders, started by rift), focus follows the keyboard only (the pointer never focuses or hides)
- `claude`: Claude Code user settings (`~/.claude/settings.json`: dark theme, workmux marketplace and `workmux-status` plugin), skills (`/recap` copies a conversation summary to the clipboard; `/wt` grills you on a dev task, writes a spec and launches it with `workmux add` in a new worktree, where `wt-run` implements, tests, reviews in a fresh context with at most 3 fix rounds and opens the PR) and status line script (`statusline.sh`: model, context fill, 5h and weekly subscription usage with reset times)
