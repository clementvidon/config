#!/usr/bin/env bash

set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly REPO_ROOT
TEST_ROOT=""

info() {
  printf '[CHECK] %s\n' "$*"
}

die() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

cleanup() {
  if [[ -n "$TEST_ROOT" && -d "$TEST_ROOT" ]]; then
    rm -rf -- "$TEST_ROOT"
  fi
}

trap cleanup EXIT

check_shell_syntax() {
  local script

  info 'Bash syntax'
  bash -n "$REPO_ROOT/install.sh"
  while IFS= read -r -d '' script; do
    bash -n "$script"
  done < <(find "$REPO_ROOT/scripts" -maxdepth 1 -type f -name '*.sh' -print0)
  while IFS= read -r -d '' script; do
    bash -n "$script"
  done < <(find "$REPO_ROOT/stow/scripts/.local/bin" -type f -print0)

  zsh -n \
    "$REPO_ROOT/stow/zsh/.zshenv" \
    "$REPO_ROOT/stow/zsh/.zprofile" \
    "$REPO_ROOT/stow/zsh/.zshrc"

  if command -v shellcheck >/dev/null 2>&1; then
    shellcheck --shell=bash \
      "$REPO_ROOT/install.sh" \
      "$REPO_ROOT/scripts/"*.sh

    shellcheck --severity=error --shell=bash \
      "$REPO_ROOT/stow/bash/.bashrc" \
      "$REPO_ROOT/stow/scripts/.local/bin/"*
  fi
}

check_managed_configs() {
  local socket="$TEST_ROOT/tmux.sock"

  info 'Managed configuration syntax'

  git config --file "$REPO_ROOT/stow/git/.gitconfig" --list >/dev/null
  [[ "$(git config --file "$REPO_ROOT/stow/git/.gitconfig" --get pull.rebase)" == true ]] || \
    die 'Git pull.rebase is not enabled'
  [[ -z "$(git config --file "$REPO_ROOT/stow/git/.gitconfig" --get gc.rebase || true)" ]] || \
    die 'Unexpected gc.rebase option'

  python3 -m json.tool \
    "$REPO_ROOT/stow/karabiner/.config/karabiner/karabiner.json" >/dev/null

  if command -v wezterm >/dev/null 2>&1; then
    wezterm \
      --config-file "$REPO_ROOT/stow/wezterm/.config/wezterm/wezterm.lua" \
      show-keys >/dev/null
  fi

  if command -v tmux >/dev/null 2>&1; then
    tmux -S "$socket" -f "$REPO_ROOT/stow/tmux/.tmux.conf" new-session -d
    tmux -S "$socket" kill-server
  fi
}

check_stale_paths() {
  local matches=""
  # This is a regex for the literal text "$HOME".
  # shellcheck disable=SC2016
  local pattern='(\$HOME/(git/)?config|/home/[^/]+/config|/Users/[^/]+/config|config/vim)'

  info 'No repository-location assumptions in managed files'
  if command -v rg >/dev/null 2>&1; then
    matches="$(rg -n "$pattern" "$REPO_ROOT/stow" || true)"
  else
    matches="$(grep -REn "$pattern" "$REPO_ROOT/stow" || true)"
  fi

  [[ -z "$matches" ]] || {
    printf '%s\n' "$matches" >&2
    die 'Managed files still reference the old repository location'
  }
}

check_removed_tools() {
  local matches=""
  local removed='i''term'

  info 'No references to removed terminal configuration'
  if command -v rg >/dev/null 2>&1; then
    matches="$(rg -n -i --hidden --glob '!.git/**' "$removed" "$REPO_ROOT" || true)"
  else
    matches="$(grep -REni --exclude-dir=.git "$removed" "$REPO_ROOT" || true)"
  fi

  [[ -z "$matches" ]] || {
    printf '%s\n' "$matches" >&2
    die 'Removed terminal configuration is still present'
  }
}

check_package_layout() {
  local package

  info 'Stow package layout'
  for package in bash zsh git tmux vim ideavim alacritty wezterm karabiner clang-format scripts x11; do
    [[ -d "$REPO_ROOT/stow/$package" ]] || die "Missing Stow package: $package"
  done

  if find "$REPO_ROOT/stow" -name .git -print -quit | grep -q .; then
    die 'Nested Git repositories must not be stored in Stow packages'
  fi
}

check_platform() {
  local platform="$1"
  local home="$TEST_ROOT/$platform/home"
  local first_links
  local second_links

  info "Install and remove in a temporary $platform HOME"
  mkdir -p "$home"

  "$REPO_ROOT/install.sh" install \
    --yes \
    --platform "$platform" \
    --target "$home" >/dev/null

  first_links="$(find "$home" -type l -print | sort)"
  [[ -n "$first_links" ]] || die "No links created for $platform"

  "$REPO_ROOT/install.sh" install \
    --yes \
    --platform "$platform" \
    --target "$home" >/dev/null

  second_links="$(find "$home" -type l -print | sort)"
  [[ "$first_links" == "$second_links" ]] || die "Second $platform apply changed the link set"

  if [[ "$platform" == "ubuntu" ]]; then
    [[ -L "$home/.Xresources" ]] || die 'Ubuntu package did not install .Xresources'
    [[ -L "$home/.config/wezterm/wezterm.lua" ]] || die 'Ubuntu did not install WezTerm configuration'
    [[ ! -e "$home/.config/karabiner/karabiner.json" ]] || \
      die 'Ubuntu unexpectedly installed Karabiner configuration'
    [[ -L "$home/.local/share/fonts/iosevka-semibold.ttc" ]] || die 'Ubuntu font target is wrong'
  else
    [[ ! -e "$home/.Xresources" ]] || die 'macOS unexpectedly installed .Xresources'
    [[ -L "$home/.config/wezterm/wezterm.lua" ]] || die 'macOS did not install WezTerm configuration'
    [[ -L "$home/.config/karabiner/karabiner.json" ]] || \
      die 'macOS did not install Karabiner configuration'
    [[ -L "$home/Library/Fonts/iosevka-semibold.ttc" ]] || die 'macOS font target is wrong'
  fi

  [[ -L "$home/.zprofile" ]] || die "$platform package did not install .zprofile"

  "$REPO_ROOT/install.sh" remove \
    --yes \
    --platform "$platform" \
    --target "$home" >/dev/null

  if find "$home" -type l -print -quit | grep -q .; then
    find "$home" -type l -print >&2
    die "Removal left managed links in the $platform HOME"
  fi
}

check_conflict_protection() {
  local home="$TEST_ROOT/conflict/home"
  local marker='user-owned bashrc'

  info 'Refuse to overwrite an unmanaged file'
  mkdir -p "$home"
  printf '%s\n' "$marker" > "$home/.bashrc"

  if "$REPO_ROOT/install.sh" install \
    --yes \
    --platform macos \
    --target "$home" \
    --no-font \
    bash >/dev/null 2>&1; then
    die 'Installer unexpectedly overwrote an unmanaged .bashrc'
  fi

  [[ "$(< "$home/.bashrc")" == "$marker" ]] || die 'Conflict test changed the unmanaged .bashrc'
}

check_legacy_migration() {
  local home="$TEST_ROOT/migration/home"

  info 'One-time legacy migration'
  mkdir -p "$home"
  ln -s "$REPO_ROOT/.bashrc" "$home/.bashrc"
  cp "$REPO_ROOT/stow/zsh/.zprofile" "$home/.zprofile"
  # Literal legacy content.
  # shellcheck disable=SC2016
  printf 'source $HOME/config/vim/init.vim\n' > "$home/.vimrc"

  "$REPO_ROOT/scripts/migrate-legacy.sh" needed "$home"
  "$REPO_ROOT/scripts/migrate-legacy.sh" dry-run "$home" >/dev/null
  [[ -L "$home/.bashrc" && -f "$home/.zprofile" && -f "$home/.vimrc" ]] || \
    die 'Migration dry run changed the target'

  "$REPO_ROOT/scripts/migrate-legacy.sh" apply "$home" >/dev/null
  [[ ! -e "$home/.bashrc" && ! -L "$home/.bashrc" ]] || die 'Legacy link was not removed'
  [[ ! -e "$home/.zprofile" ]] || die 'Matching .zprofile was not moved'
  [[ ! -e "$home/.vimrc" ]] || die 'Legacy .vimrc was not moved'
  find "$home/.config-backup" -name .zprofile -type f -print -quit | grep -q . || \
    die 'Matching .zprofile backup was not created'
  find "$home/.config-backup" -name .vimrc -type f -print -quit | grep -q . || \
    die 'Legacy .vimrc backup was not created'
}

main() {
  command -v stow >/dev/null 2>&1 || die 'GNU Stow is required'

  TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/config-check.XXXXXX")"

  check_shell_syntax
  check_stale_paths
  check_removed_tools
  check_package_layout
  check_managed_configs

  check_platform macos
  check_platform ubuntu
  check_conflict_protection
  check_legacy_migration

  info 'All structural checks passed'
}

main "$@"
