" Noesis entry point and user-level navigation.

"   bootstrap and root

if exists('g:loaded_noesis')
  finish
endif
let g:loaded_noesis = 1

if !exists('g:noesis_root')
  let g:noesis_root = empty($NOESIS_ROOT)
        \ ? expand('~/noesis')
        \ : expand($NOESIS_ROOT)
endif

"   navigation helpers

function! s:Open(relative, pattern) abort
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
  execute 'edit ' . fnameescape(g:noesis_root . '/Achiever/todos.noe')
  normal! gg0
  call search('\s\d\{6}\s', 'w')
  normal! 0zz
  let @/ = l:search
endfunction

"   commands

" These commands deliberately do not accept | as a command separator: note
" text must remain data even when it contains Ex metacharacters.
command! -nargs=+ Fr call noesis#translate('en', 'fr', <q-args>)
command! -nargs=+ En call noesis#translate('fr', 'en', <q-args>)
command! -nargs=+ Au call noesis#translate_audio(<q-args>)
command! -nargs=+ Sy call noesis#synonym(<q-args>)

"   navigation mappings

nnoremap <silent> sn  <nop>
nnoremap <silent> sne :call <SID>Open('english.noe', '##  Voca')<CR>
nnoremap <silent> snf :call <SID>Open('french.noe', '##  Voca')<CR>
nnoremap <silent> snt :call <SID>OpenTasks()<CR>
nnoremap <silent> snh :call <SID>Open('.todos.gpg.noe', '')<CR>
nnoremap <silent> snj :call <SID>Open('journal.gpg.noe', '')<CR>
nnoremap <silent> snn :call <SID>Open('notes.noe', '')<CR>

"   digraphs

" Global digraphs are registered once, not on every note buffer.

"     subscript lowercase
execute "digraphs es " . 0x2091
execute "digraphs hs " . 0x2095
execute "digraphs is " . 0x1D62
execute "digraphs js " . 0x2C7C
execute "digraphs ks " . 0x2096
execute "digraphs ls " . 0x2097
execute "digraphs ms " . 0x2098
execute "digraphs ns " . 0x2099
execute "digraphs os " . 0x2092
execute "digraphs ps " . 0x209A
execute "digraphs rs " . 0x1D63
execute "digraphs ss " . 0x209B
execute "digraphs ts " . 0x209C
execute "digraphs us " . 0x1D64
execute "digraphs vs " . 0x1D65
execute "digraphs xs " . 0x2093

"     superscript lowercase
execute "digraphs aS " . 0x1d43
execute "digraphs bS " . 0x1d47
execute "digraphs cS " . 0x1d9c
execute "digraphs dS " . 0x1d48
execute "digraphs eS " . 0x1d49
execute "digraphs fS " . 0x1da0
execute "digraphs gS " . 0x1d4d
execute "digraphs hS " . 0x02b0
execute "digraphs iS " . 0x2071
execute "digraphs jS " . 0x02b2
execute "digraphs kS " . 0x1d4f
execute "digraphs lS " . 0x02e1
execute "digraphs mS " . 0x1d50
execute "digraphs nS " . 0x207f
execute "digraphs oS " . 0x1d52
execute "digraphs pS " . 0x1d56
execute "digraphs rS " . 0x02b3
execute "digraphs sS " . 0x02e2
execute "digraphs tS " . 0x1d57
execute "digraphs uS " . 0x1d58
execute "digraphs vS " . 0x1d5b
execute "digraphs wS " . 0x02b7
execute "digraphs xS " . 0x02e3
execute "digraphs yS " . 0x02b8
execute "digraphs zS " . 0x1dbb

"     superscript uppercase
execute "digraphs AS " . 0x1D2C
execute "digraphs BS " . 0x1D2E
execute "digraphs DS " . 0x1D30
execute "digraphs ES " . 0x1D31
execute "digraphs GS " . 0x1D33
execute "digraphs HS " . 0x1D34
execute "digraphs IS " . 0x1D35
execute "digraphs JS " . 0x1D36
execute "digraphs KS " . 0x1D37
execute "digraphs LS " . 0x1D38
execute "digraphs MS " . 0x1D39
execute "digraphs NS " . 0x1D3A
execute "digraphs OS " . 0x1D3C
execute "digraphs PS " . 0x1D3E
execute "digraphs RS " . 0x1D3F
execute "digraphs TS " . 0x1D40
execute "digraphs US " . 0x1D41
execute "digraphs VS " . 0x2C7D
execute "digraphs WS " . 0x1D42
