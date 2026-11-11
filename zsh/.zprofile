
eval "$(/opt/homebrew/bin/brew shellenv)"

# Personal commands (scripts package)
export PATH="$HOME/scripts:$PATH"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
