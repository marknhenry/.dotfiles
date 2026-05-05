#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

echo "Dotfiles installed."

if [[ "$OSTYPE" == "darwin"* ]]; then
  export DOTFILES_OS="macos"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  export DOTFILES_OS="wsl"
else
  export DOTFILES_OS="linux"
fi

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
fi

if [[ "$DOTFILES_OS" == "wsl" ]]; then
  echo "Installing eza..."
  sudo apt update
  sudo apt install -y eza
  echo "eza installed."
  echo "Installing Nerd Fonts..."
  sudo apt install -y fonts-jetbrains-mono-nerd-font
  echo "Nerd Fonts installed."
fi