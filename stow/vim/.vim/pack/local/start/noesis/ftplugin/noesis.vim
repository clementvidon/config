" Buffer-local editing behavior for Noesis notes.

" # LOAD GUARD

if exists('b:did_noesis_ftplugin')
  finish
endif
let b:did_noesis_ftplugin = 1
let b:noesis_local_leader = get(g:, 'maplocalleader', '\\')

" # BUFFER CONFIGURATION

setlocal suffixesadd+=.noe
setlocal commentstring=
setlocal suffixesadd+=.gpg.noe
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
nnoremap <silent><buffer> <space>= <nop>
vnoremap <silent><buffer> <space>= <nop>
vnoremap <silent><buffer> = <nop>
nnoremap <silent><buffer> = <nop>
vnoremap <silent><buffer> gq <nop>
nnoremap <silent><buffer> gq <nop>
nnoremap <silent><buffer> gwG <nop>
nnoremap <silent><buffer> gwgo <nop>
nnoremap <silent><buffer> gwgg <nop>
nnoremap <silent><buffer> K <nop>
nnoremap <buffer><silent><expr> j v:count ? 'j' : 'gj'
nnoremap <buffer><silent><expr> k v:count ? 'k' : 'gk'
vnoremap <buffer><silent><expr> j v:count ? 'j' : 'gj'
vnoremap <buffer><silent><expr> k v:count ? 'k' : 'gk'

nnoremap <silent><buffer> <LocalLeader>X :call noesis#export_html()<CR>
nnoremap <silent><buffer> <LocalLeader>I :call noesis#index()<CR>
nnoremap <silent><buffer> <LocalLeader>i :call noesis#index_jump()<CR>

" ## language tools

nnoremap <buffer><silent> <LocalLeader>len :call noesis#translate('toe', noesis#text_from_cursor())<CR>
vnoremap <buffer><silent> <LocalLeader>len :<C-U>call noesis#translate('toe', noesis#visual_text())<CR>
nnoremap <buffer><silent> <LocalLeader>lfr :call noesis#translate('tof', noesis#text_from_cursor())<CR>
vnoremap <buffer><silent> <LocalLeader>lfr :<C-U>call noesis#translate('tof', noesis#visual_text())<CR>
vnoremap <buffer><silent> <LocalLeader>sy :<C-U>call noesis#synonym(noesis#visual_text())<CR>

" ## note structure

nnoremap <buffer><silent> <LocalLeader>t1 :<C-U>call noesis#heading(1)<CR>
nnoremap <buffer><silent> <LocalLeader>t2 :<C-U>call noesis#underline()<CR>
nnoremap <buffer><silent> <LocalLeader>t3 :<C-U>call noesis#heading(3)<CR>
nnoremap <buffer><silent> <LocalLeader>t4 :<C-U>call noesis#heading(4)<CR>
nnoremap <buffer><silent> <LocalLeader>t5 :<C-U>call noesis#heading(5)<CR>
nnoremap <buffer><silent> <LocalLeader>t6 :<C-U>call noesis#heading(6)<CR>
for [s:key, s:function] in items({'i': 'italic', 'b': 'bold', 'c': 'code', 'l': 'link', 'q': 'quote'})
  execute 'nnoremap <buffer><silent> <LocalLeader>t' . s:key
        \ . ' :<C-U>call noesis#' . s:function . '(0)<CR>'
  execute 'xnoremap <buffer><silent> <LocalLeader>t' . s:key
        \ . ' <Cmd>call noesis#' . s:function . '(1)<CR>'
endfor
unlet s:key s:function
nnoremap <buffer><silent> <LocalLeader>td :<C-U>call noesis#unstyle()<CR>

" # UNDO

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'setlocal suffixesadd< commentstring< path< foldmethod< foldmarker<'
      \ . ' linebreak< breakindent< expandtab< shiftwidth< softtabstop<'
      \ . ' tabstop< textwidth< conceallevel< concealcursor<'
      \ . '|silent! delcommand -buffer Grep'
      \ . '|unlet! b:did_noesis_ftplugin b:noesis_local_leader'
      \ . '|silent! nunmap <buffer> <space>='
      \ . '|silent! vunmap <buffer> <space>='
      \ . '|silent! vunmap <buffer> ='
      \ . '|silent! nunmap <buffer> ='
      \ . '|silent! vunmap <buffer> gq'
      \ . '|silent! nunmap <buffer> gq'
      \ . '|silent! nunmap <buffer> gwG'
      \ . '|silent! nunmap <buffer> gwgo'
      \ . '|silent! nunmap <buffer> gwgg'
      \ . '|silent! nunmap <buffer> K'
      \ . '|silent! nunmap <buffer> j'
      \ . '|silent! nunmap <buffer> k'
      \ . '|silent! vunmap <buffer> j'
      \ . '|silent! vunmap <buffer> k'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'X'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'I'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'i'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'len'
      \ . '|silent! vunmap <buffer> ' . b:noesis_local_leader . 'len'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'lfr'
      \ . '|silent! vunmap <buffer> ' . b:noesis_local_leader . 'lfr'
      \ . '|silent! vunmap <buffer> ' . b:noesis_local_leader . 'sy'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 't1'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 't2'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 't3'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 't4'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 't5'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 't6'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'td'

for s:style in ['i', 'b', 'c', 'l', 'q']
  let b:undo_ftplugin .= '|silent! nunmap <buffer> ' . b:noesis_local_leader . 't' . s:style
        \ . '|silent! xunmap <buffer> ' . b:noesis_local_leader . 't' . s:style
endfor
unlet s:style
