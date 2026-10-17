" Look up Ansible documentation with Vim's keyword command.

function! vim_config#ansible#module_under_cursor() abort
  let l:iskeyword = &l:iskeyword
  try
    setlocal iskeyword+=.
    call vim_config#ansible#module(expand('<cword>'))
  finally
    let &l:iskeyword = l:iskeyword
  endtry
endfunction

function! vim_config#ansible#keyword(keyword) abort
  if !executable('ansible-doc')
    return
  endif

  let l:doc = system('ansible-doc -t keyword ' . shellescape(a:keyword) . ' 2>/dev/null')
  if !empty(trim(l:doc))
    echo l:doc
  endif
endfunction

function! vim_config#ansible#module(name) abort
  if !executable('ansible-doc')
    return
  endif

  let l:doc = system('ansible-doc -t module ' . shellescape(a:name) . ' 2>/dev/null')
  if !empty(trim(l:doc))
    echo l:doc
  endif
endfunction
