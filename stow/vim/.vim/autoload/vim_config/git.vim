" Show the last committed change for the line under the cursor.
scriptencoding utf-8

function! vim_config#git#blame_line() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    echomsg 'Git blame unavailable in sensitive buffers'
    return
  endif

  let l:path = expand('%:p')
  if empty(l:path)
    echomsg 'Git blame requires a named file'
    return
  endif

  let l:directory = fnamemodify(l:path, ':h')
  let l:name = fnamemodify(l:path, ':t')
  let l:command = 'git -C ' . shellescape(l:directory)
        \ . ' blame --line-porcelain -L ' . line('.') . ',' . line('.')
        \ . ' --contents - -- ' . shellescape(l:name)
  let l:output = systemlist(l:command, join(getline(1, '$'), "\n") . "\n")
  if v:shell_error || empty(l:output)
    echomsg 'No committed history for this line'
    return
  endif

  let l:hash = matchstr(l:output[0], '^\x\+')
  if l:hash =~# '^0\+$'
    echomsg 'Line has uncommitted changes'
    return
  endif

  let l:author = ''
  let l:time = ''
  let l:title = ''
  for l:entry in l:output
    if l:entry =~# '^author '
      let l:author = strpart(l:entry, 7)
    elseif l:entry =~# '^author-time '
      let l:time = strftime('%Y-%m-%d', str2nr(strpart(l:entry, 12)))
    elseif l:entry =~# '^summary '
      let l:title = strpart(l:entry, 8)
    endif
  endfor
  call vim_config#popup#show([l:author . ' · ' . l:time . ' · ' . l:hash[:11], l:title])
endfunction
