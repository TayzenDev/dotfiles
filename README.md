# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/): each top-level folder is a package mirroring `$HOME`.

## Setup on a new Mac

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow rcmdnk/file/brew-file
git clone <this repo> ~/dotfiles && cd ~/dotfiles
stow brew zsh tmux git ghostty
brew file install
```

tmux plugins (tpm) and zsh plugins (antidote) install themselves on first launch.

## Packages

- `brew`: Brewfile used by `brew file` (updated automatically on `brew install`)
- `zsh`: `.zshrc`, `.zprofile`, antidote plugin list
- `git`: global git identity (GitHub noreply email), gh credential helper
- `tmux`: tmux config, gitmux, window names with AI agent session titles
- `ghostty`: starts in tmux (session `default`), Pale Night Hc theme, tab shortcuts (cmd+t/w/1-9, cmd+shift+[ ]) mapped to tmux windows
