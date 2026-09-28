" Activate Noesis for Markdown notes.

augroup noesis_filetype
  autocmd!
  " Override Vim's earlier Markdown detection to enable Noesis note tools.
  autocmd BufRead,BufNewFile *.md setlocal filetype=noesis
augroup END
