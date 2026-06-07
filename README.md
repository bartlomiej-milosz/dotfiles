# dotfiles

A terminal-centric setup for **macOS and Arch Linux** managed with [GNU Stow](https://www.gnu.org/software/stow/).
Built around full control over the environment — native binaries, minimal dependencies, and configs that compose cleanly. One set of configs drives both machines; the per-OS differences live entirely in the bootstrap scripts.

## Stack

| Layer | Tool |
| :--- | :--- |
| Shell | [Zsh](https://www.zsh.org/) + [Sheldon](https://sheldon.cli.rs/) (plugin manager) |
| Prompt | [Starship](https://starship.rs/) |
| Terminal | [Ghostty](https://ghostty.org/) |
| Editor | [Neovim](https://neovim.io/) + [LazyVim](https://www.lazyvim.org/) · [IdeaVim](https://github.com/JetBrains/ideavim) |
| Dotfile manager | [GNU Stow](https://www.gnu.org/software/stow/) |
| CLI replacements | `eza` · `bat` · `zoxide` · `fzf` · `fd` |

## Repository structure

Each top-level directory is a Stow package that mirrors the target home directory structure:

```
dotfiles/
├── ghostty/        →  ~/.config/ghostty/
├── git/            →  ~/.gitconfig
├── ideavim/        →  ~/.ideavimrc
├── nvim/           →  ~/.config/nvim/
├── sheldon/        →  ~/.config/sheldon/
├── starship/       →  ~/.config/starship.toml
├── zsh/            →  ~/.zshrc
└── scripts/        —  utility scripts (not stowed)
```

## Quick start

Clone, then run the bootstrap script for your OS:

```bash
git clone git@github.com:bartlomiej-milosz/dotfiles.git ~/dotfiles
cd ~/dotfiles

./scripts/install-macos.sh   # macOS  (Homebrew)
./scripts/install-arch.sh    # Arch Linux (pacman)
```

Both scripts are idempotent and do everything end to end:

1. install every CLI tool the dotfiles depend on,
2. link all packages via `scripts/sync.sh` (`stow --restow`).

**macOS** (`install-macos.sh`) installs Homebrew if missing, then the formulae
`git stow sheldon starship eza bat zoxide fzf fd ripgrep`, GNU userland
(`coreutils gnu-sed grep gawk bash`), `neovim tree-sitter luacheck`, the runtimes
`node go python`, and the `ghostty` cask.

**Arch** (`install-arch.sh`) installs everything from the official repos with
pacman — no AUR needed: `git stow sheldon starship eza bat zoxide fzf fd ripgrep
neovim tree-sitter-cli luacheck nodejs npm go python python-pip unzip wl-clipboard
ghostty`. No GNU userland (Arch ships it natively), plus `wl-clipboard` for the
nvim system clipboard and a generated `en_US.UTF-8` locale.

Neovim's LSPs / formatters / linters / debug adapters are installed by **mason**
on first launch — the scripts only provide the runtimes mason builds them with.

The terminal font — **Commit Mono** — ships as a Homebrew cask on macOS
(`font-commit-mono-nerd-font`); on Arch the install script prints a reminder
to grab it by hand. Use a Nerd Font build so `eza` / `starship` icons render.

After it finishes: `exec zsh`, then open `nvim` once to let mason finish.

## Packages

### Zsh (`zsh/`)

- Effectively unlimited history (1M lines) shared across sessions with deduplication and timestamps
- Tab completion with case-insensitive matching and colored output
- `AUTO_CD`, `AUTO_PUSHD`, `CORRECT` enabled
- GNU coreutils on macOS (consistent `ls`, `sed`, `grep` behaviour across platforms)
- Conditional aliases: `ls`/`ll`/`la`/`lt` → `eza`, `cat` → `bat`, `cd` → `zoxide`
- Git shorthand: `g`, `gs`, `ga`, `gc`, `gp`, `gl`

### Git (`git/`)

Sensible global defaults in `~/.gitconfig`:

- Identity, `nvim` as editor, `main` as default branch
- `push.autoSetupRemote` (no more `--set-upstream`), `push.followTags`, `pull.rebase`
- `fetch.prune`, `rebase.autoStash` + `autoSquash` + `updateRefs`, `rerere` enabled
- `diff.algorithm = histogram`, `merge.conflictStyle = zdiff3`, `help.autocorrect = prompt`
- A few aliases that don't overlap with the zsh `g*` shortcuts: `st`, `last`, `unstage`, `amend`, `graph`

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

[LazyVim](https://www.lazyvim.org/) starter on top of `lazy.nvim` — the upstream
distro handles LSP, completion, formatting, linting, treesitter, mini.* and the
rest of the editor experience:

```
nvim/.config/nvim/
├── init.lua                —  entry point
└── lua/
    ├── config/
    │   ├── options.lua     —  options overrides (empty by default)
    │   ├── keymaps.lua     —  keymap overrides  (empty by default)
    │   ├── autocmds.lua    —  autocmd overrides (empty by default)
    │   └── lazy.lua        —  lazy.nvim + LazyVim bootstrap
    └── plugins/            —  custom plugin specs / LazyVim overrides
```

**Theme**: [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) — ships
with LazyVim, `storm` for dark and `day` for light. Ghostty uses the matching
built-in `tokyonight-storm` / `tokyonight-day` so the terminal and editor share
one look.

External tooling (LSPs, formatters, linters, debug adapters) is installed by
**mason** on first launch; see the install scripts for the runtimes it needs.

### Ghostty (`ghostty/`)

- **Font**: Commit Mono, 20px, ligatures disabled
- **Theme**: `dark:tokyonight-storm, light:tokyonight-day` — follows system appearance (both built into ghostty)
- **Window**: transparent titlebar (theme bg bleeds through), zero padding (balanced), window shadow on
- **Keybinds**: unified on `ctrl+shift` so they're identical on macOS and Linux (`cmd` aliases to Super on Linux and collides with GNOME)
- **Clipboard**: `ctrl+shift+c` copy, `ctrl+shift+v` paste, `ctrl+shift+a` select all
- **Splits**: `ctrl+shift+d` right, `ctrl+shift+e` down, `ctrl+shift+w` close; navigate with `ctrl+shift+hjkl`
- **Tabs**: `ctrl+shift+t` new tab, `ctrl+1-9` jump to tab

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
| `scripts/install-macos.sh` | `./scripts/install-macos.sh` | macOS bootstrap: Homebrew + all packages/cask + stow |
| `scripts/install-arch.sh` | `./scripts/install-arch.sh` | Arch bootstrap: pacman packages + locale + stow |
| `scripts/sync.sh` | `./scripts/sync.sh` | Stow (or re-stow) all packages |
| `scripts/purge.sh` | `./scripts/purge.sh` | Unstow all packages and remove runtime caches |
| `scripts/purge.sh <pkg>` | `./scripts/purge.sh nvim` | Unstow a single package |

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
