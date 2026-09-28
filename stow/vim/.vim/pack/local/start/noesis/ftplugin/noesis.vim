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
for s:directory in ['Achiever', 'Inbox', 'Systems', 'Knowledge', 'Projects']
  execute 'setlocal path+=' . fnameescape(g:noesis_root . '/' . s:directory . '/**')
endfor
unlet s:directory
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

" Formatting operators are neutralized because note layout is edited
" explicitly and must not be changed by prose reflow or indentation commands.
vnoremap <silent><buffer> = <nop>
nnoremap <silent><buffer> = <nop>
nnoremap <silent><buffer> <Space>= <Nop>
xnoremap <silent><buffer> <Space>= <Nop>
vnoremap <silent><buffer> gq <nop>
nnoremap <silent><buffer> gq <nop>
nnoremap <silent><buffer> gw <Nop>
xnoremap <silent><buffer> gw <Nop>
nnoremap <silent><buffer> K <nop>
nnoremap <buffer><silent><expr> j v:count ? 'j' : 'gj'
nnoremap <buffer><silent><expr> k v:count ? 'k' : 'gk'
vnoremap <buffer><silent><expr> j v:count ? 'j' : 'gj'
vnoremap <buffer><silent><expr> k v:count ? 'k' : 'gk'

" # MAPPING API

nnoremap <silent><buffer> <Plug>(noesis-export) :<C-U>call noesis#export_html()<CR>
nnoremap <silent><buffer> <Plug>(noesis-index) :<C-U>call noesis#index()<CR>
nnoremap <silent><buffer> <Plug>(noesis-index-jump) :<C-U>call noesis#index_jump()<CR>
nnoremap <silent><buffer> <Plug>(noesis-translate-en) :<C-U>call noesis#translate('toe', noesis#text_from_cursor())<CR>
xnoremap <silent><buffer> <Plug>(noesis-translate-en) :<C-U>call noesis#translate('toe', noesis#visual_text())<CR>
nnoremap <silent><buffer> <Plug>(noesis-translate-fr) :<C-U>call noesis#translate('tof', noesis#text_from_cursor())<CR>
xnoremap <silent><buffer> <Plug>(noesis-translate-fr) :<C-U>call noesis#translate('tof', noesis#visual_text())<CR>
xnoremap <silent><buffer> <Plug>(noesis-synonym) :<C-U>call noesis#synonym(noesis#visual_text())<CR>
nnoremap <silent><buffer> <Plug>(noesis-heading-1) :<C-U>call noesis#heading(1)<CR>
nnoremap <silent><buffer> <Plug>(noesis-heading-2) :<C-U>call noesis#underline()<CR>
nnoremap <silent><buffer> <Plug>(noesis-heading-3) :<C-U>call noesis#heading(3)<CR>
nnoremap <silent><buffer> <Plug>(noesis-heading-4) :<C-U>call noesis#heading(4)<CR>
nnoremap <silent><buffer> <Plug>(noesis-heading-5) :<C-U>call noesis#heading(5)<CR>
nnoremap <silent><buffer> <Plug>(noesis-heading-6) :<C-U>call noesis#heading(6)<CR>
nnoremap <silent><buffer> <Plug>(noesis-italic) :<C-U>call noesis#italic(0)<CR>
xnoremap <silent><buffer> <Plug>(noesis-italic) <Cmd>call noesis#italic(1)<CR>
nnoremap <silent><buffer> <Plug>(noesis-bold) :<C-U>call noesis#bold(0)<CR>
xnoremap <silent><buffer> <Plug>(noesis-bold) <Cmd>call noesis#bold(1)<CR>
nnoremap <silent><buffer> <Plug>(noesis-code) :<C-U>call noesis#code(0)<CR>
xnoremap <silent><buffer> <Plug>(noesis-code) <Cmd>call noesis#code(1)<CR>
nnoremap <silent><buffer> <Plug>(noesis-link) :<C-U>call noesis#link(0)<CR>
xnoremap <silent><buffer> <Plug>(noesis-link) <Cmd>call noesis#link(1)<CR>
nnoremap <silent><buffer> <Plug>(noesis-quote) :<C-U>call noesis#quote(0)<CR>
xnoremap <silent><buffer> <Plug>(noesis-quote) <Cmd>call noesis#quote(1)<CR>

" # DEFAULT MAPPINGS

let b:noesis_default_maps = []
if !get(g:, 'noesis_no_mappings', 0)
  nnoremap <buffer> <LocalLeader>h :map <LocalLeader><CR>
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
      \ . '|silent! nunmap <buffer> gw'
      \ . '|silent! xunmap <buffer> gw'
      \ . '|silent! nunmap <buffer> <Space>='
      \ . '|silent! xunmap <buffer> <Space>='
      \ . '|silent! nunmap <buffer> K'
      \ . '|silent! nunmap <buffer> j'
      \ . '|silent! nunmap <buffer> k'
      \ . '|silent! vunmap <buffer> j'
      \ . '|silent! vunmap <buffer> k'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-export)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-index)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-index-jump)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-translate-en)'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-translate-en)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-translate-fr)'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-translate-fr)'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-synonym)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-1)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-2)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-3)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-4)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-5)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-6)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-italic)'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-italic)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-bold)'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-bold)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-code)'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-code)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-link)'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-link)'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-quote)'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-quote)'
for [s:mode, s:key] in b:noesis_default_maps
  let b:undo_ftplugin .= '|silent! ' . s:mode . 'unmap <buffer> '
        \ . substitute(b:noesis_local_leader, ' ', '<Space>', 'g') . s:key
endfor
unlet! s:mode s:key
let b:undo_ftplugin .= '|unlet! b:noesis_default_maps'
