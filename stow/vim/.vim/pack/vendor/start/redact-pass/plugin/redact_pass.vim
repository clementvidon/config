"
" redact_pass.vim: Switch off the 'viminfo', 'backup', 'writebackup',
" 'swapfile', and 'undofile' globally when editing a password in pass(1).
"
" This is to prevent anyone being able to extract passwords from your Vim
" cache files in the event of a compromise.
"
" Author: Tom Ryder <tom@sanctum.geek.nz>
" License: Same as Vim itself
"
if exists('loaded_redact_pass') || &compatible  || v:version < 700
  finish
endif
let loaded_redact_pass = 1

" Auto function loads only when Vim starts up
augroup redact_pass
  autocmd!
  autocmd VimEnter
        \ /dev/shm/pass.?*/?*.txt
        \,$TMPDIR/pass.?*/?*.txt
        \,/tmp/pass.?*/?*.txt
        \ call redact_pass#()
  " Work around macOS' dynamic symlink structure for temporary directories
  if has('mac')
    autocmd VimEnter
          \ /private/var/?*/pass.?*/?*.txt
          \ call redact_pass#()
  endif
augroup END
