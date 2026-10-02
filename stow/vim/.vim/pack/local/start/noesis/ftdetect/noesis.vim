" Activate Noesis for Markdown according to the note environment policy.

function! s:Detect() abort
  let l:directory = resolve(expand('%:p:h'))
  if get(g:, 'noesis_all_markdown', 0)
        \ || l:directory =~? '\(^\|/\)noesis\(/\|$\)'
    setlocal filetype=noesis
  endif
endfunction

augroup noesis_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.md call <SID>Detect()
augroup END
