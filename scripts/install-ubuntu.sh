#!/usr/bin/env bash
# Usage: ./scripts/install-ubuntu.sh [--cli|--desktop]
# Ubuntu 24.04 / 26.04 LTS, amd64 or arm64. Run as your regular user.
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE=${1:---cli}
if [[ $# -gt 1 || ($MODE != --cli && $MODE != --desktop) ]]; then
  echo 'Usage: install-ubuntu.sh [--cli|--desktop]' >&2
  exit 1
fi
[[ -r /etc/os-release ]] || {
  echo 'This installer requires Ubuntu.' >&2
  exit 1
}
# shellcheck disable=SC1091
source /etc/os-release
if [[ ${ID:-} != ubuntu || (${VERSION_ID:-} != 24.04 && ${VERSION_ID:-} != 26.04) ]]; then
  echo 'Supported systems: Ubuntu 24.04 and 26.04 LTS.' >&2
  exit 1
fi
case "$(uname -m)" in
x86_64 | aarch64) ;;
*)
  echo 'A 64-bit amd64 or arm64 system is required.' >&2
  exit 1
  ;;
esac
[[ $EUID != 0 ]] || {
  echo 'Run as your regular user; sudo is used only for system packages.' >&2
  exit 1
}

sudo apt-get update
sudo apt-get install -y git stow zsh fzf nano curl ca-certificates tar gzip zip unzip
export PATH="$HOME/.local/bin:$PATH"
mkdir -p "$HOME/.local/bin"
INSTALL_TMP=$(mktemp -d)
trap 'rm -rf "$INSTALL_TMP"' EXIT

# Prefer Ubuntu's package when available. 24.04 uses the upstream installer.
if ! command -v starship >/dev/null; then
  if [[ $VERSION_ID == 26.04 ]]; then
    sudo apt-get install -y starship
  else
    curl -fsSL https://starship.rs/install.sh -o "$INSTALL_TMP/starship.sh"
    sh "$INSTALL_TMP/starship.sh" --yes --bin-dir "$HOME/.local/bin"
  fi
fi
if ! command -v sheldon >/dev/null; then
  curl -fsSL https://rossmacarthur.github.io/install/crate.sh -o "$INSTALL_TMP/sheldon.sh"
  bash "$INSTALL_TMP/sheldon.sh" --repo rossmacarthur/sheldon --to "$HOME/.local/bin"
fi

# The shared Zsh config already loads SDKMAN; do not let its installer edit rc files.
export SDKMAN_DIR="$HOME/.sdkman"
if [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  curl -fsSL 'https://get.sdkman.io?rcupdate=false' -o "$INSTALL_TMP/sdkman.sh"
  bash "$INSTALL_TMP/sdkman.sh"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] || {
    echo 'SDKMAN installation did not create sdkman-init.sh; check the installer output.' >&2
    exit 1
  }
fi

if [[ $MODE == --desktop ]]; then
  # Use Microsoft's signed APT repository for VS Code and subsequent updates.
  sudo apt-get install -y gpg
  if ! grep -qs 'https://packages.microsoft.com/repos/code' \
    /etc/apt/sources.list.d/vscode.sources /etc/apt/sources.list.d/vscode.list; then
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc -o "$INSTALL_TMP/microsoft.asc"
    gpg --batch --yes --dearmor -o "$INSTALL_TMP/microsoft.gpg" "$INSTALL_TMP/microsoft.asc"
    sudo install -d -m 755 /usr/share/keyrings /etc/apt/sources.list.d
    sudo install -m 644 "$INSTALL_TMP/microsoft.gpg" /usr/share/keyrings/microsoft.gpg
    cat > "$INSTALL_TMP/vscode.sources" <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64 arm64
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
    sudo install -m 644 "$INSTALL_TMP/vscode.sources" /etc/apt/sources.list.d/vscode.sources
  fi
  sudo apt-get update
  printf '%s\n' 'code code/add-microsoft-repo boolean true' | sudo debconf-set-selections
  sudo apt-get install -y code
  sudo apt-get install -y fonts-jetbrains-mono fontconfig gnome-session \
    adwaita-icon-theme gnome-themes-extra sound-theme-freedesktop
  if [[ $VERSION_ID == 26.04 ]]; then
    sudo apt-get install -y fonts-adwaita
  else
    sudo apt-get install -y fonts-cantarell fonts-dejavu-core
  fi
  fc-cache -f
  if [[ ${XDG_CURRENT_DESKTOP:-} == *GNOME* && -n ${DBUS_SESSION_BUS_ADDRESS:-} ]]; then
    "$DOTFILES_DIR/scripts/configure-gnome.sh"
  else
    printf '%s\n' 'To apply the GNOME appearance, run in your desktop session:' \
      "$DOTFILES_DIR/scripts/configure-gnome.sh"
  fi
  printf '%s\n' 'For the standard GNOME Shell, log out and choose GNOME from the login screen session menu.'
  if [[ $VERSION_ID == 26.04 ]]; then
    sudo apt-get install -y ghostty
  else
    # Ghostty is not in the 24.04 apt repositories; use its documented Snap.
    sudo apt-get install -y snapd
    if ! snap list ghostty >/dev/null 2>&1; then
      sudo snap install ghostty --classic
    fi
  fi
fi

"$DOTFILES_DIR/scripts/sync.sh" "$MODE"
sheldon --config-file "$DOTFILES_DIR/sheldon/.config/sheldon/plugins.toml" lock
printf '\nReady. Start Zsh with: zsh\n'
printf 'To make it your login shell, run: chsh -s /usr/bin/zsh\n'
