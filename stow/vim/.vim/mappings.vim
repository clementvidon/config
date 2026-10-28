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
  " Keep English abbreviations independent of the system's time locale.
  let l:days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  let l:months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        \ 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  let l:date = l:days[str2nr(strftime('%w', l:now))] . ' '
        \ . strftime('%d', l:now) . ' '
        \ . l:months[str2nr(strftime('%m', l:now)) - 1] . ' '
        \ . strftime('%Y', l:now)
  let l:dates = [l:date, strftime('%y%m%d', l:now),
        \ l:date . strftime(' at %H:%M', l:now), strftime('%y%m%d%H%M%S', l:now)]
  let l:menu = ['Insert date (1-4, Esc cancels):']
  for l:index in range(len(l:dates))
    call add(l:menu, printf('%d. %s', l:index + 1, l:dates[l:index]))
  endfor
  " Consume the next key directly so glpd1 works without an Enter key.
  let l:choice = vim_config#popup#show(l:menu)
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

function! s:CycleColorscheme() abort
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
  echomsg 'Colorscheme: ' . get(g:, 'colors_name', 'unknown')
endfunction

function! s:OpenNote(path, pattern) abort
  let l:search = @/
  execute 'edit ' . fnameescape(a:path)
  if !empty(a:pattern)
    call search(a:pattern, 'b')
    normal! zt
  endif
  let @/ = l:search
endfunction

function! s:VisualText() abort
  " Vim 8.2 lacks getregion(); preserve registers around a temporary yank.
  let l:view = winsaveview()
  let l:clipboard = &clipboard
  let l:unnamed = getreginfo('"')
  let l:yank = getreginfo('0')
  let l:temporary = getreginfo('z')
  try
    let &clipboard = ''
    normal! gv"zy
    return getreg('z')
  finally
    call setreg('z', l:temporary)
    call setreg('0', l:yank)
    call setreg('"', l:unnamed)
    let &clipboard = l:clipboard
    call winrestview(l:view)
  endtry
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
" Reminder : '*' does not match '/'; use 'foo/*/bar', not 'foo*bar'
nnoremap sf  :find<Space>
nnoremap ssf :find!<Space>
nnoremap shf :sfind<Space>
nnoremap svf :vertical sfind<Space>

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

let g:vim_vocabulary_root = empty($NOESIS_ROOT) ? expand('~/noesis') : expand($NOESIS_ROOT)

nnoremap <silent> sn  <nop>
nnoremap <silent> sne :call <SID>OpenNote(g:vim_vocabulary_root . '/english.md', '##  Voca')<CR>
nnoremap <silent> snf :call <SID>OpenNote(g:vim_vocabulary_root . '/french.md', '##  Voca')<CR>
nnoremap <silent> snt :<C-U>execute 'AchieverOpen ' . fnameescape(empty($TODOS_FILE) ? expand('~/todos.md') : $TODOS_FILE)<CR>
nnoremap <silent> snn :call <SID>OpenNote(empty($NOTES_FILE) ? expand('~/notes.md') : $NOTES_FILE, '')<CR>

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
nnoremap <silent> glcc :set cursorcolumn!<CR>:echomsg 'cursorcolumn: ' . (&cursorcolumn ? 'enabled' : 'disabled')<CR>
nnoremap glcd :cd %:h<CR>
nnoremap <silent> gldm :<C-U>call vim_config#git#diff_main()<CR>
nnoremap <silent> glen :<C-U>call vim_config#llm#to_english(getline('.'))<CR>
xnoremap <silent> glen :<C-U>call vim_config#llm#to_english(<SID>VisualText())<CR>
nnoremap <silent> glfr :<C-U>call vim_config#llm#to_french(getline('.'))<CR>
xnoremap <silent> glfr :<C-U>call vim_config#llm#to_french(<SID>VisualText())<CR>
nnoremap <silent> glco :call <SID>CycleColorscheme()<CR>
nnoremap <silent> glcl :set cursorline!<CR>:echomsg 'cursorline: ' . (&cursorline ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glgb :<C-U>call vim_config#git#blame_line()<CR>
nnoremap <silent> glhl :set hls!<CR>:echomsg 'hlsearch: ' . (&hlsearch ? 'enabled' : 'disabled')<CR>
nnoremap gllc :lc %:h<CR>
nnoremap <silent> glli :set list!<CR>:echomsg 'list: ' . (&list ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glnu :set relativenumber!<CR>:echomsg 'relativenumber: ' . (&relativenumber ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glpd :<C-U>call <SID>PutDate()<CR>
nnoremap <silent> glsb :set scrollbind!<CR>:echomsg 'scrollbind: ' . (&scrollbind ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glsc :let &scrolloff = &scrolloff == 0 ? 999 : 0<CR>:echomsg 'scrolloff: ' . (&scrolloff ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glsp :set spell!<CR>:echomsg 'spell: ' . (&spell ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glss :call vim_config#search#static_prompt()<CR>
vnoremap <silent> glss :<C-U>call vim_config#search#static_selection()<CR>
nnoremap <silent> glst :set startofline!<CR>:echomsg 'startofline: ' . (&startofline ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glsy :call <SID>ShowSyntax()<CR>
nnoremap glts :%s/\s\+$//e<CR>
nnoremap <silent> glve :let &l:virtualedit = &l:virtualedit ==# 'all' ? '' : 'all'<CR>:echomsg 'virtualedit: ' . (&l:virtualedit ==# 'all' ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glvo :<C-U>call job_start(['code', '-r', '-g', expand('%:p') . ':' . line('.')], {'in_io': 'null', 'stoponexit': ''})<CR>
nnoremap <silent> glwr :setlocal wrap!<CR>:echomsg 'wrap: ' . (&wrap ? 'enabled' : 'disabled')<CR>
nnoremap <silent> glmk :<C-U>call vim_config#buffer#make_temp()<CR>
nnoremap <silent> gllm :<C-U>call vim_config#llm#menu()<CR>

" # INTERFACE

" ## file tree

nnoremap <silent> <Leader>t :<C-U>Lexplore<CR>:echomsg 'Tree: ' . (exists('t:netrw_lexbufnr') && bufwinnr(t:netrw_lexbufnr) > 0 ? 'enabled' : 'disabled')<CR>
nnoremap <Leader>T :Lexplore<Space>

" ## clipboard

nnoremap <silent> <Leader>y :call vim_config#clipboard#copy()<CR>
nnoremap <silent> <Leader>p :call vim_config#clipboard#paste()<CR>

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

" ## guard rails

nnoremap Q :echo "!Q"<CR>

cnoremap <C-U> <Nop>
inoremap <C-U> <Nop>
