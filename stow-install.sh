#!/bin/bash

# stow-install.sh
# Installation script using GNU Stow

# Check for stow
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed."
    echo "Please install it using: brew install stow"
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Dotfiles directory: $DOTFILES_DIR"

# Ensure .config directory exists
mkdir -p "$HOME/.config"

# Packages to stow
PACKAGES=(
    "zsh"
    "ghostty"
    "ideavim"
    "nvim"
)

# Run stow for each package
for package in "${PACKAGES[@]}"; do
    echo "Stowing $package..."
    # -v: verbose
    # -R: restow (updates symlinks, pruning old ones)
    stow -v -R -t "$HOME" "$package"
done

echo "Done!"
