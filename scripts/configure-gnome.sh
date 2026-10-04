#!/usr/bin/env bash
# Apply the shared GNOME appearance preferences as the logged-in desktop user.
set -euo pipefail
[[ $# == 0 ]] || {
  echo 'Usage: configure-gnome.sh' >&2
  exit 1
}
[[ $EUID != 0 ]] || {
  echo 'Run as your regular desktop user, without sudo.' >&2
  exit 1
}
[[ ${XDG_CURRENT_DESKTOP:-} == *GNOME* && -n ${DBUS_SESSION_BUS_ADDRESS:-} ]] || {
  echo 'Run this script from a terminal in your GNOME desktop session.' >&2
  exit 1
}
for tool in gsettings fc-match; do
  command -v "$tool" >/dev/null || {
    echo 'Run ./scripts/install-ubuntu.sh --desktop first.' >&2
    exit 1
  }
done

MONOSPACE_FONT='JetBrains Mono 11'
[[ $(fc-match -f '%{family[0]}' 'JetBrains Mono') == 'JetBrains Mono' ]] || {
  echo 'JetBrains Mono is missing. Install it with: sudo apt install fonts-jetbrains-mono' >&2
  exit 1
}

# GNOME 48+ uses Adwaita fonts; Ubuntu 24.04 ships GNOME 46 with Cantarell.
if [[ $(fc-match -f '%{family[0]}' 'Adwaita Sans') == 'Adwaita Sans' ]]; then
  UI_FONT='Adwaita Sans 11'
  DOCUMENT_FONT='Adwaita Sans 12'
  TITLEBAR_FONT='Adwaita Sans Bold 11'
elif [[ $(fc-match -f '%{family[0]}' Cantarell) == Cantarell ]]; then
  UI_FONT='Cantarell 11'
  DOCUMENT_FONT='Sans 11'
  TITLEBAR_FONT='Cantarell Bold 11'
else
  echo 'GNOME interface font is missing; Adwaita Sans or Cantarell is required.' >&2
  echo 'Run ./scripts/install-ubuntu.sh --desktop to install the missing fonts.' >&2
  exit 1
fi

# Keep the user's light/dark preference and apply it to legacy GTK applications.
GTK_THEME=Adwaita
if [[ $(gsettings get org.gnome.desktop.interface color-scheme) == "'prefer-dark'" ]]; then
  GTK_THEME=Adwaita-dark
fi
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme Adwaita
gsettings set org.gnome.desktop.interface cursor-theme Adwaita
gsettings set org.gnome.desktop.interface font-name "$UI_FONT"
gsettings set org.gnome.desktop.interface document-font-name "$DOCUMENT_FONT"
gsettings set org.gnome.desktop.interface monospace-font-name "$MONOSPACE_FONT"
gsettings set org.gnome.desktop.wm.preferences titlebar-uses-system-font true
gsettings set org.gnome.desktop.wm.preferences titlebar-font "$TITLEBAR_FONT"
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:close'
gsettings set org.gnome.desktop.sound theme-name freedesktop
printf 'GNOME appearance configured: %s; monospace: %s.\n' "$UI_FONT" "$MONOSPACE_FONT"
