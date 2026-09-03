#!/usr/bin/env bash

set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly REPO_ROOT
TEST_ROOT=""

info() {
  printf '[CHECK] %s\n' "$*"
}

skip() {
  printf '[SKIP] %s\n' "$*"
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
    info 'ShellCheck validation'
    shellcheck --shell=bash \
      "$REPO_ROOT/install.sh" \
      "$REPO_ROOT/scripts/"*.sh

    shellcheck --severity=error --shell=bash \
      "$REPO_ROOT/stow/bash/.bashrc" \
      "$REPO_ROOT/stow/scripts/.local/bin/"*
  else
    skip 'ShellCheck validation (shellcheck is unavailable)'
  fi
}

check_managed_configs() {
  local socket="$TEST_ROOT/tmux.sock"

  info 'Managed configuration syntax'

  info 'Git configuration validation'
  git config --file "$REPO_ROOT/stow/git/.gitconfig" --list >/dev/null

  info 'Karabiner JSON validation'
  python3 -m json.tool \
    "$REPO_ROOT/stow/karabiner/.config/karabiner/karabiner.json" >/dev/null

  if command -v wezterm >/dev/null 2>&1; then
    info 'WezTerm configuration validation'
    wezterm \
      --config-file "$REPO_ROOT/stow/wezterm/.config/wezterm/wezterm.lua" \
      show-keys >/dev/null
  else
    skip 'WezTerm configuration validation (wezterm is unavailable)'
  fi

  if command -v tmux >/dev/null 2>&1; then
    info 'tmux configuration validation'
    tmux -S "$socket" -f "$REPO_ROOT/stow/tmux/.tmux.conf" new-session -d
    tmux -S "$socket" kill-server
  else
    skip 'tmux configuration validation (tmux is unavailable)'
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

check_package_layout() {
  local package

  info 'Stow package layout'
  for package in bash zsh git tmux vim ideavim alacritty wezterm karabiner clang-format scripts; do
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
    --platform "$platform" \
    --target "$home" >/dev/null

  first_links="$(find "$home" -type l -print | sort)"
  [[ -n "$first_links" ]] || die "No links created for $platform"

  "$REPO_ROOT/install.sh" install \
    --platform "$platform" \
    --target "$home" >/dev/null

  second_links="$(find "$home" -type l -print | sort)"
  [[ "$first_links" == "$second_links" ]] || die "Second $platform apply changed the link set"

  if [[ "$platform" == "ubuntu" ]]; then
    [[ -L "$home/.config/wezterm/wezterm.lua" ]] || die 'Ubuntu did not install WezTerm configuration'
    [[ ! -e "$home/.config/karabiner/karabiner.json" ]] || \
      die 'Ubuntu unexpectedly installed Karabiner configuration'
    [[ -L "$home/.local/share/fonts/iosevka-semibold.ttc" ]] || die 'Ubuntu font target is wrong'
  else
    [[ -L "$home/.config/wezterm/wezterm.lua" ]] || die 'macOS did not install WezTerm configuration'
    [[ -L "$home/.config/karabiner/karabiner.json" ]] || \
      die 'macOS did not install Karabiner configuration'
    [[ -L "$home/Library/Fonts/iosevka-semibold.ttc" ]] || die 'macOS font target is wrong'
  fi

  [[ -L "$home/.zprofile" ]] || die "$platform package did not install .zprofile"

  "$REPO_ROOT/install.sh" remove \
    --platform "$platform" \
    --target "$home" >/dev/null

  if find "$home" -type l -print -quit | grep -q .; then
    find "$home" -type l -print >&2
    die "Removal left managed links in the $platform HOME"
  fi
}

check_dry_run() {
  local home="$TEST_ROOT/dry-run/home"
  local output

  info 'Dry run reaches Stow preflight without mutation'
  mkdir -p "$home"
  output="$("$REPO_ROOT/install.sh" install \
    --dry-run \
    --platform macos \
    --target "$home")"

  [[ "$output" == *'Stow installation preview passed'* ]] || \
    die 'Dry run did not reach the Stow preflight'
  [[ -z "$(find "$home" -mindepth 1 -print -quit)" ]] || \
    die 'Dry run changed the target HOME'
}

check_font_ownership() {
  local home="$TEST_ROOT/fonts/home"
  local font="$home/Library/Fonts/iosevka-semibold.ttc"

  info 'Bundled font belongs only to the fonts package'
  mkdir -p "$home"

  "$REPO_ROOT/install.sh" install --platform macos --target "$home" wezterm >/dev/null
  [[ ! -e "$font" && ! -L "$font" ]] || die 'WezTerm installation touched the bundled font'

  "$REPO_ROOT/install.sh" install --platform macos --target "$home" fonts >/dev/null
  [[ -L "$font" ]] || die 'Fonts package did not install the bundled font'

  "$REPO_ROOT/install.sh" remove --platform macos --target "$home" wezterm >/dev/null
  [[ -L "$font" ]] || die 'WezTerm removal touched the bundled font'

  "$REPO_ROOT/install.sh" remove --platform macos --target "$home" fonts >/dev/null
  [[ ! -e "$font" && ! -L "$font" ]] || die 'Fonts package did not remove its font link'

  mkdir -p "$(dirname "$font")"
  printf 'user-owned font\n' > "$font"
  "$REPO_ROOT/install.sh" remove --platform macos --target "$home" fonts >/dev/null
  [[ "$(< "$font")" == 'user-owned font' ]] || die 'Fonts removal changed an unowned font'
}

check_platform_guard() {
  local home="$TEST_ROOT/platform-guard/home"

  info 'Forced platform requires an explicit alternate HOME'
  mkdir -p "$home"

  if HOME="$home" "$REPO_ROOT/install.sh" --dry-run --platform ubuntu >/dev/null 2>&1; then
    die 'Forced platform was accepted against HOME without --target'
  fi

  if HOME="$home" "$REPO_ROOT/install.sh" --dry-run \
    --platform ubuntu --target "$home" >/dev/null 2>&1; then
    die 'Forced platform was accepted when --target was HOME'
  fi
}

check_conflict_protection() {
  local home="$TEST_ROOT/conflict/home"
  local marker='user-owned bashrc'

  info 'Refuse to overwrite an unmanaged file'
  mkdir -p "$home"
  printf '%s\n' "$marker" > "$home/.bashrc"

  if "$REPO_ROOT/install.sh" install \
    --platform macos \
    --target "$home" \
    --no-font \
    bash >/dev/null 2>&1; then
    die 'Installer unexpectedly overwrote an unmanaged .bashrc'
  fi

  [[ "$(< "$home/.bashrc")" == "$marker" ]] || die 'Conflict test changed the unmanaged .bashrc'
}

main() {
  command -v stow >/dev/null 2>&1 || die 'GNU Stow is required'

  TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/config-check.XXXXXX")"

  check_shell_syntax
  check_stale_paths
  check_package_layout
  check_managed_configs

  check_dry_run
  check_font_ownership
  check_platform_guard
  check_platform macos
  check_platform ubuntu
  check_conflict_protection

  info 'All structural checks passed'
}

main "$@"
