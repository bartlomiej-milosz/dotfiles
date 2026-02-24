#!/bin/bash

# uninstall.sh
# Removes all dotfiles configurations (symlinks) and cleans up cache/state.

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ask for confirmation
if [[ "$1" != "--force" ]]; then
    read -p "This will remove all dotfiles symlinks and neovim cache/state. Are you sure? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# 1. Unstow if available
if command_exists stow; then
    echo "Unstowing packages..."
    PACKAGES=(
        "zsh"
        "ghostty"
        "ideavim"
        "nvim"
    )
    for package in "${PACKAGES[@]}"; do
        # -D: delete (unstow)
        stow -D -t "$HOME" "$package" 2>/dev/null || true
    done
fi

# 2. Manual cleanup of potential leftovers (symlinks or directories in HOME)
echo "Cleaning up configurations..."

# Zsh
rm -rf "$HOME/.zsh"
rm -f "$HOME/.zshrc"

# Ghostty
rm -rf "$HOME/.config/ghostty"

# Ideavim
rm -f "$HOME/.ideavimrc"
rm -f "$HOME/.ideavimrc-doc"

# Neovim (config)
rm -rf "$HOME/.config/nvim"

# 3. Clean up cache and state
echo "Cleaning up cache and state..."

# Neovim
rm -rf "$HOME/.cache/nvim"
rm -rf "$HOME/.local/share/nvim"
rm -rf "$HOME/.local/state/nvim"
# Java Language Server (often used with nvim-jdtls)
rm -rf "$HOME/.cache/jdtls"

# Cleanup empty .config if we made it empty (optional, but clean)
rmdir "$HOME/.config" 2>/dev/null || true

echo "Done! Dotfiles have been uninstalled and caches purged."
