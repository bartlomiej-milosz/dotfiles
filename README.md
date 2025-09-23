# Dotfiles

Personal development environment configuration.

> **Note:** Optimized for macOS. May require adjustments for other operating systems.

## What's Included

- **nvim** - Neovim configuration with LazyVim
- **zsh** - Shell configuration with Antidote plugin manager
- **ghostty** - Terminal emulator themes and config
- **ideavim** - IntelliJ IDEA Vim plugin settings

## Installation

### Quick Setup

```bash
./install.sh
```

### What It Does

The install script will:
1. Check for required dependencies (fzf)
2. Clone Antidote plugin manager for zsh
3. Create symlinks from dotfiles to your home directory
4. Configure all tools automatically

### Requirements

- **fzf** - Fuzzy finder (install via `brew install fzf` on macOS)
- **git** - For cloning plugin managers

## Structure

```
dotfiles/
├── ghostty/          # Terminal emulator
│   └── .config/ghostty/
├── ideavim/          # IntelliJ Vim
│   └── .ideavimrc
├── nvim/             # Neovim editor
│   └── .config/nvim/
├── zsh/              # Shell
│   ├── .zshrc
│   └── .zsh/
└── install.sh        # Setup script
```

## Manual Configuration

To link specific configs manually:

```bash
# Neovim
ln -sf "$PWD/nvim/.config/nvim" "$HOME/.config/nvim"

# Zsh
ln -sf "$PWD/zsh/.zsh" "$HOME/.zsh"
ln -sf "$PWD/zsh/.zshrc" "$HOME/.zshrc"

# Ghostty
ln -sf "$PWD/ghostty/.config/ghostty" "$HOME/.config/ghostty"

# IdeaVim
ln -sf "$PWD/ideavim/.ideavimrc" "$HOME/.ideavimrc"
```

## Customization

Edit the `CUSTOM_PATH` variable in `install.sh` to specify a different dotfiles location:

```bash
CUSTOM_PATH="/path/to/your/dotfiles"
```
