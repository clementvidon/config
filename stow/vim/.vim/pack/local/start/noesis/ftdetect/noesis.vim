" Activate Noesis for Markdown according to the note environment policy.

function! s:Detect() abort
  if get(g:, 'noesis_all_markdown', 0)
        \ || !empty(noesis#workspace_root())
    setlocal filetype=noesis
  endif
endfunction

augroup noesis_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.md call <SID>Detect()
augroup END
