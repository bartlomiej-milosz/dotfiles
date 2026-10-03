#!/usr/bin/env bash
# Usage: ./scripts/install-macos.sh [--desktop|--cli]
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE=${1:---desktop}
if [[ $# -gt 1 || ($MODE != --desktop && $MODE != --cli) ]]; then
  echo 'Usage: install-macos.sh [--desktop|--cli]' >&2
  exit 1
fi
[[ $(uname -s) == Darwin ]] || {
  echo 'This installer requires macOS.' >&2
  exit 1
}

if ! command -v brew >/dev/null; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    installer=$(mktemp)
    trap 'rm -f "$installer"' EXIT
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"
    /bin/bash "$installer"
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
fi

brew install git stow sheldon starship fzf
if [[ $MODE == --desktop ]]; then
  brew install --cask ghostty font-jetbrains-mono
fi
"$DOTFILES_DIR/scripts/sync.sh" "$MODE"
sheldon --config-file "$DOTFILES_DIR/sheldon/.config/sheldon/plugins.toml" lock
printf '\nReady. Open a new terminal or run: exec zsh\n'
