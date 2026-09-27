" Activate Noesis for native notes and Markdown files.

augroup noesis_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.noe setfiletype noesis
  " Override Vim's earlier Markdown detection to enable Noesis note tools.
  autocmd BufRead,BufNewFile *.md setlocal filetype=noesis
augroup END
