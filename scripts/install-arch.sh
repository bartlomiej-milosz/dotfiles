#!/usr/bin/env bash
# ============================================================
# scripts/install-arch.sh
# One-shot bootstrap for a fresh Arch Linux machine:
#   1. install every CLI tool the dotfiles depend on (pacman)
#   2. generate the en_US.UTF-8 locale .zshrc expects
#   3. link the dotfiles via scripts/sync.sh
# Usage: ./scripts/install-arch.sh
# (macOS: use ./scripts/install-macos.sh instead.)
#
# Idempotent: safe to re-run; `pacman --needed` skips installed packages.
#
# Everything lives in the official repos (extra/core) — no AUR helper needed.
# Unlike macOS, no GNU userland packages are installed: Arch ships GNU coreutils,
# sed, grep, gawk, and bash natively, and .zshrc only prepends the brew gnubin
# paths on Darwin.
#
# Neovim's LSPs / formatters / linters / debug adapters are installed by mason
# on first launch (basedpyright, ruff, gopls, gofumpt, goimports, golines, delve,
# prettierd, marksman, shfmt, debugpy, ...). This script only provides the
# runtimes mason needs (node, npm, go, python, pip, unzip) plus the two tools
# mason can't install (tree-sitter, luacheck).
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

# ── Packages (pacman, all official) ──────────────────────────
PACKAGES=(
  # dotfile management
  git stow
  # shell stack
  sheldon starship eza bat zoxide fzf fd ripgrep
  # editor + nvim externals mason can't install
  neovim tree-sitter-cli luacheck
  # runtimes mason uses to build LSPs / formatters / linters / DAPs
  nodejs npm go python python-pip
  # mason needs unzip to unpack some tools
  unzip
  # nvim system clipboard (clipboard=unnamedplus) on Wayland/GNOME
  wl-clipboard
  # terminal
  ghostty
)

# ── 1. Sanity check ──────────────────────────────────────────
step "Environment"
if ! command -v pacman &>/dev/null; then
  log_err "pacman not found — this script is for Arch Linux. On macOS use install-macos.sh."
  exit 1
fi
log_ok "pacman present"

# ── 2. Packages ──────────────────────────────────────────────
# A single --needed install also does a full upgrade (-u), which avoids the
# partial-upgrade pitfall of running -Sy on its own.
step "CLI tools, terminal & runtimes"
echo "Installing: ${PACKAGES[*]}"
if sudo pacman -Syu --needed "${PACKAGES[@]}"; then
  log_ok "packages installed / up to date"
else
  log_err "pacman failed — resolve the errors above and re-run"
  exit 1
fi

# ── 3. Locale ────────────────────────────────────────────────
# .zshrc exports LANG / LC_ALL = en_US.UTF-8; generate it if missing.
step "Locale"
if locale -a 2>/dev/null | grep -qiE '^en_US\.?utf-?8$'; then
  log_ok "en_US.UTF-8 already generated"
else
  log_warn "Generating en_US.UTF-8"
  sudo sed -i 's/^#\s*\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
  sudo locale-gen
  log_ok "en_US.UTF-8 generated"
fi

# ── 4. Link dotfiles ─────────────────────────────────────────
step "Linking dotfiles"
"$DOTFILES_DIR/scripts/sync.sh"

# ── 5. Fonts (manual reminder) ───────────────────────────────
# Same font as macOS; install it by hand into ~/.local/share/fonts (or use a
# pacman package if one matches). For eza / starship icons you need a Nerd Font
# build of the variant — the base release has no icon glyphs.
step "Fonts (manual)"
log_warn "Install the terminal font by hand:"
echo "    Family : Iosevka Term Curly Slab"
echo "    Source : https://github.com/be5invis/Iosevka/releases"
echo "    Drop the .ttc files into ~/.local/share/fonts, then run: fc-cache -f"
echo "    Use a Nerd Font build of this variant, or eza / starship icons won't render."

# ── Done ─────────────────────────────────────────────────────
step "Done"
echo "Reload your shell:  exec zsh"
echo "Open nvim once so mason can install LSPs / formatters / linters."
echo "Dark/light follows the GNOME system theme automatically (ghostty + nvim)."
