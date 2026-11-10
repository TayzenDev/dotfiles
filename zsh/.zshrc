# Brewfile
if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/benjamin/.cache/lm-studio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.deno/bin:$PATH"
export EDITOR="nvim"

# Android SDK (brew android-commandlinetools)
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# History (atuin handles search, this keeps $HISTFILE sane)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups hist_ignore_space share_history extended_history hist_fcntl_lock

# Emacs keybindings (zsh picks vi mode because EDITOR=nvim); before plugins bind keys
bindkey -e

# Plugins (list in ~/.zsh_plugins.txt)
# oh-my-zsh plugins (e.g. thefuck) cache into $ZSH_CACHE_DIR
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p "$ZSH_CACHE_DIR"
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load

# Aliases
alias ll="ls -al"
alias ping="prettyping"
alias ls="eza --icons --color=auto"
alias tree="eza --icons --color=auto --tree"
alias cat="bat"
alias grep="rg"
alias cd="z"
alias zz="z -"
alias tm="tmux attach -t default || tmux new -s default"

# Tools
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
