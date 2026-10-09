#!/usr/bin/env bash
# Offline checks only: never run installers or target the real home directory.
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for tool in bash zsh shellcheck stow; do
  command -v "$tool" >/dev/null || {
    printf 'Required check tool not found: %s\n' "$tool" >&2
    exit 1
  }
done
ZSH_BIN=$(command -v zsh)
for script in "$DOTFILES_DIR"/scripts/*.sh; do
  bash -n "$script"
done
for script in "$DOTFILES_DIR/zsh/.zshrc" "$DOTFILES_DIR/tests/zsh-keybindings.zsh"; do
  zsh -n "$script"
done
shellcheck "$DOTFILES_DIR"/scripts/*.sh
printf 'PASS: Bash/Zsh syntax and ShellCheck (Bash only)\n'

CHECK_TMP=$(mktemp -d)
cleanup() {
  local result=$?
  if [[ $result -ne 0 && -f $CHECK_TMP/stow.log ]]; then
    cat "$CHECK_TMP/stow.log" >&2
  fi
  rm -rf "$CHECK_TMP"
}
trap cleanup EXIT
mkdir -p "$CHECK_TMP/empty-bin"
# compinit needs mv to save its cache; expose no optional shell tools.
ln -s "$(command -v mv)" "$CHECK_TMP/empty-bin/mv"
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

for state in widget no-widget no-sheldon; do
  target="$CHECK_TMP/zsh-$state"
  mkdir -p "$target"
  env -i HOME="$target" ZDOTDIR="$target" PATH="$CHECK_TMP/empty-bin" TERM=xterm-256color \
    "$ZSH_BIN" -f -i "$DOTFILES_DIR/tests/zsh-keybindings.zsh" "$DOTFILES_DIR/zsh/.zshrc" "$state" \
    >"$CHECK_TMP/zsh-$state.log" 2>&1 || {
      cat "$CHECK_TMP/zsh-$state.log"
      fail "Zsh regression ($state)"
    }
  cat "$CHECK_TMP/zsh-$state.log"
done

assert_links() {
  local target=$1 package file relative
  shift
  for package in "$@"; do
    while IFS= read -r file; do
      relative=${file#"$DOTFILES_DIR/$package/"}
      [[ -L $target/$relative && $target/$relative -ef $file ]] ||
        fail "Missing or incorrect link: $relative"
    done < <(find "$DOTFILES_DIR/$package" -type f ! -name '.DS_Store' ! -name '*.swp')
  done
}
assert_no_links() {
  [[ -z $(find "$1" -type l -print) ]] || fail "Unexpected links in $1"
}

# Dry-run must leave even a fresh target empty.
target="$CHECK_TMP/dry-run"
mkdir -p "$target"
HOME="$target" bash "$DOTFILES_DIR/scripts/sync.sh" --desktop --dry-run >"$CHECK_TMP/stow.log" 2>&1
[[ -z $(find "$target" -mindepth 1 -print) ]] || fail 'Dry run changed the target'
printf 'PASS: Stow dry run leaves the target untouched\n'

for profile in cli desktop; do
  target="$CHECK_TMP/stow-$profile"
  mkdir -p "$target/.config/cache"
  for file in .zshrc.local .gitconfig.local .zsh_history .config/cache/keep; do
    printf 'preserve me\n' >"$target/$file"
  done
  packages=(git sheldon starship zsh)
  [[ $profile == desktop ]] && packages+=(ghostty)
  for ((attempt=0; attempt<2; attempt++)); do
    HOME="$target" bash "$DOTFILES_DIR/scripts/sync.sh" "--$profile" >"$CHECK_TMP/stow.log" 2>&1
    assert_links "$target" "${packages[@]}"
  done
  if [[ $profile == cli ]]; then
    [[ ! -e $target/.config/ghostty ]] || fail 'CLI profile installed Ghostty'
  else
    HOME="$target" bash "$DOTFILES_DIR/scripts/sync.sh" --cli >"$CHECK_TMP/stow.log" 2>&1
    assert_links "$target" ghostty
    HOME="$target" bash "$DOTFILES_DIR/scripts/purge.sh" ghostty >"$CHECK_TMP/stow.log" 2>&1
    [[ ! -e $target/.config/ghostty/config && ! -L $target/.config/ghostty/config ]] ||
      fail 'Single-package purge left the Ghostty link'
    assert_links "$target" git sheldon starship zsh
  fi
  printf 'y\n' | HOME="$target" bash "$DOTFILES_DIR/scripts/purge.sh" >"$CHECK_TMP/stow.log" 2>&1
  assert_no_links "$target"
  for file in .zshrc.local .gitconfig.local .zsh_history .config/cache/keep; do
    [[ -f $target/$file && $(cat "$target/$file") == 'preserve me' ]] ||
      fail "Unlinking changed local data: $file"
  done
  printf 'PASS: Stow %s linking, repeat sync and unlinking preserve local data\n' "$profile"
done

# A conflict in the last CLI package must not partially link earlier packages.
for profile in cli desktop; do
  target="$CHECK_TMP/conflict-$profile"
  mkdir -p "$target"
  printf 'existing config\n' >"$target/.zshrc"
  if HOME="$target" bash "$DOTFILES_DIR/scripts/sync.sh" "--$profile" >"$CHECK_TMP/stow.log" 2>&1; then
    fail "Conflict was accepted ($profile)"
  fi
  [[ -f $target/.zshrc && ! -L $target/.zshrc && $(cat "$target/.zshrc") == 'existing config' ]] ||
    fail 'Conflict changed the existing file'
  assert_no_links "$target"
  [[ ! -e $target/.config && ! -e $target/.gitconfig ]] || fail 'Preflight partially applied configs'
  printf 'PASS: Stow %s preflight rejects conflicts without partial changes\n' "$profile"
done

# IdeaVim stays manual and installs configuration only, never its documentation.
target="$CHECK_TMP/ideavim"
mkdir -p "$target"
stow --no-folding --dir="$DOTFILES_DIR" --target="$target" ideavim >"$CHECK_TMP/stow.log" 2>&1
assert_links "$target" ideavim
[[ ! -e $target/.ideavimrc-doc && ! -L $target/.ideavimrc-doc && ! -e $target/docs ]] ||
  fail 'IdeaVim documentation was installed'
[[ $(find "$target" -type l -print | wc -l) -eq 1 ]] || fail 'IdeaVim installed unexpected files'
stow --no-folding --dir="$DOTFILES_DIR" --target="$target" --delete ideavim >"$CHECK_TMP/stow.log" 2>&1
assert_no_links "$target"
printf 'PASS: IdeaVim links only .ideavimrc and can be unlinked\n'
printf 'All checks passed; installers were not run.\n'
