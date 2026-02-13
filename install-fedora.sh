#!/bin/bash

# GENERAL SETUP
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_PATH=""
DOTFILES="${CUSTOM_PATH:-$SCRIPT_DIR}"

echo "===================================="
echo "Fedora Dotfiles Installation Script"
echo "===================================="
echo "dotfiles path: $DOTFILES"
echo ""

# INSTALL DEPENDENCIES
echo "[1/4] Installing dependencies..."
sudo dnf install -y \
  zsh \
  fzf \
  git \
  curl \
  gcc \
  make \
  nodejs \
  npm \
  neovim

# Optional: Nerd Fonts
echo "[Optional] Install Nerd Fonts? (y/n)"
read -r install_fonts
if [[ "$install_fonts" == "y" ]]; then
  FONTS_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONTS_DIR"
  curl -fLo "$FONTS_DIR/JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip "$FONTS_DIR/JetBrainsMono.zip" -d "$FONTS_DIR"
  rm "$FONTS_DIR/JetBrainsMono.zip"
  fc-cache -fv
  echo "  [✓] JetBrains Mono Nerd Font installed"
fi

# SET ZSH AS DEFAULT SHELL
echo "[2/4] Setting zsh as default shell..."
if [[ "$SHELL" != *"zsh"* ]]; then
  chsh -s "$(which zsh)"
  echo "Please log out and log back in for shell change to take effect"
fi

# LINKING DOTFILES
echo "[3/4] Linking dotfiles..."

# ZSH
ZSH_UTILS="$DOTFILES/zsh/.zsh"
rm -rf "$ZSH_UTILS/antidote"
git clone --depth=1 "https://github.com/mattmc3/antidote.git" "$ZSH_UTILS/antidote"
rm -rf "$HOME/.zsh"
rm -f "$HOME/.zshrc"
ln -sf "$ZSH_UTILS" "$HOME/.zsh"
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
echo "  [✓] zsh configuration linked"

# IDEAVIM
rm -rf "$HOME/.ideavimrc"
ln -sf "$DOTFILES/ideavim/.ideavimrc" "$HOME/.ideavimrc"
echo "  [✓] ideavim configuration linked"

# .CONFIG TOOLS
mkdir -p "$HOME/.config"

# Ghostty
rm -rf "$HOME/.config/ghostty"
ln -sf "$DOTFILES/ghostty/.config/ghostty" "$HOME/.config/ghostty"
echo "  [✓] ghostty configuration linked"

# Neovim
rm -rf "$HOME/.config/nvim"
ln -sf "$DOTFILES/nvim/.config/nvim-lazyvim" "$HOME/.config/nvim"
echo "  [✓] nvim configuration linked"

# FINAL STEPS
echo "[4/4] Final setup..."
echo "" 
echo "===================================="
echo "Installation complete!"
echo "===================================="
echo ""
echo "Next steps:"
echo "1. Log out and log back in (for zsh to take effect)"
echo "2. Open a new terminal"
echo "3. Run 'nvim' and wait for plugins to install"
echo "4. Enjoy your dotfiles!"
echo ""
