HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

# Detect OS

if [[ "$OSTYPE" == "darwin"* ]]; then
  export DOTFILES_OS="macos"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  export DOTFILES_OS="wsl"
else
  export DOTFILES_OS="linux"
fi

# Common aliases

alias ll='eza --long --all --header --icons --no-permissions --group-directories-first --sort=name'
alias la='eza --all --icons'
alias cls='clear'

# OS-specific config

if [[ "$DOTFILES_OS" == "macos" ]]; then
  alias code='open -a "Visual Studio Code"'
fi

if [[ "$DOTFILES_OS" == "wsl" ]]; then
  alias explorer='explorer.exe'
fi

# Enable zsh completion
autoload -Uz compinit
compinit