#!/usr/bin/env bash
# ============================================================
# scripts/install-macos.sh
# One-shot bootstrap for a fresh macOS machine:
#   1. install Homebrew (if missing)
#   2. install every CLI tool + GUI cask the dotfiles depend on
#   3. link the dotfiles via scripts/sync.sh
# Usage: ./scripts/install-macos.sh
# (Arch Linux: use ./scripts/install-arch.sh instead.)
#
# Idempotent: safe to re-run; already-installed packages are skipped.
#
# Neovim's LSPs / formatters / linters / debug adapters are installed by
# mason on first launch (basedpyright, ruff, gopls, gofumpt, goimports,
# golines, delve, prettierd, marksman, shfmt, debugpy, ...). This script
# only provides the runtimes mason needs to build them (node, go, python)
# plus the two tools mason can't install (tree-sitter, luacheck).
# ============================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

log_ok() { echo -e "${GREEN}✓${NC}  $1"; }
log_warn() { echo -e "${YELLOW}!${NC}  $1"; }
log_err() { echo -e "${RED}✗${NC}  $1"; }
step() { echo -e "\n${BOLD}── $1${NC}"; }

# ── Formulae (CLI) ───────────────────────────────────────────
FORMULAE=(
  # dotfile management
  git stow
  # shell stack
  sheldon starship eza bat zoxide fzf fd ripgrep
  # GNU userland (.zshrc puts these ahead of the BSD tools on macOS)
  coreutils gnu-sed grep gawk bash
  # editor + nvim externals mason can't install
  neovim tree-sitter luacheck
  # runtimes mason uses to build LSPs / formatters / linters / DAPs
  node go python
)

# ── Casks (GUI) ──────────────────────────────────────────────
CASKS=(
  ghostty
)
# Optional (IdeaVim host — not stowed by sync.sh, install only if you use it):
#   brew install --cask intellij-idea

# ── Fonts (manual) ───────────────────────────────────────────
# The terminal font (ghostty + zed) is "Iosevka Term Curly Slab", which has no
# Homebrew cask — install it by hand. For eza / starship icons to render you
# need a Nerd Font build of that variant (the base release has no icon glyphs).
FONT_FAMILY="Iosevka Term Curly Slab"
FONT_URL="https://github.com/be5invis/Iosevka/releases"

# ── 1. Homebrew ──────────────────────────────────────────────
step "Homebrew"
if ! command -v brew &>/dev/null; then
  log_warn "Homebrew not found — installing"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Load brew into the current shell (Apple Silicon vs Intel paths).
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  log_ok "Homebrew present"
fi

brew update

# ── 2. Formulae ──────────────────────────────────────────────
step "CLI tools"
for f in "${FORMULAE[@]}"; do
  if brew list --formula "$f" &>/dev/null; then
    log_ok "$f (already installed)"
  elif brew install "$f"; then
    log_ok "$f"
  else
    log_err "$f — failed"
  fi
done

# ── 3. Casks ─────────────────────────────────────────────────
step "Apps & fonts"
for c in "${CASKS[@]}"; do
  if brew list --cask "$c" &>/dev/null; then
    log_ok "$c (already installed)"
  elif brew install --cask "$c"; then
    log_ok "$c"
  else
    log_err "$c — failed"
  fi
done

# ── 4. Link dotfiles ─────────────────────────────────────────
step "Linking dotfiles"
"$DOTFILES_DIR/scripts/sync.sh"

# ── Fonts (manual reminder) ──────────────────────────────────
step "Fonts (manual)"
log_warn "Install the terminal font by hand — it's not in Homebrew:"
echo "    Family : $FONT_FAMILY"
echo "    Source : $FONT_URL"
echo "    Use a Nerd Font build of this variant, or eza / starship icons won't render."

# ── Done ─────────────────────────────────────────────────────
step "Done"
echo "Reload your shell:  exec zsh"
echo "Open nvim once so mason can install LSPs / formatters / linters."
