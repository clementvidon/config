" Personal mappings and the small helpers used only by them.
scriptencoding utf-8

" # PRIVATE HELPERS

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

function! s:PutDate() abort
  let l:now = localtime()
  let l:dates = map(['%a %d %b %Y', '%y%m%d', '%a %d %b %Y at %H:%M', '%y%m%d%H%M%S'],
        \ 'strftime(v:val, l:now)')
  let l:menu = ['Insert date (1-4, Esc cancels):']
  for l:index in range(len(l:dates))
    call add(l:menu, printf('%d. %s', l:index + 1, l:dates[l:index]))
  endfor
  try
    redraw
    echo join(l:menu, "\n")
    " Consume the next key directly so glpd1 works without an Enter key.
    let l:choice = getcharstr()
  finally
    redraw
    echo ''
  endtry
  if l:choice =~# '^[1-4]$'
    call append(line('.'), l:dates[str2nr(l:choice) - 1])
    call cursor(line('.') + 1, 1)
  endif
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

function! s:ToggleColorscheme() abort
  if get(g:, 'colors_name', '') ==# 'nord'
    let g:seoul256_light_background = 256
    colorscheme seoul256-light
  elseif get(g:, 'colors_name', '') ==# 'seoul256-light'
    if get(g:, 'seoul256_current_bg', -1) ==# 256
      let g:seoul256_light_background = 252
      colorscheme seoul256-light
    else
      colorscheme seoul256
    endif
  else
    colorscheme nord
  endif
endfunction

function! s:OpenNote(relative, pattern) abort
  let l:search = @/
  execute 'edit ' . fnameescape(g:noesis_root . '/' . a:relative)
  if !empty(a:pattern)
    call search(a:pattern, 'b')
    normal! zt
  endif
  let @/ = l:search
endfunction

function! s:OpenTasks() abort
  let l:search = @/
  execute 'edit ' . fnameescape(g:noesis_root . '/Achiever/todos.md')
  normal! gg0
  call search('\s\d\{6}\s', 'w')
  normal! 0zz
  let @/ = l:search
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

nnoremap <silent> mso :<C-U>call vim_config#reload()<CR>

" ## find and edit

nnoremap s <nop>

" The vertical Ex-command prefixes intentionally stay open for Tab completion.
nnoremap se  :e<Space>
nnoremap sse :e!<Space>
nnoremap she :sp<Space>
nnoremap sve :vert sp<Space>

nnoremap sp :e #<CR>
nnoremap shp :sp #<CR>
nnoremap svp :vert sp #<CR>

nnoremap sb :ls<CR>:b<Space>

" ## personal notes

nnoremap <silent> sn  <nop>
nnoremap <silent> sne :call <SID>OpenNote('english.md', '##  Voca')<CR>
nnoremap <silent> snf :call <SID>OpenNote('french.md', '##  Voca')<CR>
nnoremap <silent> snt :call <SID>OpenTasks()<CR>
nnoremap <silent> snh :call <SID>OpenNote('.todos.gpg.md', '')<CR>
nnoremap <silent> snj :call <SID>OpenNote('journal.gpg.md', '')<CR>
nnoremap <silent> snn :call <SID>OpenNote('notes.md', '')<CR>

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

nnoremap <silent> sg :call vim_config#search#grep_prompt(0)<CR>
vnoremap <silent> sg :<C-U>call vim_config#search#grep_prompt(1)<CR>

" # OPTIONS AND COMMANDS

nnoremap gl <nop>
nnoremap glcc :set cursorcolumn!<CR>:set cursorcolumn?<CR>
nnoremap glcd :cd %:h<CR>
nnoremap <silent> glco :call <SID>ToggleColorscheme()<CR>
nnoremap glcl :set cursorline!<CR>:set cursorline?<CR>
nnoremap glhl :set hls!<CR>:set hls?<CR>
nnoremap gllc :lc %:h<CR>
nnoremap glli :set list!<CR>:set list?<CR>
nnoremap glnu :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap <silent> glpd :<C-U>call <SID>PutDate()<CR>
nnoremap glsb :set scrollbind!<CR>:set scrollbind?<CR>
nnoremap glsc :exec ':set scrolloff=' . 999*(&scrolloff == 0)<CR>
nnoremap glsp :set spell!<CR>:set spell?<CR>
nnoremap <silent> glss :call vim_config#search#static_prompt()<CR>
vnoremap <silent> glss :<C-U>call vim_config#search#static_selection()<CR>
nnoremap glst :set startofline!<CR>:set startofline?<CR>
nnoremap <silent> glsy :call <SID>ShowSyntax()<CR>
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

nnoremap <silent> <Space>= :call <SID>IndentBuffer()<CR>

" ## clipboard

nnoremap <silent> <Leader>y :call vim_config#clipboard#copy()<CR>
nnoremap <silent> <Leader>p :call vim_config#clipboard#paste()<CR>

" ## guard rails

nnoremap Q :echo "!Q"<CR>

cnoremap <C-U> <Nop>
inoremap <C-U> <Nop>
