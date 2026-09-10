" Check whether we should set redacting options or not
function! redact_pass#() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    return
  endif

  " Ensure there's one argument and it's the matched file
  if argc() != 1
    return
  endif

  let l:argument = resolve(fnamemodify(argv(0), ':p'))
  let l:matched_file = resolve(expand('<afile>:p'))
  if l:argument !=# l:matched_file
    return
  endif

  let g:vim_sensitive_session = 1
  let b:vim_sensitive_buffer = 1
  call redact_pass#protect()
  if exists('#User#RedactPassSensitive')
    doautocmd <nomodeline> User RedactPassSensitive
  endif

  " Tell the user what we're doing so they know this worked, via a message and
  " a global variable they can check
  redraw
  echomsg 'Editing password file--disabled leaky options!'
  let g:redact_pass_redacted = 1

endfunction

" Reapply after sourcing configuration, including when used without vim-gpg.
function! redact_pass#protect() abort
  if get(g:, 'vim_sensitive_session', 0)
    set nobackup nowritebackup viminfo=
  endif
  if get(b:, 'vim_sensitive_buffer', 0)
    setlocal noswapfile noundofile
  endif
endfunction
