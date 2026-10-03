#!/usr/bin/env bash
# Usage: ./scripts/sync.sh [--desktop|--cli] [--dry-run]
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE=cli
[[ $(uname -s) == Darwin ]] && MODE=desktop
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
  --desktop) MODE=desktop ;;
  --cli) MODE=cli ;;
  --dry-run) DRY_RUN=true ;;
  *)
    printf 'Unknown option: %s\n' "$arg" >&2
    exit 1
    ;;
  esac
done
command -v stow >/dev/null || {
  echo 'Install GNU Stow first (brew install stow / sudo apt install stow).' >&2
  exit 1
}
PACKAGES=(git sheldon starship zsh)
[[ $MODE == desktop ]] && PACKAGES+=(ghostty)

# Check every package before changing any links. Never adopt or overwrite files.
stow --no-folding --ignore='\.DS_Store$' --ignore='\.swp$' --dir="$DOTFILES_DIR" --target="$HOME" --simulate --restow "${PACKAGES[@]}"
if [[ $DRY_RUN == true ]]; then
  echo 'Dry run complete; no links changed.'
else
  stow --no-folding --ignore='\.DS_Store$' --ignore='\.swp$' --dir="$DOTFILES_DIR" --target="$HOME" --restow "${PACKAGES[@]}"
  echo 'Dotfiles linked. Open a new terminal or run: exec zsh'
fi
