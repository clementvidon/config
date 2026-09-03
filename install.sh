#!/usr/bin/env bash

set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly REPO_ROOT
readonly STOW_DIR="$REPO_ROOT/stow"
readonly FONT_SOURCE="$REPO_ROOT/assets/fonts/iosevka-semibold.ttc"
readonly MIGRATION_SCRIPT="$REPO_ROOT/scripts/migrate-legacy.sh"

ACTION="install"
TARGET="$HOME"
PLATFORM=""
DRY_RUN=false
ASSUME_YES=false
MANAGE_FONT=true
declare -a REQUESTED=()
declare -a PACKAGES=()
declare -a STOW_PACKAGES=()

usage() {
  cat <<'EOF'
Usage:
  ./install.sh [install] [options] [package ...]
  ./install.sh remove [options] [package ...]
  ./install.sh check
  ./install.sh list

Packages:
  all (default), bash, zsh, git, tmux, vim, ideavim, alacritty,
  wezterm, karabiner, clang-format, scripts, x11, fonts

Options:
  -n, --dry-run              Show what would change
  -y, --yes                  Install GNU Stow without confirmation if missing
  -t, --target DIR           Target HOME (mainly for tests)
      --platform PLATFORM    Force macos or ubuntu (mainly for tests)
      --no-font              Do not manage the bundled font
  -h, --help                 Show this help
EOF
}

info() {
  printf '[INFO] %s\n' "$*"
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

die() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

print_command() {
  printf '  '
  printf '%q ' "$@"
  printf '\n'
}

run() {
  print_command "$@"
  $DRY_RUN || "$@"
}

confirm() {
  local answer

  $ASSUME_YES && return 0
  [[ -t 0 ]] || die 'GNU Stow is missing; rerun with --yes to install it'
  read -r -p 'GNU Stow is missing. Install it now? [y/N] ' answer
  [[ "$answer" == [yY] || "$answer" == [yY][eE][sS] ]]
}

parse_args() {
  if [[ $# -gt 0 ]]; then
    case "$1" in
      install|remove|check|list)
        ACTION="$1"
        shift
        ;;
      all)
        REQUESTED+=(all)
        shift
        ;;
    esac
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -n|--dry-run)
        DRY_RUN=true
        shift
        ;;
      -y|--yes)
        ASSUME_YES=true
        shift
        ;;
      -t|--target)
        [[ $# -ge 2 ]] || die "$1 expects a directory"
        TARGET="$2"
        shift 2
        ;;
      --platform)
        [[ $# -ge 2 ]] || die "$1 expects macos or ubuntu"
        PLATFORM="$2"
        shift 2
        ;;
      --no-font)
        MANAGE_FONT=false
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      --)
        shift
        REQUESTED+=("$@")
        break
        ;;
      -*)
        die "Unknown option: $1"
        ;;
      *)
        REQUESTED+=("$1")
        shift
        ;;
    esac
  done

  [[ "$TARGET" == /* ]] || die "Target must be an absolute path: $TARGET"
}

detect_platform() {
  if [[ -n "$PLATFORM" ]]; then
    [[ "$PLATFORM" == "macos" || "$PLATFORM" == "ubuntu" ]] || \
      die "Unsupported platform: $PLATFORM"
    return
  fi

  case "$(uname -s)" in
    Darwin)
      PLATFORM="macos"
      ;;
    Linux)
      [[ -r /etc/os-release ]] || die 'Cannot identify this Linux distribution'
      # shellcheck disable=SC1091
      . /etc/os-release
      [[ "${ID:-}" == "ubuntu" ]] || die "Supported Linux distribution: Ubuntu (found ${ID:-unknown})"
      PLATFORM="ubuntu"
      ;;
    *)
      die 'Supported operating systems: macOS and Ubuntu'
      ;;
  esac
}

resolve_packages() {
  local package

  if [[ ${#REQUESTED[@]} -eq 0 || "${REQUESTED[0]}" == "all" ]]; then
    PACKAGES=(bash zsh git tmux vim ideavim alacritty wezterm clang-format scripts fonts)
    if [[ "$PLATFORM" == "macos" ]]; then
      PACKAGES+=(karabiner)
    else
      PACKAGES+=(x11)
    fi
  else
    PACKAGES=("${REQUESTED[@]}")
  fi

  for package in "${PACKAGES[@]}"; do
    if [[ "$package" == "fonts" ]]; then
      continue
    fi
    [[ -d "$STOW_DIR/$package" ]] || die "Unknown package: $package"
    [[ "$package" != "karabiner" || "$PLATFORM" == "macos" ]] || \
      die 'Package karabiner is only supported on macOS'
    [[ "$package" != "x11" || "$PLATFORM" == "ubuntu" ]] || \
      die 'Package x11 is only supported on Ubuntu'
    STOW_PACKAGES+=("$package")
  done
}

package_selected() {
  local expected="$1"
  local package

  for package in "${PACKAGES[@]}"; do
    [[ "$package" == "$expected" ]] && return 0
  done
  return 1
}

ensure_stow() {
  command -v stow >/dev/null 2>&1 && return 0
  $DRY_RUN && die 'GNU Stow is required for a dry run'
  confirm || die 'GNU Stow is required'

  case "$PLATFORM" in
    macos)
      command -v brew >/dev/null 2>&1 || die 'Install Homebrew first: https://brew.sh'
      run brew install stow
      ;;
    ubuntu)
      command -v apt-get >/dev/null 2>&1 || die 'apt-get is required on Ubuntu'
      run sudo apt-get update
      run sudo apt-get install -y stow
      ;;
  esac

  command -v stow >/dev/null 2>&1 || die 'GNU Stow installation failed'
}

migrate_if_needed() {
  "$MIGRATION_SCRIPT" needed "$TARGET" || return 1

  if $DRY_RUN; then
    "$MIGRATION_SCRIPT" dry-run "$TARGET"
  else
    "$MIGRATION_SCRIPT" apply "$TARGET"
  fi
  return 0
}

install_stow_packages() {
  local migration_pending=false
  local -a command=(stow --dir "$STOW_DIR" --target "$TARGET" --no-folding --restow)

  [[ ${#STOW_PACKAGES[@]} -gt 0 ]] || return 0
  migrate_if_needed && migration_pending=true

  info 'Preflight Stow'
  print_command "${command[@]}" --simulate "${STOW_PACKAGES[@]}"

  if $DRY_RUN && $migration_pending; then
    info 'Stow preflight will run after the one-time migration shown above'
    return 0
  fi

  "${command[@]}" --simulate "${STOW_PACKAGES[@]}"
  $DRY_RUN && return 0

  info 'Apply Stow packages'
  print_command "${command[@]}" "${STOW_PACKAGES[@]}"
  "${command[@]}" "${STOW_PACKAGES[@]}"
}

remove_stow_packages() {
  local -a command=(stow --dir "$STOW_DIR" --target "$TARGET" --no-folding --delete)

  [[ ${#STOW_PACKAGES[@]} -gt 0 ]] || return 0
  $DRY_RUN && command+=(--simulate)

  info 'Remove Stow packages'
  print_command "${command[@]}" "${STOW_PACKAGES[@]}"
  "${command[@]}" "${STOW_PACKAGES[@]}"
}

font_target() {
  if [[ "$PLATFORM" == "macos" ]]; then
    printf '%s/Library/Fonts/iosevka-semibold.ttc\n' "$TARGET"
  else
    printf '%s/.local/share/fonts/iosevka-semibold.ttc\n' "$TARGET"
  fi
}

install_font() {
  local destination

  $MANAGE_FONT || return 0
  package_selected fonts || package_selected alacritty || package_selected wezterm || return 0
  [[ -f "$FONT_SOURCE" ]] || die "Bundled font not found: $FONT_SOURCE"
  destination="$(font_target)"

  if [[ -L "$destination" && "$(readlink "$destination")" == "$FONT_SOURCE" ]]; then
    info "Font already linked: $destination"
    return 0
  fi
  if [[ -e "$destination" ]] && cmp -s "$FONT_SOURCE" "$destination"; then
    info "Identical font already installed: $destination"
    return 0
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    warn "Font target already exists and is left unchanged: $destination"
    return 0
  fi

  info 'Install bundled font'
  run mkdir -p "$(dirname "$destination")"
  run ln -s "$FONT_SOURCE" "$destination"

  if ! $DRY_RUN && [[ "$PLATFORM" == "ubuntu" && "$TARGET" == "$HOME" ]] && command -v fc-cache >/dev/null 2>&1; then
    run fc-cache -f "$(dirname "$destination")"
  fi
}

remove_font() {
  local destination

  $MANAGE_FONT || return 0
  package_selected fonts || package_selected alacritty || package_selected wezterm || return 0
  destination="$(font_target)"

  if [[ -L "$destination" && "$(readlink "$destination")" == "$FONT_SOURCE" ]]; then
    info 'Remove bundled font link'
    run unlink "$destination"
  elif [[ -e "$destination" || -L "$destination" ]]; then
    warn "Font target is not owned by this repository: $destination"
  fi
}

list_packages() {
  cat <<'EOF'
PACKAGE          SCOPE
bash             common
zsh              common
git              common
tmux             common
vim              common
ideavim          common
alacritty        common
wezterm          common
karabiner        macos
clang-format     common
scripts          common
fonts            platform-specific destination
x11              ubuntu
EOF
}

main() {
  parse_args "$@"

  case "$ACTION" in
    check)
      exec "$REPO_ROOT/scripts/check.sh"
      ;;
    list)
      list_packages
      exit 0
      ;;
  esac

  detect_platform
  resolve_packages
  ensure_stow
  run mkdir -p "$TARGET"

  case "$ACTION" in
    install)
      install_stow_packages
      install_font
      info "Installation complete ($PLATFORM -> $TARGET)"
      ;;
    remove)
      remove_stow_packages
      remove_font
      info "Removal complete ($PLATFORM -> $TARGET)"
      ;;
  esac
}

main "$@"
