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
sudo apt-get install -y git stow zsh fzf nano curl ca-certificates tar gzip
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

if [[ $MODE == --desktop ]]; then
  sudo apt-get install -y fonts-jetbrains-mono
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
