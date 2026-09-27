" Note operations; no dependency on the surrounding personal configuration.

" # LANGUAGE TOOLS

function! noesis#text_from_cursor() abort
  return strpart(getline('.'), col('.') - 1)
endfunction

function! noesis#visual_text() abort
  let l:unnamed = getreginfo('"')
  let l:yank = getreginfo('0')
  try
    silent normal! gvy
    return getreg('"')
  finally
    call setreg('0', l:yank)
    call setreg('"', l:unnamed)
  endtry
endfunction

function! s:RunTextTool(action, text) abort
  if !executable('llm-text')
    throw 'Noesis: llm-text is not installed'
  endif
  let l:command = shellescape(exepath('llm-text')) . ' ' . shellescape(a:action)
  let l:output = systemlist(l:command, a:text)
  if v:shell_error
    throw 'Noesis: llm-text failed'
  endif
  return l:output
endfunction

function! noesis#translate(action, text) abort
  call append(line('.'), s:RunTextTool(a:action, a:text))
endfunction

function! noesis#synonym(text) abort
  echo join(s:RunTextTool('syn', a:text), "\n")
endfunction

" # HTML EXPORT

function! noesis#export_html() abort
  if get(b:, 'vim_sensitive_buffer', 0)
    throw 'Noesis: refusing to export a sensitive buffer'
  endif
  TOhtml
  let l:author = get(g:, 'noesis_export_author', '')
  let l:author = substitute(l:author, '&', '\&amp;', 'g')
  let l:author = substitute(l:author, '[<>"'']', '\=printf("&#%d;", char2nr(submatch(0)))', 'g')
  let l:lines = getline(1, '$')
  let l:output = []
  for l:line in l:lines
    let l:line = substitute(l:line, '\.noesisItalic {[^}]*}',
          \ '.noesisItalic { color: #87AFFF; font-style: italic; }', 'g')
    let l:line = substitute(l:line, '\.noesisBold {[^}]*}',
          \ '.noesisBold { color: #EBCB8B; font-weight: bold; }', 'g')
    let l:line = substitute(l:line, '\.Todo {[^}]*}',
          \ '.Todo { color: #EBCB8B; font-weight: bold; }', 'g')
    let l:line = substitute(l:line, 'background-color: #000000;', 'background-color: #2e333f;', 'g')
    let l:line = substitute(l:line, '^\(\.noesis[^}]*\)}', '\1font-size: inherit; }', '')
    let l:line = substitute(l:line, '\* { font-size: 1em; }', '* { font-size: 1.1em; }', '')
    if l:line =~# '</style>'
      call extend(l:output, ['a { color: #8787af; font-size: inherit; }',
            \ 'footer { font-style: italic; font-size: 0.8em; }'])
    endif
    if l:line =~# '</head>' && !empty(l:author)
      call add(l:output, '<meta name="author" content="' . l:author . '">')
      if !empty(get(g:, 'noesis_export_copyright', ''))
        let l:copyright = substitute(g:noesis_export_copyright, '[&<>"'']',
              \ '\=printf("&#%d;", char2nr(submatch(0)))', 'g')
        call add(l:output, '<meta name="copyright" content="' . l:copyright . '">')
      endif
    endif
    if l:line =~# '</body>' && !empty(get(g:, 'noesis_export_footer', ''))
      call add(l:output, '<footer>' . g:noesis_export_footer . '</footer>')
    endif
    call add(l:output, l:line)
  endfor
  call setline(1, l:output)
endfunction

" # INDEX

function! s:IndexBlock(lines) abort
  let l:start = 0
  " Accept an older index at the top, or the index after the opening paragraph.
  if index(['INDEX', '<!-- INDEX {{{'], get(a:lines, 0, '')) < 0
    while l:start < len(a:lines) && a:lines[l:start] !~# '^\s*$'
      let l:start += 1
    endwhile
    while l:start < len(a:lines) && a:lines[l:start] =~# '^\s*$'
      let l:start += 1
    endwhile
  endif
  if get(a:lines, l:start, '') ==# '<!-- INDEX {{{'
    let l:marker = l:start
    let l:closing = 'INDEX }}} -->'
  elseif get(a:lines, l:start, '') ==# 'INDEX'
        \ && get(a:lines, l:start + 1, '') =~# '^\(-\{60}\|=\{80}\)$'
    let l:marker = l:start + 2
    while get(a:lines, l:marker, 'nonempty') =~# '^\s*$'
      let l:marker += 1
    endwhile
    if get(a:lines, l:marker, '') !=# '{{{'
      return {}
    endif
    let l:closing = '}}}'
  else
    return {}
  endif
  let l:end = index(a:lines, l:closing, l:marker + 1)
  if l:end < 0
    throw 'Noesis: existing index is not closed'
  endif
  return {'start': l:start, 'first': l:marker + 1, 'end': l:end}
endfunction

function! s:Headings(lines, start) abort
  let l:headings = []
  let l:fence = ''
  for l:index in range(a:start, len(a:lines) - 1)
    let l:line = a:lines[l:index]
    if !empty(l:fence)
      if l:line =~# '^\s*[' . l:fence[0] . ']\{' . len(l:fence) . ',}\s*$'
        let l:fence = ''
      endif
      continue
    endif
    let l:fence = matchstr(l:line, '^\s*\zs\(`\{3,}\|[~]\{3,}\)')
    if !empty(l:fence)
      continue
    endif
    let l:heading = matchlist(l:line, '^\(#\{2,3}\)\s\+\(\S.*\)$')
    if !empty(l:heading)
      let l:level = len(l:heading[1])
      let l:title = trim(substitute(l:heading[2], '\s\+#\+\s*$', '', ''))
    elseif l:line =~# '^\S' && l:line !~# '^#'
          \ && get(a:lines, l:index + 1, '') =~# '^-\{60}\s*$'
      let l:level = 2
      let l:title = trim(l:line)
    else
      continue
    endif
    call add(l:headings, {'line': l:index + 1,
          \ 'entry': repeat(' ', 2 * (l:level - 1)) . l:title})
  endfor
  return l:headings
endfunction

function! noesis#index() abort
  let l:lines = getline(1, '$')
  let l:block = s:IndexBlock(l:lines)
  if !empty(l:block)
    call remove(l:lines, l:block.start, l:block.end)
    while !empty(l:lines) && l:lines[0] =~# '^\s*$'
      call remove(l:lines, 0)
    endwhile
  endif
  let l:split = 0
  while l:split < len(l:lines) && l:lines[l:split] !~# '^\s*$'
    let l:split += 1
  endwhile
  let l:opening = l:split ? l:lines[:l:split - 1] : []
  while l:split < len(l:lines) && l:lines[l:split] =~# '^\s*$'
    let l:split += 1
  endwhile
  let l:body = l:lines[l:split:]
  let l:entries = map(s:Headings(l:body, 0), 'v:val.entry')
  if empty(l:entries)
    echo 'Noesis: no headings found'
    return
  endif
  let l:output = l:opening + ['', '<!-- INDEX {{{']
        \ + l:entries + ['INDEX }}} -->', ''] + l:body
  call setline(1, l:output)
  if line('$') > len(l:output)
    silent! undojoin
    call deletebufline('%', len(l:output) + 1, '$')
  endif
  call cursor(len(l:opening) + 2, 1)
  normal! zMzv
endfunction

function! noesis#index_jump() abort
  let l:lines = getline(1, '$')
  let l:block = s:IndexBlock(l:lines)
  let l:entry = line('.') - 1
  if empty(l:block) || l:entry < l:block.first || l:entry >= l:block.end
    return
  endif
  let l:headings = s:Headings(l:lines, l:block.end + 1)
  " Entry order distinguishes identical titles; re-read positions after edits.
  if map(copy(l:headings), 'v:val.entry') !=# l:lines[l:block.first:l:block.end - 1]
    echo 'Noesis: headings changed; refresh the index with <LocalLeader>I'
    return
  endif
  call cursor(l:headings[l:entry - l:block.first].line, 1)
  normal! zvzt
endfunction

" # SEARCH

function! noesis#grep(pattern) abort
  if !executable('rg')
    throw 'Noesis: rg is not installed'
  endif
  let l:command = 'rg --vimgrep --smart-case --hidden --glob='
        \ . shellescape('*.noe')
        \ . ' --glob=' . shellescape('!*.gpg.noe')
        \ . ' --glob=' . shellescape('!**/.git/**')
        \ . ' -- ' . shellescape(a:pattern) . ' ' . shellescape(g:noesis_root)
  let l:lines = systemlist(l:command)
  if v:shell_error > 1
    throw 'Noesis: rg failed'
  endif
  call setqflist([], 'r', {
        \ 'title': 'Noesis: ' . a:pattern,
        \ 'lines': l:lines,
        \ 'efm': '%f:%l:%c:%m',
        \ })
  cwindow
endfunction
