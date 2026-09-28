" Activate the note environment only inside its workspace.

function! s:Detect() abort
  let l:root = substitute(resolve(fnamemodify(expand(g:noesis_root), ':p')), '/\+$', '', '') . '/'
  if stridx(resolve(expand('%:p')), l:root) == 0
    setlocal filetype=noesis
  endif
endfunction

augroup noesis_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.md call <SID>Detect()
augroup END
