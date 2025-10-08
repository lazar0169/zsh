#!/bin/bash

# --------------------------
# Zsh Setup Script (macOS)
# --------------------------
# Assumes Homebrew is installed
# Run with: bash setup-zsh.sh
# --------------------------

set -e

echo "Starting Zsh setup..."

# --- Install Zsh (if not installed) ---
if ! command -v zsh &> /dev/null; then
  echo "Installing Zsh..."
  brew install zsh
fi

# --- Install Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Copy .zshrc (assumes you have it in same folder as script) ---
if [ -f "./.zshrc" ]; then
  echo "Copying .zshrc..."
  cp ./.zshrc ~/
fi

# --- Install Zsh plugins ---
echo "Installing Zsh plugins..."
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search

# Ensure custom plugins folder exists
CUSTOM_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$CUSTOM_PLUGINS"

# Optional: add any custom plugin clones here
# Example: git clone plugin if not already present
# zsh-history-substring-search is installed via brew, so no need to clone

# --- Install Nerd Font for powerline (agnoster theme) ---
echo "Installing Hack Nerd Font..."
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# --- Install nvm ---
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing nvm..."
  brew install nvm
  mkdir -p ~/.nvm
fi

# --- Install Docker CLI (optional, depends if you need it) ---
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  brew install --cask docker
fi

# --- Flutter setup ---
if [ ! -d "$HOME/Development/flutter" ]; then
  echo "Installing Flutter..."
  mkdir -p ~/Development
  git clone https://github.com/flutter/flutter.git ~/Development/flutter
fi

# --- Android SDK setup ---
if [ ! -d "$HOME/Library/Android/sdk" ]; then
  echo "Installing Android SDK..."
  brew install --cask android-sdk
fi

# --- Source the new Zsh config ---
echo "Applying Zsh configuration..."
source ~/.zshrc

echo "Zsh setup complete!"
echo "Remember to set your terminal font to 'Hack Nerd Font' for agnoster theme."

