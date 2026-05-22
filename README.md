# dotfiles

A terminal-centric macOS setup managed with [GNU Stow](https://www.gnu.org/software/stow/).
Built around full control over the environment — native binaries, minimal dependencies, and configs that compose cleanly.

## Stack

| Layer | Tool |
| :--- | :--- |
| Shell | [Zsh](https://www.zsh.org/) + [Sheldon](https://sheldon.cli.rs/) (plugin manager) |
| Prompt | [Starship](https://starship.rs/) |
| Terminal | [Ghostty](https://ghostty.org/) |
| Editor | [Neovim](https://neovim.io/) (custom [lazy.nvim](https://github.com/folke/lazy.nvim) config) + [IdeaVim](https://github.com/JetBrains/ideavim) |
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

On a fresh macOS machine, clone and run the bootstrap script:

```bash
git clone git@github.com:bartlomiej-milosz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
```

`install.sh` is idempotent and does everything end to end:

1. installs Homebrew if it's missing,
2. installs every CLI tool and GUI cask the dotfiles depend on,
3. links all packages via `scripts/sync.sh` (`stow --restow`).

It installs the formulae `git stow sheldon starship eza bat zoxide fzf fd ripgrep`,
GNU userland (`coreutils gnu-sed grep gawk bash`), `neovim tree-sitter luacheck`,
the runtimes `node go python`, and the casks `ghostty` + JetBrains Mono fonts.
Neovim's LSPs / formatters / linters / debug adapters are installed by **mason**
on first launch — this script only provides the runtimes mason builds them with.

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

A lean custom configuration on `lazy.nvim`:

```
nvim/.config/nvim/
├── init.lua                —  entry point
└── lua/
    ├── config/
    │   ├── options.lua     —  editor options
    │   ├── keymaps.lua     —  custom key bindings
    │   ├── autocmds.lua    —  auto commands
    │   └── lazy.lua        —  lazy.nvim bootstrap
    └── plugins/
        ├── lsp.lua         —  mason + lspconfig (basedpyright, gopls, bashls, marksman, lua_ls)
        ├── completion.lua  —  blink.cmp completion
        ├── format.lua      —  conform.nvim (stylua, shfmt, gofumpt, prettierd)
        ├── lint.lua        —  nvim-lint (luacheck)
        ├── treesitter.lua  —  syntax / parsers
        ├── dap.lua         —  debugging (debugpy, delve)
        ├── mini.lua        —  mini.nvim modules + clue popup
        ├── noice.lua       —  command-palette cmdline + LSP UI
        ├── theme.lua       —  Rose Pine colorscheme
        └── zen-mode.lua    —  distraction-free writing
```

**Theme**: [vim-colors-xcode](https://github.com/lunacookies/vim-colors-xcode) — Apple's native Xcode palette, `xcodedark` (dark) / `xcodelight` (light).
Switches between dark and light variants based on the macOS system appearance via [auto-dark-mode.nvim](https://github.com/f-person/auto-dark-mode.nvim). Ghostty uses the matching `Apple System Colors` theme so the terminal and editor share one clean, macOS-native look.

External tooling (LSPs, formatters, linters, debug adapters) is installed by **mason** on first launch; see `scripts/install.sh` for the runtimes it needs.

### Ghostty (`ghostty/`)

- **Font**: JetBrains Mono Medium, 20px, ligatures disabled
- **Theme**: `dark:Apple System Colors, light:Apple System Colors Light` — follows macOS appearance
- **Window**: tabbed titlebar, zero padding (balanced), window shadow on
- **Splits**: `cmd+d` right, `cmd+shift+d` down, `cmd+shift+w` close; navigate with `cmd+alt+hjkl`
- **Tabs**: `ctrl+t` new tab, `ctrl+1-9` jump to tab

A set of [zenbones](https://github.com/zenbones-theme/zenbones.nvim) colour themes is also bundled under `ghostty/.config/ghostty/themes/` as ready-to-use alternatives.

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
| `scripts/install.sh` | `./scripts/install.sh` | Full bootstrap: Homebrew + all packages/casks + stow |
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
