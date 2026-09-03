#!/usr/bin/env bash
#
# Purpose: Set the current user's login shell to the zsh found in PATH.

set -Eeuo pipefail

usage() {
  cat <<'EOF'
Usage: set-login-shell.sh [-h|--help]

Set the current user's login shell to the zsh executable found in PATH.
The executable must already be listed in /etc/shells.

Options:
  -h, --help  Show this help
EOF
}

die() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

main() {
  if [[ $# -gt 0 ]]; then
    case "$1" in
      -h | --help)
        [[ $# -eq 1 ]] || die 'Help does not accept additional arguments'
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  fi

  command -v zsh >/dev/null 2>&1 || die 'zsh is not installed'
  command -v chsh >/dev/null 2>&1 || die 'chsh is not installed'
  [[ -r /etc/shells ]] || die '/etc/shells is not readable'

  local zsh_path
  zsh_path="$(command -v zsh)"
  grep -Fxq -- "$zsh_path" /etc/shells \
    || die "$zsh_path is not listed in /etc/shells"

  if [[ "${SHELL:-}" == "$zsh_path" ]]; then
    printf 'Login shell is already %s\n' "$zsh_path"
    exit 0
  fi

  chsh -s "$zsh_path"
}

main "$@"
