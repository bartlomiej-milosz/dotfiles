# Dotfiles

A collection of my personal configuration files for macOS/Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/). 
Designed for a highly productive, terminal-centric workflow featuring **Neovim**, **Zsh**, and **Ghostty**.

## Tech Stack

- **Shell**: [Zsh](https://www.zsh.org/) + [Antidote](https://getantidote.github.io/) (Plugin Manager)
- **Editor**: [Neovim](https://neovim.io/) (LazyVim based) + [IdeaVim](https://github.com/JetBrains/ideavim) (for JetBrains IDEs)
- **Terminal**: [Ghostty](https://ghostty.org/)
- **Management**: [GNU Stow](https://www.gnu.org/software/stow/)

## Installation

### Prerequisites

| Tool     | Installation (macOS) |
| -------- | -------------------- |
| **Stow** | `brew install stow`  |
| **Git**  | `brew install git`   |

### Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2.  **Install/Stow configurations:**
    Run the installation script to symlink all configurations to your home directory.
    ```bash
    ./stow-install.sh
    ```

    *This script uses `stow` to create symlinks from this repo to your `$HOME` directory (`~/.zshrc`, `~/.config/nvim`, etc.).*

## Structure

The repository is organized into **stow packages**. Each top-level directory corresponds to a configuration package.

```
dotfiles/
├── zsh/           -> Symlinks to ~/.zshrc, ~/.zsh/
├── nvim/          -> Symlinks to ~/.config/nvim/
├── ghostty/       -> Symlinks to ~/.config/ghostty/
└── ideavim/       -> Symlinks to ~/.ideavimrc
└── scripts/       -> Admin scripts (purge, install)
```

## Maintenance

- **Add new config**: Create a new folder (e.g., `tmux`), add files inside (replicating the home dir structure, e.g., `tmux/.tmux.conf`), and run `./stow-install.sh`.
- **Remove/Clean**: To remove all symlinks and clear cache/state:
    ```bash
    ./scripts/uninstall.sh
    ```
- **Ignore files**: The `.stow-local-ignore` file ensures that repo-only files (like `README.md`, `.git`) are not symlinked to your home directory.

## Updates

- **Update Antidote & Plugins**:
    ```bash
    ./scripts/update-antidote.sh
    ```

---
