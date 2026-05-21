# dotfiles

A terminal-centric macOS setup managed with [GNU Stow](https://www.gnu.org/software/stow/).
Built around full control over the environment — native binaries, minimal dependencies, and configs that compose cleanly.

## Stack

| Layer | Tool |
| :--- | :--- |
| Shell | [Zsh](https://www.zsh.org/) + [Sheldon](https://sheldon.cli.rs/) (plugin manager) |
| Prompt | [Starship](https://starship.rs/) |
| Terminal | [Ghostty](https://ghostty.org/) |
| Editor | [Neovim](https://neovim.io/) (LazyVim-based) + [IdeaVim](https://github.com/JetBrains/ideavim) |
| Dotfile manager | [GNU Stow](https://www.gnu.org/software/stow/) |
| CLI replacements | `eza` · `bat` · `zoxide` · `fzf` · `fd` |

## Repository structure

Each top-level directory is a Stow package that mirrors the target home directory structure:

```
dotfiles/
├── ghostty/        →  ~/.config/ghostty/
├── ideavim/        →  ~/.ideavimrc
├── nvim/           →  ~/.config/nvim/
├── sheldon/        →  ~/.config/sheldon/
├── starship/       →  ~/.config/starship.toml
├── zsh/            →  ~/.zshrc
└── scripts/        —  utility scripts (not stowed)
```

## Quick start

### Prerequisites

Install dependencies on macOS:

```bash
brew install git stow
bash scripts/zsh_deps_mac.sh
```

`zsh_deps_mac.sh` installs: `sheldon starship eza bat zoxide fzf fd` and GNU coreutils (`coreutils gnu-sed grep gawk bash`).

### Clone and link

```bash
git clone git@github.com:bartlomiej-milosz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/sync.sh
```

`sync.sh` runs `stow --restow` for each package. Conflicts are resolved automatically with `--adopt`.

## Packages

### Zsh (`zsh/`)

- 50k-line history shared across sessions with deduplication and timestamps
- Tab completion with case-insensitive matching and colored output
- `AUTO_CD`, `AUTO_PUSHD`, `CORRECT` enabled
- GNU coreutils on macOS (consistent `ls`, `sed`, `grep` behaviour across platforms)
- Conditional aliases: `ls`/`ll`/`la`/`lt` → `eza`, `cat` → `bat`, `cd` → `zoxide`
- Git shorthand: `g`, `gs`, `ga`, `gc`, `gp`, `gl`

### Sheldon plugins (`sheldon/`)

Plugins are sourced via `eval "$(sheldon source)"`:

| Plugin | Purpose |
| :--- | :--- |
| `zsh-completions` | Extended completion definitions |
| `zsh-syntax-highlighting` | Fish-like real-time syntax highlighting |
| `zsh-autosuggestions` | History- and completion-based inline suggestions |
| `zsh-history-substring-search` | `↑`/`↓` searches history by typed prefix |

### Starship prompt (`starship/`)

Minimal two-line prompt showing: directory → git branch + status → Python / Go version → command duration.

- Success: `❯` (purple) · Error: `❯` (red) · Vim normal mode: `❮` (green)
- Git status symbols: `⇡⇣` ahead/behind · `!` modified · `?` untracked · `+` staged · `✘` deleted
- Command duration displayed for commands longer than 2 s
- Node, Rust, Docker, Conda segments disabled (low noise)

### Neovim (`nvim/`)

LazyVim-based configuration with a minimal custom layer on top:

```
nvim/.config/nvim/
├── init.lua              —  entry point
└── lua/
    ├── config/
    │   ├── options.lua   —  editor options
    │   ├── keymaps.lua   —  custom key bindings
    │   ├── autocmds.lua  —  auto commands
    │   └── lazy.lua      —  lazy.nvim bootstrap
    └── plugins/
        ├── theme.lua     —  zenbones/zenwritten colorscheme
        └── zen-mode.lua  —  distraction-free writing
```

**Theme**: [zenwritten](https://github.com/zenbones-theme/zenbones.nvim) — zero-hue, contrast-based.
Automatically switches between dark and light variants based on the macOS system appearance via [auto-dark-mode.nvim](https://github.com/f-person/auto-dark-mode.nvim). Ghostty uses the matching `zenwritten_dark` / `zenwritten_light` theme so the terminal and editor stay in sync.

### Ghostty (`ghostty/`)

- **Font**: Geist Mono 16px, ligatures disabled
- **Theme**: `dark:zenwritten_dark, light:zenwritten_light` — follows macOS appearance
- **Window**: hidden title bar, balanced padding, no drop shadow
- **Splits**: `cmd+d` vertical, `cmd+shift+d` horizontal; navigate with `cmd+alt+hjkl`
- **Tabs**: `ctrl+t` new tab, `ctrl+1-9` jump to tab

Eighteen [zenbones](https://github.com/zenbones-theme/zenbones.nvim) colour themes are included under `ghostty/.config/ghostty/themes/` for easy switching.

### IdeaVim (`ideavim/`)

Full Vim emulation for IntelliJ IDEA with `<Space>` as leader and [which-key](https://github.com/TheBlob42/idea-which-key) popup.

**Plugin emulations**: `surround` · `commentary` · `ReplaceWithRegister` · `exchange` · `argtextobj` · `textobj-entire` · `textobj-indent` · `sneak` · `quickscope` · `matchit` · `multiple-cursors` · `NERDTree`

**Leader groups**:

| Prefix | Group |
| :--- | :--- |
| `<leader>f` | Find (files, grep, buffers, symbols) |
| `<leader>c` | Code actions (rename, format, imports, generate) |
| `<leader>r` | Refactor (extract method/variable) |
| `<leader>g` | Git (status, blame, history, diff, branches) |
| `<leader>x` | Run & test · `<leader>d` Debug |
| `<leader>w` | Window splits · `<leader>b` Buffers |
| `<leader>k` | Bookmarks · `<leader>t` Terminal |

> **Note**: `ideavim` is not included in `sync.sh`. Stow it manually if needed:
> ```bash
> stow --dir=~/dotfiles --target="$HOME" ideavim
> ```

## Scripts

| Script | Usage | Description |
| :--- | :--- | :--- |
| `scripts/sync.sh` | `./scripts/sync.sh` | Stow (or re-stow) all packages |
| `scripts/purge.sh` | `./scripts/purge.sh` | Unstow all packages and remove runtime caches |
| `scripts/purge.sh <pkg>` | `./scripts/purge.sh nvim` | Unstow a single package |
| `scripts/zsh_deps_mac.sh` | `bash scripts/zsh_deps_mac.sh` | Install all macOS Homebrew dependencies |

## Maintenance

**Add a new config:**
1. Create `<tool>/<mirror of home dir structure>/` (e.g. `tmux/.tmux.conf`)
2. Add the package name to the `PACKAGES` array in `scripts/sync.sh`
3. Run `./scripts/sync.sh`

**Remove all symlinks and caches** (full reset):
```bash
./scripts/purge.sh
```

**Update Sheldon plugins:**
```bash
sheldon lock --update
```

**Files excluded from stowing** are listed in `.stow-local-ignore` (e.g. `README.md`, `.git`, `.DS_Store`).
