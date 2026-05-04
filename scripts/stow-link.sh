#!/bin/bash

# stow-install.sh
# OS-agnostic installation script using GNU Stow

# 1. Check if GNU Stow is installed
if ! command -v stow >/dev/null 2>&1; then
    echo "Error: GNU Stow is not installed."
    echo "Please install it using your system's package manager before running this script."
    exit 1
fi

# 2. Determine the root dotfiles directory (moving one level up from 'scripts/')
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Dotfiles directory: $DOTFILES_DIR"

# 3. Ensure .config directory exists to prevent directory folding
mkdir -p "$HOME/.config"

# 4. Packages to stow
PACKAGES=(
    "git"
    "ghostty"
    "ideavim"
    "nvim"
    "tmux"
    "zsh"
)

# 5. Run stow for each package
for package in "${PACKAGES[@]}"; do
    echo "Stowing $package..."
    # -v: verbose
    # -R: restow (updates symlinks, pruning old ones)
    # -d: source directory (forces the exact source folder)
    # -t: target directory
    stow -v -R -d "$DOTFILES_DIR" -t "$HOME" "$package"
done

echo "Done! Configuration symlinks have been successfully created."

