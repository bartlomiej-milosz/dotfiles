# Dotfiles

A collection of my personal configuration files for macOS and Linux (Ubuntu), managed with [GNU Stow](https://www.gnu.org/software/stow/). 
Designed for a highly productive, terminal-centric workflow featuring **Neovim**, **Zsh**, and **Ghostty**. Built with a "full control" ideology, preferring native binaries and isolated environments over heavy package managers like Snap.

## Tech Stack

- **Shell**: [Zsh](https://www.zsh.org/) + [Antidote](https://getantidote.github.io/) (Plugin Manager) + FZF
- **Editor**: [Neovim](https://neovim.io/) (LazyVim based, native binary) + [IdeaVim](https://github.com/JetBrains/ideavim) (for JetBrains IDEs)
- **Terminal**: [Ghostty](https://ghostty.org/) (Native installation)
- **Runtimes**: Node.js (via NVM) / Java 21 (via SDKMAN or APT)
- **Management**: [GNU Stow](https://www.gnu.org/software/stow/)

## Installation

### Prerequisites

| Tool | macOS (Homebrew) | Ubuntu (APT / Manual) |
| :--- | :--- | :--- |
| **Git** | `brew install git` | `sudo apt install git` |
| **Stow** | `brew install stow` | `sudo apt install stow` |
| **Curl** | Built-in | `sudo apt install curl` |

*Note for Ubuntu users: SSH keys (Ed25519) must be configured and added to GitHub before cloning to avoid authentication prompts.*

### Setup

1.  **Clone the repository (via SSH):**
    ```bash
    git clone git@github.com:bartlomiej-milosz/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2.  **System-specific preparation (Ubuntu only):**
    If you are setting up a fresh Ubuntu environment, run the bootstrap script to install native binaries (Neovim, Ghostty) and avoid Snap limitations:
    ```bash
    ./scripts/ubuntu-setup.sh
    ```

3.  **Install/Stow configurations:**
    Run the installation script to symlink all configurations to your home directory.
    ```bash
    ./stow-install.sh
    ```
    *This script uses `stow` to create symlinks from this repo to your `$HOME` directory (`~/.zshrc`, `~/.config/nvim`, etc.).*

## Structure

The repository is organized into **stow packages**. Each top-level directory corresponds to a configuration package. OS-specific logic (like PATH management and LS_COLORS) is handled dynamically inside the scripts.

```text
dotfiles/
├── zsh/           -> Symlinks to ~/.zshrc, ~/.zsh/
├── nvim/          -> Symlinks to ~/.config/nvim/
├── ghostty/       -> Symlinks to ~/.config/ghostty/
├── ideavim/       -> Symlinks to ~/.ideavimrc
└── scripts/       -> System management scripts (setup, update, uninstall)
```

## Maintenance

- **Add new config**: Create a new folder (e.g., `tmux`), add files inside (replicating the home dir structure, e.g., `tmux/.tmux.conf`), and run `./stow-install.sh`.
- **Remove/Clean**: To remove all symlinks and clear cache/state:
  ```bash
  ./scripts/uninstall.sh
  ```
- **Ignore files**: The `.stow-local-ignore` file ensures that repo-only files (like `README.md`, `.git`) are not symlinked to your home directory.

## Updates & Automation

To keep the system and binaries up to date, use the included update scripts:

- **Update All (Ubuntu):** Updates APT, refreshes native binaries (Neovim/Ghostty), and updates global NPM packages.
  ```bash
  ./scripts/update-all.sh
  ```

- **Update Antidote & Zsh Plugins**:
  ```bash
  ./scripts/update-antidote.sh
  ```

