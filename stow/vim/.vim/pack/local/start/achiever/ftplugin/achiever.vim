" Buffer-local task behavior for the Achiever filetype component.

"   load guard

if exists('b:did_achiever_ftplugin')
  finish
endif
let b:did_achiever_ftplugin = 1

"   buffer configuration

let b:achiever_task_detail_prefix = get(b:, 'achiever_task_detail_prefix',
      \ g:achiever_task_detail_prefix)
let b:achiever_mappings = get(b:, 'achiever_mappings', g:achiever_mappings)
let b:achiever_local_leader = g:achiever_local_leader

setlocal commentstring=
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal spellcapcheck=
setlocal tabstop=2
setlocal textwidth=0

"   mappings

execute 'nnoremap <silent><buffer> ' . b:achiever_local_leader . ' <Nop>'
for [s:key, s:command] in items(b:achiever_mappings)
  execute 'nnoremap <silent><buffer> ' . b:achiever_local_leader . s:key
        \ . ' :call ' . s:command . '<CR>'
endfor
unlet! s:key s:command

"   abbreviations

iabbrev <silent><buffer> wwo - work:
iabbrev <silent><buffer> lli - life:

"   undo

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'setlocal commentstring< expandtab< shiftwidth< softtabstop<'
      \ . ' spellcapcheck< tabstop< textwidth<'
      \ . '|unlet! b:achiever_task_detail_prefix b:achiever_mappings'
      \ . ' b:achiever_total_difference_seconds b:achiever_local_leader'
      \ . ' b:did_achiever_ftplugin'
      \ . '|silent! nunmap <buffer> ' . b:achiever_local_leader
      \ . '|silent! iunabbrev <buffer> wwo'
      \ . '|silent! iunabbrev <buffer> lli'
for s:key in keys(b:achiever_mappings)
  let b:undo_ftplugin .= '|silent! nunmap <buffer> '
        \ . b:achiever_local_leader . s:key
endfor
unlet! s:key
