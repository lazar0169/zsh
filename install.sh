#!/usr/bin/env bash
set -euo pipefail

echo "Starting Zsh setup..."

# --- Helpers ---
ensure_plugin_repo() {
  local name="$1"
  local repo="$2"
  local dest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"

  mkdir -p "$(dirname "$dest")"
  if [[ -d "$dest/.git" ]]; then
    echo "Updating $name..."
    git -C "$dest" fetch --quiet
    git -C "$dest" reset --hard origin/HEAD --quiet
  elif [[ -d "$dest" ]]; then
    echo "Found $name (non-git). Leaving as is."
  else
    echo "Installing $name..."
    git clone --depth=1 "$repo" "$dest" >/dev/null
  fi
}

ensure_plugin_in_zshrc() {
  local name="$1"
  local zshrc="$2"

  # If plugins line exists, append name if missing. If not, create one.
  if grep -qE '^\s*plugins=\(' "$zshrc"; then
    if ! grep -E '^\s*plugins=\(' "$zshrc" | grep -qw "$name"; then
      echo "Adding $name to plugins in $zshrc"
      # Insert before the closing parenthesis on the first plugins= line
      perl -0777 -pe "s/plugins=\(([^)]*)\)/plugins=(\1 $name)/" -i "$zshrc"
    fi
  else
    echo "Creating plugins list in $zshrc with $name"
    printf '\nplugins=(git %s)\n' "$name" >> "$zshrc"
  fi
}

# --- Install Zsh ---
if ! command -v zsh >/dev/null 2>&1; then
  echo "Installing Zsh..."
  brew install zsh
fi

# --- Install Oh My Zsh ---
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSHRC="$HOME/.zshrc"

# --- Copy .zshrc if present (your repo version) ---
if [[ -f "./.zshrc" ]]; then
  echo "Copying .zshrc from current directory..."
  cp ./.zshrc "$ZSHRC"
elif [[ ! -f "$ZSHRC" ]]; then
  echo "Creating a minimal .zshrc..."
  cat > "$ZSHRC" <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# completions safety
autoload -Uz compinit
compinit -u
EOF
fi

# --- Install Zsh plugins directly into $ZSH_CUSTOM/plugins ---
# Stop relying on Homebrew for these to avoid "plugin not found"
echo "Installing Zsh plugins (via git into \$ZSH_CUSTOM/plugins)..."
ensure_plugin_repo "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search.git"
ensure_plugin_repo "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
ensure_plugin_repo "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

# Ensure they are listed in plugins=() exactly once
ensure_plugin_in_zshrc "zsh-history-substring-search" "$ZSHRC"
ensure_plugin_in_zshrc "zsh-autosuggestions" "$ZSHRC"
ensure_plugin_in_zshrc "zsh-syntax-highlighting" "$ZSHRC"

# Place syntax-highlighting after compinit in case user sources directly
if ! grep -q 'zsh-syntax-highlighting.zsh' "$ZSHRC"; then
  cat >> "$ZSHRC" <<'EOF'

# Ensure syntax highlighting loads at the end
if [ -f "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
EOF
fi

# Optional keybindings for history-substring-search
if ! grep -q 'history-substring-search-up' "$ZSHRC"; then
  cat >> "$ZSHRC" <<'EOF'

# History substring search keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
EOF
fi

# --- Remove Homebrew-installed plugin formulas to avoid confusion (optional) ---
# Uncomment if you previously installed these via brew
# brew list zsh-history-substring-search >/dev/null 2>&1 && brew uninstall --formula zsh-history-substring-search
# brew list zsh-autosuggestions >/dev/null 2>&1 && brew uninstall --formula zsh-autosuggestions
# brew list zsh-syntax-highlighting >/dev/null 2>&1 && brew uninstall --formula zsh-syntax-highlighting

# --- Fix permissions for compinit insecure directories (Homebrew prefix) ---
ZSH_SHARE="$(brew --prefix)/share"
if [[ -d "$ZSH_SHARE" ]]; then
  echo "Fixing compinit insecure directories..."
  chmod go-w "$ZSH_SHARE" || true
  [[ -d "$ZSH_SHARE/zsh" ]] && chmod -R go-w "$ZSH_SHARE/zsh" || true
fi

# --- Install JetBrains Mono Nerd Font ---
echo "Installing JetBrains Mono Nerd Font..."
brew tap homebrew/cask-fonts || true
brew install --cask font-jetbrains-mono-nerd-font || true

# --- Install nvm ---
if [[ ! -d "$HOME/.nvm" ]]; then
  echo "Installing nvm..."
  brew install nvm
  mkdir -p "$HOME/.nvm"
fi

# --- Install Docker (optional) ---
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  brew install --cask docker
fi

# --- Set Zsh as default shell ---
ZSH_BIN="$(command -v zsh)"
if ! grep -q "$ZSH_BIN" /etc/shells; then
  echo "Adding $ZSH_BIN to /etc/shells (sudo may prompt)..."
  echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$SHELL" != "$ZSH_BIN" ]]; then
  echo "Changing default shell to $ZSH_BIN..."
  chsh -s "$ZSH_BIN"
fi

echo "Zsh setup complete."
echo "Open a new terminal or run: source \"$ZSHRC\""
