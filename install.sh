#!/bin/bash
# remember to use `$HOME` instead `~`

# detect OS and set proper dotfiles path
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "mac OS detected"
    DOTFILES="$HOME/Documents/dev/dotfiles"
else
    echo "linux detected"
    DOTFILES="$HOME/dev/dotfiles"
fi

echo "dotfiles path: $DOTFILES"

# setup `zsh` plugins and `zsh` prompt
ZSH_UTILS="$DOTFILES/zsh/utils"

# clone latest commit only
rm -rf "$ZSH_UTILS/antidote"
git clone --depth=1 "https://github.com/mattmc3/antidote.git" "$ZSH_UTILS/antidote"

# finally symlink init file `.zshrc` and config directory `.zsh/`
rm -rf "$HOME/.zsh"
rm -f "$HOME/.zshrc"
ln -sf "$ZSH_UTILS" "$HOME/.zsh"                      # utils/ -> ~/.zsh
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"          # .zshrc separately        
echo "[OK] zsh configuration linked successfully!"    
