# dotfiles

A small, shared terminal setup for **macOS and Ubuntu 24.04 / 26.04 LTS**
(64-bit amd64 / arm64), managed with GNU Stow.

- **Ghostty** with JetBrains Mono, GitHub Light/Dark following system appearance,
  an opaque background, and a little space around the text.
- **Zsh**, **Starship**, and **fzf** for everyday shell use.
- Two plugins managed by **Sheldon**: history suggestions and syntax highlighting.
- Standard `ls`, `cat`, `cd`, and other system commands. No icon font required.
- An independent **IdeaVim** config, kept as-is and installed separately.

## Install

Clone the repository and run the installer as your regular user:

```sh
git clone git@github.com:bartlomiej-milosz/dotfiles.git ~/dotfiles
cd ~/dotfiles

# macOS: shell tools, Ghostty, and JetBrains Mono via Homebrew
./scripts/install-macos.sh

# Ubuntu VM / SSH machine: shell tools only
./scripts/install-ubuntu.sh

# Ubuntu desktop: also install Ghostty and JetBrains Mono
./scripts/install-ubuntu.sh --desktop
```

| System | Default profile | Desktop packages |
| --- | --- | --- |
| macOS | `--desktop` | Ghostty and JetBrains Mono via Homebrew |
| Ubuntu 24.04 LTS | `--cli` | Ghostty via Snap; JetBrains Mono via apt |
| Ubuntu 26.04 LTS | `--cli` | Ghostty and JetBrains Mono via apt |

Both installers accept `--cli` and `--desktop`. Ubuntu defaults to `--cli`,
regardless of whether a desktop is detected.
The installers do not install language runtimes or development environments.
They stop on errors and can be rerun; existing applications are not uninstalled.

On Ubuntu, enable the standard **universe** repository if your minimal image
omits it. Most tools come from apt. On 24.04, Starship is installed using its
upstream installer into `~/.local/bin`; on 26.04 it comes from apt. Sheldon uses
its upstream binary installer into `~/.local/bin` when not already installed.
For the desktop profile, Ghostty comes from apt on 26.04 and the Snap package
(with classic confinement) on 24.04. JetBrains Mono comes from apt.
No Rust toolchain or Linux Homebrew installation is needed.

Sources: [Starship installation](https://starship.rs/guide/),
[Sheldon installation](https://sheldon.cli.rs/Installation.html),
[Ghostty packages](https://ghostty.org/docs/install/binary).

Open a new terminal after installation. On Ubuntu, start `zsh`; optionally make
it your login shell with `chsh -s /usr/bin/zsh`, then log out and back in.
An SSH host needs only the CLI profile: the font and window theme belong to
the computer running the terminal application.

## Appearance

Ghostty uses the regular **JetBrains Mono** family, 20 pt, with ligatures disabled.
The two-line prompt uses the terminal's palette so it follows the light/dark theme.
It displays the directory, Git branch and changes, an activated Python environment,
and duration for commands taking at least two seconds. SSH sessions also show the
hostname. There are no language-version badges or decorative icons.

```text
~/projects/api main +2?1 3s
❯
```

Git status uses ordinary characters: `!` modified, `?` untracked, `+` staged,
`-` deleted, `r` renamed, `=` conflicts, `*` stash, `>` ahead, `<` behind.
The prompt marker turns red after a failed command.

The GitHub theme files live in `ghostty/.config/ghostty/themes/`.
Automatic appearance switching requires the desktop to expose its light/dark
preference to Ghostty.

## Shell

- Shared, deduplicated history; commands starting with a space are not saved.
- Case-insensitive tab completion and normal readline-style keybindings.
- `Ctrl+R` searches history with fzf; `Ctrl+T` selects files; `Alt+C` selects a directory.
- History suggestions can be accepted with `Ctrl+Space` or the right arrow.
- `ll` and `la` call standard `ls`; `..`, `...`, and `....` move up directories.
- Git shortcuts: `g`, `gs`, `ga`, `gc`, `gp`, `gl`.
- No command spelling correction, forced locale, or replacement of macOS system utilities.
- Existing SDKMAN installations are loaded if present; SDKMAN is not installed here.

The shell still starts with a basic prompt if optional tools are missing.
Ubuntu's older fzf integration is supported alongside the newer `fzf --zsh` form.

`EDITOR` defaults to `nano`. Locally, `VISUAL` uses `code --wait` when the VS Code
command is available; over SSH it stays with `nano`. Git follows these settings.
Put machine-specific paths and editor choices in `~/.zshrc.local`, for example:

```sh
export EDITOR=nano
export VISUAL="$EDITOR"
```

## Git

The shared config contains only a few everyday defaults:

| Setting | Behavior |
| --- | --- |
| `user.name`, `user.email` | Commit author identity; change these if you fork the repository |
| `init.defaultBranch = main` | Use `main` when creating a repository |
| `push.autoSetupRemote = true` | Set the upstream automatically on the first push |
| `pull.ff = only` | Update without creating merge commits or rebasing automatically |
| `fetch.prune = true` | Remove stale remote-tracking branches; keep local branches |
| `merge.conflictStyle = zdiff3` | Show the common base when presenting conflicts |
| `diff.algorithm = histogram` | Use histogram matching for diffs |

If local and remote histories diverge, `git pull` stops so you can explicitly
choose a merge or rebase. Git aliases and automatic tag publishing, tag pruning,
stashing, and conflict-resolution reuse are not configured. The shell shortcuts
listed above remain available.

Git loads `~/.gitconfig.local` last for machine-specific overrides, such as a
work email or `core.editor`. This file is not tracked by the repository.

## Ghostty shortcuts

| Action | Shortcut |
| --- | --- |
| Copy / paste | `Ctrl+Shift+C` / `Ctrl+Shift+V` |
| New tab / select tab | `Ctrl+Shift+T` / `Ctrl+1` through `Ctrl+9` |
| Split right / down | `Ctrl+Shift+D` / `Ctrl+Shift+E` |
| Move between splits | `Ctrl+Shift+H/J/K/L` |
| Close surface | `Ctrl+Shift+W` |
| Font size | `Ctrl+Shift+=`, `Ctrl+Shift+-`, `Ctrl+Shift+0` |

## Linking and maintenance

Each directory mirrors the relevant paths in your home directory:

| Package | Target |
| --- | --- |
| `ghostty` | `~/.config/ghostty/` (desktop only) |
| `git` | `~/.gitconfig` |
| `sheldon` | `~/.config/sheldon/` |
| `starship` | `~/.config/starship.toml` |
| `zsh` | `~/.zshrc` |
| `ideavim` | `~/.ideavimrc` (manual, unchanged) |

```sh
./scripts/sync.sh --cli --dry-run  # check without changing links
./scripts/sync.sh --cli           # shell configs
./scripts/sync.sh --desktop       # shell configs + Ghostty
sheldon lock --update             # update shell plugins
./scripts/purge.sh                # confirm, then unlink all managed configs
./scripts/purge.sh ghostty        # unlink just one package
```

Without a profile, `sync.sh` defaults to desktop on macOS and CLI on Linux.
A CLI sync does not remove an existing desktop configuration. Conflicting files
are reported before links are changed; they are never adopted into the repository
or overwritten. Move conflicting files aside yourself, then rerun the command.
Unlinking preserves command history, caches, installed applications, and local overrides.

IdeaVim is intentionally outside automatic installation and cleanup:

```sh
stow --dir="$PWD" --target="$HOME" ideavim
```

## Updating an older installation

Arch Linux and Neovim are no longer managed by this repository. The installers
do not uninstall previously installed tools or delete their data. Old links to
removed packages can remain in your home directory; inspect and remove those
links separately if needed.

After pulling changes, run the appropriate `sync.sh` profile and open a new Zsh
session. Reload Ghostty's configuration or restart the application to apply
appearance changes. Run the installer if required tools or fonts are missing.

## Validation

Shell syntax, ShellCheck, Ghostty configuration, shell startup, prompt rendering,
and Stow linking/conflict handling have been checked locally on macOS.
End-to-end installation on a fresh Ubuntu machine has not yet been verified.
