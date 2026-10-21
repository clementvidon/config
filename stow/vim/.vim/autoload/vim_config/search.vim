" Search helpers for selected text, prompts, and ripgrep.

function! s:SelectedText() abort
  let l:unnamed = getreginfo('"')
  let l:yank = getreginfo('0')
  let l:clipboard = &clipboard
  let l:view = winsaveview()
  try
    " Extract with native selection semantics, without clipboard/yank hooks.
    set clipboard=
    silent noautocmd normal! gvy
    " V and v$ may include the selected line's final newline.
    let l:text = substitute(getreg('0'), '\n$', '', '')
  finally
    call setreg('0', l:yank)
    call setreg('"', l:unnamed)
    let &clipboard = l:clipboard
    call winrestview(l:view)
  endtry
  if empty(l:text) || l:text =~# '[[:cntrl:]]'
    throw 'Search: select text on one line, without control characters'
  endif
  return l:text
endfunction

function! vim_config#search#static_selection() abort
  let @/ = '\V' . escape(s:SelectedText(), '\')
  set hlsearch
  redraw!
endfunction

function! vim_config#search#static_prompt() abort
  let l:pattern = input('Static search: ')
  if empty(l:pattern)
    return
  endif
  let @/ = l:pattern
  set hlsearch
  redraw!
endfunction

function! vim_config#search#grep_prompt(visual) abort
  if !executable('rg')
    throw 'Search requires ripgrep (rg) on PATH'
  endif
  let l:command = ':silent grep '
  if a:visual
    let l:argument_start = strlen(l:command) - 1
    let l:command .= ' -F -- ' . shellescape(s:SelectedText(), 1)
          \ . "\<Home>" . repeat("\<Right>", l:argument_start)
  endif
  call feedkeys(l:command, 'n')
endfunction
