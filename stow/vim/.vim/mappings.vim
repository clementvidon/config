" Personal mappings and the small helpers used only by them.
scriptencoding utf-8

"   private helpers

function! s:FindPrompt(command) abort
  let l:extension = expand('%:e')
  let l:suffix = empty(l:extension) ? '' : '.' . fnameescape(l:extension)
  return ':' . a:command . ' **' . l:suffix
        \ . repeat("\<Left>", strchars(l:suffix) + 1)
endfunction

function! s:CompleteFind() abort
  " Completion only sees text before the cursor, including the suffix filter.
  if getcmdtype() ==# ':' && getcmdpos() <= strlen(getcmdline())
        \ && getcmdline() =~# '^\%(find!\?\|tabfind\|sfind\|vertical sfind\)\s'
    return "\<End>\<Tab>"
  endif
  return "\<Tab>"
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

function! s:CalculateLine() abort
  let l:expression = substitute(getline('.'), ',', '.', 'g')
  let l:number = '\%(\d\+\%(\.\d*\)\?\|\.\d\+\)\%([eE][+-]\?\d\+\)\?'
  " Only arithmetic tokens may reach eval(); never execute text from a file.
  if empty(trim(l:expression))
        \ || substitute(l:expression, l:number . '\|[-+*/() \t]', '', 'g') !=# ''
    echoerr 'Calculator: use numbers, parentheses and + - * /'
    return
  endif
  " Floats avoid integer division and octal interpretation of leading zeros.
  let l:expression = substitute(l:expression, l:number,
        \ '\=printf("%.17e", str2float(submatch(0)))', 'g')
  try
    sandbox let l:result = eval(l:expression)
    if type(l:result) != v:t_float || isinf(l:result) || isnan(l:result)
      throw 'Invalid or non-finite result'
    endif
  catch
    echoerr 'Calculator: invalid expression or non-finite result'
    return
  endtry
  let l:parts = split(printf('%.12g', l:result), 'e', 1)
  let l:parts[0] = substitute(l:parts[0], '0\+$', '', '')
  let l:parts[0] = substitute(l:parts[0], '\.$', '', '')
  call setline('.', matchstr(getline('.'), '^\s*') . join(l:parts, 'e'))
endfunction

function! s:Clipboard(action) abort
  if !executable('clipboard')
    echoerr 'Install the scripts Stow package and add ~/.local/bin to PATH'
    return
  endif
  let l:command = shellescape(exepath('clipboard')) . ' ' . a:action
  let l:text = a:action ==# 'copy'
        \ ? system(l:command, getreg('"')) : system(l:command)
  if v:shell_error
    echoerr 'Clipboard ' . a:action . ' failed; check providers or use terminal paste over SSH'
    return
  endif
  if a:action ==# 'paste'
    " The expression register preserves the user's yank/delete registers.
    call setreg('=', string(l:text))
    execute "normal! \"=\<CR>p"
  endif
endfunction

function! s:GrepPrompt(word) abort
  if !executable('rg')
    throw 'Search requires ripgrep (rg) on PATH'
  endif
  if a:word
    return ':grep! --fixed-strings --word-regexp -- '
          \ . shellescape(expand('<cword>'), 1) . "\<CR>:cwindow\<CR>"
  endif
  return ':grep '
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
nnoremap <expr> sf  <SID>FindPrompt('find')
nnoremap <expr> ssf <SID>FindPrompt('find!')
nnoremap <expr> sTf <SID>FindPrompt('tabfind')
nnoremap <expr> shf <SID>FindPrompt('sfind')
nnoremap <expr> svf <SID>FindPrompt('vertical sfind')

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

"     buffer list
nnoremap sb :ls<CR>:b<Space>

"     navigation
nnoremap [b :<C-U>execute v:count1 . 'bprevious'<CR>
nnoremap ]b :<C-U>execute v:count1 . 'bnext'<CR>
nnoremap [l :<C-U>execute v:count1 . 'lprevious'<CR>
nnoremap ]l :<C-U>execute v:count1 . 'lnext'<CR>
nnoremap [q :<C-U>execute v:count1 . 'cprevious'<CR>
nnoremap ]q :<C-U>execute v:count1 . 'cnext'<CR>

"     tags
nnoremap st :tag /
nnoremap sij :ijump /
nnoremap sil :ilist /
nnoremap sis :isearch /

"     search
nnoremap <expr> sg <SID>GrepPrompt(0)
nnoremap <expr> sgr <SID>GrepPrompt(1)

"   option and command helpers

nnoremap gl <nop>
nnoremap <silent> glbc :call <SID>CalculateLine()<CR>
nnoremap glcc :set cursorcolumn!<CR>:set cursorcolumn?<CR>
nnoremap glcd :cd %:h<CR>
nnoremap glcl :set cursorline!<CR>:set cursorline?<CR>
nnoremap glhl :set hls!<CR>:set hls?<CR>
nnoremap gllc :lc %:h<CR>
nnoremap glli :set list!<CR>:set list?<CR>
nnoremap glv :let &virtualedit = &virtualedit ==# 'all' ? '' : 'all'<CR>:set virtualedit?<CR>
nnoremap glnu :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap glpd :put=strftime('%a %d %b %Y')<CR>
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

"     clipboard
nnoremap <silent> <Leader>y :call <SID>Clipboard('copy')<CR>
nnoremap <silent> <Leader>p :call <SID>Clipboard('paste')<CR>

"     guard rails
nnoremap Q :echo "!Q"<CR>

"     command-line guard
cnoremap <expr> <Tab> <SID>CompleteFind()
cnoremap <C-U> <Nop>
inoremap <C-U> <Nop>

nnoremap <space>z <C-z>
nnoremap <space>r <C-r>
" Do not mirror CTRL-O/CTRL-I here; keep the native jump-list keys direct.
nnoremap <space>v <C-v>
nnoremap <space>u <C-u>
nnoremap <space>d <C-d>
