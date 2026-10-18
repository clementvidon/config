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

function! s:ShowWords(action, text) abort
  let l:lines = s:Run(a:action, a:text)
  if !empty(l:lines)
    call vim_config#popup#show(l:lines)
  endif
endfunction

function! s:Refine(text) abort
  call append(line('.'), s:Run('ref', a:text))
endfunction

function! s:ToEnglish(text) abort
  call append(line('.'), s:Run('toe', a:text))
endfunction

function! s:ToFrench(text) abort
  call append(line('.'), s:Run('tof', a:text))
endfunction

function! s:Synonyms(text) abort
  call s:ShowWords('syn', a:text)
endfunction

function! s:Antonyms(text) abort
  call s:ShowWords('ant', a:text)
endfunction

function! s:LexicalField(text) abort
  call s:ShowWords('lex', a:text)
endfunction

function! s:Equivalents(text) abort
  call s:ShowWords('equ', a:text)
endfunction

function! s:Ask(prompt) abort
  let l:lines = s:Run('ask', a:prompt)
  if !empty(l:lines)
    call vim_config#scratch#show('Text response', l:lines)
  endif
endfunction

function! vim_config#llm#menu() abort
  let l:actions = [
        \ ['Other', function('s:Ask')],
        \ ['Refine', function('s:Refine')],
        \ ['To English', function('s:ToEnglish')],
        \ ['To French', function('s:ToFrench')],
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
