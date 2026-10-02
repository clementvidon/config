" Buffer-local editing behavior for Noesis notes.

" # LOAD GUARD

if exists('b:did_noesis_ftplugin')
  finish
endif
let b:did_noesis_ftplugin = 1
let b:noesis_local_leader = get(g:, 'maplocalleader', '\\')

" # BUFFER CONFIGURATION

setlocal suffixesadd+=.md
setlocal commentstring=
setlocal suffixesadd+=.gpg.md
setlocal path=.
let s:root = noesis#workspace_root()
if !empty(s:root)
  for s:directory in ['Achiever', 'Inbox', 'Systems', 'Knowledge', 'Projects']
    execute 'setlocal path+=' . fnameescape(s:root . '/' . s:directory . '/**')
  endfor
  unlet s:directory
endif
unlet s:root
setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
setlocal linebreak breakindent
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80
if has('conceal')
  setlocal conceallevel=3
  setlocal concealcursor=vn
endif

" # COMMANDS

command! -buffer -nargs=+ Grep call noesis#grep(<q-args>)

" # MAPPINGS

" Keep the personal indentation and formatting mappings out of note buffers.
vnoremap <silent><buffer> = <nop>
nnoremap <silent><buffer> = <nop>
nnoremap <silent><buffer> <Space>= <Nop>
xnoremap <silent><buffer> <Space>= <Nop>
vnoremap <silent><buffer> gq <nop>
nnoremap <silent><buffer> gq <nop>
nnoremap <silent><buffer> K <nop>
nnoremap <buffer><silent><expr> j v:count ? 'j' : 'gj'
nnoremap <buffer><silent><expr> k v:count ? 'k' : 'gk'
vnoremap <buffer><silent><expr> j v:count ? 'j' : 'gj'
vnoremap <buffer><silent><expr> k v:count ? 'k' : 'gk'

" # DEFAULT MAPPINGS

let b:noesis_default_maps = []
if !get(g:, 'noesis_no_mappings', 0)
  nnoremap <buffer> <LocalLeader>h :map <lt>LocalLeader><CR>
  nnoremap <buffer> <LocalLeader> <Nop>
  xnoremap <buffer> <LocalLeader> <Nop>
  let b:noesis_default_maps = [["n", ""], ["x", ""], ["n", "h"]]
  nmap <buffer> <LocalLeader>x <Plug>(noesis-export)
  call add(b:noesis_default_maps, ["n", "x"])
  nmap <buffer> <LocalLeader>g <Plug>(noesis-index)
  call add(b:noesis_default_maps, ["n", "g"])
  nmap <buffer> <LocalLeader>j <Plug>(noesis-index-jump)
  call add(b:noesis_default_maps, ["n", "j"])
  nmap <buffer> <LocalLeader>e <Plug>(noesis-translate-en)
  call add(b:noesis_default_maps, ["n", "e"])
  xmap <buffer> <LocalLeader>e <Plug>(noesis-translate-en)
  call add(b:noesis_default_maps, ["x", "e"])
  nmap <buffer> <LocalLeader>f <Plug>(noesis-translate-fr)
  call add(b:noesis_default_maps, ["n", "f"])
  xmap <buffer> <LocalLeader>f <Plug>(noesis-translate-fr)
  call add(b:noesis_default_maps, ["x", "f"])
  xmap <buffer> <LocalLeader>s <Plug>(noesis-synonym)
  call add(b:noesis_default_maps, ["x", "s"])
  nmap <buffer> <LocalLeader>1 <Plug>(noesis-heading-1)
  call add(b:noesis_default_maps, ["n", "1"])
  nmap <buffer> <LocalLeader>2 <Plug>(noesis-heading-2)
  call add(b:noesis_default_maps, ["n", "2"])
  nmap <buffer> <LocalLeader>3 <Plug>(noesis-heading-3)
  call add(b:noesis_default_maps, ["n", "3"])
  nmap <buffer> <LocalLeader>4 <Plug>(noesis-heading-4)
  call add(b:noesis_default_maps, ["n", "4"])
  nmap <buffer> <LocalLeader>5 <Plug>(noesis-heading-5)
  call add(b:noesis_default_maps, ["n", "5"])
  nmap <buffer> <LocalLeader>6 <Plug>(noesis-heading-6)
  call add(b:noesis_default_maps, ["n", "6"])
  nmap <buffer> <LocalLeader>i <Plug>(noesis-italic)
  call add(b:noesis_default_maps, ["n", "i"])
  xmap <buffer> <LocalLeader>i <Plug>(noesis-italic)
  call add(b:noesis_default_maps, ["x", "i"])
  nmap <buffer> <LocalLeader>b <Plug>(noesis-bold)
  call add(b:noesis_default_maps, ["n", "b"])
  xmap <buffer> <LocalLeader>b <Plug>(noesis-bold)
  call add(b:noesis_default_maps, ["x", "b"])
  nmap <buffer> <LocalLeader>c <Plug>(noesis-code)
  call add(b:noesis_default_maps, ["n", "c"])
  xmap <buffer> <LocalLeader>c <Plug>(noesis-code)
  call add(b:noesis_default_maps, ["x", "c"])
  nmap <buffer> <LocalLeader>l <Plug>(noesis-link)
  call add(b:noesis_default_maps, ["n", "l"])
  xmap <buffer> <LocalLeader>l <Plug>(noesis-link)
  call add(b:noesis_default_maps, ["x", "l"])
  nmap <buffer> <LocalLeader>q <Plug>(noesis-quote)
  call add(b:noesis_default_maps, ["n", "q"])
  xmap <buffer> <LocalLeader>q <Plug>(noesis-quote)
  call add(b:noesis_default_maps, ["x", "q"])
endif

" # UNDO

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'setlocal suffixesadd< commentstring< path< foldmethod< foldmarker<'
      \ . ' linebreak< breakindent< expandtab< shiftwidth< softtabstop<'
      \ . ' tabstop< textwidth< conceallevel< concealcursor<'
      \ . '|silent! delcommand -buffer Grep'
      \ . '|unlet! b:did_noesis_ftplugin b:noesis_local_leader'
      \ . '|silent! vunmap <buffer> ='
      \ . '|silent! nunmap <buffer> ='
      \ . '|silent! vunmap <buffer> gq'
      \ . '|silent! nunmap <buffer> gq'
      \ . '|silent! nunmap <buffer> <Space>='
      \ . '|silent! xunmap <buffer> <Space>='
      \ . '|silent! nunmap <buffer> K'
      \ . '|silent! nunmap <buffer> j'
      \ . '|silent! nunmap <buffer> k'
      \ . '|silent! vunmap <buffer> j'
      \ . '|silent! vunmap <buffer> k'
for [s:mode, s:key] in b:noesis_default_maps
  let b:undo_ftplugin .= '|silent! ' . s:mode . 'unmap <buffer> '
        \ . substitute(b:noesis_local_leader, ' ', '<Space>', 'g') . s:key
endfor
unlet! s:mode s:key
let b:undo_ftplugin .= '|unlet! b:noesis_default_maps'
