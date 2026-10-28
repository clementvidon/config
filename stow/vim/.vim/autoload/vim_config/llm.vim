" Run personal LLM text actions from Vim.

function! s:Run(action, text) abort
  if !executable('llm-text')
    throw 'llm-text is not installed'
  endif

  let l:text = a:text
  let l:command = shellescape(exepath('llm-text')) . ' ' . shellescape(a:action)
  if index(['syn', 'ant', 'lex', 'equ'], a:action) >= 0
    let l:count = matchstr(l:text, '^-[0-9]\+\ze\s')
    if !empty(l:count)
      let l:command .= ' ' . shellescape(l:count)
      let l:text = trim(strpart(l:text, strlen(l:count)))
    endif
  endif

  let l:output = systemlist(l:command, l:text)
  if v:shell_error
    throw 'llm-text failed'
  endif
  return l:output
endfunction

function! s:ShowResponse(action, text) abort
  if empty(trim(a:text))
    return
  endif
  let l:lines = s:Run(a:action, a:text)
  if !empty(l:lines)
    call vim_config#popup#show(l:lines)
  endif
endfunction

function! s:Refine(text) abort
  call s:ShowResponse('ref', a:text)
endfunction

function! vim_config#llm#to_english(text) abort
  call s:ShowResponse('toe', a:text)
endfunction

function! vim_config#llm#to_french(text) abort
  call s:ShowResponse('tof', a:text)
endfunction

function! s:Synonyms(text) abort
  call s:ShowResponse('syn', a:text)
endfunction

function! s:Antonyms(text) abort
  call s:ShowResponse('ant', a:text)
endfunction

function! s:LexicalField(text) abort
  call s:ShowResponse('lex', a:text)
endfunction

function! s:Equivalents(text) abort
  call s:ShowResponse('equ', a:text)
endfunction

function! s:Ask(prompt) abort
  call s:ShowResponse('ask', a:prompt)
endfunction

function! vim_config#llm#menu() abort
  let l:actions = [
        \ ['Other', function('s:Ask')],
        \ ['Refine', function('s:Refine')],
        \ ['To English', function('vim_config#llm#to_english')],
        \ ['To French', function('vim_config#llm#to_french')],
        \ ['Synonyms', function('s:Synonyms')],
        \ ['Antonyms', function('s:Antonyms')],
        \ ['Lexical field', function('s:LexicalField')],
        \ ['Equivalents', function('s:Equivalents')],
        \ ]
  let l:menu = ['LLM text (Esc cancels)']
  for l:index in range(1, len(l:actions) - 1) + [0]
    call add(l:menu, printf('%d. %s', l:index, l:actions[l:index][0]))
  endfor
  let l:choice = vim_config#popup#show(l:menu)
  if l:choice !~# '^\d$' || str2nr(l:choice) >= len(l:actions)
    return
  endif

  let l:text = input(l:choice ==# '0' ? 'Prompt: ' : 'Text: ')
  if empty(trim(l:text))
    return
  endif
  call call(l:actions[str2nr(l:choice)][1], [l:text])
endfunction
