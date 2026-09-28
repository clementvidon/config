" Achiever activation and defaults.

if exists('g:loaded_achiever')
  finish
endif
let g:loaded_achiever = 1

" # DEFAULTS

if !exists('g:achiever_task_detail_prefix')
  let g:achiever_task_detail_prefix = '--'
endif

" # ACTIVATION

function! s:Enable() abort
  if index(split(&l:filetype, '\.'), 'achiever') < 0
    let l:layout = [&l:textwidth, &l:wrap, &l:wrapmargin, &l:formatoptions]
    let &l:filetype = empty(&l:filetype) ? 'achiever' : &l:filetype . '.achiever'
    let b:achiever_saved_layout = l:layout
  endif
endfunction

function! s:Disable() abort
  unlet! b:achiever_pending
  if index(split(&l:filetype, '\.'), 'achiever') < 0
    return
  endif
  let l:layout = b:achiever_saved_layout
  let &l:filetype = join(filter(split(&l:filetype, '\.'), 'v:val !=# "achiever"'), '.')
  let [&l:textwidth, &l:wrap, &l:wrapmargin, &l:formatoptions] = l:layout
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
