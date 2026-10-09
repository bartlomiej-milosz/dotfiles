# IdeaVim notes

The only configuration source is [`ideavim/.ideavimrc`](../ideavim/.ideavimrc).
This page describes that file; it is not another configuration to copy or source.
IdeaVim is optional and is not included in either installer or `purge.sh`.

From the repository root, check conflicts, link, or unlink it with GNU Stow:

```sh
stow --dir="$PWD" --target="$HOME" --simulate ideavim
stow --dir="$PWD" --target="$HOME" ideavim
stow --dir="$PWD" --target="$HOME" --delete ideavim
```

Stow installs only `~/.ideavimrc`. These notes stay in `docs/`.
If an older installation left a `.ideavimrc-doc` symlink in your home directory,
inspect and remove that obsolete link manually.

## Settings and extensions

The configuration uses relative line numbers, centered scrolling, incremental
search, smart case, the system clipboard and IntelliJ clipboard integration.
`gdefault` makes substitutions global by default: adding the `g` flag toggles
that behavior for the individual substitution. The leader key is **Space**.
The which-key section sets `timeoutlen=1000` and `notimeout`.

The enabled extensions are listed in section 2 of `.ideavimrc`: surround,
commentary, ReplaceWithRegister, exchange, argument/entire/indent text objects,
sneak, quickscope, paragraph motion, matchit, NERDTree, highlighted yank,
multiple cursors and which-key. Some extensions require a separate IDE plugin;
see the [IdeaVim plugin documentation](https://github.com/JetBrains/ideavim/wiki/IdeaVim-Plugins)
for their requirements. The installers do not install IDE plugins.

## Selected shortcuts

These reflect the tracked configuration. See section 5 of `.ideavimrc` for the
complete mappings, including visual-mode variants.

| Action | Shortcut |
| --- | --- |
| Move to left / lower / right split | `Ctrl+H` / `Ctrl+J` / `Ctrl+L` |
| Move to upper split | Vim's built-in `Ctrl+W`, then `k` |
| Parameter info (normal and insert modes) | `Ctrl+K` |
| Resize splits | `Ctrl+Shift+H/J/K/L` |
| Split vertically / horizontally; unsplit | `<leader>wv` / `<leader>ws` / `<leader>wu` |
| Save | `<leader>w` or `<leader>ww` |
| Next / previous / close tab | `<leader>bn` / `<leader>bp` / `<leader>bd` |
| Back / forward; recent locations | `Ctrl+O` / `Ctrl+I`; `<leader>o` |
| Move lines down / up (normal and visual modes) | `Alt+J` / `Alt+K` |
| Start / end of line | `H` / `L` |
| Find file / text / recent files / symbols / everything | `<leader>ff` / `fg` / `fb` / `fs` / `fa` |
| Toggle explorer / find current file in explorer | `<leader>e` / `<leader>E` |
| Declaration / type / implementation / usages | `gd` / `gD` / `gi` / `gr` |
| Documentation; show usages | `K`; `<leader>u` |
| Next / previous error; next / previous method | `]d` / `[d`; `]m` / `[m` |
| Quick fix / rename / format / optimize imports | `<leader>ca` / `cr` / `cf` / `ci` |
| Refactoring menu / extract method / introduce variable | `<leader>rr` / `rm` / `rv` |
| Comment (normal and visual modes) | `<leader>/` |
| Git changes / blame / history / diff / branches | `<leader>gs` / `gb` / `gh` / `gd` / `gB` |
| Run / choose configuration / stop | `<leader>xx` / `xr` / `xs` |
| Run class / test method / failed tests | `<leader>xt` / `xm` / `xf` |
| Debug / breakpoint / stop | `<leader>dd` / `db` / `ds` |
| Toggle / list / next / previous bookmark | `<leader>kk` / `kl` / `kn` / `kp` |
| Terminal / terminal here; database / version control | `<leader>tt` / `tn`; `<leader>vd` / `vg` |
| Distraction-free / Zen mode; dismiss notifications | `<leader>z` / `<leader>Z`; `<leader>n` |
| Insert a line below / above | `<leader>ij` / `<leader>ik` |
| Scroll down / up; search next / previous (centered) | `Ctrl+D` / `Ctrl+U`; `n` / `N` |
| Collapse / expand / toggle fold; collapse / expand all | `zc` / `zo` / `za`; `zM` / `zR` |
| Select / unselect occurrence (visual mode) | `Ctrl+N` / `Ctrl+P` |
| Select all occurrences (visual mode) | `<leader>ma` |
| Indent and keep selection (visual mode) | `<` / `>` |
| Paste without yanking replaced text (visual mode) | `p` |

`Ctrl+K` is reserved for ParameterInfo. Use the built-in `Ctrl+W`, then `k`
sequence to move to the upper split.

Normal-mode `gr` keeps the explicit FindUsages mapping. It overrides the
ReplaceWithRegister default `gr{motion}` operator, so that default cannot be
used on `gr` in normal mode with this configuration. The extension stays enabled;
the explicit IDE action takes precedence in normal mode.

The configuration and these notes were reviewed statically. Shortcuts and plugin
behavior have not been exercised in IntelliJ as part of this review.
