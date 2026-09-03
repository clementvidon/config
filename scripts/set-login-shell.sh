#!/usr/bin/env bash

set -Eeuo pipefail

command -v zsh >/dev/null 2>&1 || {
  echo 'zsh is not installed' >&2
  exit 1
}

zsh_path="$(command -v zsh)"
grep -Fxq "$zsh_path" /etc/shells || {
  echo "$zsh_path is not listed in /etc/shells" >&2
  exit 1
}

if [[ "${SHELL:-}" == "$zsh_path" ]]; then
  echo "Login shell is already $zsh_path"
  exit 0
fi

chsh -s "$zsh_path"
