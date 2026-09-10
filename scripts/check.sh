#!/usr/bin/env bash
#
# Purpose: Validate configuration files and Stow installation behavior.

set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly REPO_ROOT
TEST_ROOT=""

usage() {
  cat <<'EOF'
Usage: check.sh [-h|--help]

Run configuration and isolated installation checks for this dotfiles repository.

Options:
  -h, --help  Show this help
EOF
}

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

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h | --help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done
}

check_managed_configs() {
  local config
  local socket="$TEST_ROOT/tmux.sock"

  info 'Managed configuration syntax'

  while IFS= read -r -d '' config; do
    bash -n "$config"
  done < <(find "$REPO_ROOT/stow" -type f -name '.bashrc' -print0)

  if command -v zsh >/dev/null 2>&1; then
    while IFS= read -r -d '' config; do
      zsh -n "$config"
    done < <(find "$REPO_ROOT/stow" -type f \
      \( -name '.zshenv' -o -name '.zprofile' -o -name '.zshrc' \) -print0)
  else
    skip 'Zsh configuration validation (zsh is unavailable)'
  fi

  while IFS= read -r -d '' config; do
    git config --file "$config" --list >/dev/null
  done < <(find "$REPO_ROOT/stow" -type f -name '.gitconfig' -print0)

  if command -v python3 >/dev/null 2>&1; then
    while IFS= read -r -d '' config; do
      python3 -m json.tool "$config" >/dev/null
    done < <(find "$REPO_ROOT/stow" "$REPO_ROOT/exports" -type f -name '*.json' -print0)
  else
    skip 'JSON validation (python3 is unavailable)'
  fi

  if command -v python3 >/dev/null 2>&1 \
    && python3 -c 'import tomllib' >/dev/null 2>&1; then
    while IFS= read -r -d '' config; do
      python3 -c \
        'import pathlib, sys, tomllib; tomllib.loads(pathlib.Path(sys.argv[1]).read_text())' \
        "$config"
    done < <(find "$REPO_ROOT/stow" -type f -name '*.toml' -print0)
  else
    skip 'TOML validation (Python tomllib is unavailable)'
  fi

  while IFS= read -r -d '' config; do
    if command -v wezterm >/dev/null 2>&1; then
      wezterm --config-file "$config" show-keys >/dev/null
    else
      skip "WezTerm configuration validation (wezterm is unavailable): $config"
    fi
  done < <(find "$REPO_ROOT/stow" -type f -name 'wezterm.lua' -print0)

  while IFS= read -r -d '' config; do
    if command -v tmux >/dev/null 2>&1; then
      tmux -S "$socket" -f "$config" new-session -d
      tmux -S "$socket" kill-server
    else
      skip "tmux configuration validation (tmux is unavailable): $config"
    fi
  done < <(find "$REPO_ROOT/stow" -type f -name '.tmux.conf' -print0)
}

stow_ignores_path() {
  local package="$1"
  local relative="$2"
  local ignore_file="$package/.stow-local-ignore"
  local pattern

  [[ "$relative" == ".stow-local-ignore" ]] && return 0
  [[ -f "$ignore_file" ]] || return 1

  while IFS= read -r pattern || [[ -n "$pattern" ]]; do
    [[ -z "$pattern" || "$pattern" =~ ^[[:space:]]*# ]] && continue
    [[ "/$relative" =~ $pattern ]] && return 0
  done <"$ignore_file"

  return 1
}

assert_stow_files_installed() {
  local platform="$1"
  local home="$2"
  local package source relative target

  while IFS= read -r -d '' package; do
    [[ "${package##*/}" == "karabiner" ]] && continue

    while IFS= read -r -d '' source; do
      relative="${source#"$package"/}"
      stow_ignores_path "$package" "$relative" && continue
      target="$home/$relative"
      [[ -L "$target" ]] || die "Managed file was not linked: $relative"
    done < <(find "$package" \( -type f -o -type l \) -print0)
  done < <(find "$REPO_ROOT/stow" -mindepth 1 -maxdepth 1 -type d -print0)
}

check_package_layout() {
  local package

  info 'Stow package layout'
  find "$REPO_ROOT/stow" -mindepth 1 -maxdepth 1 -type d -print -quit | grep -q . \
    || die 'No Stow packages found'

  while IFS= read -r -d '' package; do
    find "$package" \( -type f -o -type l \) -print -quit | grep -q . \
      || die "Empty Stow package: ${package##*/}"
  done < <(find "$REPO_ROOT/stow" -mindepth 1 -maxdepth 1 -type d -print0)

  if find "$REPO_ROOT/stow" -mindepth 1 -maxdepth 1 ! -type d -print -quit | grep -q .; then
    die 'Only package directories may exist at the top level of stow/'
  fi

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
  assert_stow_files_installed "$platform" "$home"
  if [[ "$platform" == "macos" ]]; then
    [[ -f "$home/.config/karabiner/karabiner.json" \
      && ! -L "$home/.config/karabiner/karabiner.json" ]] \
      || die 'Karabiner configuration was not deployed as a regular file'
    [[ -f "$home/.local/state/config-installer/karabiner.json" ]] \
      || die 'Karabiner ownership snapshot is missing'
  fi

  "$REPO_ROOT/install.sh" install \
    --platform "$platform" \
    --target "$home" >/dev/null

  second_links="$(find "$home" -type l -print | sort)"
  [[ "$first_links" == "$second_links" ]] || die "Second $platform apply changed the link set"

  "$REPO_ROOT/install.sh" remove \
    --platform "$platform" \
    --target "$home" >/dev/null

  if find "$home" -type l -print -quit | grep -q .; then
    find "$home" -type l -print >&2
    die "Removal left managed links in the $platform HOME"
  fi
  [[ ! -e "$home/.config/karabiner/karabiner.json" ]] \
    || die 'Removal left the managed Karabiner configuration in place'
  [[ ! -e "$home/.local/state/config-installer/karabiner.json" ]] \
    || die 'Removal left the Karabiner ownership snapshot in place'
}

check_dry_run() {
  local home="$TEST_ROOT/dry-run/home"

  info 'Dry run does not mutate the target'
  mkdir -p "$home"
  "$REPO_ROOT/install.sh" install \
    --dry-run \
    --platform macos \
    --target "$home" >/dev/null

  [[ -z "$(find "$home" -mindepth 1 -print -quit)" ]] \
    || die 'Dry run changed the target HOME'
}

check_font_ownership() {
  local home="$TEST_ROOT/fonts/home"
  local font="$home/Library/Fonts/iosevka-semibold.ttc"

  info 'Bundled font belongs only to the fonts package'
  mkdir -p "$home"

  "$REPO_ROOT/install.sh" install --platform macos --target "$home" fonts >/dev/null 2>&1
  [[ -L "$font" ]] || die 'Fonts package did not install the bundled font'

  "$REPO_ROOT/install.sh" remove --platform macos --target "$home" fonts >/dev/null
  [[ ! -e "$font" && ! -L "$font" ]] || die 'Fonts package did not remove its font link'

  mkdir -p "$(dirname "$font")"
  printf 'user-owned font\n' >"$font"
  "$REPO_ROOT/install.sh" install --platform macos --target "$home" fonts >/dev/null 2>&1
  [[ "$(<"$font")" == 'user-owned font' ]] || die 'Fonts installation changed an unowned font'

  "$REPO_ROOT/install.sh" remove --platform macos --target "$home" fonts >/dev/null
  [[ "$(<"$font")" == 'user-owned font' ]] || die 'Fonts removal changed an unowned font'
}

check_font_preflight() {
  local fixture="$TEST_ROOT/missing-font/repository"
  local home="$TEST_ROOT/missing-font/home"

  info 'Missing bundled font fails before Stow changes'
  mkdir -p "$fixture/assets/fonts" "$home"
  cp "$REPO_ROOT/install.sh" "$fixture/install.sh"
  cp -R "$REPO_ROOT/stow" "$fixture/stow"

  if "$fixture/install.sh" install --dry-run \
    --platform macos --target "$home" >/dev/null 2>&1; then
    die 'Installation dry run succeeded without the bundled font'
  fi

  if "$fixture/install.sh" install \
    --platform macos --target "$home" >/dev/null 2>&1; then
    die 'Normal installation succeeded without the bundled font'
  fi

  [[ -z "$(find "$home" -mindepth 1 -print -quit)" ]] \
    || die 'Missing font failure happened after target HOME changes'
}

check_karabiner_ownership() {
  local fixture="$TEST_ROOT/karabiner/repository"
  local home="$TEST_ROOT/karabiner/home"
  local legacy_home="$TEST_ROOT/karabiner/legacy-home"
  local raw_stow_home="$TEST_ROOT/karabiner/raw-stow-home"
  local source target state

  info 'Karabiner copy ownership, updates, conflicts, and legacy migration'
  mkdir -p "$fixture/stow" "$home" "$legacy_home/.config/karabiner" \
    "$raw_stow_home"
  cp "$REPO_ROOT/install.sh" "$fixture/install.sh"
  cp -R "$REPO_ROOT/stow/karabiner" "$fixture/stow/karabiner"
  source="$fixture/stow/karabiner/.config/karabiner/karabiner.json"
  target="$home/.config/karabiner/karabiner.json"
  state="$home/.local/state/config-installer/karabiner.json"

  stow --dir "$fixture/stow" --target "$raw_stow_home" \
    --no-folding --restow karabiner
  [[ ! -e "$raw_stow_home/.config/karabiner/karabiner.json" \
    && ! -L "$raw_stow_home/.config/karabiner/karabiner.json" ]] \
    || die 'Raw Stow deployed the Karabiner application file'

  "$fixture/install.sh" install --platform macos --target "$home" karabiner >/dev/null
  [[ -f "$target" && ! -L "$target" ]] \
    || die 'Karabiner initial deployment did not create a regular file'
  cmp -s "$source" "$target" || die 'Karabiner initial copy differs from its source'
  cmp -s "$source" "$state" || die 'Karabiner ownership snapshot differs from its source'

  printf '\n' >>"$source"
  "$fixture/install.sh" install --platform macos --target "$home" karabiner >/dev/null
  cmp -s "$source" "$target" || die 'Karabiner source update was not deployed'
  cmp -s "$source" "$state" || die 'Karabiner ownership snapshot was not updated'

  printf 'user modification\n' >>"$target"
  if "$fixture/install.sh" install \
    --platform macos --target "$home" karabiner >/dev/null 2>&1; then
    die 'Karabiner installation overwrote an externally modified configuration'
  fi
  [[ "$(tail -n 1 "$target")" == 'user modification' ]] \
    || die 'Karabiner conflict handling changed the user configuration'
  "$fixture/install.sh" remove --platform macos --target "$home" karabiner >/dev/null
  [[ -f "$target" ]] || die 'Karabiner removal deleted an externally modified configuration'

  target="$legacy_home/.config/karabiner/karabiner.json"
  ln -s "$source" "$target"
  "$fixture/install.sh" install \
    --platform macos --target "$legacy_home" karabiner >/dev/null
  [[ -f "$target" && ! -L "$target" ]] \
    || die 'Karabiner legacy Stow link was not migrated to a regular file'
  cmp -s "$source" "$target" || die 'Karabiner legacy migration changed the configuration'
}

check_gpg_plugin() {
  local test="$REPO_ROOT/stow/vim/.vim/pack/local/start/gpg/test/run.sh"

  if command -v vim >/dev/null 2>&1 && command -v gpg >/dev/null 2>&1; then
    info 'Vim GPG security regressions'
    "$test"
  else
    skip 'Vim GPG security regressions (vim or gpg is unavailable)'
  fi
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
  local marker='user-owned configuration'
  local source relative package target

  info 'Refuse to overwrite an unmanaged file'
  source="$(find "$REPO_ROOT/stow" -mindepth 2 -type f -print | sort | sed -n '1p')"
  [[ -n "$source" ]] || die 'No managed file available for the conflict check'

  relative="${source#"$REPO_ROOT/stow/"}"
  package="${relative%%/*}"
  relative="${relative#*/}"
  target="$home/$relative"

  mkdir -p "${target%/*}"
  printf '%s\n' "$marker" >"$target"

  if "$REPO_ROOT/install.sh" install \
    --platform macos \
    --target "$home" \
    --no-font \
    "$package" >/dev/null 2>&1; then
    die "Installer unexpectedly overwrote an unmanaged file: $relative"
  fi

  [[ "$(<"$target")" == "$marker" ]] || die "Conflict check changed: $relative"
}

main() {
  parse_args "$@"

  command -v stow >/dev/null 2>&1 || die 'GNU Stow is required'

  TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/config-check.XXXXXX")"

  check_package_layout
  check_managed_configs
  info 'Vim behavior'
  bash "$REPO_ROOT/scripts/check-vim.sh"
  check_gpg_plugin

  check_dry_run
  check_font_preflight
  check_font_ownership
  check_karabiner_ownership
  check_platform_guard
  check_platform macos
  check_platform ubuntu
  check_conflict_protection

  info 'All structural checks passed'
}

main "$@"
