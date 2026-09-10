" Buffer-local editing behavior for Noesis notes.

"   load guard

if exists('b:did_noesis_ftplugin')
  finish
endif
let b:did_noesis_ftplugin = 1
let b:noesis_local_leader = get(g:, 'maplocalleader', '\\')

"   buffer configuration

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
setlocal textwidth=100
if has('conceal')
  setlocal conceallevel=3
  setlocal concealcursor=vn
endif

"   commands

command! -buffer -nargs=+ Grep call noesis#grep(<q-args>)

"   mappings

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

"     language tools

nnoremap <buffer><silent> <LocalLeader>len :call noesis#translate('fr', 'en', noesis#text_from_cursor())<CR>
vnoremap <buffer><silent> <LocalLeader>len :<C-U>call noesis#translate('fr', 'en', noesis#visual_text())<CR>
nnoremap <buffer><silent> <LocalLeader>lfr :call noesis#translate('en', 'fr', noesis#text_from_cursor())<CR>
vnoremap <buffer><silent> <LocalLeader>lfr :<C-U>call noesis#translate('en', 'fr', noesis#visual_text())<CR>
vnoremap <buffer><silent> <LocalLeader>sy :<C-U>call noesis#synonym(noesis#visual_text())<CR>

"     note structure

nnoremap <buffer><silent> <LocalLeader>h1 o<Esc>80i=<Esc>
nnoremap <buffer><silent> <LocalLeader>h2 o<Esc>40i-<Esc>
nnoremap <buffer><silent> <LocalLeader>ts :put=strftime('%a %d %b %Y at %H:%M')<CR>

"   undo

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
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'h1'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'h2'
      \ . '|silent! nunmap <buffer> ' . b:noesis_local_leader . 'ts'
