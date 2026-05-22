#!/usr/bin/env bash
# ============================================================
# scripts/sync.sh
# Link all dotfile packages via GNU Stow.
# Run after cloning or after any change in dotfiles.
# Usage: ./scripts/sync.sh
# ============================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$HOME"

PACKAGES=(
  ghostty
  git
  nvim
  sheldon
  starship
  zsh
)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_ok() { echo -e "${GREEN}✓${NC}  $1"; }
log_warn() { echo -e "${YELLOW}!${NC}  $1"; }
log_err() { echo -e "${RED}✗${NC}  $1"; }

if ! command -v stow &>/dev/null; then
  log_err "stow not found — install with: brew install stow"
  exit 1
fi

echo ""
echo "Dotfiles : $DOTFILES_DIR"
echo "Target   : $TARGET_DIR"
echo ""

for pkg in "${PACKAGES[@]}"; do
  pkg_path="$DOTFILES_DIR/$pkg"

  if [[ ! -d "$pkg_path" ]]; then
    log_warn "$pkg — directory not found, skipping"
    continue
  fi

  if stow --dir="$DOTFILES_DIR" --target="$TARGET_DIR" --restow "$pkg" 2>/dev/null; then
    log_ok "$pkg"
  else
    log_warn "$pkg — conflict, attempting adopt + restow"
    if stow --dir="$DOTFILES_DIR" --target="$TARGET_DIR" --adopt "$pkg" &&
      stow --dir="$DOTFILES_DIR" --target="$TARGET_DIR" --restow "$pkg" 2>/dev/null; then
      log_ok "$pkg (adopted)"
    else
      log_err "$pkg — failed, resolve manually"
    fi
  fi
done

echo ""
echo "Done. Reload shell: source ~/.zshrc"
