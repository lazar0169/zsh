# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme (change this to 'agnoster' or 'powerlevel10k' for git branch/status)
# ZSH_THEME="awesomepanda"
ZSH_THEME="agnoster"
DEFAULT_USER=$USER

# Auto-update settings
zstyle ':omz:update' mode auto

# Enable plugins
plugins=(
  git
  docker
  asdf
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# --- HOMEBREW COMPLETIONS ---
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# --- AUTOSUGGESTIONS ---
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- SYNTAX HIGHLIGHTING (must come last) ---
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- ALIASES ---
alias list="ls -lah"
alias p="python3"
alias pip3="pip"

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# --- ANDROID SDK ---
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# --- FLUTTER ---
export PATH="$HOME/Development/flutter/bin:$PATH"

# --- CHROME EXECUTABLE ---
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"

# --- HOMEBREW BIN ---
export PATH="/opt/homebrew/bin:$PATH"

# --- PREVENT WARNINGS ---
ZSH_DISABLE_COMPFIX=true

