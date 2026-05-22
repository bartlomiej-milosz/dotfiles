#!/usr/bin/env bash
# ============================================================
# scripts/purge.sh
# Unlink all dotfile symlinks and remove leftover config files.
# Restores the system to a state as if dotfiles were never applied.
# Usage: ./scripts/purge.sh [package]
#   No args : purge everything
#   With arg : purge single package, e.g. ./scripts/purge.sh nvim
# ============================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$HOME"

PACKAGES=(
  ghostty
  nvim
  sheldon
  starship
  zsh
)

# Files/dirs to remove after unstowing (not managed by stow)
# Add anything that gets created at runtime and should be cleaned up.
# NOTE: ~/.zsh_history is deliberately NOT listed — command history is kept
# across purges so frequent dotfile reinstalls don't wipe it.
EXTRA_CLEANUP=(
  "$HOME/.zcompdump"
  "$HOME/.local/share/nvim"    # lazy.nvim plugins
  "$HOME/.local/state/nvim"    # nvim state
  "$HOME/.local/share/sheldon" # sheldon plugin cache
  "$HOME/.cache/nvim"
  "$HOME/.cache/starship"
)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

log_ok() { echo -e "${GREEN}✓${NC}  $1"; }
log_warn() { echo -e "${YELLOW}!${NC}  $1"; }
log_err() { echo -e "${RED}✗${NC}  $1"; }

if ! command -v stow &>/dev/null; then
  log_err "stow not found — install with: brew install stow"
  exit 1
fi

# Single package mode
if [[ $# -eq 1 ]]; then
  PACKAGES=("$1")
  EXTRA_CLEANUP=() # skip cleanup when targeting single package
fi

# ── Confirm ──────────────────────────────────────────────────
echo ""
if [[ ${#PACKAGES[@]} -gt 1 ]]; then
  echo -e "${BOLD}This will remove all dotfile symlinks and runtime caches.${NC}"
  read -r -p "Continue? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || {
    echo "Aborted."
    exit 0
  }
fi

echo ""

# ── Unstow packages ──────────────────────────────────────────
echo -e "${BOLD}── Unlinking packages${NC}"
for pkg in "${PACKAGES[@]}"; do
  pkg_path="$DOTFILES_DIR/$pkg"

  if [[ ! -d "$pkg_path" ]]; then
    log_warn "$pkg — directory not found, skipping"
    continue
  fi

  if stow --dir="$DOTFILES_DIR" --target="$TARGET_DIR" --delete "$pkg" 2>/dev/null; then
    log_ok "$pkg"
  else
    log_err "$pkg — failed"
  fi
done

# ── Remove runtime caches ────────────────────────────────────
if [[ ${#EXTRA_CLEANUP[@]} -gt 0 ]]; then
  echo ""
  echo -e "${BOLD}── Removing caches${NC}"
  for path in "${EXTRA_CLEANUP[@]}"; do
    if [[ -e "$path" || -L "$path" ]]; then
      rm -rf "$path"
      log_ok "removed $path"
    fi
  done
fi

echo ""
echo "System returned to clean state."
