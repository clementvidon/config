#!/usr/bin/env bash
# Download and compile French; Vim's bundled English dictionary gives faster suggestions.

set -euo pipefail

spell_dir="${XDG_DATA_HOME:-$HOME/.local/share}/vim/spell"
work_dir="$(mktemp -d "${TMPDIR:-/tmp}/vim-spell.XXXXXX")"
trap 'rm -rf -- "$work_dir"' EXIT

curl --fail --location --output "$work_dir/fr.zip" \
  https://www.grammalecte.net/dic/hunspell-french-dictionaries-v7.7.zip
unzip -q "$work_dir/fr.zip" 'fr-classique.aff' 'fr-classique.dic' -d "$work_dir"

cat >"$work_dir/compile.vim" <<'VIM'
set encoding=utf-8 nomore
execute 'mkspell! ' . fnameescape($VIM_SPELL_WORK_DIR . '/fr')
      \ . ' ' . fnameescape($VIM_SPELL_WORK_DIR . '/fr-classique')
qa!
VIM

if ! VIM_SPELL_WORK_DIR="$work_dir" vim -Nu NONE -i NONE -n -es -V1 \
  -S "$work_dir/compile.vim" >"$work_dir/compile.log" 2>&1; then
  cat "$work_dir/compile.log" >&2
  exit 1
fi

if [[ ! -s "$work_dir/fr.utf-8.spl" ]]; then
  cat "$work_dir/compile.log" >&2
  exit 1
fi

mkdir -p "$spell_dir"
install -m 644 "$work_dir/fr.utf-8.spl" "$spell_dir/fr.utf-8.spl"
if [[ -f "$work_dir/fr.utf-8.sug" ]]; then
  install -m 644 "$work_dir/fr.utf-8.sug" "$spell_dir/fr.utf-8.sug"
else
  rm -f -- "$spell_dir/fr.utf-8.sug"
fi

printf 'Installed Vim dictionaries in %s\n' "$spell_dir"
