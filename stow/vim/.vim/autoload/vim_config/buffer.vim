" Make a private temporary file the current buffer's save destination.

function! vim_config#buffer#make_temp() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    throw 'Temporary files are disabled for encrypted or sensitive buffers'
  endif
  if !executable('mktemp')
    throw 'Temporary files require mktemp on PATH'
  endif

  let l:paths = systemlist('mktemp')
  if v:shell_error || len(l:paths) != 1 || !filereadable(l:paths[0])
    throw 'Could not create a temporary file'
  endif
  let l:path = l:paths[0]
  " mktemp already created the private file, so overwriting it is intentional.
  execute 'saveas! ' . fnameescape(l:path)
  return l:path
endfunction
