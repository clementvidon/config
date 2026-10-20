#!/usr/bin/env bash
# Download and compile French and English dictionaries for the Vim configuration.

set -euo pipefail

spell_dir="${XDG_DATA_HOME:-$HOME/.local/share}/vim/spell"
work_dir="$(mktemp -d "${TMPDIR:-/tmp}/vim-spell.XXXXXX")"
trap 'rm -rf -- "$work_dir"' EXIT

english_version='2026.02.25'
english_source="https://github.com/en-wl/wordlist/releases/download/rel-$english_version"

curl --fail --location --output "$work_dir/fr.zip" \
  https://www.grammalecte.net/dic/hunspell-french-dictionaries-v7.7.zip
unzip -q "$work_dir/fr.zip" 'fr-classique.aff' 'fr-classique.dic' -d "$work_dir"

for dictionary in en_US en_GB-ise; do
  curl --fail --location --output "$work_dir/$dictionary.zip" \
    "$english_source/hunspell-$dictionary-$english_version.zip"
  for extension in aff dic; do
    # Vim combines regions using the final _US and _GB filename suffixes.
    unzip -p "$work_dir/$dictionary.zip" "$dictionary.$extension" \
      >"$work_dir/${dictionary%-ise}.$extension"
  done
done

cat >"$work_dir/compile.vim" <<'VIM'
set encoding=utf-8 nomore
execute 'mkspell! ' . fnameescape($VIM_SPELL_WORK_DIR . '/fr')
      \ . ' ' . fnameescape($VIM_SPELL_WORK_DIR . '/fr-classique')
execute 'mkspell! ' . fnameescape($VIM_SPELL_WORK_DIR . '/en')
      \ . ' ' . fnameescape($VIM_SPELL_WORK_DIR . '/en_US')
      \ . ' ' . fnameescape($VIM_SPELL_WORK_DIR . '/en_GB')
qa!
VIM

if ! VIM_SPELL_WORK_DIR="$work_dir" vim -Nu NONE -i NONE -n -es -V1 \
  -S "$work_dir/compile.vim" >"$work_dir/compile.log" 2>&1; then
  cat "$work_dir/compile.log" >&2
  exit 1
fi

for language in fr en; do
  if [[ ! -s "$work_dir/$language.utf-8.spl" ]]; then
    cat "$work_dir/compile.log" >&2
    exit 1
  fi
done

mkdir -p "$spell_dir"
for language in fr en; do
  install -m 644 "$work_dir/$language.utf-8.spl" "$spell_dir/$language.utf-8.spl"
  if [[ -f "$work_dir/$language.utf-8.sug" ]]; then
    install -m 644 "$work_dir/$language.utf-8.sug" "$spell_dir/$language.utf-8.sug"
  else
    rm -f -- "$spell_dir/$language.utf-8.sug"
  fi
done

printf 'Installed Vim dictionaries in %s\n' "$spell_dir"
