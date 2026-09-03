#!/usr/bin/env bash

set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly REPO_ROOT
readonly STOW_DIR="$REPO_ROOT/stow"
readonly FONT_SOURCE="$REPO_ROOT/assets/fonts/iosevka-semibold.ttc"

ACTION="install"
TARGET="$HOME"
TARGET_EXPLICIT=false
PLATFORM=""
DRY_RUN=false
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
  wezterm, karabiner, clang-format, scripts, fonts

Options:
  -n, --dry-run              Show what would change
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
      -t|--target)
        [[ $# -ge 2 ]] || die "$1 expects a directory"
        TARGET="$2"
        TARGET_EXPLICIT=true
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

  if [[ -n "$PLATFORM" ]] && { ! $TARGET_EXPLICIT || [[ "$TARGET" == "$HOME" ]]; }; then
    die '--platform requires --target set to a directory other than HOME'
  fi
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
      [[ "${ID:-}" == "ubuntu" ]] || \
        die "Supported Linux distribution: Ubuntu (found ${ID:-unknown})"
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
    PACKAGES=(
      bash
      zsh
      git
      tmux
      vim
      ideavim
      alacritty
      wezterm
      clang-format
      scripts
      fonts
    )

    [[ "$PLATFORM" == "macos" ]] && PACKAGES+=(karabiner)
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

require_stow() {
  command -v stow >/dev/null 2>&1 || die 'GNU Stow is required'
}

ensure_target_directory() {
  if [[ -d "$TARGET" ]]; then
    return 0
  fi

  [[ ! -e "$TARGET" ]] || die "Target exists but is not a directory: $TARGET"

  if $DRY_RUN; then
    die "Target directory does not exist; create it before previewing: $TARGET"
  fi

  info "Create target directory: $TARGET"
  run mkdir -p "$TARGET"
}

report_stow_conflicts() {
  local plan="$1"
  local conflicts

  conflicts="$(printf '%s\n' "$plan" | sed -n -E \
    's/.*over existing target ([^ ]+) since neither a link nor a directory.*/  ~\/\1/p' | \
    awk '!seen[$0]++')"

  [[ -n "$conflicts" ]] || return 1

  warn 'Existing unmanaged files block installation; no files were changed:'
  printf '%s\n' "$conflicts" >&2
  warn 'Move or back up those files, then rerun ./install.sh.'
  warn 'Stow never overwrites unmanaged files automatically.'

  return 0
}

install_stow_packages() {
  local plan
  local -a command=(
    stow
    --dir "$STOW_DIR"
    --target "$TARGET"
    --no-folding
    --restow
  )

  [[ ${#STOW_PACKAGES[@]} -gt 0 ]] || return 0

  info 'Preview Stow installation'
  print_command "${command[@]}" --simulate "${STOW_PACKAGES[@]}"

  if ! plan="$("${command[@]}" --simulate "${STOW_PACKAGES[@]}" 2>&1)"; then
    if report_stow_conflicts "$plan"; then
      die 'Installation preview failed; existing files were left untouched'
    fi

    printf '%s\n' "$plan" >&2
    die 'Stow installation preview failed'
  fi

  info 'Stow installation preview passed'
  $DRY_RUN && return 0

  info 'Apply Stow packages'
  print_command "${command[@]}" "${STOW_PACKAGES[@]}"
  "${command[@]}" "${STOW_PACKAGES[@]}"
}

remove_stow_packages() {
  local plan
  local links
  local -a command=(
    stow
    --dir "$STOW_DIR"
    --target "$TARGET"
    --no-folding
    --delete
  )
  local -a preview=("${command[@]}" --simulate --verbose=2)

  [[ ${#STOW_PACKAGES[@]} -gt 0 ]] || return 0

  info 'Preview Stow removal'
  print_command "${preview[@]}" "${STOW_PACKAGES[@]}"

  plan="$("${preview[@]}" "${STOW_PACKAGES[@]}" 2>&1)"

  links="$(printf '%s\n' "$plan" | sed -n -E \
    -e 's/^UNLINK: (.*)$/  would remove ~\/\1/p' \
    -e 's/^--- removing link owned by [^:]+: (.*) => .*$/  would remove ~\/\1/p' | \
    awk '!seen[$0]++')"

  if [[ -n "$links" ]]; then
    printf '%s\n' "$links"
  else
    info 'No managed links need removal'
  fi

  $DRY_RUN && return 0

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
  package_selected fonts || return 0

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

  if ! $DRY_RUN &&
     [[ "$PLATFORM" == "ubuntu" && "$TARGET" == "$HOME" ]] &&
     command -v fc-cache >/dev/null 2>&1; then
    run fc-cache -f "$(dirname "$destination")"
  fi
}

remove_font() {
  local destination

  $MANAGE_FONT || return 0
  package_selected fonts || return 0

  destination="$(font_target)"

  if [[ -L "$destination" && "$(readlink "$destination")" == "$FONT_SOURCE" ]]; then
    info 'Remove bundled font link'
    run unlink "$destination"
  elif [[ -e "$destination" || -L "$destination" ]]; then
    info "Leave existing font unchanged (not owned by this repository): $destination"
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
  require_stow

  case "$ACTION" in
    install)
      ensure_target_directory
      install_stow_packages
      install_font

      if $DRY_RUN; then
        info "Installation preview complete; no changes made ($PLATFORM -> $TARGET)"
      else
        info "Installation complete ($PLATFORM -> $TARGET)"
      fi
      ;;
    remove)
      remove_stow_packages
      remove_font

      if $DRY_RUN; then
        info "Removal preview complete; no changes made ($PLATFORM -> $TARGET)"
      else
        info "Removal complete ($PLATFORM -> $TARGET)"
      fi
      ;;
  esac
}

main "$@"
