" Show a short message over the editor and return the dismissing key.

function! vim_config#popup#show(lines) abort
  let l:popup = popup_create(a:lines, {
        \ 'line': &lines - 1,
        \ 'col': 1,
        \ 'pos': 'botleft',
        \ 'minwidth': &columns,
        \ 'maxwidth': &columns,
        \ 'maxheight': &lines - 2,
        \ 'wrap': 1,
        \ })
  try
    redraw
    return getcharstr()
  finally
    call popup_close(l:popup)
  endtry
endfunction
