" Personal Vim configuration.

" # BOOTSTRAP

let mapleader = ' '
let maplocalleader = 'gh'

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1

" # PERSISTENT STATE

" Keep generated state out of the configuration tree. Only swap may fall back
" to /tmp; persistent undo must stay in its private state directory.
let s:state_home = empty($XDG_STATE_HOME)
      \ ? expand('~/.local/state')
      \ : expand($XDG_STATE_HOME)
let s:data_home = empty($XDG_DATA_HOME)
      \ ? expand('~/.local/share')
      \ : expand($XDG_DATA_HOME)
let s:state_dir = s:state_home . '/vim'
let g:vim_data_dir = s:data_home . '/vim'

let s:undo_dir = s:state_dir . '/undo'
let &undodir = escape(s:undo_dir . '//', '\,')
let s:undo_ready = 0
try
  call mkdir(s:undo_dir, 'p', 0700)
  if isdirectory(s:undo_dir) && getfperm(s:undo_dir) !=# 'rwx------'
    call setfperm(s:undo_dir, 'rwx------')
  endif
  let s:undo_ready = isdirectory(s:undo_dir) && filewritable(s:undo_dir) == 2
        \ && getfperm(s:undo_dir) ==# 'rwx------'
catch /^Vim\%((\a\+)\)\=:E739/
  " Failure to create the directory must not enable a less private fallback.
endtry
if !s:undo_ready
  " Reloads must also stop already-open buffers from writing unsafe history.
  for s:buffer in getbufinfo()
    call setbufvar(s:buffer.bufnr, '&undofile', 0)
  endfor
  unlet! s:buffer
endif
call mkdir(s:state_dir . '/swap', 'p', 0700)
let s:spell_dir = g:vim_data_dir . '/spell'
let s:spell_ready = 0
try
  call mkdir(s:spell_dir, 'p', 0700)
  let s:spell_ready = isdirectory(s:spell_dir) && filewritable(s:spell_dir) == 2
catch /^Vim\%((\a\+)\)\=:E739/
  " A personal spellfile is optional and must not block Vim startup.
endtry
if s:spell_ready
  execute 'set runtimepath+=' . fnameescape(g:vim_data_dir)
endif

let &directory = s:state_dir . '/swap//,/tmp//'
" Once plaintext has entered a session, the GPG plugin deliberately leaves
" viminfo disabled so history and registers cannot persist it later.
if !get(g:, 'vim_sensitive_session', 0)
  let &viminfo = "'100,<50,s10,h,n" . s:state_dir . '/viminfo'
endif
if s:spell_ready
  let &spellfile = s:spell_dir . '/custom.utf-8.add'
  if filereadable(&spellfile)
    let s:compiled_spellfile = &spellfile . '.spl'
    if !filereadable(s:compiled_spellfile)
          \ || getftime(&spellfile) > getftime(s:compiled_spellfile)
      silent! execute 'mkspell! ' . fnameescape(&spellfile)
    endif
  endif
else
  let &spellfile = ''
endif

" # PLUGINS

source ~/.vim/plugins.vim

" # APPEARANCE

" Seoul presets for glco: white 256, off-white 252, brown-green dark 236.
" The plugin uses separate light (252-256) and dark (233-239) palettes.
let s:seoul_backgrounds = {
      \ 'white': 256,
      \ 'off_white': 252,
      \ 'dark': 236,
      \ }
let g:seoul256_background = s:seoul_backgrounds.dark
let g:seoul256_light_background = s:seoul_backgrounds.white

set background=dark
try
  colorscheme nord
catch /^Vim\%((\a\+)\)\=:E185/
endtry

function! s:ToggleColorscheme() abort
  if get(g:, 'colors_name', '') ==# 'nord'
    let g:seoul256_light_background = s:seoul_backgrounds.white
    colorscheme seoul256-light
  elseif get(g:, 'colors_name', '') ==# 'seoul256-light'
    if get(g:, 'seoul256_current_bg', -1) ==# s:seoul_backgrounds.white
      let g:seoul256_light_background = s:seoul_backgrounds.off_white
      colorscheme seoul256-light
    else
      let g:seoul256_background = s:seoul_backgrounds.dark
      colorscheme seoul256
    endif
  else
    colorscheme nord
  endif
endfunction

function! s:Highlights() abort
  " The palette targets cterm because this configuration is for terminal Vim.
  highlight LineNr ctermbg=NONE
  highlight CursorLine gui=underline cterm=underline ctermbg=NONE
  highlight Comment ctermfg=103
  highlight Visual cterm=reverse ctermbg=7
  highlight Folded ctermfg=105 ctermbg=NONE cterm=italic
  highlight MatchParen ctermbg=darkgrey guibg=darkgrey
  if &background ==# 'dark'
    highlight Search ctermbg=NONE ctermfg=105
  else
    highlight Search ctermbg=229 ctermfg=NONE
  endif
endfunction
call s:Highlights()

" # EDITOR OPTIONS

set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:-
set shortmess=filnxtToOF
set smartcase ignorecase
set noincsearch
set nowrap
set relativenumber
set spelllang=en,fr
if filereadable('/usr/share/dict/words')
  set dictionary=spell,/usr/share/dict/words
else
  set dictionary=spell
endif
set completeopt=menu,preview
set shiftround
" Reloading must not overwrite filetype-local indentation or prose width.
setglobal autoindent expandtab
setglobal shiftwidth=4 softtabstop=-1 tabstop=4 textwidth=0
if empty(&l:filetype)
  setlocal autoindent expandtab
  setlocal shiftwidth=4 softtabstop=-1 tabstop=4 textwidth=0
endif
set laststatus=2
set ruler showcmd
" Modelines are disabled because opening an untrusted file must not execute or
" alter local configuration.
set nomodeline
let &g:undofile = s:undo_ready
let &l:undofile = s:undo_ready && !get(b:, 'vim_sensitive_buffer', 0)
" Native find searches below :pwd; note ftplugins may supply their own scope.
set path=**
set wildmenu
set wildmode=full
" Allow command-line mappings to invoke native completion.
set wildcharm=<Tab>
set mouse=

set listchars=tab:>\ ,trail:-
set switchbuf+=uselast
set ttimeout
" Older macOS terminfo lacks the capabilities Vim needs to detect pasted text.
if !has('gui_running') && empty(&t_BE)
      \ && &term =~# '^\%(screen\|tmux\|xterm\)'
  let &t_BE = "\<Esc>[?2004h"
  let &t_BD = "\<Esc>[?2004l"
  let &t_PS = "\<Esc>[200~"
  let &t_PE = "\<Esc>[201~"
endif
if exists('$SSH_CONNECTION') || exists('$SSH_TTY') || exists('$MOSH_CONNECTION')
  set ttimeoutlen=250
else
  set ttimeoutlen=0
endif
set history=1000
set belloff=all

" # SEARCH AND NAVIGATION

" Vim and ripgrep use different glob syntax for the same directory exclusions.
let s:ignored_directories = ['.git', 'node_modules', 'vendor', 'dist', 'build', 'target']
let s:wildignore_patterns = []
for s:directory in s:ignored_directories
  call extend(s:wildignore_patterns,
        \ [s:directory . '/*', '*/' . s:directory . '/*'])
endfor
let &wildignore = join(s:wildignore_patterns, ',')
unlet s:wildignore_patterns s:directory

set tags=./tags;
if executable('rg')
  " Search project dotfiles while excluding VCS, dependency, and build trees.
  let &grepprg = shellescape(exepath('rg')) . ' --vimgrep --smart-case --hidden'
  for s:directory in s:ignored_directories
    let &grepprg .= ' --glob ' . shellescape('!**/' . s:directory . '/**')
  endfor
  unlet s:directory
  set grepformat=%f:%l:%c:%m
endif

" # AUTOCOMMANDS

augroup personal_config
  autocmd!
  autocmd ColorScheme * call <SID>Highlights()
  autocmd QuickFixCmdPost grep,grepadd cwindow
augroup END

" # MAPPINGS

source ~/.vim/mappings.vim
nnoremap <silent> glco :call <SID>ToggleColorscheme()<CR>
