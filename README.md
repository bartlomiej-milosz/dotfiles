# dotfiles

My personal shell and terminal configuration for macOS and Ubuntu, managed with
GNU Stow. The setup combines a small Zsh configuration, a readable prompt, and
light/dark terminal themes while keeping standard system commands unchanged.

Installer scripts target macOS and Ubuntu 24.04 / 26.04 LTS. They separate a
**CLI profile** for shell tools from a **desktop profile** that also includes
Ghostty and JetBrains Mono. On Ubuntu, both profiles install SDKMAN, while the
desktop profile adds VS Code and a GNOME session with Adwaita appearance settings.
IdeaVim is optional and installed separately.

## What's included

| Component | Configuration |
| --- | --- |
| [Zsh](zsh/.zshrc) | Shared history, case-insensitive completion, Emacs-style editing, and optional tool integration. |
| [Starship](starship/.config/starship.toml) | A two-line prompt showing the directory, Git status, Python virtual environment, and command duration. |
| [Sheldon](sheldon/.config/sheldon/plugins.toml) | Two plugins: zsh-autosuggestions and zsh-syntax-highlighting. |
| [Ghostty](ghostty/.config/ghostty/config) | JetBrains Mono, automatic GitHub light/dark themes, and tab/split shortcuts. |
| [Git](git/.gitconfig) | Explicit pull behavior, readable conflict markers, and local overrides. |
| [IdeaVim](ideavim/.ideavimrc) | IntelliJ navigation, refactoring, Git, and run/debug mappings. |

No icon font, replacement core utilities, or language-version badges are required.
This is a personal configuration, not a general-purpose workstation installer.

## Installation

**Requirements:** Git, Bash, network access, and permission to install packages.
Run installers as your regular user. Ubuntu requires sudo access, the `universe`
repository, and an amd64 or arm64 system. The macOS installer installs Homebrew
if it is missing.

```sh
git clone https://github.com/bartlomiej-milosz/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Choose the command for your system and profile.

### macOS

Install shell tools, Ghostty, and JetBrains Mono:

```sh
./scripts/install-macos.sh
```

Use `./scripts/install-macos.sh --cli` for shell tools only.

### Ubuntu

Install shell tools and SDKMAN for a VM or SSH machine:

```sh
./scripts/install-ubuntu.sh
```

For a desktop, also install VS Code, Ghostty, fonts, and a GNOME session:

```sh
./scripts/install-ubuntu.sh --desktop
```

Both installers accept `--cli` and `--desktop`. macOS defaults to desktop;
Ubuntu defaults to CLI regardless of whether a desktop session is detected.

Installers add packages, link the selected configuration with Stow, and download
the two Sheldon plugins. Ubuntu also installs SDKMAN without changing shell rc
files; its desktop profile installs VS Code through Microsoft's signed apt
repository and applies GNOME appearance preferences when run in a GNOME session.
Java versions and other language runtimes are installed separately. Existing
applications are not removed, and the login shell is not changed. On macOS,
SDKMAN remains a separate installation and is loaded by Zsh when present.

Existing configuration files are not overwritten or adopted into the repository.
If Stow reports a conflict, inspect and move the conflicting file aside before
retrying. Package installation happens before linking, so a link conflict does
not roll back packages that were already installed.

Open a new terminal after installation. On Ubuntu, run `zsh`; optionally use
`chsh -s /usr/bin/zsh` and log out and back in to change the login shell.
An SSH host needs only the CLI profile: fonts and window themes belong to the
computer running the terminal application.

See [installation notes](docs/installation.md) for package sources and verification
limits. Inspect the tracked Git identity before using this configuration on your
own account; a fork should use its owner's name and email.

| Ubuntu component | CLI / no flag | Desktop |
| --- | --- | --- |
| Shell tools and SDKMAN | Installed | Installed |
| VS Code | Skipped | Microsoft apt repository |
| Ghostty and desktop fonts | Skipped | Installed |
| GNOME session and Adwaita preferences | Skipped | Installed; preferences applied in a GNOME session |

See [Ubuntu desktop notes](docs/ubuntu-desktop.md) for SDKMAN usage, VS Code,
GNOME session selection, fonts, and reapplying appearance preferences.

## Shell and appearance

Ghostty uses regular **JetBrains Mono at 20 pt**, with ligatures disabled and an
opaque background. GitHub Light/Dark follows the system appearance when the
desktop exposes that preference. Starship uses the terminal palette. Ghostty
starts Zsh explicitly, independently of the account's login shell.

Example prompt layout:

```text
~/projects/api main !1 3s
❯
```

The prompt shows an activated Python virtual environment, an SSH hostname when
applicable, and duration for commands taking at least two seconds. Its marker
turns red after a failed command. Git status uses ordinary characters:
`!` modified, `?` untracked, `+` staged, `-` deleted, `r` renamed, `=` conflicts,
`*` stash, `>` ahead, and `<` behind.

| Shell behavior | Detail |
| --- | --- |
| History | Shared and deduplicated; commands starting with a space are not saved. |
| Completion | Case-insensitive matching and Emacs/readline-style editing. |
| fzf | `Ctrl+R` searches history, `Ctrl+T` selects files, `Alt+C` selects a directory. |
| Autosuggestions | `Ctrl+Space` accepts a suggestion; the right arrow does so at the end of the line. |
| Fallback | A basic prompt and editing remain available when optional tools are absent. |

fzf shortcuts require fzf; autosuggestions require the Sheldon plugin to be
loaded. Both older Ubuntu fzf integration and `fzf --zsh` are handled.
No shell aliases, spelling correction, or forced locale are configured.

`EDITOR` defaults to `nano`. On local sessions, `VISUAL` uses `code --wait` if
that command is available; SSH sessions keep `nano`. Machine-specific settings
belong in `~/.zshrc.local`, which is loaded after the shared editor defaults.

### fzf shortcuts

The shell loads fzf's keybindings and fuzzy completion automatically when fzf is
installed. These shortcuts work at the Zsh prompt:

| Shortcut | Action | Example |
| --- | --- | --- |
| `Ctrl+R` | Search command history and insert the selected command without running it | Type part of an old command, press `Ctrl+R`, then select a match |
| `Ctrl+T` | Search files and directories under the current directory and insert selected paths | Type `nano `, press `Ctrl+T`, then select a file |
| `Alt+C` | Search directories under the current directory and change into the selected one | Press `Alt+C`, then select a project directory |
| `**` followed by `Tab` | Fuzzy-complete paths for supported commands | Type `nano **` or `cd **`, then press `Tab` |

Inside the picker, type to narrow the results, use `Up` / `Down` or `Ctrl+P` /
`Ctrl+N` to move, `Enter` to confirm, and `Esc` or `Ctrl+C` to cancel. In the
`Ctrl+T` picker, `Tab` / `Shift+Tab` select multiple paths. In the `Ctrl+R` picker,
press `Ctrl+R` again to toggle relevance sorting.

On macOS, Ghostty maps Option to Alt, so `Alt+C` is `Option+C`. If another terminal
intercepts it, press `Esc` and then `c` instead. Open a new terminal or run
`source ~/.zshrc` after updating the config.

See the [fzf documentation](https://github.com/junegunn/fzf#key-bindings-for-command-line)
for more examples and customization.

## Git defaults

| Setting | Behavior |
| --- | --- |
| `init.defaultBranch = main` | New repositories start on `main`. |
| `push.autoSetupRemote = true` | Set an upstream automatically on the first push. |
| `pull.ff = only` | Stop on divergent histories instead of choosing a merge or rebase. |
| `fetch.prune = true` | Remove stale remote-tracking branches without removing local branches. |
| `merge.conflictStyle = zdiff3` | Include the common base in conflict markers. |
| `diff.algorithm = histogram` | Use histogram matching for diffs. |

Git loads `~/.gitconfig.local` last for overrides such as a work identity or
`core.editor`. Local override files are not managed by this repository.

## Ghostty shortcuts

| Action | Shortcut |
| --- | --- |
| Copy / paste | `Ctrl+Shift+C` / `Ctrl+Shift+V` |
| New tab / select tab | `Ctrl+Shift+T` / `Ctrl+1` through `Ctrl+9` |
| Split right / down | `Ctrl+Shift+D` / `Ctrl+Shift+E` |
| Move between splits | `Ctrl+Shift+H/J/K/L` |
| Close surface | `Ctrl+Shift+W` |
| Font size | `Ctrl+Shift+=`, `Ctrl+Shift+-`, `Ctrl+Shift+0` |

See [IdeaVim notes](docs/ideavim.md) for the separate IDE mappings and plugin
requirements. The terminal and IDE have independent keybindings.

## Linking and maintenance

Each package mirrors paths in the home directory. Zsh and Git install `.zshrc`
and `.gitconfig`; Sheldon, Starship, and Ghostty use `.config/`.

If the tools are already installed, use GNU Stow through the helper scripts:

```sh
./scripts/sync.sh --cli --dry-run  # Report conflicts without changing links
./scripts/sync.sh --cli           # Link shell configuration
./scripts/sync.sh --desktop       # Also link Ghostty configuration
sheldon lock --update             # Update shell plugins
```

Without a profile, `sync.sh` selects desktop on macOS and CLI on Linux. All
selected packages are checked for conflicts before links change. Repeating a sync
is supported; a CLI sync does not remove an existing desktop configuration.

Remove managed links while preserving history, caches, applications, and local
overrides:

```sh
./scripts/purge.sh                # Confirm before unlinking all managed packages
./scripts/purge.sh ghostty        # Unlink only Ghostty, without a prompt
```

IdeaVim is outside automatic installation and cleanup. From the repository root:

```sh
stow --dir="$PWD" --target="$HOME" --simulate ideavim
stow --dir="$PWD" --target="$HOME" ideavim
stow --dir="$PWD" --target="$HOME" --delete ideavim
```

Only `~/.ideavimrc` is linked; documentation stays in `docs/`.

After updating the repository, rerun the appropriate sync profile and open a new
Zsh session. Reload or restart Ghostty for terminal changes. Run an installer
when tools or fonts are missing, or to install the expanded Ubuntu desktop profile.
`sync.sh` only manages links: it does not install packages or apply GNOME settings.
To reapply desktop preferences, run `./scripts/configure-gnome.sh` from your
GNOME terminal without sudo.

Arch Linux and Neovim are no longer managed. Old links to removed packages or to
`.ideavimrc-doc` may remain; inspect and remove those obsolete links separately.
No installer deletes previous application data.

## Validation

With Bash, Zsh, ShellCheck, and GNU Stow on PATH:

```sh
./scripts/check.sh
```

The offline suite checks:

- Bash/Zsh syntax and ShellCheck for Bash scripts.
- `Ctrl+Space` with a mock Sheldon: widget present, widget absent, and Sheldon absent.
- Basic shell fallback without optional tools.
- Stow dry runs, both profiles, repeated sync, and single/all-package unlinking.
- Conflicts rejected before partial linking; local history, overrides, and caches preserved.
- Manual IdeaVim installation containing only its configuration file.

Tests use temporary homes and target directories. They do not download plugins,
run installers, or change the active terminal configuration. The suite has been
run locally on macOS; [GitHub Actions](.github/workflows/check.yml) is configured
to run the same checks on Ubuntu 24.04.

Full installation on a fresh macOS or Ubuntu system is not covered by this suite.
Ghostty rendering and IdeaVim behavior inside IntelliJ also require manual
verification. Package-source checks are documented in the
[installation notes](docs/installation.md).
