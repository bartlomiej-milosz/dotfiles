#!/usr/bin/env bash
# Unlink managed configs; preserve caches, history, and installed applications.
# Usage: ./scripts/purge.sh [git|sheldon|starship|zsh|ghostty]
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES=(git sheldon starship zsh ghostty)
if [[ $# -gt 1 ]]; then
  echo 'Usage: purge.sh [git|sheldon|starship|zsh|ghostty]' >&2
  exit 1
elif [[ $# == 1 ]]; then
  case "$1" in
  git | sheldon | starship | zsh | ghostty) PACKAGES=("$1") ;;
  *)
    printf 'Unknown package: %s\n' "$1" >&2
    exit 1
    ;;
  esac
else
  read -r -p 'Unlink all managed configs? [y/N] ' confirm
  [[ $confirm == y || $confirm == Y ]] || exit 0
fi
command -v stow >/dev/null || {
  echo 'Install GNU Stow first.' >&2
  exit 1
}
stow --no-folding --ignore='\.DS_Store$' --ignore='\.swp$' --dir="$DOTFILES_DIR" --target="$HOME" --delete "${PACKAGES[@]}"
echo 'Configs unlinked. History, caches, and installed applications were preserved.'
