#!/usr/bin/env bash
#
# Purpose: Exercise the stable behavior of the managed Vim configuration.

set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly REPO_ROOT
CHECK_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/vim-check.XXXXXX")"
readonly CHECK_ROOT
readonly CHECK_HOME="$CHECK_ROOT/home"
readonly CHECK_DATA="$CHECK_ROOT/data"
readonly CHECK_STATE="$CHECK_ROOT/state"
readonly CHECK_BIN="$CHECK_ROOT/bin"
readonly ERRORS="$CHECK_ROOT/errors"
readonly VIM_LOG="$CHECK_ROOT/vim.log"
PASS_ROOT="$(mktemp -d /tmp/pass.XXXXXX)"
readonly PASS_ROOT
readonly PASS_FILE="$PASS_ROOT/password.txt"
ALE_SOURCE="${XDG_DATA_HOME:-$HOME/.local/share}/vim/plugged/ale"
GITGUTTER_SOURCE="${XDG_DATA_HOME:-$HOME/.local/share}/vim/plugged/vim-gitgutter"

cleanup() {
  rm -rf -- "$CHECK_ROOT"
  rm -rf -- "$PASS_ROOT"
}

trap cleanup EXIT

fail() {
  printf '[ERROR] Vim regression checks failed:\n' >&2
  cat -- "$ERRORS" >&2
  exit 1
}

command -v vim >/dev/null 2>&1 || {
  printf '[SKIP] Vim regression checks (vim is unavailable)\n'
  exit 0
}

if command -v rg >/dev/null 2>&1; then
  check_rg=1
else
  check_rg=0
fi

case "$(uname -s)" in
  Darwin) platform=macos ;;
  Linux) platform=ubuntu ;;
  *)
    printf '[SKIP] Vim regression checks (unsupported platform)\n'
    exit 0
    ;;
esac

mkdir -p "$CHECK_HOME" "$CHECK_DATA/vim/plugged" "$CHECK_STATE" "$CHECK_BIN"
"$REPO_ROOT/install.sh" install --platform "$platform" --target "$CHECK_HOME" \
  --no-font vim >/dev/null

if [[ -d "$ALE_SOURCE" ]]; then
  ln -s "$ALE_SOURCE" "$CHECK_DATA/vim/plugged/ale"
  check_ale=1
else
  mkdir -p "$CHECK_DATA/vim/plugged/ale"
  check_ale=0
fi

if [[ -d "$GITGUTTER_SOURCE" ]]; then
  ln -s "$GITGUTTER_SOURCE" "$CHECK_DATA/vim/plugged/vim-gitgutter"
  check_gitgutter=1
else
  mkdir -p "$CHECK_DATA/vim/plugged/vim-gitgutter"
  check_gitgutter=0
fi

repo="$CHECK_ROOT/project"
mkdir -p "$repo/.git" "$repo/sub" "$repo/scripts" "$repo/Achiever" \
  "$repo/.github/workflows" "$repo/node_modules/.bin" "$CHECK_ROOT/no-tags" \
  "$CHECK_ROOT/project-b/.git"
touch "$repo/.yamlfmt" "$repo/sub/.yamlfmt.yml" "$repo/.yamllint" \
  "$repo/.hadolint.yaml" "$repo/checkmake.ini"
printf 'foo\nfoobar\nmy_foo\n' >"$repo/words.txt"
printf 'hidden_probe\n' >"$repo/.github/workflows/check.yml"
printf 'hidden_probe\n' >"$repo/.git/config"
printf 'key: value\n' >"$repo/sub/file.yaml"
printf 'key: queued\n' >"$repo/queued.yaml"
printf '{"key": true}\n' >"$repo/data.json"
printf '#!/bin/sh\necho ok\n' >"$repo/scripts/example.sh"
printf 'FROM scratch\n' >"$repo/Dockerfile"
printf 'all:\n\t@true\n' >"$repo/Makefile"
printf 'resource "null_resource" "example" {}\n' >"$repo/main.tf"
printf 'int Probe(void) { return 1; }\n' >"$repo/probe.c"
printf 'int main(void) { return Probe(); }\n' >"$repo/sub/main.c"
printf 'Probe\tprobe.c\t/^int Probe(void)/;"\tf\n' >"$repo/tags"
printf 'int main(void) { return 0; }\n' >"$CHECK_ROOT/no-tags/main.c"
printf 'prefix noesis_probe suffix\n' >"$repo/plain.noe"
printf 'prefix noesis_probe secret\n' >"$repo/secret.gpg.noe"
printf 'prefix noesis_probe git-private\n' >"$repo/.git/private.noe"
printf '##  Voca\n' >"$repo/english.noe"
printf '##  Voca\n' >"$repo/french.noe"
printf '%s\n' '- task' >"$repo/Achiever/todos.noe"
printf 'notes\n' >"$repo/notes.noe"
printf 'temporary password\n' >"$PASS_FILE"
printf 'key: other\n' >"$CHECK_ROOT/project-b/file.yaml"
mkdir -p "$CHECK_ROOT/write%s"
gitgutter_repo="$CHECK_ROOT/gitgutter-repository"
git -C "$CHECK_ROOT" init -q "${gitgutter_repo##*/}"
printf 'tracked\n' >"$gitgutter_repo/tracked.txt"
git -C "$gitgutter_repo" add tracked.txt
git -C "$gitgutter_repo" -c user.name='Vim Check' \
  -c user.email='vim-check@example.invalid' -c commit.gpgsign=false \
  commit -qm initial
awk 'BEGIN { for (line = 1; line <= 120; line++) print "line " line }' \
  >"$CHECK_ROOT/reload.txt"

outer_repo="$CHECK_ROOT/outer-repository"
git -C "$CHECK_ROOT" init -q "${outer_repo##*/}"
git -C "$outer_repo" -c user.name='Vim Check' \
  -c user.email='vim-check@example.invalid' -c commit.gpgsign=false \
  commit --allow-empty -qm initial
touch "$outer_repo/.yamlfmt"
git -C "$outer_repo" worktree add -qb vim-check-worktree \
  "$outer_repo/worktree" >/dev/null
printf 'key: worktree\n' >"$outer_repo/worktree/file.yaml"

hostile_make="$CHECK_ROOT/make\$(true) with 'quote' \"double\" \`true\`"
mkdir -p "$hostile_make/.git"
touch "$hostile_make/checkmake.ini"
printf 'all:\n\t@true\n' >"$hostile_make/Makefile"

hostile_ale="$CHECK_ROOT/ale%s/\$(printf ALE-EXPANDED)"
mkdir -p "$hostile_ale/.git"
touch "$hostile_ale/.yamllint" "$hostile_ale/.yamlfmt" \
  "$hostile_ale/.hadolint.yaml"
printf 'key: hostile\n' >"$hostile_ale/file.yaml"
printf 'FROM scratch\n' >"$hostile_ale/Dockerfile"

printf '#!/bin/sh\nprintf "%%s\\n" "$@" >"$VIM_CHECK_ROOT/yamlfmt.argv"\ncat\n' \
  >"$CHECK_BIN/yamlfmt"
for tool in shellcheck yamllint jsonlint hadolint tflint checkmake; do
  cat >"$CHECK_BIN/$tool" <<'TOOL'
#!/bin/sh
tool=${0##*/}
{
  pwd
  printf '%s\n' "$@"
} >"$VIM_CHECK_ROOT/$tool.argv"
cat >/dev/null
TOOL
done
cat >"$CHECK_BIN/yamllint" <<'TOOL'
#!/bin/sh
{
  pwd
  printf '%s\n' "$@"
} >"$VIM_CHECK_ROOT/yamllint.argv"
for argument do
  case "$argument" in
    *.yaml | *.yml)
      [ ! -f "$argument" ] || cp -- "$argument" "$VIM_CHECK_ROOT/yamllint.input"
      ;;
  esac
done
cat >/dev/null
TOOL
cat >"$repo/node_modules/.bin/jsonlint" <<'TOOL'
#!/bin/sh
printf 'project executable ran\n' >"$VIM_CHECK_ROOT/project-jsonlint.marker"
cat >/dev/null
TOOL
cat >"$CHECK_BIN/trans" <<'TOOL'
#!/bin/sh
printf '%s\n' "$@" >"$VIM_CHECK_ROOT/trans.argv"
cat >"$VIM_CHECK_ROOT/trans.stdin"
printf 'translated\n'
TOOL
cat >"$CHECK_BIN/synonym" <<'TOOL'
#!/bin/sh
printf '%s' "$1" >"$VIM_CHECK_ROOT/synonym.argv"
TOOL
cat >"$CHECK_BIN/sudo" <<'TOOL'
#!/bin/sh
printf '%s\n' "$@" >"$VIM_CHECK_ROOT/sudo.argv"
[ "$1" = tee ] && [ "$2" = -- ] && [ -n "$3" ] || exit 1
cat >"$3"
TOOL
chmod +x "$CHECK_BIN"/*
chmod +x "$repo/node_modules/.bin/jsonlint"

cat >"$CHECK_ROOT/check.vim" <<'VIM'
set nomore
let s:errors = []
let s:root = $VIM_CHECK_ROOT
let s:repo = s:root . '/project'

function! s:Check(condition, message) abort
  if !a:condition
    call add(s:errors, a:message)
  endif
endfunction

function! s:Equal(expected, actual, message) abort
  call s:Check(a:expected ==# a:actual,
        \ a:message . ': expected ' . string(a:expected)
        \ . ', got ' . string(a:actual))
endfunction

function! s:WaitFor(path) abort
  for l:attempt in range(100)
    if filereadable(a:path)
      return 1
    endif
    sleep 10m
  endfor
  return 0
endfunction

function! s:Keys(keys) abort
  call feedkeys(a:keys, 'mtx')
endfunction

function! s:CheckPluginPin(name, source) abort
  let l:declaration = get(get(g:, 'plugs', {}), a:name, {})
  let l:expected = get(l:declaration, 'commit', '')
  let l:actual = systemlist('git -C ' . shellescape(a:source) . ' rev-parse HEAD')
  call s:Check(!empty(l:expected), a:name . ' has no declared commit pin')
  call s:Check(v:shell_error == 0 && len(l:actual) == 1,
        \ a:name . ' installed commit could not be read')
  if v:shell_error == 0 && len(l:actual) == 1
    call s:Equal(l:expected, l:actual[0], a:name . ' is not at its declared pin')
  endif
endfunction

if $VIM_CHECK_ALE ==# '1'
  call s:CheckPluginPin('ale', $VIM_CHECK_ALE_SOURCE)
endif
if $VIM_CHECK_GITGUTTER ==# '1'
  call s:CheckPluginPin('vim-gitgutter', $VIM_CHECK_GITGUTTER_SOURCE)
endif

" Systemd uses only Vim's runtime and must not pull ALE into the buffer.
enew
setfiletype systemd
call s:Check(exists('b:current_syntax'), 'systemd runtime syntax is unavailable')
call s:Check(!has_key(g:ale_linters, 'systemd'), 'systemd remains in the ALE matrix')
call s:Check(&ttimeout && &ttimeoutlen == 100,
      \ 'terminal key timeout is not enabled at 100 ms')
if !has('clipboard')
  call s:Check(empty(maparg('<Space>p', 'n')),
        \ '<Space>p exists without clipboard support')
  let s:saved_path = $PATH
  let $PATH = s:root . '/bin'
  let s:clipboard_failed_cleanly = 0
  try
    call s:Keys(' y')
  catch /No clipboard provider available/
    let s:clipboard_failed_cleanly = 1
  finally
    let $PATH = s:saved_path
  endtry
  call s:Check(s:clipboard_failed_cleanly,
        \ '<Leader>y did not explain the missing clipboard provider')
endif

" The global header mapping refuses buffers without a comment template.
enew
setfiletype noesis
let s:header_guarded = 0
try
  call s:Keys(' H')
catch /No commentstring defined for this buffer/
  let s:header_guarded = 1
endtry
call s:Check(s:header_guarded, '<Leader>H accepted an empty commentstring')

" ROT13 preserves the local spell setting and window view.
enew
call setline(1, ['alpha', 'beta', 'gamma'])
setlocal spell
normal! G$
let s:rot13_view = winsaveview()
call s:Keys(' ?')
call s:Check(&l:spell, '<Leader>? did not restore spell')
call s:Equal(s:rot13_view, winsaveview(), '<Leader>? did not restore the view')
call s:Keys(' ?')
call s:Equal(['alpha', 'beta', 'gamma'], getline(1, '$'),
      \ '<Leader>? changed its visible ROT13 behavior')
setlocal nomodified

" mso exercises the real mapping path and restores its view after re-sourcing.
execute 'edit ' . fnameescape(s:root . '/reload.txt')
normal! 80Gzt
let s:reload_view = winsaveview()
let v:errmsg = ''
call s:Keys('mso')
call s:Equal('', v:errmsg, 'mso raised an error while re-sourcing the config')
call s:Equal(s:reload_view, winsaveview(), 'mso did not restore the view')
call s:Check(!exists('w:vim_reload_view'), 'mso left transient window state')

" Window maximize mappings contain only window commands, including in a terminal.
for [s:mode, s:mapping] in [['n', ' wM'], ['n', ' wX'],
      \ ['t', ' wM'], ['t', ' wX']]
  call s:Check(stridx(maparg(s:mapping, s:mode), '\|') < 0,
        \ s:mode . ' ' . s:mapping . ' still contains a literal pipe key')
endfor
if exists('*term_start')
  let s:terminal_capture = s:root . '/terminal-window-mapping.input'
  enew!
  let s:terminal_buffer = term_start(['/bin/sh', '-c',
        \ 'IFS= read -r line; printf "%s\n" "$line" >"$1"',
        \ 'vim-window-mapping', s:terminal_capture],
        \ {'curwin': 1, 'term_finish': 'open'})
  call feedkeys(" wMterminal-probe\<CR>", 'xt')
  call term_wait(s:terminal_buffer, 1000)
  call s:Check(s:WaitFor(s:terminal_capture),
        \ 'terminal wM probe did not reach its job')
  if filereadable(s:terminal_capture)
    call s:Equal(['terminal-probe'], readfile(s:terminal_capture),
          \ 'terminal wM sent a non-window key to its job')
  endif
  execute 'silent! bwipeout! ' . s:terminal_buffer
endif

" ToggleNavigation preserves complete pre-existing normal-mode mappings.
nnoremap <silent><nowait> gn :let g:navigation_test = 1<CR>
nnoremap <expr> gp 'k'
let s:saved_gn = maparg('gn', 'n', 0, 1)
let s:saved_gp = maparg('gp', 'n', 0, 1)
call s:Keys('glbn')
call s:Keys('glbn')
call s:Equal(s:saved_gn, maparg('gn', 'n', 0, 1),
      \ 'ToggleNavigation did not restore gn')
call s:Equal(s:saved_gp, maparg('gp', 'n', 0, 1),
      \ 'ToggleNavigation did not restore gp')
silent! nunmap gn
silent! nunmap gp

" Syntax inspection handles both an absent and a resolved syntax group.
syntax off
let s:syntax_mapping = maparg('glsy', 'n', 0, 1)
let s:show_syntax = '<SNR>' . s:syntax_mapping.sid . '_ShowSyntax'
call s:Check(execute('call ' . s:show_syntax . '()') =~# 'No syntax group',
      \ 'ShowSyntax did not handle an absent syntax group')
syntax on
setfiletype c
setlocal syntax=c
call setline(1, 'int value;')
normal! gg0
call s:Check(execute('call ' . s:show_syntax . '()') =~# 'cType',
      \ 'ShowSyntax did not report a resolved syntax group')
setlocal nomodified

" Native tags work when present and a missing tags file does not break editing.
execute 'edit ' . fnameescape(s:repo . '/sub/main.c')
call search('Probe')
call s:Keys("\<C-]>")
call s:Equal(resolve(s:repo . '/probe.c'), resolve(expand('%:p')),
      \ 'CTRL-] selected the wrong tag')
call s:Keys("\<C-T>")
call s:Equal(resolve(s:repo . '/sub/main.c'), resolve(expand('%:p')),
      \ 'CTRL-T did not return from a tag')
call search('Probe')
call s:Keys("g]1\<CR>")
call s:Equal(resolve(s:repo . '/probe.c'), resolve(expand('%:p')),
      \ 'g] selected the wrong tag')
execute 'edit ' . fnameescape(s:repo . '/sub/main.c')
tag Probe
call s:Equal(resolve(s:repo . '/probe.c'), resolve(expand('%:p')),
      \ ':tag selected the wrong file')
execute 'edit ' . fnameescape(s:repo . '/sub/main.c')
let s:tselect_output = execute('tselect Probe')
call s:Check(s:tselect_output =~# 'Probe' && s:tselect_output =~# 'probe.c',
      \ ':tselect did not list the expected candidate')
execute 'edit ' . fnameescape(s:root . '/no-tags/main.c')
silent! tag MissingTag
call setline(1, 'still usable')
call s:Equal('still usable', getline(1), 'a missing tags file broke editing')
setlocal nomodified

if $VIM_CHECK_RG ==# '1'
  " sgr is a whole-word project search: foo matches neither foobar nor my_foo.
  execute 'lcd ' . fnameescape(s:repo)
  execute 'edit ' . fnameescape(s:repo . '/words.txt')
  normal! gg0
  normal sgr
  let s:references = getqflist()
  call s:Equal(1, len(s:references), 'sgr returned non-word matches')
  if len(s:references) == 1
    call s:Equal(1, s:references[0].lnum, 'sgr returned the wrong line')
    call s:Equal(1, s:references[0].col, 'sgr returned the wrong column')
  endif
  cclose
  call s:Equal(':grep ', maparg('sg', 'n'), 'sg is not a free-form grep mapping')
  silent grep! foo
  call s:Check(!empty(getqflist()), 'free-form ripgrep did not populate quickfix')
  cclose
  silent grep! hidden_probe
  let s:hidden_results = getqflist()
  call s:Equal(1, len(s:hidden_results), 'ripgrep did not search hidden project files')
  if len(s:hidden_results) == 1
    call s:Check(bufname(s:hidden_results[0].bufnr) =~# '\.github/workflows/check\.yml$',
          \ 'ripgrep returned the wrong hidden file')
  endif
  cclose
endif

" :W crosses both Ex and shell parsing without reinterpreting the filename.
let s:privileged_path = s:root . '/write%s/$(printf W-EXPANDED).txt'
execute 'edit ' . fnameescape(s:privileged_path)
call setline(1, 'privileged contents')
W
call s:Equal(['tee', '--', s:privileged_path], readfile(s:root . '/sudo.argv'),
      \ ':W changed its filename while crossing Ex and shell parsing')
call s:Equal(['privileged contents'], readfile(s:privileged_path),
      \ ':W wrote the wrong privileged contents')

let g:noesis_root = s:repo
execute 'edit ' . fnameescape(s:repo . '/plain.noe')
setfiletype noesis
if $VIM_CHECK_RG ==# '1'
  " Noesis grep searches plaintext notes and excludes encrypted notes.
  let s:saved_grepprg = &grepprg
  set grepprg=false
  execute 'lcd ' . fnameescape(s:root)
  silent Grep noesis_probe
  let &grepprg = s:saved_grepprg
  let s:noesis_results = getqflist()
  call s:Equal(1, len(s:noesis_results),
        \ 'Noesis Grep included an encrypted or .git note from outside its root')
  if len(s:noesis_results) == 1
    call s:Check(bufname(s:noesis_results[0].bufnr) =~# 'plain\.noe$',
          \ 'Noesis Grep returned the wrong file')
    call s:Equal(1, s:noesis_results[0].lnum, 'Noesis Grep returned the wrong line')
    call s:Equal(8, s:noesis_results[0].col, 'Noesis Grep returned the wrong column')
  endif
  cclose
  execute 'lcd ' . fnameescape(s:repo)
  silent Grep noesis_probe
  call s:Equal(1, len(getqflist()),
        \ 'Noesis Grep included an encrypted or .git note inside its root')
  cclose
endif

" Noesis mappings and commands remain wired to live operations.
let s:noesis_normal_targets = {
      \ 'ghX': 'noesis#export_html()',
      \ 'ghI': 'noesis#index()',
      \ 'ghi': 'noesis#index_jump()',
      \ 'ghlen': 'noesis#translate(',
      \ 'ghlfr': 'noesis#translate(',
      \ 'ghh1': '80i=',
      \ 'ghh2': '40i-',
      \ 'ghts': 'strftime(',
      \ }
for [s:mapping, s:target] in items(s:noesis_normal_targets)
  let s:definition = maparg(s:mapping, 'n', 0, 1)
  call s:Check(get(s:definition, 'buffer', 0), 'Noesis mapping is missing: ' . s:mapping)
  call s:Check(get(s:definition, 'rhs', '') =~# '\V' . escape(s:target, '\'),
        \ 'Noesis mapping has a dead target: ' . s:mapping)
endfor
call s:Check(empty(maparg('gh?', 'n')), 'obsolete Noesis mini-help still exists')
call s:Check(get(maparg('ghsy', 'x', 0, 1), 'rhs', '') =~# 'noesis#synonym(',
      \ 'Noesis synonym mapping has the wrong target')
for s:command in ['Fr', 'En', 'Au', 'Sy', 'Grep']
  call s:Check(exists(':' . s:command) == 2, 'Noesis command is missing: ' . s:command)
endfor
for s:mapping in ['sne', 'snf', 'snt', 'snh', 'snj', 'snn']
  let s:definition = maparg(s:mapping, 'n', 0, 1)
  let s:function = '<SNR>' . get(s:definition, 'sid', 0) . '_'
        \ . (s:mapping ==# 'snt' ? 'OpenTasks' : 'Open')
  call s:Check(get(s:definition, 'rhs', '') =~# '<SID>Open'
        \ && exists('*' . s:function),
        \ 'Noesis navigation target is wrong: ' . s:mapping)
endfor
for [s:mapping, s:path] in [
      \ ['sne', 'english.noe'],
      \ ['snf', 'french.noe'],
      \ ['snt', 'Achiever/todos.noe'],
      \ ['snh', '.todos.gpg.noe'],
      \ ['snj', 'journal.gpg.noe'],
      \ ['snn', 'notes.noe'],
      \ ]
  call s:Keys(s:mapping)
  call s:Equal(resolve(s:repo . '/' . s:path), resolve(expand('%:p')),
        \ 'Noesis navigation opened the wrong file for ' . s:mapping)
endfor
execute 'edit ' . fnameescape(s:repo . '/plain.noe')

" Cleanup uses the leader captured when the Noesis ftplugin initialized.
let s:saved_local_leader = maplocalleader
let maplocalleader = 'zz'
let v:errmsg = ''
let &l:filetype = 'text'
call s:Check(empty(maparg('ghX', 'n')), 'Noesis left its original leader mapping')
call s:Check(exists(':Grep') != 2, 'Noesis left its buffer-local command')
call s:Check(!exists('b:did_noesis_ftplugin') && !exists('b:noesis_local_leader'),
      \ 'Noesis left buffer-local ftplugin state')
call s:Equal('', v:errmsg, 'Noesis cleanup raised an error after leader change')
let maplocalleader = s:saved_local_leader
let &l:filetype = 'noesis'

" Exercise the safe editing operations rather than accepting maparg alone.
call setline(1, ['First heading', repeat('=', 80), '', 'Second heading', repeat('-', 40)])
call s:Keys('ghI')
call s:Check(getline(1) ==# 'INDEX', 'ghI did not rebuild the index')
call cursor(4, 1)
call s:Keys('ghi')
call s:Equal('First heading', getline('.'), 'ghi did not jump from the index')
call setline(1, 'heading one')
call cursor(1, 1)
call s:Keys('ghh1')
call s:Check(getline(2) ==# repeat('=', 80), 'ghh1 did not add an underline')
call s:Keys('ghh2')
call s:Check(getline(3) ==# repeat('-', 40), 'ghh2 did not add an underline')
call s:Keys('ghts')
call s:Check(getline(4) =~# '^\a\{3} \d\{2} \a\{3} \d\{4} at \d\d:\d\d$',
      \ 'ghts did not insert a timestamp')
" Translation input remains data through commands and normal/visual mappings.
unlet! g:noesis_translation_executed
En hello | let g:noesis_translation_executed = 1
call s:Check(!exists('g:noesis_translation_executed'),
      \ ':En executed note text as an Ex command')
call s:Equal(['hello | let g:noesis_translation_executed = 1'],
      \ readfile(s:root . '/trans.stdin'), ':En changed literal command text')
call s:Equal(['-from', 'fr', '-to', 'en', '-brief'],
      \ readfile(s:root . '/trans.argv'), ':En constructed the wrong trans argv')
call setline(1, '100% # ''single'' "double" | let g:noesis_translation_executed = 1')
normal! gg0
call s:Keys('ghlen')
call s:Check(!exists('g:noesis_translation_executed'),
      \ 'ghlen executed note text as an Ex command')
call s:Equal(['100% # ''single'' "double" | let g:noesis_translation_executed = 1'],
      \ readfile(s:root . '/trans.stdin'), 'ghlen changed literal note text')

" Reading a visual selection preserves register 0 and the unnamed reference.
call setline(1, 'alpha beta')
normal! gg0ve
execute "normal! \<Esc>"
call setreg('0', 'previous numbered yank')
normal! "ayy
let s:yank_register = getreginfo('0')
let s:unnamed_register = getreginfo('"')
call s:Equal('alpha', noesis#visual_text(),
      \ 'Noesis returned the wrong visual selection')
call s:Equal(s:yank_register, getreginfo('0'),
      \ 'Noesis changed register 0 while reading a selection')
call s:Equal(s:unnamed_register, getreginfo('"'),
      \ 'Noesis changed the unnamed register while reading a selection')

call setline(1, ['first line | % #', 'second ''line'' "quoted"'])
normal! ggVj
call s:Keys('ghlfr')
call s:Equal(['first line | % #', 'second ''line'' "quoted"'],
      \ readfile(s:root . '/trans.stdin'), 'visual translation changed multiline text')
call s:Equal(['-from', 'en', '-to', 'fr', '-brief'],
      \ readfile(s:root . '/trans.argv'), 'ghlfr constructed the wrong trans argv')
call setline(1, ['first line | % #', 'second ''line'' "quoted"'])
call deletebufline('%', 3, '$')
normal! ggVj
call s:Keys('ghsy')
call s:Equal(['first line | % #', 'second ''line'' "quoted"'],
      \ readfile(s:root . '/synonym.argv'), 'visual synonym input changed')
Au audio | % # ' "
call s:Equal(['audio | % # '' "'], readfile(s:root . '/trans.stdin'),
      \ ':Au changed literal input')
call s:Equal(['-from', 'fr', '-to', 'en', '-brief', '-play'],
      \ readfile(s:root . '/trans.argv'), ':Au constructed the wrong trans argv')
set background=light
doautocmd ColorScheme
call s:Check(synIDattr(hlID('noesisTag'), 'fg', 'cterm') ==# '125',
      \ 'Noesis tag highlight is missing in light mode')
set background=dark
doautocmd ColorScheme
call setline(1, ['Export heading', repeat('=', 80)])
call cursor(1, 1)
call s:Keys('ghX')
call s:Equal('html', &l:filetype, 'ghX did not create an HTML buffer')
call s:Check(getline(1) =~# '<!DOCTYPE html>', 'ghX produced invalid HTML')
bwipeout!

" HTML export fails closed before TOhtml creates a persistent plaintext buffer.
execute 'edit! ' . fnameescape(s:root . '/sensitive-export.noe')
call setline(1, 'sensitive export probe')
let b:vim_sensitive_buffer = 1
let s:export_buffer = bufnr('')
let s:export_refused = 0
try
  call noesis#export_html()
catch /Noesis: refusing to export a sensitive buffer/
  let s:export_refused = 1
endtry
call s:Check(s:export_refused, 'Noesis accepted a sensitive HTML export')
call s:Equal(s:export_buffer, bufnr(''),
      \ 'a refused Noesis export changed buffers')
call s:Check(bufnr(s:root . '/sensitive-export.noe.html') < 0,
      \ 'a refused Noesis export created a derived plaintext buffer')
bwipeout!

" Achiever owns six task mappings and two buffer-local abbreviations.
let s:achiever_targets = {
      \ 'ghk': 'achiever#task_check()',
      \ 'ghc': 'achiever#task_clear()',
      \ 'ghF': 'achiever#task_fix("time_end")',
      \ 'ghf': 'achiever#task_fix("time_beg")',
      \ 'ghd': 'achiever#task_duration(getline("."))',
      \ 'ghx': 'achiever#task_detail_toggle_view("--")',
      \ }
function! s:CheckAchieverBindings(filetype) abort
  enew!
  execute 'setfiletype ' . a:filetype
  call s:Equal(a:filetype, &l:filetype, 'Achiever filetype changed unexpectedly')
  for [l:mapping, l:target] in items(s:achiever_targets)
    let l:definition = maparg(l:mapping, 'n', 0, 1)
    call s:Check(get(l:definition, 'buffer', 0),
          \ a:filetype . ': missing ' . l:mapping)
    call s:Check(get(l:definition, 'rhs', '') =~# '\V' . escape(l:target, '\'),
          \ a:filetype . ': wrong target for ' . l:mapping)
  endfor
  call s:Check(execute('verbose nmap ghd') =~# 'ftplugin/achiever.vim',
        \ a:filetype . ': ghd was not loaded by the Achiever ftplugin')
  call s:Check(empty(maparg('gha', 'n')), a:filetype . ': obsolete gha exists')
  call s:Check(get(maparg('wwo', 'i', 1, 1), 'buffer', 0),
        \ a:filetype . ': wwo abbreviation is missing')
  call s:Check(get(maparg('lli', 'i', 1, 1), 'buffer', 0),
        \ a:filetype . ': lli abbreviation is missing')
endfunction

for s:filetype in ['achiever', 'noesis.achiever', 'markdown.achiever']
  call s:CheckAchieverBindings(s:filetype)
endfor

" Exercise every task operation through its mapping.
call setline(1, '- task')
call s:Keys('ghk')
call s:Check(getline(1) =~# '^- \d\{6} \d\d:\d\d task$', 'ghk did not check a task')
call s:Keys('ghc')
call s:Equal('- task', getline(1), 'ghc did not clear a task')
call setline(1, 'note - 260908 10:00 secret')
call s:Keys('ghc')
call s:Equal('note - 260908 10:00 secret', getline(1),
      \ 'ghc changed a non-task containing an embedded timestamp')
for s:description in ['@call Alice', '#infra migration', '[home] something',
      \ '42 things', '→ investigate this']
  call setline(1, '- ' . s:description)
  call s:Keys('ghk')
  let s:task_line = getline(1)
  call s:Check(s:task_line =~# '^- \d\{6} \d\d:\d\d \S'
        \ && strpart(s:task_line, strlen(s:task_line) - strlen(s:description))
        \ ==# s:description,
        \ 'ghk rejected a general task description: ' . s:description)
endfor
call setline(1, '  - legacy subtask')
call s:Keys('ghk')
call s:Equal('  - legacy subtask', getline(1),
      \ 'ghk still implements the removed subtask grammar')
call setline(1, ['- 260101 09:00 10:00 first', '- 260101 11:00 12:00 second'])
1
call s:Keys('ghf')
call s:Check(getline(1) =~# '260101 12:00 10:00', 'ghf did not repair the start time')
call setline(1, ['- 260101 09:00 10:00 first', '- 260101 11:00 12:00 second'])
2
call s:Keys('ghF')
call s:Check(getline(2) =~# '260101 11:00 09:00', 'ghF did not repair the end time')
call cursor(1, 1)
let s:no_sibling = execute('call achiever#task_fix("time_end")')
call s:Check(s:no_sibling =~# 'No sibling task found',
      \ 'task_fix reports the wrong missing-sibling message')
1
unlet! b:achiever_total_difference_seconds
call setline(1, 'meeting 10:00 11:00 tomorrow')
let s:non_task_duration = execute('call achiever#task_duration(getline("."))')
call s:Check(s:non_task_duration =~# 'No time range found',
      \ 'task_duration accepted a time range outside a canonical task')
call s:Check(!exists('b:achiever_total_difference_seconds'),
      \ 'an invalid duration initialized Achiever state')
call setline(1, '- 260101 09:00 10:30 duration')
call s:Keys('ghd')
let s:duration_output = execute('call achiever#task_duration(getline("."))')
call s:Check(s:duration_output =~# 'All durations: 03:00',
      \ 'ghd or direct duration accumulation is broken')
call s:Equal(3 * 60 * 60, b:achiever_total_difference_seconds,
      \ 'duration accumulation is not buffer-local')
call setline(1, '- 260101 23:30 00:15 overnight')
let s:overnight_duration = execute('call achiever#task_duration(getline("."))')
call s:Check(s:overnight_duration =~# 'This duration: 00:45',
      \ 'task_duration rejected a valid overnight duration')
call s:Equal(3 * 60 * 60 + 45 * 60, b:achiever_total_difference_seconds,
      \ 'overnight duration was accumulated incorrectly')
let s:duration_before_invalid = b:achiever_total_difference_seconds
for s:invalid_task in ['- 260101 24:00 invalid hour',
      \ '- 260101 12:60 invalid minute',
      \ '- 260101 99:99 00:00 invalid range',
      \ '- 260101 23:59 24:00 invalid end']
  call setline(1, s:invalid_task)
  call s:Keys('ghk')
  call s:Equal(s:invalid_task, getline(1),
        \ 'ghk rewrote invalid timestamp metadata')
  call s:Keys('ghc')
  call s:Equal(s:invalid_task, getline(1),
        \ 'ghc cleared invalid timestamp metadata')
  let s:invalid_duration = execute('call achiever#task_duration(getline("."))')
  call s:Check(s:invalid_duration =~# 'Invalid time range',
        \ 'task_duration accepted invalid timestamp metadata')
  call s:Equal(s:duration_before_invalid, b:achiever_total_difference_seconds,
        \ 'an invalid duration changed the accumulator')
endfor
call setline(1, ['- 260101 23:00 valid sibling',
      \ '- 260101 23:30 24:00 invalid destination'])
call deletebufline('%', 3, '$')
2
call s:Keys('ghF')
call s:Equal('- 260101 23:30 24:00 invalid destination', getline(2),
      \ 'task_fix rewrote invalid timestamp metadata')
call deletebufline('%', 2, '$')
call cursor(1, 1)
call setline(1, '- 260101 23:59 valid boundary')
call s:Keys('ghk')
call s:Check(getline(1) =~# '^- 260101 23:59 [0-2]\d:[0-5]\d valid boundary$',
      \ 'ghk rejected the valid 23:59 boundary')
setlocal syntax=achiever
call setline(1, '- 260101 23:59 valid syntax')
syntax sync fromstart
call s:Equal('achieverTaskTimestamp', synIDattr(synID(1, 3, 1), 'name'),
      \ 'Achiever syntax did not recognize a valid timestamp')
call setline(1, '- 260101 24:00 invalid syntax')
syntax sync fromstart
call s:Check(synIDattr(synID(1, 3, 1), 'name') !=# 'achieverTaskTimestamp',
      \ 'Achiever syntax highlighted an invalid timestamp')
call setline(1, '- 260101 23:59 24:00 invalid end syntax')
syntax sync fromstart
call s:Check(synIDattr(synID(1, 3, 1), 'name') !=# 'achieverTaskTimestamp',
      \ 'Achiever syntax highlighted a timestamp with an invalid end time')
call setline(1, '- work: task -- first -- second')
call s:Keys('ghx')
call s:Check(getline(2) =~# '^  -- second$',
      \ 'ghx did not expand task details')
call setline(1, '')
call cursor(1, 1)
call s:Keys("Awwo \<Esc>")
call s:Equal('- work: ', getline(1), 'wwo did not expand')
call setline(1, '')
call cursor(1, 1)
call s:Keys("Alli \<Esc>")
call s:Equal('- life: ', getline(1), 'lli did not expand')

" Native ftplugin undo removes and restores compound components cleanly.
let v:errmsg = ''
let &l:filetype = 'noesis.achiever'
let &l:filetype = 'noesis'
call s:Check(empty(maparg('ghd', 'n')), 'Achiever mapping leaked into Noesis')
call s:Check(empty(maparg('wwo', 'i', 1)), 'Achiever abbreviation leaked into Noesis')
call s:Check(get(maparg('ghX', 'n', 0, 1), 'buffer', 0),
      \ 'Noesis mapping disappeared with the Achiever component')
let &l:filetype = 'noesis.achiever'
call s:Check(get(maparg('ghd', 'n', 0, 1), 'buffer', 0),
      \ 'Achiever mapping did not return in noesis.achiever')
let &l:filetype = 'text'
call s:Check(!exists('b:did_noesis_ftplugin'), 'Noesis state leaked into text')
call s:Check(!exists('b:did_achiever_ftplugin'), 'Achiever state leaked into text')
call s:Check(!exists('b:achiever_total_difference_seconds'),
      \ 'Achiever duration state leaked after ftplugin undo')
call s:Check(!exists('b:achiever_local_leader'),
      \ 'Achiever leader state leaked after ftplugin undo')
call s:Check(empty(maparg('ghX', 'n')), 'Noesis mapping leaked into text')
let &l:filetype = 'markdown.achiever'
let &l:filetype = 'markdown'
call s:Check(empty(maparg('ghd', 'n')), 'Achiever mapping leaked into Markdown')
let &l:filetype = 'markdown.achiever'
call s:Check(get(maparg('ghd', 'n', 0, 1), 'buffer', 0),
      \ 'Achiever mapping did not return in markdown.achiever')
let &l:filetype = 'noesis'
call s:Check(get(maparg('ghX', 'n', 0, 1), 'buffer', 0),
      \ 'Noesis mapping did not return after reactivation')
call s:Equal('', v:errmsg, 'an Achiever filetype transition raised an error')

" Disabling every optional mapping is a valid Achiever configuration.
let s:saved_achiever_mappings = g:achiever_mappings
let g:achiever_mappings = {}
enew!
let v:errmsg = ''
setfiletype achiever
call s:Equal('', v:errmsg, 'empty Achiever mappings raised an error')
let &l:filetype = 'text'
let g:achiever_mappings = s:saved_achiever_mappings

" Achiever derives date and time from the same rounded instant at midnight.
let s:rounded_function = matchstr(execute('function /RoundedTimestamp'),
      \ '<SNR>\d\+_RoundedTimestamp')
let s:saved_tz = $TZ
let $TZ = 'UTC'
call s:Equal('700102 00:00', call(s:rounded_function, [86399]),
      \ 'Achiever rounded midnight without advancing the date')
let $TZ = s:saved_tz

" GPG mappings point to live script functions, and new encrypted buffers are
" protected without invoking real encryption or keys.
for [s:mode, s:mappings] in items({
      \ 'n': ['glgd', 'glgr'],
      \ 'x': ['glgs', 'glga', 'glgd'],
      \ })
  for s:mapping in s:mappings
    let s:definition = maparg(s:mapping, s:mode, 0, 1)
    let s:function_name = s:mapping ==# 'glgr' ? 'RestartAgent' : 'Transform'
    let s:function = '<SNR>' . get(s:definition, 'sid', 0) . '_' . s:function_name
    call s:Check(get(s:definition, 'rhs', '') =~# '<SID>' . s:function_name
          \ && exists('*' . s:function),
          \ 'GPG target is missing: ' . s:mode . ' ' . s:mapping)
  endfor
endfor
call s:Check(empty(maparg('glge', 'n')), 'unsafe whole-buffer GPG encrypt mapping remains')
execute 'edit! ' . fnameescape(s:root . '/temporary.gpg.noe')
call s:Check(get(b:, 'vim_sensitive_buffer', 0), 'GPG buffer was not marked sensitive')
call s:Check(get(b:, 'vim_gpg_managed_buffer', 0),
      \ 'GPG buffer was not marked as managed')
call s:Equal('Not encrypted yet', &titlestring,
      \ 'new GPG buffer has an invalid encryption timestamp')
call s:Check(!&l:swapfile && !&l:undofile, 'GPG local protections are incomplete')
call s:Check(!&backup && !&writebackup && empty(&viminfo),
      \ 'GPG global protections are incomplete')
execute 'source ' . fnameescape(s:root . '/home/.vimrc')
call s:Check(!&l:swapfile && !&l:undofile && !&backup && !&writebackup
      \ && empty(&viminfo), 'sourcing vimrc weakened GPG protection')

if $VIM_CHECK_ALE ==# '1'
  " ALE must never receive plaintext from any sensitive buffer lifecycle event.
  call delete(s:root . '/yamllint.argv')
  call delete(s:root . '/yamllint.input')
  execute 'edit! ' . fnameescape(s:root . '/sensitive.gpg.yaml')
  call setline(1, 'password: ALE-SENSITIVE-PROBE')
  sleep 400m
  doautocmd <nomodeline> BufWritePost
  silent ALELint
  setfiletype json
  setfiletype yaml
  execute 'source ' . fnameescape(s:root . '/home/.vimrc')
  sleep 400m
  call s:Check(!get(b:, 'ale_enabled', 1),
        \ 'ALE remained enabled for a sensitive buffer')
  call s:Check(!filereadable(s:root . '/yamllint.argv')
        \ && !filereadable(s:root . '/yamllint.input'),
        \ 'ALE passed sensitive plaintext to yamllint')

  " A queued lint rechecks policy after the buffer becomes sensitive.
  execute 'edit! ' . fnameescape(s:repo . '/queued.yaml')
  call delete(s:root . '/yamllint.argv')
  call delete(s:root . '/yamllint.input')
  call ale#Queue(200)
  doautocmd <nomodeline> FileReadPre queued.gpg.yaml
  call setline(1, 'password: ALE-QUEUED-SENSITIVE-PROBE')
  sleep 400m
  call s:Equal([], get(b:, 'ale_linters', 'missing'),
        \ 'a sensitive transition did not close ALE linter selection')
  call s:Check(!filereadable(s:root . '/yamllint.argv')
        \ && !filereadable(s:root . '/yamllint.input'),
        \ 'queued ALE work processed a buffer after it became sensitive')

  " A normal Ops buffer still lints and the fake linter sees its temporary file.
  execute 'edit! ' . fnameescape(s:repo . '/sub/file.yaml')
  silent ALELint
  call s:Check(s:WaitFor(s:root . '/yamllint.input'),
        \ 'yamllint did not process an ordinary YAML buffer')
  if filereadable(s:root . '/yamllint.input')
    call s:Equal(['key: value'], readfile(s:root . '/yamllint.input'),
          \ 'yamllint received the wrong ordinary buffer contents')
  endif
endif

if $VIM_CHECK_GITGUTTER ==# '1'
  " Lazy loading and later enable commands cannot reactivate sensitive buffers.
  let g:gitgutter_async = 0
  execute 'edit! ' . fnameescape(s:root . '/gitgutter-repository/tracked.txt')
  GitGutterToggle
  call s:Check(exists('g:loaded_gitgutter'),
        \ 'GitGutterToggle did not exercise the lazy-load path')
  runtime autoload/gitgutter/diff.vim
  let s:gitgutter_writer = matchstr(execute('function /write_buffer'),
        \ '<SNR>\d\+_write_buffer')
  let g:gitgutter_writes = []
  execute 'function! ' . s:gitgutter_writer . "(buffer, file)\n"
        \ . "call add(g:gitgutter_writes, [a:buffer, "
        \ . "getbufvar(a:buffer, 'vim_sensitive_buffer', 0)])\n"
        \ . "throw 'gitgutter diff failed'\nendfunction"
  call gitgutter#buffer_enable()
  call s:Equal([[bufnr(''), 0]], g:gitgutter_writes,
        \ 'the GitGutter serialization probe did not exercise an ordinary buffer')
  let g:gitgutter_writes = []
  let b:gitgutter = {'enabled': 1}
  let b:vim_sensitive_buffer = 1
  let s:gitgutter_sensitive_buffer = bufnr('')
  call timer_start(20,
        \ {-> gitgutter#process_buffer(s:gitgutter_sensitive_buffer, 1)})
  doautocmd <nomodeline> User VimGPGSensitive
  sleep 100m
  call s:Equal([], g:gitgutter_writes,
        \ 'queued GitGutter work processed a sensitive buffer')
  GitGutterEnable
  call s:Equal(0, get(b:gitgutter, 'enabled', -1),
        \ 'GitGutterEnable reactivated a sensitive buffer')
  GitGutterBufferEnable
  call s:Equal(0, get(b:gitgutter, 'enabled', -1),
        \ 'GitGutterBufferEnable reactivated a sensitive buffer')

  " GitGutter's BufFilePost callback cannot undo GPG protection on rename.
  enew!
  let b:gitgutter = {'enabled': 1}
  let v:errmsg = ''
  execute 'file ' . fnameescape(s:root . '/gitgutter-named.gpg.noe')
  call s:Check(get(b:, 'vim_sensitive_buffer', 0) && !b:gitgutter.enabled,
        \ 'a GPG rename remained active in GitGutter')
  call s:Equal('', v:errmsg,
        \ 'GitGutter raised an error while GPG protected a renamed buffer')
endif

" Project policy is evaluated from the file, independently of Vim's cwd.
execute 'cd ' . fnameescape(s:root)
execute 'edit ' . fnameescape(s:repo . '/sub/file.yaml')
call s:Equal(['yamlfmt'], b:ale_fixers, 'yamlfmt was not enabled for '
      \ . expand('%:p') . ' from ' . getcwd())
call s:Check(b:ale_yaml_yamlfmt_options =~# '/sub/\.yamlfmt\.yml',
      \ 'the nearest yamlfmt config did not win')
call s:Check(index(map([s:repo . '/.yamllint', resolve(s:repo . '/.yamllint')],
      \ '"-c " . shellescape(v:val)'), b:ale_yaml_yamllint_options) >= 0,
      \ 'yamllint did not receive the project config')
execute 'edit ' . fnameescape(s:repo . '/Dockerfile')
call s:Check(index(map([s:repo . '/.hadolint.yaml',
      \ resolve(s:repo . '/.hadolint.yaml')],
      \ '"--config " . shellescape(v:val)'),
      \ b:ale_dockerfile_hadolint_options) >= 0,
      \ 'Hadolint did not receive the project config')
execute 'edit ' . fnameescape(s:repo . '/Makefile')
call s:Check(!exists('b:ale_make_checkmake_config'),
      \ 'unsafe checkmake config integration remains enabled')
execute 'edit ' . fnameescape(s:root . '/without-config.sh')
setfiletype sh
call s:Equal([], b:ale_fixers, 'shell has an ALE fixer')

" A nested worktree is its own policy boundary even when its parent has config.
execute 'edit ' . fnameescape(s:root . '/outer-repository/worktree/file.yaml')
call s:Equal([], b:ale_fixers,
      \ 'a worktree inherited the parent repository yamlfmt config')
call s:Check(!exists('b:ale_yaml_yamlfmt_options'),
      \ 'a worktree retained a parent repository yamlfmt path')

" BufFilePost refreshes policy when the current buffer moves between projects.
execute 'edit ' . fnameescape(s:repo . '/sub/file.yaml')
call s:Equal(['yamlfmt'], b:ale_fixers,
      \ 'the source repository did not enable yamlfmt before :file')
execute 'file ' . fnameescape(s:root . '/project-b/file.yaml')
call s:Equal([], b:ale_fixers, ':file retained the previous repository fixer')
call s:Check(!exists('b:ale_yaml_yamlfmt_options')
      \ && !exists('b:ale_yaml_yamllint_options'),
      \ ':file retained the previous repository config paths')

if $VIM_CHECK_ALE ==# '1'
  " Every configured linter can run when its executable is present.
  call delete(s:root . '/project-jsonlint.marker')
  call delete(s:root . '/jsonlint.argv')
  for [s:filetype, s:path, s:tool] in [
        \ ['sh', s:repo . '/scripts/example.sh', 'shellcheck'],
        \ ['yaml', s:repo . '/sub/file.yaml', 'yamllint'],
        \ ['json', s:repo . '/data.json', 'jsonlint'],
        \ ['dockerfile', s:repo . '/Dockerfile', 'hadolint'],
        \ ['terraform', s:repo . '/main.tf', 'tflint'],
        \ ['make', s:repo . '/Makefile', 'checkmake'],
        \ ]
    execute 'edit ' . fnameescape(s:path)
    execute 'setfiletype ' . s:filetype
    silent ALELint
    call s:Check(s:WaitFor(s:root . '/' . s:tool . '.argv'),
      \ s:tool . ' did not execute')
  endfor
  call s:Check(!filereadable(s:root . '/project-jsonlint.marker'),
        \ 'ALE executed node_modules/.bin/jsonlint from the checkout')
  call s:Check(filereadable(s:root . '/jsonlint.argv'),
        \ 'ALE did not execute jsonlint from PATH')
  if filereadable(s:root . '/tflint.argv')
    call s:Equal(resolve(s:repo), resolve(readfile(s:root . '/tflint.argv')[0]),
          \ 'TFLint did not run from the Terraform project')
  endif
  " Current ALE still interpolates checkmake config paths unsafely, so the
  " personal integration passes no config, including from hostile pathnames.
  call delete(s:root . '/checkmake.argv')
  execute 'edit ' . fnameescape(s:root
        \ . '/make$(true) with ''quote'' "double" `true`/Makefile')
  setfiletype make
  silent ALELint
  call s:Check(s:WaitFor(s:root . '/checkmake.argv'),
        \ 'checkmake did not execute for a hostile project path')
  if filereadable(s:root . '/checkmake.argv')
    call s:Check(index(readfile(s:root . '/checkmake.argv'), '--config') < 0
          \ && join(readfile(s:root . '/checkmake.argv'), "\n") !~# 'checkmake.ini',
          \ 'checkmake received an unsafe project config path')
  endif
  execute 'edit ' . fnameescape(s:repo . '/scripts/example.sh')
  call s:Equal([], b:ale_fixers, 'shell has a fixer inside a configured project')

  " Project paths survive ALE's percent-template pass and the later shell pass.
  let s:hostile_ale = s:root . '/ale%s/$(printf ALE-EXPANDED)'
  call delete(s:root . '/yamllint.argv')
  execute 'edit ' . fnameescape(s:hostile_ale . '/file.yaml')
  silent ALELint
  call s:Check(s:WaitFor(s:root . '/yamllint.argv'),
        \ 'yamllint did not execute for a percent-template project path')
  if filereadable(s:root . '/yamllint.argv')
    call s:Check(index(readfile(s:root . '/yamllint.argv'),
          \ s:hostile_ale . '/.yamllint') >= 0,
          \ 'ALE reinterpreted the yamllint project path')
  endif
  call delete(s:root . '/yamlfmt.argv')
  ALEFix
  call s:Check(s:WaitFor(s:root . '/yamlfmt.argv'),
        \ 'yamlfmt did not execute for a percent-template project path')
  if filereadable(s:root . '/yamlfmt.argv')
    call s:Check(index(readfile(s:root . '/yamlfmt.argv'),
          \ s:hostile_ale . '/.yamlfmt') >= 0,
          \ 'ALE reinterpreted the yamlfmt project path')
  endif
  call delete(s:root . '/hadolint.argv')
  execute 'edit ' . fnameescape(s:hostile_ale . '/Dockerfile')
  silent ALELint
  call s:Check(s:WaitFor(s:root . '/hadolint.argv'),
        \ 'hadolint did not execute for a percent-template project path')
  if filereadable(s:root . '/hadolint.argv')
    call s:Check(index(readfile(s:root . '/hadolint.argv'),
          \ s:hostile_ale . '/.hadolint.yaml') >= 0,
          \ 'ALE reinterpreted the Hadolint project path')
  endif

  " Execute the project-configured YAML fixer and inspect its actual argv.
  execute 'edit ' . fnameescape(s:repo . '/sub/file.yaml')
  call delete(s:root . '/yamlfmt.argv')
  ALEFix
  call s:Check(s:WaitFor(s:root . '/yamlfmt.argv'), 'yamlfmt did not execute')
  if filereadable(s:root . '/yamlfmt.argv')
    let s:yamlfmt_argv = readfile(s:root . '/yamlfmt.argv')
    call s:Check(s:yamlfmt_argv ==# ['-conf', s:repo . '/sub/.yamlfmt.yml', '-in']
          \ || s:yamlfmt_argv ==# ['-conf', resolve(s:repo . '/sub/.yamlfmt.yml'), '-in'],
          \ 'yamlfmt argv is incorrect: ' . string(s:yamlfmt_argv))
  endif

  " Missing external tools are a supported no-op for every configured linter.
  let g:ale_sh_shellcheck_executable = s:root . '/missing-shellcheck'
  let g:ale_yaml_yamllint_executable = s:root . '/missing-yamllint'
  let g:ale_json_jsonlint_executable = s:root . '/missing-jsonlint'
  let g:ale_dockerfile_hadolint_executable = s:root . '/missing-hadolint'
  let g:ale_terraform_tflint_executable = s:root . '/missing-tflint'
  let $PATH = '/usr/bin:/bin'
  let v:errmsg = ''
  for s:filetype in keys(g:ale_linters)
    enew
    execute 'setfiletype ' . s:filetype
    silent ALELint
  endfor
  call s:Equal('', v:errmsg, 'a missing ALE executable raised a Vim error')
endif

if !empty(s:errors)
  call writefile(s:errors, $VIM_CHECK_ERRORS)
  cquit 1
endif
qa!
VIM

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
if !exists('g:loaded_personal_gpg')
  call add(s:errors, 'GPG plugin did not coexist with redact-pass')
endif
execute 'source ' . fnameescape($VIM_CHECK_ROOT . '/home/.vimrc')
if &l:swapfile || &l:undofile || &backup || &writebackup || !empty(&viminfo)
  call add(s:errors, 'sourcing vimrc weakened pass buffer protection')
endif
if !empty(s:errors)
  call writefile(s:errors, $VIM_CHECK_ERRORS, 'a')
  cquit 1
endif
qa!
VIM

if [[ "$check_ale" == 0 ]]; then
  printf '[SKIP] ALE argv checks (ALE is not downloaded)\n'
fi
if [[ "$check_gitgutter" == 0 ]]; then
  printf '[SKIP] GitGutter security checks (GitGutter is not downloaded)\n'
fi
if [[ "$check_rg" == 0 ]]; then
  printf '[SKIP] Vim search checks (rg is unavailable)\n'
fi

if ! HOME="$CHECK_HOME" \
  XDG_DATA_HOME="$CHECK_DATA" \
  XDG_STATE_HOME="$CHECK_STATE" \
  VIM_CHECK_ALE="$check_ale" \
  VIM_CHECK_ALE_SOURCE="$ALE_SOURCE" \
  VIM_CHECK_GITGUTTER="$check_gitgutter" \
  VIM_CHECK_GITGUTTER_SOURCE="$GITGUTTER_SOURCE" \
  VIM_CHECK_RG="$check_rg" \
  VIM_CHECK_ERRORS="$ERRORS" \
  VIM_CHECK_ROOT="$CHECK_ROOT" \
  PATH="$CHECK_BIN:$PATH" \
    vim -Nu "$CHECK_HOME/.vimrc" -i NONE -n -es \
      -S "$CHECK_ROOT/check.vim" +qa! >"$VIM_LOG" 2>&1; then
  cat -- "$VIM_LOG" >&2
  [[ ! -s "$ERRORS" ]] || fail
  exit 1
fi

if ! HOME="$CHECK_HOME" \
  XDG_DATA_HOME="$CHECK_DATA" \
  XDG_STATE_HOME="$CHECK_STATE" \
  VIM_CHECK_ERRORS="$ERRORS" \
  VIM_CHECK_ROOT="$CHECK_ROOT" \
    vim -Nu "$CHECK_HOME/.vimrc" -i NONE -n -es "$PASS_FILE" \
      -S "$CHECK_ROOT/redact.vim" +qa! >>"$VIM_LOG" 2>&1; then
  cat -- "$VIM_LOG" >&2
  [[ ! -s "$ERRORS" ]] || fail
  exit 1
fi

[[ ! -s "$ERRORS" ]] || fail
