#!/bin/bash
set -e

echo "🚀 Starting Zsh setup..."

# --- Install Zsh ---
if ! command -v zsh &> /dev/null; then
  echo "Installing Zsh..."
  brew install zsh
fi

# --- Install Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Copy .zshrc ---
if [ -f "./.zshrc" ]; then
  echo "Copying .zshrc..."
  cp ./.zshrc ~/
fi

# --- Install plugins ---
echo "Installing Zsh plugins..."
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zsh-completions

# --- Fix permissions for Homebrew completions ---
ZSH_SHARE=$(brew --prefix)/share
echo "Fixing compinit insecure directories..."
chmod go-w "$ZSH_SHARE"
chmod -R go-w "$ZSH_SHARE/zsh"

# --- Install JetBrains Mono Nerd Font ---
echo "Installing JetBrains Mono Nerd Font..."
brew tap homebrew/cask-fonts || true
brew install --cask font-jetbrains-mono-nerd-font

# --- Install nvm ---
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing nvm..."
  brew install nvm
  mkdir -p ~/.nvm
fi

# --- Install Docker (optional) ---
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  brew install --cask docker
fi

# --- Install Flutter ---
if [ ! -d "$HOME/Development/flutter" ]; then
  echo "Installing Flutter..."
  mkdir -p ~/Development
  git clone --depth=1 https://github.com/flutter/flutter.git ~/Development/flutter
fi

# --- Install Android SDK ---
if [ ! -d "$HOME/Library/Android/sdk" ]; then
  echo "Installing Android SDK..."
  brew install --cask android-sdk
fi

# --- Set Zsh as default shell ---
if ! grep -q "$(which zsh)" /etc/shells; then
  echo "$(which zsh)" | sudo tee -a /etc/shells
fi
chsh -s "$(which zsh)"

echo "✅ Zsh setup complete!"
