# dotfiles

A shared terminal setup for **macOS and Ubuntu 24.04 / 26.04 LTS**
(64-bit amd64 / arm64), managed with GNU Stow, with a GNOME desktop and developer
tools profile for Ubuntu.

- **Ghostty** with JetBrains Mono, GitHub Light/Dark following system appearance,
  an opaque background, and a little space around the text.
- **Zsh**, **Starship**, and **fzf** for everyday shell use.
- Two plugins managed by **Sheldon**: history suggestions and syntax highlighting.
- Standard `ls`, `cat`, `cd`, and other system commands. No icon font required.
- An independent **IdeaVim** config, kept as-is and installed separately.
- Ubuntu's desktop profile adds a standard **GNOME** session and Adwaita appearance.
- Ubuntu installs **SDKMAN** in both profiles and **VS Code** in the desktop profile.

## Install

Clone the repository and run the installer as your regular user:

```sh
git clone git@github.com:bartlomiej-milosz/dotfiles.git ~/dotfiles
cd ~/dotfiles

# macOS: shell tools, Ghostty, and JetBrains Mono via Homebrew
./scripts/install-macos.sh

# Ubuntu VM / SSH machine: shell tools and SDKMAN
./scripts/install-ubuntu.sh

# Ubuntu desktop: also VS Code, Ghostty, JetBrains Mono, and GNOME / Adwaita appearance
./scripts/install-ubuntu.sh --desktop
```

| System | Default profile | Desktop packages |
| --- | --- | --- |
| macOS | `--desktop` | Ghostty and JetBrains Mono via Homebrew |
| Ubuntu 24.04 LTS | `--cli` | VS Code, GNOME/Adwaita, JetBrains Mono, Cantarell; Ghostty via Snap |
| Ubuntu 26.04 LTS | `--cli` | VS Code, Ghostty, GNOME/Adwaita, JetBrains Mono, Adwaita Sans |

Both installers accept `--cli` and `--desktop`. Ubuntu defaults to `--cli`,
regardless of whether a desktop is detected.
On Ubuntu, no flag is equivalent to `--cli`:

| Component | `--cli` / no flag | `--desktop` |
| --- | --- | --- |
| Git, Stow, Zsh, fzf, nano, Starship, Sheldon | Install and link shell configs | Same |
| SDKMAN | Install for the current user | Same |
| VS Code | Skip | Install through Microsoft's signed apt repository |
| Ghostty and desktop fonts | Skip | Install and link Ghostty config |
| GNOME session and appearance | Skip | Install packages and apply preferences in a GNOME session |

The installers stop on errors and can be rerun; existing applications are not
uninstalled. Java versions and other language runtimes are installed separately.

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

## Developer tools on Ubuntu

**VS Code** is installed by `--desktop` from Microsoft's official signed apt
repository. Updates arrive through apt. Run `code .` to open the current project
or `code --version` to verify the installation. The shell uses `code --wait` as
the visual editor locally when available; SSH sessions use `nano`.

**SDKMAN** is installed by both Ubuntu profiles into `~/.sdkman`. It has no
official apt package, so the installer uses the official script with
`rcupdate=false`; the shared Zsh config already loads it. Existing installations
are reused, and its `zip` and `unzip` dependencies come from apt. Open a new Zsh
session before using it:

```sh
sdk version       # verify SDKMAN
sdk list java     # browse available JDKs
sdk install java  # optionally install the current default JDK
```

**JetBrains Toolbox** and its IDEs are installed separately. Download its Linux
archive, extract it to a permanent location such as `~/.local/opt`, and run
`./bin/jetbrains-toolbox` from the extracted directory. Toolbox creates an
application-menu entry on first launch and manages IDE installations and updates.
Steam and other personal desktop applications are also outside the installer.

Sources: [VS Code on Linux](https://code.visualstudio.com/docs/setup/linux),
[SDKMAN installation](https://sdkman.io/install/),
[JetBrains Toolbox installation](https://www.jetbrains.com/help/toolbox-app/installation.html).

## Appearance

### Terminal

Ghostty uses the regular **JetBrains Mono** family, 20 pt, with ligatures disabled.
The desktop installers install the font automatically. On Ubuntu, `--desktop`
also installs the GNOME appearance packages and refreshes the font cache.
Ghostty uses JetBrains Mono independently of the desktop's font preferences.

For an existing Ubuntu desktop installation, rerun:

```sh
./scripts/install-ubuntu.sh --desktop
```

Verify the installed terminal font with `fc-match 'JetBrains Mono'`, then reopen Ghostty.

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

### GNOME appearance on Ubuntu

The desktop installer installs `gnome-session` and applies these user preferences
when run from a GNOME desktop terminal:

| Setting | Ubuntu 26.04 | Ubuntu 24.04 (GNOME 46) |
| --- | --- | --- |
| Interface font | Adwaita Sans 11 | Cantarell 11 |
| Document font | Adwaita Sans 12 | Sans 11 |
| Monospace font | JetBrains Mono 11 | JetBrains Mono 11 |
| Icons and cursor | Adwaita | Adwaita |
| Legacy GTK applications | Adwaita; Adwaita-dark if dark mode is selected | Same |
| Window titles | Follow the interface font; close button only | Same |
| Sound theme | freedesktop | freedesktop |

Ubuntu 24.04 uses Cantarell for the interface; Ubuntu 26.04 uses Adwaita Sans.
If Adwaita Sans is already installed on 24.04, the configuration script uses it
too. Both versions use JetBrains Mono for fixed-width text in applications that
follow GNOME's monospace preference. All fonts used by the installer come from apt.

To apply the preferences again, or after installing over SSH, run from a terminal
in your desktop session, without sudo:

```sh
./scripts/configure-gnome.sh
```

For the standard GNOME Shell, log out, select your user, open the session menu
(gear icon), and choose **GNOME** before logging in. The Ubuntu session uses its
own Shell styling and extensions. The installer adds the GNOME session alongside
Ubuntu; session selection is saved by the login screen. Existing user extensions
and the light/dark preference are preserved.

On Ubuntu 26.04, install the configured fonts with
`sudo apt install fonts-adwaita fonts-jetbrains-mono`. Check them with
`fc-match 'Adwaita Sans'` and `fc-match 'JetBrains Mono'`.

Sources: [GNOME fonts](https://github.com/GNOME/adwaita-fonts),
[GNOME 48 release notes](https://release.gnome.org/48/),
[Ubuntu's GNOME customizations](https://help.ubuntu.com/stable/ubuntu-help/gnome-on-ubuntu.html.en).


## Shell

- Shared, deduplicated history; commands starting with a space are not saved.
- Case-insensitive tab completion and normal readline-style keybindings.
- History suggestions can be accepted with `Ctrl+Space` or the right arrow.
- Use standard commands such as `ls -lah`, `cd ..`, and `git status`;
  the shared Zsh config defines no aliases.
- No command spelling correction, forced locale, or replacement of macOS system utilities.
- SDKMAN is loaded when present. Both Ubuntu profiles install it automatically;
  on macOS, install it separately.

The shell still starts with a basic prompt if optional tools are missing.
Ubuntu's older fzf integration is supported alongside the newer `fzf --zsh` form.

`EDITOR` defaults to `nano`. Locally, `VISUAL` uses `code --wait` when the VS Code
command is available; over SSH it stays with `nano`. Git follows these settings.
Put machine-specific paths and editor choices in `~/.zshrc.local`, for example:

```sh
export EDITOR=nano
export VISUAL="$EDITOR"
```

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
stashing, and conflict-resolution reuse are not configured. Use full Git commands,
such as `git status`, `git add`, `git commit`, and `git push`.

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
`sync.sh` only manages dotfile links; it does not install packages or apply GNOME
preferences. To reapply the desktop appearance, run `./scripts/configure-gnome.sh`
from a terminal in your GNOME session, without sudo.

## Validation

Shell syntax, ShellCheck, Ghostty configuration, shell startup, prompt rendering,
and Stow linking/conflict handling have been checked locally on macOS.
The Ubuntu installer and GNOME configuration have also been checked for shell
syntax, profile selection, repeated runs, and font detection. Package installation
and desktop writes were simulated for those checks. The required desktop packages
and SDKMAN are installed on the current Ubuntu 26.04 machine; end-to-end
installation on a fresh Ubuntu machine has not yet been verified.
