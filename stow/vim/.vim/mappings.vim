" Personal mappings and the small helpers used only by them.
scriptencoding utf-8

" # PRIVATE HELPERS

function! s:SelectedText() abort
  let l:unnamed = getreginfo('"')
  let l:yank = getreginfo('0')
  let l:clipboard = &clipboard
  let l:view = winsaveview()
  try
    " Extract with native selection semantics, without clipboard/yank hooks.
    set clipboard=
    silent noautocmd normal! gvy
    " V and v$ may include the selected line's final newline.
    let l:text = substitute(getreg('0'), '\n$', '', '')
  finally
    call setreg('0', l:yank)
    call setreg('"', l:unnamed)
    let &clipboard = l:clipboard
    call winrestview(l:view)
  endtry
  if empty(l:text) || l:text =~# '[[:cntrl:]]'
    throw 'Search: select text on one line, without control characters'
  endif
  return l:text
endfunction

function! s:StaticSearchSelection() abort
  let @/ = '\V' . escape(s:SelectedText(), '\')
  set hlsearch
  redraw!
endfunction

function! s:StaticSearchPrompt() abort
  let l:pattern = input('Static search: ')
  if empty(l:pattern)
    return
  endif
  let @/ = l:pattern
  set hlsearch
  redraw!
endfunction

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

function! s:IndentBuffer() abort
  let l:view = winsaveview()
  try
    normal! gg=G
  finally
    call winrestview(l:view)
  endtry
endfunction

function! s:PositionCursorAtQuarter() abort
  " Keep the cursor near eye level in windows of any height.
  let l:target = max([1, (winheight(0) + 3) / 4])
  normal! zt
  if l:target > 1
    execute 'normal! ' . (l:target - 1) . "\<C-Y>"
  endif
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

function! s:WriteAsRoot() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    throw 'Use :write for encrypted or sensitive files'
  endif
  if empty(expand('%'))
    throw 'No filename'
  endif
  execute 'write !sudo tee -- ' . shellescape(expand('%:p'), 1) . ' >/dev/null'
  if v:shell_error
    throw 'Privileged write failed; buffer left unchanged'
  endif
  edit!
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

function! s:GrepPrompt(visual) abort
  if !executable('rg')
    throw 'Search requires ripgrep (rg) on PATH'
  endif
  let l:command = ':grep '
  if a:visual
    let l:command .= ' -F -- ' . shellescape(s:SelectedText(), 1)
          \ . "\<Home>" . repeat("\<Right>", 5)
  endif
  " Queue the prompt before echoing so the help needs no hit-enter pause.
  call feedkeys(l:command, 'n')
  redraw
  if &lines < 12 || &columns < 60
    echo '-i sans casse | -s casse | -w mot | -F littéral'
  else
    echo join([
          \ 'Default            : smartcase + hidden',
          \ 'Search             :grep             hello',
          \ 'Ignore case        :grep -i          Hello',
          \ 'Match case         :grep -s          hello',
          \ 'Whole word         :grep -w          hello',
          \ 'Whole word, icase  :grep -iw         hello',
          \ 'Literal text       :grep -F         ''hello.json''',
          \ 'Skip hidden        :grep --no-hidden hello',
          \ 'Unrestricted       :grep -u          hello',
          \ ], "\n")
  endif
endfunction

" # FILES AND BUFFERS

" ## write and quit

nnoremap mw  :write<CR>
nnoremap <silent> mvv :call <SID>WriteAsRoot()<CR>
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

nnoremap <silent> mso :execute 'source ' . fnameescape($MYVIMRC)<CR>

" ## find and edit

nnoremap s <nop>
nnoremap <expr> sf  <SID>FindPrompt('find')
nnoremap <expr> ssf <SID>FindPrompt('find!')
nnoremap <expr> shf <SID>FindPrompt('sfind')
nnoremap <expr> svf <SID>FindPrompt('vertical sfind')

" The vertical Ex-command prefixes intentionally stay open for Tab completion.
nnoremap se  :e<Space>
nnoremap sse :e!<Space>
nnoremap she :sp<Space>
nnoremap sve :vert sp<Space>

nnoremap sp :e #<CR>
nnoremap shp :sp #<CR>
nnoremap svp :vert sp #<CR>

nnoremap sb :ls<CR>:b<Space>

" ## navigation and tags

nnoremap [b :<C-U>execute v:count1 . 'bprevious'<CR>
nnoremap ]b :<C-U>execute v:count1 . 'bnext'<CR>
nnoremap [l :<C-U>execute v:count1 . 'lprevious'<CR>
nnoremap ]l :<C-U>execute v:count1 . 'lnext'<CR>
nnoremap [q :<C-U>execute v:count1 . 'cprevious'<CR>
nnoremap ]q :<C-U>execute v:count1 . 'cnext'<CR>

nnoremap st :tag /
nnoremap sij :ijump /
nnoremap sil :ilist /
nnoremap sis :isearch /

" ## search

nnoremap <silent> sg :call <SID>GrepPrompt(0)<CR>
vnoremap <silent> sg :<C-U>call <SID>GrepPrompt(1)<CR>

" # OPTIONS AND COMMANDS

nnoremap gl <nop>
nnoremap <silent> glbc :call <SID>CalculateLine()<CR>
nnoremap glcc :set cursorcolumn!<CR>:set cursorcolumn?<CR>
nnoremap glcd :cd %:h<CR>
nnoremap glcl :set cursorline!<CR>:set cursorline?<CR>
nnoremap glhl :set hls!<CR>:set hls?<CR>
nnoremap gllc :lc %:h<CR>
nnoremap glli :set list!<CR>:set list?<CR>
nnoremap glnu :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap glpd :put=strftime('%a %d %b %Y')<CR>
nnoremap glsb :set scrollbind!<CR>:set scrollbind?<CR>
nnoremap glsc :exec ':set scrolloff=' . 999*(&scrolloff == 0)<CR>
nnoremap glsp :set spell!<CR>:set spell?<CR>
nnoremap <silent> glss :call <SID>StaticSearchPrompt()<CR>
vnoremap <silent> glss :<C-U>call <SID>StaticSearchSelection()<CR>
nnoremap glst :set startofline!<CR>:set startofline?<CR>
nnoremap <silent> glsy :call <SID>ShowSyntax()<CR>
nnoremap glts :put=strftime('%y%m%d%H%M%S')<CR>
nnoremap glve :let &virtualedit = &virtualedit ==# 'all' ? '' : 'all'<CR>:set virtualedit?<CR>

" # INTERFACE

" ## windows and splits

nnoremap <Leader>w <C-W>
nnoremap <Leader>wM <C-W>_<C-W><BAR>
nnoremap <Leader>wX <C-W>x<C-W>_<C-W><BAR>
tnoremap <Leader>w <C-W>
tnoremap <Leader>wM <C-W>_<C-W><BAR>
tnoremap <Leader>wX <C-W>x<C-W>_<C-W><BAR>

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

" ## command line

nnoremap x :

" ## cursor and editing

nnoremap <silent> z, :call <SID>PositionCursorAtQuarter()<CR>

vnoremap P pgvy

nnoremap 2s 2z=
nnoremap 1s 1z=
inoremap <c-q> <c-g>u<esc>[s1z=`]a<c-g>u

nnoremap <silent> <Leader>= :call <SID>IndentBuffer()<CR>

" ## clipboard

nnoremap <silent> <Leader>y :call <SID>Clipboard('copy')<CR>
nnoremap <silent> <Leader>p :call <SID>Clipboard('paste')<CR>

" ## guard rails

nnoremap Q :echo "!Q"<CR>

cnoremap <expr> <Tab> <SID>CompleteFind()
cnoremap <C-U> <Nop>
inoremap <C-U> <Nop>
