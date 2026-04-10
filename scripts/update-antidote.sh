#!/bin/bash

# update-antidote.sh
# Ensures Antidote is installed, updates it, and updates Zsh plugins.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
ANTIDOTE_DIR="$DOTFILES_DIR/zsh/.zsh/antidote"

# 1. Install or Update Antidote
if [ -d "$ANTIDOTE_DIR/.git" ]; then
    echo "Updating Antidote..."
    git -C "$ANTIDOTE_DIR" pull
else
    echo "Antidote not found. Installing..."
    # Ensure the parent directory exists before cloning
    mkdir -p "$(dirname "$ANTIDOTE_DIR")"
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

# 2. Update Plugins
echo "Updating plugins..."
if [ -f "$ANTIDOTE_DIR/antidote" ]; then
    zsh "$ANTIDOTE_DIR/antidote" update
else
    echo "Error: Antidote executable not found even after installation attempt."
    exit 1
fi

echo "Done!"

