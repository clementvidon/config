" Achiever activation and public mapping API.

if exists('g:loaded_achiever')
  finish
endif
let g:loaded_achiever = 1

" # ACTIVATION

function! s:Enable() abort
  if index(split(&l:filetype, '\.'), 'achiever') < 0
    " Load only the added component; reloading the host would reset local edits.
    noautocmd let &l:filetype = empty(&l:filetype) ? 'achiever' : &l:filetype . '.achiever'
    runtime! ftplugin/achiever.vim
    let &l:syntax = &l:filetype
  endif
endfunction

function! s:Disable() abort
  unlet! b:achiever_pending
  if index(split(&l:filetype, '\.'), 'achiever') < 0
    return
  endif
  execute b:undo_achiever_ftplugin
  noautocmd let &l:filetype = join(filter(split(&l:filetype, '\.'), 'v:val !=# "achiever"'), '.')
  let &l:syntax = &l:filetype
endfunction

command! -bar AchieverEnable call <SID>Enable()
command! -bar AchieverDisable call <SID>Disable()

" # FILENAME DETECTION

augroup achiever_settings
  autocmd!
  " Defer composition until filetype detection and modelines have finished.
  autocmd BufReadPost,BufNewFile achiever.md,*.achiever.md,achiever.noe.md,*.achiever.noe.md
        \ let b:achiever_pending = 1
  autocmd BufWinEnter * nested
        \ if get(b:, 'achiever_pending', 0) |
        \   unlet b:achiever_pending |
        \   call <SID>Enable() |
        \ endif
augroup END

" # MAPPING API

nnoremap <silent> <Plug>(achiever-check) :<C-U>call achiever#task_check()<CR>
nnoremap <silent> <Plug>(achiever-clear) :<C-U>call achiever#task_clear()<CR>
nnoremap <silent> <Plug>(achiever-link-begin) :<C-U>call achiever#task_link_begin()<CR>
nnoremap <silent> <Plug>(achiever-link-end) :<C-U>call achiever#task_link_end()<CR>
nnoremap <silent> <Plug>(achiever-duration) :<C-U>call achiever#task_duration(getline("."))<CR>
nnoremap <silent> <Plug>(achiever-duration-add) :<C-U>call achiever#task_duration_add()<CR>
nnoremap <silent> <Plug>(achiever-duration-total) :<C-U>call achiever#task_duration_total()<CR>
nnoremap <silent> <Plug>(achiever-duration-reset) :<C-U>call achiever#task_duration_reset()<CR>
nnoremap <silent> <Plug>(achiever-detail-toggle) :<C-U>call achiever#task_detail_toggle_view()<CR>
