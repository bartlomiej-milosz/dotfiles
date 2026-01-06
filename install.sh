#!/bin/bash

# GENERAL SETUP

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# For custom dotfiles directory, specify desired path below
# Leave empty to use script's directory
CUSTOM_PATH=""
DOTFILES="${CUSTOM_PATH:-$SCRIPT_DIR}"
echo "dotfiles path: $DOTFILES"

# Reminder to install fzf if not exist
if ! command -v fzf &> /dev/null; then
    echo "[IMPORTANT] FZF not found. Install via package manager:"
    echo "macOS: brew install fzf"
    echo "Linux: sudo apt/dnf/pacman install fzf"
fi

# LINKING DOTFILES

# ZSH

ZSH_UTILS="$DOTFILES/zsh/.zsh"

# Install plugin manager
rm -rf "$ZSH_UTILS/antidote"
git clone --depth=1 "https://github.com/mattmc3/antidote.git" "$ZSH_UTILS/antidote"

# Symlink init file `.zshrc` and config directory `.zsh/`
rm -rf "$HOME/.zsh"
rm -f "$HOME/.zshrc"
ln -sf "$ZSH_UTILS" "$HOME/.zsh"
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
echo "[OK] zsh configuration linked successfully!"

# IDEAVIM

rm -rf "$HOME/.ideavimrc"
ln -sf "$DOTFILES/ideavim/.ideavimrc" "$HOME/.ideavimrc"
echo "[OK] ideavim configuration linked successfully!"

# .CONFIG TOOLS

# Ensure .config exists
mkdir -p "$HOME/.config"

# Remove specific subdirectories, not entire .config
rm -rf "$HOME/.config/ghostty"
rm -rf "$HOME/.config/nvim"

# Create symlinks
rm -f "$HOME/.config/ghostty"
rm -f "$HOME/.config/nvim"
ln -sf "$DOTFILES/ghostty/.config/ghostty" "$HOME/.config/ghostty"
echo "[OK] ghostty configuration linked successfully!"

# Choose between two available configs by uncommenting
ln -sf "$DOTFILES/nvim/.config/nvim-custom" "$HOME/.config/nvim"
# ln -sf "$DOTFILES/nvim/.config/nvim-lazyvim" "$HOME/.config/nvim"
echo "[OK] nvim configuration linked successfully!"
