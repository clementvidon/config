" Buffer-local task behavior for the Achiever filetype component.

" # LOAD GUARD

if exists('b:did_achiever_ftplugin')
  finish
endif
let b:did_achiever_ftplugin = 1

" # BUFFER CONFIGURATION

let b:achiever_task_detail_prefix = get(b:, 'achiever_task_detail_prefix',
      \ g:achiever_task_detail_prefix)
" Task records must stay on one logical line, independent of host formatting.
let b:achiever_saved_layout = [&l:textwidth, &l:wrap, &l:wrapmargin, &l:formatoptions]
setlocal textwidth=0 wrapmargin=0 nowrap
setlocal formatoptions-=a

" # COMMANDS AND MAPPING API

command! -buffer -bar AchieverCheck call achiever#task_check()
nnoremap <silent><buffer> <Plug>(achiever-check) :<C-U>AchieverCheck<CR>
command! -buffer -bar AchieverClear call achiever#task_clear()
nnoremap <silent><buffer> <Plug>(achiever-clear) :<C-U>AchieverClear<CR>
command! -buffer -bar AchieverLinkBegin call achiever#task_link_begin()
nnoremap <silent><buffer> <Plug>(achiever-link-begin) :<C-U>AchieverLinkBegin<CR>
command! -buffer -bar AchieverLinkEnd call achiever#task_link_end()
nnoremap <silent><buffer> <Plug>(achiever-link-end) :<C-U>AchieverLinkEnd<CR>
command! -buffer -bar AchieverDuration call achiever#task_duration(getline("."))
nnoremap <silent><buffer> <Plug>(achiever-duration) :<C-U>AchieverDuration<CR>
command! -buffer -bar AchieverDurationAdd call achiever#task_duration_add()
nnoremap <silent><buffer> <Plug>(achiever-duration-add) :<C-U>AchieverDurationAdd<CR>
command! -buffer -bar AchieverDurationTotal call achiever#task_duration_total()
nnoremap <silent><buffer> <Plug>(achiever-duration-total) :<C-U>AchieverDurationTotal<CR>
command! -buffer -bar AchieverDurationReset call achiever#task_duration_reset()
nnoremap <silent><buffer> <Plug>(achiever-duration-reset) :<C-U>AchieverDurationReset<CR>
command! -buffer -bar AchieverDetailToggle call achiever#task_detail_toggle_view(b:achiever_task_detail_prefix)
nnoremap <silent><buffer> <Plug>(achiever-detail-toggle) :<C-U>AchieverDetailToggle<CR>

" # DEFAULT MAPPINGS

let b:achiever_default_keys = []
if !get(g:, 'achiever_no_mappings', 0)
  nmap <buffer> <Leader>hk <Plug>(achiever-check)
  nmap <buffer> <Leader>hc <Plug>(achiever-clear)
  nmap <buffer> <Leader>hb <Plug>(achiever-link-begin)
  nmap <buffer> <Leader>he <Plug>(achiever-link-end)
  nmap <buffer> <Leader>hd <Plug>(achiever-duration)
  nmap <buffer> <Leader>ha <Plug>(achiever-duration-add)
  nmap <buffer> <Leader>hs <Plug>(achiever-duration-total)
  nmap <buffer> <Leader>hr <Plug>(achiever-duration-reset)
  nmap <buffer> <Leader>ht <Plug>(achiever-detail-toggle)
  nnoremap <buffer> <Leader>hh :map <Leader>h<CR>
  let b:achiever_default_keys = map(split("k c b e d a s r t h"),
        \ 'get(g:, "mapleader", "\\") . "h" . v:val')
endif

iabbrev <silent><buffer> wwo - work:
iabbrev <silent><buffer> lli - life:

" # UNDO

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . (!empty(get(b:, 'undo_ftplugin', '')) ? '|' : '')
      \ . 'let [&l:textwidth, &l:wrap, &l:wrapmargin, &l:formatoptions] = b:achiever_saved_layout'
      \ . '|silent! iunabbrev <buffer> wwo|silent! iunabbrev <buffer> lli'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-check)'
      \ . '|silent! delcommand -buffer AchieverCheck'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-clear)'
      \ . '|silent! delcommand -buffer AchieverClear'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-link-begin)'
      \ . '|silent! delcommand -buffer AchieverLinkBegin'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-link-end)'
      \ . '|silent! delcommand -buffer AchieverLinkEnd'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-duration)'
      \ . '|silent! delcommand -buffer AchieverDuration'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-duration-add)'
      \ . '|silent! delcommand -buffer AchieverDurationAdd'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-duration-total)'
      \ . '|silent! delcommand -buffer AchieverDurationTotal'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-duration-reset)'
      \ . '|silent! delcommand -buffer AchieverDurationReset'
let b:undo_ftplugin .= '|silent! nunmap <buffer> <Plug>(achiever-detail-toggle)'
      \ . '|silent! delcommand -buffer AchieverDetailToggle'
for s:key in b:achiever_default_keys
  let b:undo_ftplugin .= '|silent! nunmap <buffer> ' . substitute(s:key, ' ', '<Space>', 'g')
endfor
unlet! s:key
let b:undo_ftplugin .= '|unlet! b:achiever_task_detail_prefix b:achiever_default_keys'
      \ . ' b:achiever_total_difference_seconds b:did_achiever_ftplugin b:achiever_saved_layout'
