#!/usr/bin/env bash

set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly REPO_ROOT

MODE="${1:-apply}"
TARGET="${2:-$HOME}"
DRY_RUN=false
FOUND=false

[[ "$MODE" == "apply" || "$MODE" == "dry-run" || "$MODE" == "needed" ]] || {
  echo "Usage: $0 {apply|dry-run|needed} [target-home]" >&2
  exit 2
}
[[ "$MODE" == "dry-run" ]] && DRY_RUN=true

info() {
  [[ "$MODE" == "needed" ]] || printf '[MIGRATE] %s\n' "$*"
}

run() {
  if $DRY_RUN; then
    printf '  '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

legacy_link() {
  local destination_rel="$1"
  local legacy_source_rel="$2"
  local destination="$TARGET/$destination_rel"
  local expected="$REPO_ROOT/$legacy_source_rel"

  [[ -L "$destination" && "$(readlink "$destination")" == "$expected" ]] || return 0
  FOUND=true
  [[ "$MODE" == "needed" ]] && return 0

  info "Remove old link: ~/$destination_rel"
  run unlink "$destination"
}

legacy_links() {
  local file

  legacy_link .bashrc .bashrc
  legacy_link .zshrc .zshrc
  legacy_link .zshenv .zshenv
  legacy_link .gitconfig .gitconfig
  legacy_link .gitmessage .gitmessage
  legacy_link .gitignore .gitignore
  legacy_link .tmux.conf .tmux.conf

  for file in "$REPO_ROOT/stow/scripts/.local/bin/"*; do
    [[ -f "$file" ]] || continue
    legacy_link ".local/bin/$(basename "$file")" ".local/bin/$(basename "$file")"
  done

  for file in "$REPO_ROOT/stow/alacritty/.config/alacritty/"*.toml; do
    [[ -f "$file" ]] || continue
    legacy_link ".config/alacritty/$(basename "$file")" "alacritty/$(basename "$file")"
  done

  for file in "$REPO_ROOT/stow/alacritty/.config/alacritty/colors/"*.toml; do
    [[ -f "$file" ]] || continue
    legacy_link \
      ".config/alacritty/colors/$(basename "$file")" \
      "alacritty/colors/$(basename "$file")"
  done

  legacy_link .fonts/iosevka-semibold.ttc .fonts/iosevka-semibold.ttc
}

legacy_zprofile() {
  local zprofile="$TARGET/.zprofile"
  local managed="$REPO_ROOT/stow/zsh/.zprofile"
  local backup_dir

  [[ -f "$zprofile" && ! -L "$zprofile" ]] || return 0
  cmp -s "$managed" "$zprofile" || return 0

  FOUND=true
  [[ "$MODE" == "needed" ]] && return 0

  backup_dir="$TARGET/.config-backup/config-stow-$(date +%Y%m%d-%H%M%S)"
  info "Back up the matching .zprofile to $backup_dir/.zprofile"
  run mkdir -p "$backup_dir"
  run mv "$zprofile" "$backup_dir/.zprofile"
}

legacy_vimrc() {
  local vimrc="$TARGET/.vimrc"
  local first_line=""
  local backup_dir

  [[ -f "$vimrc" && ! -L "$vimrc" ]] || return 0
  IFS= read -r first_line < "$vimrc" || true

  # Literal legacy file contents; $HOME must not expand here.
  # shellcheck disable=SC2016
  case "$first_line" in
    'source $HOME/config/vim/init.vim'|'source $HOME/git/config/vim/init.vim') ;;
    *) return 0 ;;
  esac

  FOUND=true
  [[ "$MODE" == "needed" ]] && return 0

  backup_dir="$TARGET/.config-backup/config-stow-$(date +%Y%m%d-%H%M%S)"
  info "Back up old ~/.vimrc to $backup_dir/.vimrc"
  run mkdir -p "$backup_dir"
  run mv "$vimrc" "$backup_dir/.vimrc"
}

legacy_vim_state() {
  local name
  local source
  local destination

  [[ "$TARGET" == "$HOME" && -d "$REPO_ROOT/vim" ]] || return 0

  for name in .plugged .undo .swap .viminfo; do
    source="$REPO_ROOT/vim/$name"
    destination="$TARGET/.vim/$name"
    [[ -e "$source" && ! -e "$destination" && ! -L "$destination" ]] || continue

    FOUND=true
    [[ "$MODE" == "needed" ]] && continue

    info "Move Vim runtime state: $name"
    run mkdir -p "$TARGET/.vim"
    run mv "$source" "$destination"
  done
}

main() {
  legacy_links
  legacy_zprofile
  legacy_vimrc
  legacy_vim_state

  if [[ "$MODE" == "needed" ]]; then
    $FOUND
    exit
  fi

  if $FOUND; then
    info 'Legacy migration complete'
  else
    info 'No legacy state found'
  fi
}

main
