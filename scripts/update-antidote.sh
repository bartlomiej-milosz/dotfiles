#!/bin/bash

# update-antidote.sh
# Updates Antidote itself and the plugins it manages.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
ANTIDOTE_DIR="$DOTFILES_DIR/zsh/.zsh/antidote"

# 1. Update Antidote (git pull)
echo "Updating Antidote..."
if [ -d "$ANTIDOTE_DIR/.git" ]; then
    git -C "$ANTIDOTE_DIR" pull
else
    echo "Error: Antidote git repository not found at $ANTIDOTE_DIR"
    exit 1
fi

# 2. Update Plugins
echo "Updating plugins..."
# Use the antidote executable directly
if [ -f "$ANTIDOTE_DIR/antidote" ]; then
    zsh "$ANTIDOTE_DIR/antidote" update
else
    echo "Error: Antidote executable not found."
    exit 1
fi

echo "Done!"
