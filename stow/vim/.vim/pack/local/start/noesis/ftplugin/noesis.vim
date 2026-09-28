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

command! -buffer -bar NoesisExport call noesis#export_html()
nnoremap <silent><buffer> <Plug>(noesis-export) :<C-U>NoesisExport<CR>
command! -buffer -bar NoesisIndex call noesis#index()
nnoremap <silent><buffer> <Plug>(noesis-index) :<C-U>NoesisIndex<CR>
command! -buffer -bar NoesisIndexJump call noesis#index_jump()
nnoremap <silent><buffer> <Plug>(noesis-index-jump) :<C-U>NoesisIndexJump<CR>
command! -buffer -bar NoesisTranslateEnglish call noesis#translate('toe', noesis#text_from_cursor())
nnoremap <silent><buffer> <Plug>(noesis-translate-en) :<C-U>NoesisTranslateEnglish<CR>
command! -buffer -bar NoesisTranslateEnglishSelection call noesis#translate('toe', noesis#visual_text())
xnoremap <silent><buffer> <Plug>(noesis-translate-en) :<C-U>NoesisTranslateEnglishSelection<CR>
command! -buffer -bar NoesisTranslateFrench call noesis#translate('tof', noesis#text_from_cursor())
nnoremap <silent><buffer> <Plug>(noesis-translate-fr) :<C-U>NoesisTranslateFrench<CR>
command! -buffer -bar NoesisTranslateFrenchSelection call noesis#translate('tof', noesis#visual_text())
xnoremap <silent><buffer> <Plug>(noesis-translate-fr) :<C-U>NoesisTranslateFrenchSelection<CR>
command! -buffer -bar NoesisSynonymSelection call noesis#synonym(noesis#visual_text())
xnoremap <silent><buffer> <Plug>(noesis-synonym) :<C-U>NoesisSynonymSelection<CR>
command! -buffer -bar NoesisHeading1 call noesis#heading(1)
nnoremap <silent><buffer> <Plug>(noesis-heading-1) :<C-U>NoesisHeading1<CR>
command! -buffer -bar NoesisHeading2 call noesis#underline()
nnoremap <silent><buffer> <Plug>(noesis-heading-2) :<C-U>NoesisHeading2<CR>
command! -buffer -bar NoesisHeading3 call noesis#heading(3)
nnoremap <silent><buffer> <Plug>(noesis-heading-3) :<C-U>NoesisHeading3<CR>
command! -buffer -bar NoesisHeading4 call noesis#heading(4)
nnoremap <silent><buffer> <Plug>(noesis-heading-4) :<C-U>NoesisHeading4<CR>
command! -buffer -bar NoesisHeading5 call noesis#heading(5)
nnoremap <silent><buffer> <Plug>(noesis-heading-5) :<C-U>NoesisHeading5<CR>
command! -buffer -bar NoesisHeading6 call noesis#heading(6)
nnoremap <silent><buffer> <Plug>(noesis-heading-6) :<C-U>NoesisHeading6<CR>
command! -buffer -bar NoesisItalic call noesis#italic(0)
nnoremap <silent><buffer> <Plug>(noesis-italic) :<C-U>NoesisItalic<CR>
command! -buffer -bar NoesisItalicSelection call noesis#italic(1)
xnoremap <silent><buffer> <Plug>(noesis-italic) <Cmd>NoesisItalicSelection<CR>
command! -buffer -bar NoesisBold call noesis#bold(0)
nnoremap <silent><buffer> <Plug>(noesis-bold) :<C-U>NoesisBold<CR>
command! -buffer -bar NoesisBoldSelection call noesis#bold(1)
xnoremap <silent><buffer> <Plug>(noesis-bold) <Cmd>NoesisBoldSelection<CR>
command! -buffer -bar NoesisCode call noesis#code(0)
nnoremap <silent><buffer> <Plug>(noesis-code) :<C-U>NoesisCode<CR>
command! -buffer -bar NoesisCodeSelection call noesis#code(1)
xnoremap <silent><buffer> <Plug>(noesis-code) <Cmd>NoesisCodeSelection<CR>
command! -buffer -bar NoesisLink call noesis#link(0)
nnoremap <silent><buffer> <Plug>(noesis-link) :<C-U>NoesisLink<CR>
command! -buffer -bar NoesisLinkSelection call noesis#link(1)
xnoremap <silent><buffer> <Plug>(noesis-link) <Cmd>NoesisLinkSelection<CR>
command! -buffer -bar NoesisQuote call noesis#quote(0)
nnoremap <silent><buffer> <Plug>(noesis-quote) :<C-U>NoesisQuote<CR>
command! -buffer -bar NoesisQuoteSelection call noesis#quote(1)
xnoremap <silent><buffer> <Plug>(noesis-quote) <Cmd>NoesisQuoteSelection<CR>
command! -buffer -bar NoesisUnstyle call noesis#unstyle()
nnoremap <silent><buffer> <Plug>(noesis-unstyle) :<C-U>NoesisUnstyle<CR>

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
  nmap <buffer> <LocalLeader>u <Plug>(noesis-unstyle)
  call add(b:noesis_default_maps, ["n", "u"])
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
      \ . '|silent! delcommand -buffer NoesisExport'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-index)'
      \ . '|silent! delcommand -buffer NoesisIndex'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-index-jump)'
      \ . '|silent! delcommand -buffer NoesisIndexJump'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-translate-en)'
      \ . '|silent! delcommand -buffer NoesisTranslateEnglish'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-translate-en)'
      \ . '|silent! delcommand -buffer NoesisTranslateEnglishSelection'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-translate-fr)'
      \ . '|silent! delcommand -buffer NoesisTranslateFrench'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-translate-fr)'
      \ . '|silent! delcommand -buffer NoesisTranslateFrenchSelection'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-synonym)'
      \ . '|silent! delcommand -buffer NoesisSynonymSelection'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-1)'
      \ . '|silent! delcommand -buffer NoesisHeading1'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-2)'
      \ . '|silent! delcommand -buffer NoesisHeading2'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-3)'
      \ . '|silent! delcommand -buffer NoesisHeading3'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-4)'
      \ . '|silent! delcommand -buffer NoesisHeading4'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-5)'
      \ . '|silent! delcommand -buffer NoesisHeading5'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-heading-6)'
      \ . '|silent! delcommand -buffer NoesisHeading6'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-italic)'
      \ . '|silent! delcommand -buffer NoesisItalic'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-italic)'
      \ . '|silent! delcommand -buffer NoesisItalicSelection'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-bold)'
      \ . '|silent! delcommand -buffer NoesisBold'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-bold)'
      \ . '|silent! delcommand -buffer NoesisBoldSelection'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-code)'
      \ . '|silent! delcommand -buffer NoesisCode'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-code)'
      \ . '|silent! delcommand -buffer NoesisCodeSelection'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-link)'
      \ . '|silent! delcommand -buffer NoesisLink'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-link)'
      \ . '|silent! delcommand -buffer NoesisLinkSelection'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-quote)'
      \ . '|silent! delcommand -buffer NoesisQuote'
let b:undo_ftplugin .= '|silent! xunmap <buffer> <Plug>(noesis-quote)'
      \ . '|silent! delcommand -buffer NoesisQuoteSelection'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(noesis-unstyle)'
      \ . '|silent! delcommand -buffer NoesisUnstyle'
for [s:mode, s:key] in b:noesis_default_maps
  let b:undo_ftplugin .= '|silent! ' . s:mode . 'unmap <buffer> '
        \ . substitute(b:noesis_local_leader, ' ', '<Space>', 'g') . s:key
endfor
unlet! s:mode s:key
let b:undo_ftplugin .= '|unlet! b:noesis_default_maps'
