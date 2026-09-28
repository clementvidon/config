" Achiever activation and defaults.

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
  autocmd BufReadPost,BufNewFile achiever.md,*.achiever.md let b:achiever_pending = 1
  autocmd BufWinEnter * nested
        \ if get(b:, 'achiever_pending', 0) |
        \   unlet b:achiever_pending |
        \   call <SID>Enable() |
        \ endif
augroup END
