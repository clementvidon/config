" Detect Noesis notes by their dedicated extension.

augroup noesis_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.noe setfiletype noesis
augroup END
