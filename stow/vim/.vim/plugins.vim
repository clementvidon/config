" Plugin settings, integrations, mappings and declarations.
scriptencoding utf-8

" # LOCAL PLUGINS

let g:achiever_filenames = [ 'todos.noe', '.todos.gpg.noe' ]
let g:noesis_export_author = 'Clément VIDON'

let g:vim_gpg_recipient = 'B8AE5479C3DE72D291F1E923B32613620A074922'

" # ALE

let g:ale_enabled = 1
let g:ale_disable_lsp = 1
" Never resolve executables from a project checkout.
let g:ale_use_global_executables = 1
let g:ale_linters_explicit = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 0
let g:ale_maximum_file_size = 1024 * 1024

let g:ale_linters = {
      \ 'sh': ['shellcheck'],
      \ 'yaml': ['yamllint', 'actionlint'],
      \ 'json': ['jq'],
      \ 'dockerfile': ['hadolint'],
      \ 'terraform': ['tflint'],
      \ 'make': ['checkmake'],
      \ }
" An empty global table prevents ALE from selecting implicit fixers; only the
" buffer-local project policy below may enable one.
let g:ale_fixers = {}

" ## ALE / project policy

" Treat nested worktrees as separate projects.
function! s:FindGitRoot(directory) abort
  let l:directory = a:directory
  while 1
    let l:marker = l:directory . '/.git'
    if isdirectory(l:marker) || filereadable(l:marker)
      return l:directory
    endif
    let l:parent = fnamemodify(l:directory, ':h')
    if l:parent ==# l:directory
      return ''
    endif
    let l:directory = l:parent
  endwhile
endfunction

" Do not inherit lint policy from outside the repository.
function! s:FindProjectConfig(names) abort
  let l:directory = expand('%:p:h')
  let l:root = s:FindGitRoot(l:directory)
  if empty(l:root)
    return ''
  endif
  while 1
    for l:name in a:names
      let l:config = l:directory . '/' . l:name
      if filereadable(l:config)
        return fnamemodify(l:config, ':p')
      endif
    endfor
    if l:directory ==# l:root
      break
    endif
    let l:parent = fnamemodify(l:directory, ':h')
    if l:parent ==# l:directory
      break
    endif
    let l:directory = l:parent
  endwhile
  return ''
endfunction

function! s:ResetALEPolicy() abort
  let b:ale_fixers = []
  unlet! b:ale_linters b:ale_yaml_yamlfmt_options b:ale_yaml_yamllint_options
        \ b:ale_dockerfile_hadolint_options
endfunction

function! s:ConfigureALE() abort
  call s:ResetALEPolicy()
  if get(b:, 'vim_sensitive_buffer', 0)
    " A pending ALE timer selects linters again when it fires.  The empty
    " buffer-local list keeps that execution boundary closed too.
    let b:ale_enabled = 0
    let b:ale_linters = []
    if exists('*ale#engine#Cleanup')
      call ale#engine#Cleanup(bufnr(''))
    endif
    return
  endif
  if &l:filetype ==# 'terraform'
    let b:ale_fixers = ['terraform']
  elseif &l:filetype ==# 'yaml'
    let l:config = s:FindProjectConfig([
          \ '.yamlfmt', 'yamlfmt.yml', 'yamlfmt.yaml',
          \ '.yamlfmt.yml', '.yamlfmt.yaml',
          \ ])
    if !empty(l:config)
      let b:ale_fixers = ['yamlfmt']
      let b:ale_yaml_yamlfmt_options = '-conf '
            \ . substitute(shellescape(l:config), '%', '%%', 'g')
    endif
    let l:config = s:FindProjectConfig([
          \ '.yamllint', '.yamllint.yml', '.yamllint.yaml',
          \ ])
    if !empty(l:config)
      let b:ale_yaml_yamllint_options = '-c '
            \ . substitute(shellescape(l:config), '%', '%%', 'g')
    endif
  elseif &l:filetype ==# 'dockerfile'
    let l:config = s:FindProjectConfig(['.hadolint.yaml', '.hadolint.yml'])
    if !empty(l:config)
      let b:ale_dockerfile_hadolint_options = '--config '
            \ . substitute(shellescape(l:config), '%', '%%', 'g')
    endif
  endif
endfunction

" ## ALE / mappings

nnoremap <Leader>al :ALELint<CR>
nnoremap <Leader>af :ALEFix<CR>
nnoremap <Leader>an :ALENext<CR>
nnoremap <Leader>ap :ALEPrevious<CR>
nnoremap <Leader>ad :ALEDetail<CR>
nnoremap <Leader>ai :ALEInfo<CR>
nnoremap <Leader>at :ALEToggle<CR>

" # GITGUTTER

" Keep GitGutter inactive until explicitly enabled.
let g:gitgutter_enabled = 0
let g:gitgutter_map_keys = 0

" ## GITGUTTER / buffer guards

function! s:DisableGitGutter(buffer) abort
  let l:state = getbufvar(a:buffer, 'gitgutter')
  if type(l:state) !=# v:t_dict
    let l:state = {}
    call setbufvar(a:buffer, 'gitgutter', l:state)
  endif
  let l:state.enabled = 0
  if exists('*gitgutter#buffer_disable')
    call gitgutter#buffer_disable(a:buffer)
  endif
endfunction

function! s:DisableSensitiveGitGutterBuffers() abort
  for l:buffer in range(1, bufnr('$'))
    if bufexists(l:buffer) && getbufvar(l:buffer, 'vim_sensitive_buffer', 0)
      call s:DisableGitGutter(l:buffer)
    endif
  endfor
endfunction

function! s:EnableGitGutter() abort
  let g:gitgutter_enabled = 1
  for l:buffer in range(1, bufnr('$'))
    if !buflisted(l:buffer) || empty(bufname(l:buffer))
      continue
    endif
    if getbufvar(l:buffer, 'vim_sensitive_buffer', 0)
      call s:DisableGitGutter(l:buffer)
    else
      call gitgutter#buffer_enable(l:buffer)
    endif
  endfor
endfunction

function! s:ToggleGitGutter() abort
  if g:gitgutter_enabled
    call gitgutter#disable()
  else
    call s:EnableGitGutter()
  endif
endfunction

function! s:EnableGitGutterBuffer() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    call s:DisableGitGutter(bufnr(''))
    return
  endif
  call gitgutter#buffer_enable()
endfunction

function! s:ToggleGitGutterBuffer() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    call s:DisableGitGutter(bufnr(''))
    return
  endif
  call gitgutter#buffer_toggle()
endfunction

function! s:InstallGitGutterGuards() abort
  command! -bar GitGutterEnable call <SID>EnableGitGutter()
  command! -bar GitGutterToggle call <SID>ToggleGitGutter()
  command! -bar GitGutterBufferEnable call <SID>EnableGitGutterBuffer()
  command! -bar GitGutterBufferToggle call <SID>ToggleGitGutterBuffer()
  call s:DisableSensitiveGitGutterBuffers()
endfunction

" ## GITGUTTER / mappings

nmap [c <Plug>(GitGutterPrevHunk)
nmap ]c <Plug>(GitGutterNextHunk)
nmap <Leader>gs <Plug>(GitGutterStageHunk)
xmap <Leader>gs <Plug>(GitGutterStageHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)
nmap <Leader>gp <Plug>(GitGutterPreviewHunk)
nnoremap <Leader>gg :GitGutterToggle<CR>
nnoremap <Leader>gr :GitGutterAll<CR>
nnoremap <Leader>gb :GitGutterBufferToggle<CR>
nnoremap <Leader>gq :GitGutterQuickFix<CR>
nnoremap <Leader>gd :GitGutterDiffOrig<CR>

" # SHARED INTEGRATION HOOKS

function! s:ProtectAutomaticIntegrations() abort
  call s:ConfigureALE()
  call s:DisableGitGutter(bufnr(''))
endfunction

augroup personal_ale
  autocmd!
  autocmd FileType * call <SID>ConfigureALE()
  autocmd BufEnter,BufFilePost,BufWritePre * call <SID>ConfigureALE()
  autocmd User VimGPGSensitive,RedactPassSensitive
        \ call <SID>ProtectAutomaticIntegrations()
  autocmd User vim-gitgutter call <SID>InstallGitGutterGuards()
augroup END
call s:ConfigureALE()

" # NETRW

let g:netrw_banner = 0
let g:netrw_dirhistmax = 0

" # COLORSCHEMES

let g:seoul256_background = 256

" # PLUGIN DECLARATIONS

call plug#begin(g:vim_data_dir . '/plugged')

Plug 'tpope/vim-repeat', { 'commit': '65846025c15494983dafe5e3b46c8f88ab2e9635' }
Plug 'tpope/vim-surround', { 'commit': '3d188ed2113431cf8dac77be61b842acb64433d9' }
Plug 'tpope/vim-commentary', { 'commit': '64a654ef4a20db1727938338310209b6a63f60c9' }
Plug 'arcticicestudio/nord-vim', { 'commit': 'f13f5dfbb784deddbc1d8195f34dfd9ec73e2295' }
Plug 'junegunn/seoul256.vim', { 'commit': '0357ff3e44faab66c98bc98dfc89c834e37012da' }
Plug 'dense-analysis/ale', {
      \ 'commit': 'e1789bc54483d76ac9ddb40b633d1645c8281914',
      \ 'for': ['sh', 'yaml', 'json', 'dockerfile', 'terraform', 'make'],
      \ 'on': ['ALELint', 'ALEFix', 'ALEInfo', 'ALEToggle', 'ALEDetail',
      \        'ALENext', 'ALEPrevious']
      \ }
Plug 'airblade/vim-gitgutter', {
      \ 'commit': '90b75207bd9b55d8ac4af15f72b4e935462014d0',
      \ 'on': [
      \   'GitGutterToggle', 'GitGutterDisable', 'GitGutterEnable', 'GitGutterAll',
      \   'GitGutterBufferToggle', 'GitGutterNextHunk', 'GitGutterPrevHunk',
      \   'GitGutterQuickFix', 'GitGutterDiffOrig', 'GitGutterUndoHunk',
      \   '<Plug>(GitGutterNextHunk)', '<Plug>(GitGutterPrevHunk)',
      \   '<Plug>(GitGutterStageHunk)', '<Plug>(GitGutterUndoHunk)',
      \   '<Plug>(GitGutterPreviewHunk)'
      \ ]
      \ }
call plug#end()

" Re-sourcing after GitGutter was loaded must retain the guarded commands.
if exists('g:loaded_gitgutter')
  call s:InstallGitGutterGuards()
endif
