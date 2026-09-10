#!/usr/bin/env bash
#
# Purpose: Smoke-test the managed Vim configuration and sensitive defaults.

set -Eeuo pipefail

# Headless Vim helpers may still inspect terminal capabilities.
export TERM="${TERM:-dumb}"

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly REPO_ROOT
CHECK_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/vim-check.XXXXXX")"
readonly CHECK_ROOT
readonly CHECK_HOME="$CHECK_ROOT/home"
readonly CHECK_DATA="$CHECK_ROOT/data"
readonly CHECK_STATE="$CHECK_ROOT/state"
readonly ERRORS="$CHECK_ROOT/errors"
readonly VIM_LOG="$CHECK_ROOT/vim.log"
PASS_ROOT="$(mktemp -d /tmp/pass.XXXXXX)"
readonly PASS_ROOT
readonly PASS_FILE="$PASS_ROOT/password.txt"

cleanup() {
  rm -rf -- "$CHECK_ROOT"
  rm -rf -- "$PASS_ROOT"
}

trap cleanup EXIT

fail() {
  printf '[ERROR] Vim smoke checks failed:\n' >&2
  [[ ! -s "$ERRORS" ]] || cat -- "$ERRORS" >&2
  exit 1
}

command -v vim >/dev/null 2>&1 || {
  printf '[SKIP] Vim smoke checks (vim is unavailable)\n'
  exit 0
}

case "$(uname -s)" in
  Darwin) platform=macos ;;
  Linux) platform=ubuntu ;;
  *)
    printf '[SKIP] Vim smoke checks (unsupported platform)\n'
    exit 0
    ;;
esac

mkdir -p "$CHECK_HOME" "$CHECK_DATA/vim/plugged" "$CHECK_STATE"
"$REPO_ROOT/install.sh" install --platform "$platform" --target "$CHECK_HOME" \
  --no-font vim >/dev/null

# Reuse downloaded plugins when available; missing optional plugins must not
# prevent the first-party configuration from loading.
for plugin in ale vim-gitgutter; do
  source="${XDG_DATA_HOME:-$HOME/.local/share}/vim/plugged/$plugin"
  [[ ! -d "$source" ]] || ln -s "$source" "$CHECK_DATA/vim/plugged/$plugin"
done

mkdir -p "$CHECK_ROOT/project"
printf 'plain note\n' >"$CHECK_ROOT/project/plain.noe"
printf '%s\n' '- task' >"$CHECK_ROOT/project/todos.noe"
printf '{"key": true}\n' >"$CHECK_ROOT/project/data.json"
printf 'key: value\n' >"$CHECK_ROOT/project/data.yaml"
printf 'temporary password\n' >"$PASS_FILE"

cat >"$CHECK_ROOT/smoke.vim" <<'VIM'
set nomore
let s:errors = []

function! s:Open(path) abort
  let v:errmsg = ''
  execute 'edit ' . fnameescape(a:path)
  filetype detect
  if !empty(v:errmsg)
    call add(s:errors, fnamemodify(a:path, ':t') . ': ' . v:errmsg)
  endif
endfunction

for s:name in ['plain.noe', 'todos.noe', 'data.json', 'data.yaml']
  call s:Open($VIM_CHECK_ROOT . '/project/' . s:name)
endfor

" Reloading is a supported workflow and must not invalidate the configuration.
let v:errmsg = ''
execute 'source ' . fnameescape($VIM_CHECK_ROOT . '/home/.vimrc')
if !empty(v:errmsg)
  call add(s:errors, 'vimrc reload: ' . v:errmsg)
endif

if !empty(s:errors)
  call writefile(s:errors, $VIM_CHECK_ERRORS)
  cquit 1
endif
qa!
VIM

# Password buffers are the only non-GPG behavior checked precisely because a
# regression could persist secrets to disk or send them to integrations.
cat >"$CHECK_ROOT/redact.vim" <<'VIM'
set nomore
let s:errors = []
if !get(b:, 'vim_sensitive_buffer', 0)
  call add(s:errors, 'pass buffer was not marked sensitive')
endif
if &l:swapfile || &l:undofile || &backup || &writebackup || !empty(&viminfo)
  call add(s:errors, 'pass buffer privacy protections are incomplete')
endif
if get(b:, 'ale_enabled', 1) || get(b:, 'ale_linters', 'missing') !=# []
  call add(s:errors, 'pass buffer did not disable automatic ALE processing')
endif
if get(get(b:, 'gitgutter', {}), 'enabled', -1) != 0
  call add(s:errors, 'pass buffer did not disable automatic GitGutter processing')
endif
execute 'source ' . fnameescape($VIM_CHECK_ROOT . '/home/.vimrc')
if &l:swapfile || &l:undofile || &backup || &writebackup || !empty(&viminfo)
  call add(s:errors, 'vimrc reload weakened pass buffer protection')
endif
if !empty(s:errors)
  call writefile(s:errors, $VIM_CHECK_ERRORS, 'a')
  cquit 1
endif
qa!
VIM

run_vim() {
  HOME="$CHECK_HOME" \
    XDG_DATA_HOME="$CHECK_DATA" \
    XDG_STATE_HOME="$CHECK_STATE" \
    VIM_CHECK_ERRORS="$ERRORS" \
    VIM_CHECK_ROOT="$CHECK_ROOT" \
    vim -Nu "$CHECK_HOME/.vimrc" -i NONE -n -es "$@" >>"$VIM_LOG" 2>&1
}

if ! run_vim -S "$CHECK_ROOT/smoke.vim" +qa!; then
  cat -- "$VIM_LOG" >&2
  fail
fi

if ! run_vim "$PASS_FILE" -S "$CHECK_ROOT/redact.vim" +qa!; then
  cat -- "$VIM_LOG" >&2
  fail
fi

[[ ! -s "$ERRORS" ]] || fail
