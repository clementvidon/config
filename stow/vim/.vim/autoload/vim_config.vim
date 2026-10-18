" Reload the personal Vim configuration and the current buffer's filetype.

function! vim_config#reload() abort
  let l:config = get(g:, 'vim_config_file', '')
  if empty(l:config) || !filereadable(l:config)
    echoerr 'Vim reload: configuration file is unavailable'
    return
  endif

  let l:filetype = &l:filetype
  let l:view = winsaveview()
  " FileType handlers undo and reapply the current buffer's ftplugins.
  let &l:filetype = ''

  try
    execute 'source ' . fnameescape(l:config)
    for l:script in globpath(&runtimepath,
          \ 'autoload/vim_config/*.vim', 0, 1)
      execute 'source ' . fnameescape(l:script)
    endfor
    for l:script in globpath(&runtimepath,
          \ 'pack/local/start/*/autoload/*.vim', 0, 1)
      execute 'source ' . fnameescape(l:script)
    endfor
    if !empty(l:filetype)
      execute 'setfiletype ' . l:filetype
    endif
    call winrestview(l:view)
    redraw
    unsilent echomsg 'Vim configuration reloaded'
  catch
    if !empty(l:filetype) && empty(&l:filetype)
      execute 'setfiletype ' . l:filetype
    endif
    call winrestview(l:view)
    echoerr 'Vim reload failed: ' . v:exception
  endtry
endfunction
