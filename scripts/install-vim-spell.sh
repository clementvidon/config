#!/usr/bin/env bash
# Install Vim's French spelling dictionary and suggestion index.

set -euo pipefail

spell_dir="${XDG_DATA_HOME:-$HOME/.local/share}/vim/spell"
work_dir="$(mktemp -d "${TMPDIR:-/tmp}/vim-spell.XXXXXX")"
trap 'rm -rf -- "$work_dir"' EXIT

base_url=https://ftp.nluug.nl/pub/vim/runtime/spell
for extension in spl sug; do
  curl --fail --location --silent --show-error \
    --output "$work_dir/fr.utf-8.$extension" \
    "$base_url/fr.utf-8.$extension"
done

mkdir -p "$spell_dir"
install -m 644 "$work_dir/fr.utf-8.spl" "$spell_dir/fr.utf-8.spl"
install -m 644 "$work_dir/fr.utf-8.sug" "$spell_dir/fr.utf-8.sug"

printf 'Installed Vim French spelling and suggestions in %s\n' "$spell_dir"
