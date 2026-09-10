" Personal mappings and the small helpers used only by them.
scriptencoding utf-8

"   private helpers

function! s:ToggleNavigation(next, previous) abort
  if exists('s:navigation_mappings')
    silent! nunmap gn
    silent! nunmap gp
    for l:mapping in s:navigation_mappings
      if !empty(l:mapping)
        call mapset('n', 0, l:mapping)
      endif
    endfor
    unlet s:navigation_mappings
    echo 'Custom navigation off'
    return
  endif

  let s:navigation_mappings = [maparg('gn', 'n', 0, 1), maparg('gp', 'n', 0, 1)]
  execute 'nnoremap gn ' . a:next . '<CR>'
  execute 'nnoremap gp ' . a:previous . '<CR>'
  echo 'Custom navigation on'
endfunction

function! s:ShowSyntax() abort
  let l:syntax = synID(line('.'), col('.'), 1)
  let l:name = synIDattr(l:syntax, 'name')
  let l:resolved = synIDattr(synIDtrans(l:syntax), 'name')
  if empty(l:name) || empty(l:resolved)
    echo 'No syntax group'
    return
  endif
  echo l:name
  execute 'highlight ' . l:resolved
endfunction

function! s:Rot13Buffer() abort
  let l:view = winsaveview()
  let l:spell = &l:spell
  try
    setlocal nospell
    normal! ggg?G
  finally
    let &l:spell = l:spell
    call winrestview(l:view)
  endtry
endfunction

function! s:SaveReloadView() abort
  let w:vim_reload_view = winsaveview()
endfunction

function! s:RestoreReloadView() abort
  if exists('w:vim_reload_view')
    let l:view = w:vim_reload_view
    unlet w:vim_reload_view
    call winrestview(l:view)
  endif
endfunction

function! s:IndentBuffer() abort
  let l:view = winsaveview()
  try
    normal! gg=G
  finally
    call winrestview(l:view)
  endtry
endfunction

function! s:AddHeader() abort
  let l:comment = &commentstring
  if empty(l:comment) || l:comment !~# '%s'
    throw 'No commentstring defined for this buffer'
  endif
  let l:date = strftime('%y%m%d')
  call append(0, [
        \ substitute(l:comment, '%s', ' ' . expand('%:p:h:t') . '/' . expand('%:t:r') . ' ', ''),
        \ substitute(l:comment, '%s', ' Created: ' . l:date, ''),
        \ substitute(l:comment, '%s', ' Updated: ' . l:date, ''),
        \ substitute(l:comment, '%s', ' Author: Clément Vidon (clementvidon)', ''),
        \ '',
        \ ])
endfunction

function! s:CopyRegister() abort
  if has('clipboard')
    call setreg('+', getreg('"'), getregtype('"'))
  elseif executable('pbcopy') || executable('wl-copy') || executable('xclip')
    if executable('pbcopy')
      let l:clipboard_command = 'LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 pbcopy'
    elseif executable('wl-copy')
      let l:clipboard_command = 'wl-copy'
    else
      let l:clipboard_command = 'xclip -selection clipboard'
    endif
    call system(l:clipboard_command, getreg('"'))
    if v:shell_error
      echoerr 'Clipboard copy failed'
    endif
  else
    echoerr 'No clipboard provider available'
  endif
endfunction

"   files and buffers

nnoremap s  <nop>
nnoremap gs <nop>
nnoremap sT <nop>
nnoremap sh <nop>
nnoremap sv <nop>

"     write / quit
nnoremap mw  :write<CR>
nnoremap mvv :W<CR>
nnoremap mmw :write!<CR>
nnoremap mW  :wall<CR>
nnoremap mmW :wall!<CR>
nnoremap mq  :quit<CR>
nnoremap mmq :quit!<CR>
nnoremap mQ  :quitall<CR>
nnoremap mmQ :quitall!<CR>
nnoremap md  :bn\|bd#<CR>
nnoremap mmd :bn!\|bd! #<CR>
nnoremap me  :e<CR>
nnoremap mme :e!<CR>
" Source outside the helpers so mappings.vim can redefine them during reload.
nnoremap <silent> mso :call <SID>SaveReloadView()<CR>:try<CR>:write<CR>:source $HOME/.vimrc<CR>:edit<CR>:finally<CR>:call <SID>RestoreReloadView()<CR>:endtry<CR>

"     find
nnoremap sf  :fin<Space>
nnoremap ssf :fin!<Space>
nnoremap sTf :tabf<Space>
nnoremap shf :sf<Space>
nnoremap svf :vert sf<Space>

"     edit
" The vertical Ex-command prefixes intentionally stay open for Tab completion.
nnoremap se  :e<Space>
nnoremap sse :e!<Space>
nnoremap sTe :tabe<Space>
nnoremap she :sp<Space>
nnoremap sve :vert sp<Space>

"     previous
nnoremap sp :e #<CR>
nnoremap sTp :tabe #<CR>
nnoremap shp :sp #<CR>
nnoremap svp :vert sp #<CR>

"     edit from buffer directory
nnoremap s.  :lc %:h<CR>:e<Space>
nnoremap ss. :lc %:h<CR>:e!<Space>
nnoremap sT. :lc %:h<CR>:tabe<Space>
nnoremap sh. :lc %:h<CR>:sp<Space>
nnoremap sv. :lc %:h<CR>:vert sp<Space>

"     buffer list
nnoremap sb :ls<CR>:b<Space>

"     tags
nnoremap st :tag /
nnoremap sij :ijump /
nnoremap sil :ilist /
nnoremap sis :isearch /

"     search
nnoremap sg :grep<Space>
nnoremap sgr :execute 'grep! --word-regexp -- ' . shellescape(expand('<cword>'))<CR>:cwindow<CR>

"   configuration
nnoremap <silent> sc  <nop>
nnoremap <silent> scv :e $MYVIMRC<CR>gi<Esc>
nnoremap <silent> scp :e $HOME/.vim/plugins.vim<CR>gi<Esc>
nnoremap <silent> scm :e $HOME/.vim/mappings.vim<CR>gi<Esc>
nnoremap <silent> sca :e $HOME/.config/alacritty/alacritty.toml<CR>gi<Esc>
nnoremap <silent> scz :e $HOME/.zshrc<CR>gi<Esc>
nnoremap <silent> sce :e $HOME/.zshenv<CR>gi<Esc>
nnoremap <silent> sct :e $HOME/.tmux.conf<CR>gi<Esc>

"   git

nnoremap <Leader>gg :echo system('
\
\ git status -s --show-stash --ignore-submodules=untracked &&
\ git diff -U0 \| grep "^+\\|^-" \| grep -v "^+++\\s\\|^---\\s" &&
\ echo "" && git log --oneline -5')
\\|echo "                                                                             Max len msg ↓"
\<CR>:!git add . && git commit --allow-empty -m ""<Left>

nnoremap <Leader>g? :!clear
\
\ && git status -s --show-stash --ignore-submodules=untracked
\ && git diff -U0 && git show -U0
\ && git log --oneline -10<CR>

nnoremap <Leader>gcm :echo system('git log --oneline -5')
\
\\|echo "                                                                   Max len msg ↓"
\<CR>:!git commit -m ""<Left>

nnoremap <Leader>gap :!clear && git add --patch<CR>
nnoremap <Leader>gau :!clear && git add --update && git status -s --show-stash --ignore-submodules=untracked<CR>
nnoremap <Leader>gca :!clear && git commit --amend<CR>
nnoremap <Leader>gco :!clear && git commit<CR>
nnoremap <Leader>gdi :!clear && git diff<CR>
nnoremap <Leader>gds :!clear && git diff --staged<CR>
nnoremap <Leader>glo :!clear && git log --oneline -10<CR>
nnoremap <Leader>gre :!clear && git restore<Space>
nnoremap <Leader>grs :!clear && git reset<Space>
nnoremap <Leader>gsh :!clear && git show<CR>
nnoremap <Leader>gst :!clear && git status -s --show-stash --ignore-submodules=untracked<CR>

"   option and command helpers

nnoremap gl <nop>
nnoremap glbc V:!bc<CR>
nnoremap glbn :call <SID>ToggleNavigation(':bnext', ':bprev')<CR>
nnoremap glcc :set cursorcolumn!<CR>:set cursorcolumn?<CR>
nnoremap glcd :cd %:h<CR>
nnoremap glcl :set cursorline!<CR>:set cursorline?<CR>
vnoremap glen :'<,'>!trans -b :fr
nnoremap glex :exe getline(".")<CR>
vnoremap glfr :'<,'>!trans -b :en
nnoremap glhl :set hls!<CR>:set hls?<CR>
nnoremap gllc :lc %:h<CR>
nnoremap glli :set list!<CR>:set list?<CR>
nnoremap glve :set virtualedit=all
nnoremap glln :call <SID>ToggleNavigation(':lnext', ':lprev')<CR>
nnoremap glnu :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap glpd :put=strftime('%a %d %b %Y')<CR>
nnoremap glqn :call <SID>ToggleNavigation(':cnext', ':cprev')<CR>
nnoremap glsb :set scrollbind!<CR>:set scrollbind?<CR>
nnoremap glsc :exec ':set scrolloff=' . 999*(&scrolloff == 0)<CR>
nnoremap glsp :set spell!<CR>:set spell?<CR>
nnoremap glss :StaticSearch<Space>
nnoremap glst :set startofline!<CR>:set startofline?<CR>
nnoremap glsy :call <SID>ShowSyntax()<CR>
nnoremap glts :put=strftime('%y%m%d%H%M%S')<CR>

"   interface

"     windows (CTRL-W aemABCDE G I MNO Q UVWXYZ)

nnoremap <Leader>w <C-W>
nnoremap <Leader>wM <C-W>_<C-W><BAR>
nnoremap <Leader>wX <C-W>x<C-W>_<C-W><BAR>
tnoremap <Leader>w <C-W>
tnoremap <Leader>wM <C-W>_<C-W><BAR>
tnoremap <Leader>wX <C-W>x<C-W>_<C-W><BAR>
"     grow split size
nnoremap <Leader>wE :resize <C-R>=&lines * 0.66<CR><CR>
nnoremap <Leader>we :vertical resize <C-R>=&columns * 0.66<CR><CR>
nnoremap <S-Left> <C-W>5<
nnoremap <S-Up> <C-W>5+
nnoremap <S-Right> <C-W>5>
nnoremap <S-Down> <C-W>5-
tnoremap <S-Left> <C-W><
tnoremap <S-Up> <C-W>+
tnoremap <S-Right> <C-W>>
tnoremap <S-Down> <C-W>-

"     command line
nnoremap x :

"     eye-level cursor
nnoremap z, z.15<C-e>

"     search
nnoremap g8 *N
nnoremap g3 #N

"     paste
vnoremap P pgvy

"     spell
nnoremap 2s 2z=
nnoremap 1s 1z=
inoremap <c-q> <c-g>u<esc>[s1z=`]a<c-g>u

"     indentation
nnoremap <silent> <Leader>= :call <SID>IndentBuffer()<CR>

"     transforms
nnoremap <silent> <Leader>? :call <SID>Rot13Buffer()<CR>

"     clipboard
nnoremap <silent> <Leader>y :call <SID>CopyRegister()<CR>

"     guard rails
nnoremap Q :echo "!Q"<CR>

"     header
nnoremap <Leader>H :call <SID>AddHeader()<CR>

inoremap jf <Esc>
inoremap fj <Esc>

"     command-line guard
cnoremap <C-U> <Nop>

if has('clipboard')
  nnoremap <space>p "+p
endif

nnoremap <space>z <C-z>
nnoremap <space>r <C-r>
" Do not mirror CTRL-O/CTRL-I here; keep the native jump-list keys direct.
nnoremap <space>v <C-v>
nnoremap <space>u <C-u>
nnoremap <space>d <C-d>

"     prefixed normal commands

" Move the rest of the line down without entering Insert mode afterward.
nnoremap <space>o i<CR><Esc><S-j>

nnoremap <space>sq Q
nnoremap <space>sw W
nnoremap <space>se E
nnoremap <space>sr R
nnoremap <space>st T
nnoremap <space>sy Y
nnoremap <space>su U
nnoremap <space>si I
nnoremap <space>so O
nnoremap <space>sp P
nnoremap <space>sa A
nnoremap <space>ss S
nnoremap <space>sd D
nnoremap <space>sf F
nnoremap <space>sg G
nnoremap <space>sh H
nnoremap <space>sj J
nnoremap <space>sk K
nnoremap <space>sl L
nnoremap <space>sz Z
nnoremap <space>sx X
nnoremap <space>sc C
nnoremap <space>sv V
nnoremap <space>sb B
nnoremap <space>sn N
nnoremap <space>sm M

nnoremap <space>s` ~
nnoremap <space>s1 !
nnoremap <space>s2 @
nnoremap <space>s3 #
nnoremap <space>s4 $
nnoremap <space>s5 %
nnoremap <space>s6 ^
nnoremap <space>s7 &
nnoremap <space>s8 *
nnoremap <space>s9 (
nnoremap <space>s0 )
nnoremap <space>s- _
nnoremap <space>s= +

nnoremap <space>s[ {
nnoremap <space>s] }
nnoremap <space>s<BS> <BAR>
nnoremap <space>s; :
nnoremap <space>s' "
nnoremap <space>s, <
nnoremap <space>s. >
nnoremap <space>s/ ?
