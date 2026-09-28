" Buffer-local task behavior for the Achiever filetype component.

" # LOAD GUARD

if exists('b:did_achiever_ftplugin')
  finish
endif
let b:did_achiever_ftplugin = 1

" # BUFFER CONFIGURATION

" Task records must stay on one logical line, independent of host formatting.
let b:achiever_saved_layout = [&l:textwidth, &l:wrap, &l:wrapmargin, &l:formatoptions]
setlocal textwidth=0 wrapmargin=0 nowrap
setlocal formatoptions-=a

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

let b:achiever_host_undo = get(b:, 'undo_ftplugin', '')
let b:undo_achiever_ftplugin =
      \ 'let [&l:textwidth, &l:wrap, &l:wrapmargin, &l:formatoptions] = b:achiever_saved_layout'
      \ . '|silent! iunabbrev <buffer> wwo|silent! iunabbrev <buffer> lli'
for s:key in b:achiever_default_keys
  let b:undo_achiever_ftplugin .= '|silent! nunmap <buffer> ' . substitute(s:key, ' ', '<Space>', 'g')
endfor
unlet! s:key
let b:undo_achiever_ftplugin .= '|unlet! b:achiever_default_keys'
      \ . ' b:achiever_total_difference_seconds b:did_achiever_ftplugin b:achiever_saved_layout'
      \ . '|let b:undo_ftplugin = b:achiever_host_undo'
      \ . '|unlet! b:achiever_host_undo b:undo_achiever_ftplugin'
" Undo the added component before the host when Vim changes filetype normally.
let b:undo_ftplugin = b:undo_achiever_ftplugin
      \ . (empty(b:achiever_host_undo) ? '' : '|' . b:achiever_host_undo)
