" Show read-only output in a temporary scratch split.

function! vim_config#scratch#show(title, lines) abort
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  execute 'file ' . fnameescape('[' . a:title . ' #' . bufnr('%') . ']')
  call setline(1, a:lines)
  setlocal nomodified nomodifiable
  nnoremap <buffer> <silent> q :close<CR>
endfunction
