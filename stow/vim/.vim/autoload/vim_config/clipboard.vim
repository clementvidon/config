" Copy and paste through the platform clipboard helper.

function! s:ClipboardCommand() abort
  if !executable('clipboard')
    throw 'Install the scripts Stow package and add ~/.local/bin to PATH'
  endif
  return shellescape(exepath('clipboard'))
endfunction

function! vim_config#clipboard#copy() abort
  call system(s:ClipboardCommand() . ' copy', getreg('"'))
  if v:shell_error
    echoerr 'Clipboard copy failed; check providers or use terminal paste over SSH'
  endif
endfunction

function! vim_config#clipboard#paste() abort
  let l:text = system(s:ClipboardCommand() . ' paste')
  if v:shell_error
    echoerr 'Clipboard paste failed; check providers or use terminal paste over SSH'
    return
  endif
  " The expression register preserves the user's yank/delete registers.
  call setreg('=', string(l:text))
  execute "normal! \"=\<CR>p"
endfunction
