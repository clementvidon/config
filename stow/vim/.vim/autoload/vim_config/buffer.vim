" Save a private temporary copy without changing the source buffer.

function! vim_config#buffer#write_temp() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    throw 'Temporary copies are disabled for encrypted or sensitive buffers'
  endif
  if !executable('mktemp')
    throw 'Temporary copies require mktemp on PATH'
  endif

  let l:paths = systemlist('mktemp')
  if v:shell_error || len(l:paths) != 1 || !filereadable(l:paths[0])
    throw 'Could not create a temporary file'
  endif
  let l:path = l:paths[0]
  let l:cpoptions = &cpoptions
  try
    " Preserve unnamed buffers and their modified state; skip save hooks.
    set cpoptions-=F cpoptions-=+
    silent execute 'noautocmd keepalt write! ' . fnameescape(l:path)
  catch
    call delete(l:path)
    throw 'Temporary copy failed: ' . v:exception
  finally
    let &cpoptions = l:cpoptions
  endtry
  echomsg 'Temporary copy: ' . l:path
  return l:path
endfunction
