#!/usr/bin/env bash

set -e

DOTFILES="$HOME/.dotfiles"

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/p10k/.p10k.zsh" "$HOME/.p10k.zsh"

echo "Dotfiles installed."

if [[ "$OSTYPE" == "darwin"* ]]; then
  export DOTFILES_OS="macos"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  export DOTFILES_OS="wsl"
else
  export DOTFILES_OS="linux"
fi
echo "Starting Configuration"
echo "Detected OS: $DOTFILES_OS"

if [[ "$DOTFILES_OS" == "macos" ]]; then

# Homebrew
  if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed."
  else
    echo "Homebrew already installed."
  fi

# Eza
  if ! command -v eza &> /dev/null; then
    echo "Installing eza..."
    brew install eza
    echo "eza installed."
  else
    echo "eza already installed."
  fi

#Nerd Fonts
  if ! brew list --cask | grep -q "font-jetbrains-mono-nerd-font"; then
    echo "Installing Nerd Fonts..."
    brew install --cask font-jetbrains-mono-nerd-font
    echo "Nerd Fonts installed."
  else
    echo "Nerd Fonts already installed."
  fi

# Install GitHub CLI
  if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    brew install gh
    echo "GitHub CLI installed."
  else
    echo "GitHub CLI already installed."
  fi

fi

if [[ "$DOTFILES_OS" == "wsl" ]]; then
  echo "Installing eza..."
  sudo apt update
  sudo apt install -y eza
  echo "eza installed."
  # echo "Installing Nerd Fonts..."
  # sudo apt install -y fonts-jetbrains-mono-nerd-font
  # echo "Nerd Fonts installed."
  echo "Installing Git and GitHub CLI..."
  sudo apt install -y git gh
  echo "Git and GitHub CLI installed."
  echo "Installing fzf..."
  sudo apt install -y fzf
  echo "fzf installed."
fi

# Git configuration
git config --global user.email "marknhenry@live.com"
git config --global user.name "Mark Henry"
git config --global pull.rebase false
git config --global init.defaultBranch main
echo "Git configured with user.name and user.email."

# Zinit Installation
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    echo "Installing Zinit..."
    mkdir -p "$HOME/.local/share/zinit" && chmod g-rwX "$HOME/.local/share/zinit"
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    echo "Zinit installed."
fi

source "$HOME/.zshrc"
source "${ZINIT_HOME}/zinit.zsh"

# # Add in Powerlevel10k
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# # Add in zsh plugins
# zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions