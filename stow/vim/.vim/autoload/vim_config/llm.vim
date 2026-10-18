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
  let l:choice = vim_config#popup#show([
        \ 'LLM text (Esc cancels)',
        \ '1. Refine',
        \ '2. To English',
        \ '3. To French',
        \ '4. Synonyms',
        \ '5. Antonyms',
        \ '6. Lexical field',
        \ '7. Equivalents',
        \ '0. Other',
        \ ])
  if l:choice ==# '0'
    let l:prompt = input('Prompt: ')
    if !empty(trim(l:prompt))
      call s:Ask(l:prompt)
    endif
    return
  endif
  if l:choice !~# '^[1-7]$'
    return
  endif

  let l:text = input('Text: ')
  if empty(trim(l:text))
    return
  endif
  if l:choice ==# '1'
    call s:Refine(l:text)
  elseif l:choice ==# '2'
    call s:ToEnglish(l:text)
  elseif l:choice ==# '3'
    call s:ToFrench(l:text)
  elseif l:choice ==# '4'
    call s:Synonyms(l:text)
  elseif l:choice ==# '5'
    call s:Antonyms(l:text)
  elseif l:choice ==# '6'
    call s:LexicalField(l:text)
  elseif l:choice ==# '7'
    call s:Equivalents(l:text)
  endif
endfunction
