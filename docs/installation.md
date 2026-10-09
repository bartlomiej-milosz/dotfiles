# Installation notes

The installers target macOS and Ubuntu 24.04 / 26.04 LTS. Ubuntu is limited to
amd64 and arm64. These are intended platform targets, not a claim of end-to-end
installation testing on every combination.

## Package sources

| Component | macOS | Ubuntu 24.04 | Ubuntu 26.04 |
| --- | --- | --- | --- |
| Git, Stow, fzf | Homebrew | apt | apt |
| Zsh | Supplied by macOS | apt | apt |
| Starship | Homebrew | Upstream binary installer | apt (`universe`) |
| Sheldon | Homebrew | Upstream binary installer | Upstream binary installer |
| Ghostty (desktop) | Homebrew cask | Community Snap, classic confinement | apt (`universe`) |
| JetBrains Mono (desktop) | Homebrew cask | apt (`universe`) | apt (`universe`) |
| SDKMAN | Separate installation | Official installer (`rcupdate=false`) | Official installer (`rcupdate=false`) |
| VS Code (desktop) | Separate installation | Microsoft signed apt repository | Microsoft signed apt repository |
| GNOME session and appearance packages (desktop) | Not applicable | apt; Cantarell interface font | apt; Adwaita Sans interface font |

Ubuntu additionally installs nano, zip/unzip, and the download/extraction tools used by the
scripts. Enable `universe` if a minimal image omits it. Upstream Starship and
Sheldon binaries are installed into `~/.local/bin`; the scripts reuse an existing
command when it is already on PATH. No Rust toolchain or Linux Homebrew is needed.

Both profiles finish by linking their configuration and running `sheldon lock`.
On Ubuntu, both profiles also install SDKMAN for the current user without editing
rc files. The desktop profile adds VS Code, Ghostty, fonts, a GNOME session and
appearance packages. `configure-gnome.sh` applies user preferences only when
called from a GNOME session with a session bus; otherwise the installer prints
instructions for applying them later. It does not select the login session.
The Snap route requires a system with working snapd support. See the
[Ubuntu desktop notes](ubuntu-desktop.md) for details and upstream references.

The scripts stop on errors. Rerunning them does not uninstall existing tools,
but installation is not transactional: downloaded or installed packages remain
if a later step fails. Existing configuration conflicts are reported by Stow
before it changes links. Resolve them explicitly rather than using `--adopt`.

## Source verification

The following sources were checked on 2026-10-09:

- Ubuntu archive listings for [Starship](https://packages.ubuntu.com/starship)
  and [Ghostty](https://packages.ubuntu.com/ghostty). Neither binary package is
  listed for the standard Ubuntu 24.04 archive.
- Ubuntu 26.04 listings for
  [Starship across architectures](https://packages.ubuntu.com/search?keywords=starship&suite=resolute)
  and [Ghostty](https://packages.ubuntu.com/resolute/utils/ghostty), including
  amd64 and arm64 builds in `universe`.
- JetBrains Mono for
  [Ubuntu 24.04](https://packages.ubuntu.com/noble/fonts-jetbrains-mono) and
  [Ubuntu 26.04](https://packages.ubuntu.com/resolute/fonts-jetbrains-mono).
- Upstream instructions for the [Starship installer](https://starship.rs/guide/),
  [Sheldon binary installer](https://sheldon.cli.rs/Installation.html), and
  [Ghostty packages](https://ghostty.org/docs/install/binary).
  Ghostty's Linux packages are maintained by distributions or the community;
  the Snap route uses classic confinement.

These references establish package availability and documented installation
routes. They do not establish that a full installation has passed on a fresh
machine. The repository's [check suite](../scripts/check.sh) exercises shell and
linking behavior without executing either installer.
