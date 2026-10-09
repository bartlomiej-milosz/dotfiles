# Ubuntu desktop and developer tools

These options belong to the Ubuntu installer. The macOS installer is unchanged.
Use `--cli` for shell tools and SDKMAN, or `--desktop` to add VS Code, Ghostty,
fonts, and a GNOME session. See the [README](../README.md) for installation commands.

## Developer tools

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

## GNOME appearance

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



The offline check suite checks script syntax and portable shell/linking behavior.
It does not execute package installation or GNOME settings changes. Desktop
appearance and full installation on a fresh Ubuntu system require separate
manual verification.
