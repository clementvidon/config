" Plugin settings, integration guards and declarations.
scriptencoding utf-8

" # LOCAL PLUGINS

let g:noesis_all_markdown = 1

let g:vim_gpg_recipient = empty($VIM_GPG_RECIPIENT)
      \ ? 'B8AE5479C3DE72D291F1E923B32613620A074922' : $VIM_GPG_RECIPIENT

" # ALE

if exists(':ALEDisable')
  silent ALEDisable
endif
let g:ale_enabled = 0
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_hover_to_floating_preview = 0
let g:ale_hover_to_preview = 1
if exists(':ALEStopAllLSPs')
  silent ALEStopAllLSPs
endif
let g:ale_disable_lsp = 0
" Never resolve executables from a project checkout.
let g:ale_use_global_executables = 1
let g:ale_linters_explicit = 1
" Use ALE's native buffer-entry checks and recheck on save.
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 0
let g:ale_maximum_file_size = 1024 * 1024

" Terraform validation is manual because ALE does not set its cwd.
let g:ale_linters = {
      \ 'sh': ['shellcheck'],
      \ 'yaml': ['yamllint', 'actionlint'],
      \ 'ansible': ['ansible_lint', 'language_server'],
      \ 'json': ['jq'],
      \ 'dockerfile': ['hadolint'],
      \ 'terraform': ['tflint', 'terraform_ls'],
      \ 'make': ['checkmake'],
      \ }
let g:ale_fixers = {
      \ 'terraform': ['terraform'],
      \ 'yaml': ['yamlfmt'],
      \ }
" Run ansible-lint through ALE, without duplicate validation from the server.
let g:ale_ansible_language_server_config = {'ansible': {'validation': {'enabled': v:false}}}

" ## ALE / sensitive buffers

function! s:DisableALEBuffer() abort
  if exists(':ALEDisableBuffer')
    silent ALEDisableBuffer
  endif
  let b:ale_enabled = 0
  let b:ale_disable_lsp = 1
  let b:ale_linters = []
  let b:ale_fixers = []
endfunction

function! s:GuardALEExecution() abort
  " ALE's delayed callback may run while a different buffer is current.
  if getbufvar(g:ale_want_results_buffer, 'vim_sensitive_buffer', 0)
    throw 'ALE: refusing to lint a sensitive buffer'
  endif
endfunction

" ## ALE / mappings

nnoremap <Leader>al :ALELint<CR>
nnoremap <Leader>af :ALEFix<CR>
nnoremap <Leader>aj :ALENext<CR>
nnoremap <Leader>ak :ALEPrevious<CR>
nnoremap <Leader>ad :ALEDetail<CR>
nnoremap <Leader>ah :ALEHover<CR>
nnoremap <Leader>ai :ALEInfo<CR>
nnoremap <silent> <Leader>at :ALEToggle<CR>:echomsg 'ALE: ' . (g:ale_enabled ? 'enabled' : 'disabled')<CR>

nnoremap <Leader>a? :map <lt>Leader>a<CR>

" # GITGUTTER

if exists(':GitGutterDisable')
  silent GitGutterDisable
endif
let g:gitgutter_enabled = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_diff_base = 'HEAD'

" ## GITGUTTER / buffer guards

function! s:DisableGitGutter() abort
  if exists('*gitgutter#buffer_disable')
    call gitgutter#buffer_disable()
  else
    " Sensitive buffers can be marked before GitGutter finishes loading.
    let b:gitgutter = get(b:, 'gitgutter', {})
    let b:gitgutter.enabled = 0
  endif
endfunction

function! s:EnableGitGutterBuffer() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    call s:DisableGitGutter()
    return
  endif
  call gitgutter#buffer_enable()
endfunction

function! s:InstallGitGutterGuards() abort
  " Upstream has no pre-enable hook; these overrides enforce sensitive isolation.
  command! -bar GitGutterBufferEnable call <SID>EnableGitGutterBuffer()
  command! -bar GitGutterBufferToggle execute gitgutter#utility#getbufvar(
        \ bufnr(''), 'enabled', g:gitgutter_enabled)
        \ ? 'GitGutterBufferDisable' : 'GitGutterBufferEnable'
  if get(b:, 'vim_sensitive_buffer', 0)
    call s:DisableGitGutter()
  endif
endfunction

" ## GITGUTTER / mappings

nmap <Leader>gk <Plug>(GitGutterPrevHunk)
nmap <Leader>gj <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPreviewHunk)
nnoremap <silent> <Leader>gt :GitGutterBufferToggle<CR>:echomsg 'GitGutter: ' . (gitgutter#utility#getbufvar(bufnr(''), 'enabled', g:gitgutter_enabled) ? 'enabled' : 'disabled')<CR>
nnoremap <Leader>gd :GitGutterDiffOrig<CR>

nnoremap <Leader>g? :map <lt>Leader>g<CR>

" # SHARED INTEGRATION HOOKS

function! s:ProtectAutomaticIntegrations() abort
  call s:DisableALEBuffer()
  call s:DisableGitGutter()
endfunction

augroup personal_integrations
  autocmd!
  autocmd User VimGPGSensitive,RedactPassSensitive
        \ call <SID>ProtectAutomaticIntegrations()
  " This event runs before ALE starts linters, including already queued work.
  autocmd User ALEWantResults call <SID>GuardALEExecution()
  " Eager plugins load after vimrc; guard commands once GitGutter defines them.
  autocmd SourcePost */plugin/gitgutter.vim call <SID>InstallGitGutterGuards()
augroup END
if get(b:, 'vim_sensitive_buffer', 0)
  call s:DisableALEBuffer()
endif

" # COLORSCHEMES

let g:seoul256_background = 236
let g:seoul256_light_background = 256

" # NETRW

let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro nornu'
let g:netrw_dirhistmax = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 33
let g:Netrw_UserMaps = [
      \ ['p', 'vim_config#netrw#open_without_jump'],
      \ ['?', 'vim_config#netrw#show_usage'],
      \ ]

" # FZF

let g:fzf_layout = { 'down': '30%' }
nnoremap <silent> sr :<C-U>FZF<CR>
nnoremap sR :<C-U>FZF<Space>

" # PLUGIN DECLARATIONS

call plug#begin(g:vim_data_dir . '/plugged')

Plug 'tpope/vim-repeat', { 'commit': '65846025c15494983dafe5e3b46c8f88ab2e9635' }
Plug 'tpope/vim-surround', { 'commit': '3d188ed2113431cf8dac77be61b842acb64433d9' }
Plug 'tpope/vim-commentary', { 'commit': '64a654ef4a20db1727938338310209b6a63f60c9' }
" Supported older runtimes lack HCL and Terraform filetype support.
Plug 'hashivim/vim-terraform', { 'commit': '520498fab16a3a11f2ae1b8cb65e0a1684bc317a' }
Plug 'arcticicestudio/nord-vim', { 'commit': 'f13f5dfbb784deddbc1d8195f34dfd9ec73e2295' }
Plug 'junegunn/seoul256.vim', { 'commit': '0357ff3e44faab66c98bc98dfc89c834e37012da' }
Plug 'junegunn/fzf', { 'commit': 'a140afeb4d733cad3c96a56bf6db7e26853b6757', 'on': 'FZF' }
Plug 'dense-analysis/ale', {
      \ 'commit': 'e1789bc54483d76ac9ddb40b633d1645c8281914',
      \ 'for': keys(g:ale_linters),
      \ 'on': ['ALELint', 'ALEFix', 'ALEInfo', 'ALEToggle', 'ALEDetail', 'ALEHover',
      \        'ALENext', 'ALEPrevious']
      \ }
Plug 'airblade/vim-gitgutter', { 'commit': '90b75207bd9b55d8ac4af15f72b4e935462014d0' }
call plug#end()

" Re-sourcing after GitGutter was loaded must retain the guarded commands.
if exists('g:loaded_gitgutter')
  call s:InstallGitGutterGuards()
endif
