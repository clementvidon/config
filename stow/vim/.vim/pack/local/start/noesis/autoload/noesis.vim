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

" # STYLES

function! noesis#heading(level) abort
  let l:view = winsaveview()
  let l:prefix = repeat('#', a:level) . ' '
  call setline('.', l:prefix . getline('.'))
  let l:view.col += strlen(l:prefix)
  let l:view.curswant += strlen(l:prefix)
  call winrestview(l:view)
endfunction

function! noesis#underline() abort
  call append(line('.'), repeat('-', 80))
endfunction

function! s:SelectedRange(visual) abort
  let l:view = winsaveview()
  " Visual $ can place the cursor beyond the last text character.
  let l:view.col = min([l:view.col, max([0, match(getline('.'), '.$')])])
  try
    if !a:visual
      if getline('.') =~# '^\s*$'
        return {}
      endif
      normal! viw
    endif
    execute "normal! \<Esc>"
    if visualmode() ==# "\<C-V>"
      echo 'Noesis: select characters with v or lines with V'
      return {}
    endif
    let [l:first, l:start] = getpos("'<")[1:2]
    let [l:last, l:end] = getpos("'>")[1:2]
    let l:lines = getline(l:first, l:last)
    if visualmode() ==# 'V'
      let l:start = 0
      let l:end = strlen(l:lines[-1])
    else
      let l:start -= 1
      let l:end = min([l:end - 1, strlen(l:lines[-1])])
      if &selection !=# 'exclusive' || (l:first == l:last && l:start == l:end)
        let l:end += strlen(matchstr(strpart(l:lines[-1], l:end), '^.'))
      endif
    endif
    let l:text = join(l:lines, "\n")
    let l:end += strlen(l:text) - strlen(l:lines[-1])
    return {'first': l:first, 'last': l:last, 'linewise': visualmode() ==# 'V',
          \ 'text': l:text, 'start': l:start, 'end': l:end, 'view': l:view,
          \ 'body': strpart(l:text, l:start, l:end - l:start)}
  finally
    call winrestview(l:view)
  endtry
endfunction

function! s:InlineRange(visual) abort
  let l:range = s:SelectedRange(a:visual)
  if !empty(l:range) && l:range.body =~# '\n[ \t]*\n'
    echo 'Noesis: select text within one paragraph'
    return {}
  endif
  return l:range
endfunction

function! s:TrimRange(range) abort
  if !empty(a:range)
    let a:range.start += strlen(matchstr(a:range.body, '^\_s*'))
    let a:range.body = trim(a:range.body)
    let a:range.end = a:range.start + strlen(a:range.body)
  endif
  return a:range
endfunction

function! s:ShiftCursor(view, first, preceding, added) abort
  let l:lines = split(a:preceding, "\n", 1)
  if a:view.lnum == a:first + len(l:lines) - 1
        \ && a:view.col >= strlen(l:lines[-1])
    let a:view.col += strlen(a:added)
    let a:view.curswant += strdisplaywidth(a:added)
  endif
endfunction

function! s:Wrap(range, open, body, close) abort
  let l:before = strpart(a:range.text, 0, a:range.start)
  let l:after = strpart(a:range.text, a:range.end)
  call setline(a:range.first, split(l:before . a:open . a:body . a:close . l:after, "\n", 1))
  call s:ShiftCursor(a:range.view, a:range.first,
        \ strpart(a:range.text, 0, a:range.end), a:close)
  call s:ShiftCursor(a:range.view, a:range.first, l:before, a:open)
  call winrestview(a:range.view)
endfunction

function! noesis#italic(visual) abort
  let l:range = s:TrimRange(s:InlineRange(a:visual))
  if !empty(l:range) && !empty(l:range.body)
    call s:Wrap(l:range, '*', l:range.body, '*')
  endif
endfunction

function! noesis#bold(visual) abort
  let l:range = s:TrimRange(s:InlineRange(a:visual))
  if !empty(l:range) && !empty(l:range.body)
    call s:Wrap(l:range, '**', l:range.body, '**')
  endif
endfunction

function! noesis#link(visual) abort
  let l:range = s:TrimRange(s:InlineRange(a:visual))
  if empty(l:range) || empty(l:range.body)
    return
  endif
  let l:label = escape(l:range.body, '\[]')
  call s:Wrap(l:range, '[', l:label, ']()')
  let l:target = split(strpart(l:range.text, 0, l:range.start) . '[' . l:label . '](', "\n", 1)
  call cursor(l:range.first + len(l:target) - 1, strlen(l:target[-1]) + 1)
  startinsert
endfunction

function! noesis#quote(visual) abort
  let l:range = a:visual ? s:SelectedRange(1)
        \ : {'first': line('.'), 'last': line('.'), 'view': winsaveview()}
  if empty(l:range)
    return
  endif
  let l:lines = getline(l:range.first, l:range.last)
  call setline(l:range.first, map(l:lines, 'empty(v:val) ? ">" : "> " . v:val'))
  let l:range.view.col += 2
  let l:range.view.curswant += 2
  call winrestview(l:range.view)
endfunction

function! s:CodeDelimiter(text, minimum) abort
  let l:runs = map(split(a:text, '[^`]\+'), 'strlen(v:val)')
  return repeat('`', max([a:minimum - 1] + l:runs) + 1)
endfunction

function! s:Fence(range) abort
  let l:fence = s:CodeDelimiter(a:range.text, 3)
  call append(a:range.last, l:fence)
  undojoin
  call append(a:range.first - 1, l:fence)
  call cursor(a:range.first, strlen(l:fence))
  startinsert!
endfunction

function! noesis#code(visual) abort
  let l:range = s:SelectedRange(a:visual)
  if empty(l:range)
    return
  endif
  if l:range.linewise
    call s:Fence(l:range)
    return
  endif
  if empty(l:range.body) || l:range.body =~# '\n[ \t]*\n'
    echo 'Noesis: select text within one paragraph'
    return
  endif
  let l:open = s:CodeDelimiter(l:range.body, 1)
  let l:close = l:open
  " Markdown strips one padding space on each side of a code span.
  if l:range.body =~# '^`\|`$' || (l:range.body =~# '^ .* $' && l:range.body =~# '\S')
    let l:open .= ' '
    let l:close = ' ' . l:close
  endif
  call s:Wrap(l:range, l:open, l:range.body, l:close)
endfunction

" ## code blocks

function! s:CodeBlocks(lines) abort
  let l:blocks = []
  let l:fence = ''
  for l:index in range(len(a:lines))
    let l:line = a:lines[l:index]
    if empty(l:fence)
      let l:fence = matchstr(l:line, '^[ \t]\{0,3}\zs\(`\{3,}\|[~]\{3,}\)')
      if l:fence =~# '^`' && strpart(l:line, matchend(l:line, '`\+')) =~# '`'
        let l:fence = ''
      endif
      if !empty(l:fence)
        call add(l:blocks, [l:index + 1, len(a:lines) + 1])
      endif
    elseif l:line =~# '^[ \t]\{0,3}[' . l:fence[0] . ']\{' . strlen(l:fence) . ',}[ \t]*$'
      let l:blocks[-1][1] = l:index + 1
      let l:fence = ''
    endif
  endfor
  return l:blocks
endfunction

function! s:CodeBlockAt(lnum, blocks) abort
  for l:block in a:blocks
    if a:lnum >= l:block[0] && a:lnum <= l:block[1]
      return l:block
    endif
  endfor
  return []
endfunction

" # INDEX

function! s:IndexBlock(lines) abort
  let l:start = 0
  while l:start < len(a:lines) && a:lines[l:start] !~# '^\s*$'
    let l:start += 1
  endwhile
  while l:start < len(a:lines) && a:lines[l:start] =~# '^\s*$'
    let l:start += 1
  endwhile
  if get(a:lines, l:start, '') !=# '<!-- INDEX {{{'
    return {}
  endif
  let l:end = index(a:lines, 'INDEX }}} -->', l:start + 1)
  if l:end < 0
    throw 'Noesis: existing index is not closed'
  endif
  return {'start': l:start, 'first': l:start + 1, 'end': l:end}
endfunction

function! s:Headings(lines, start) abort
  let l:headings = []
  let l:blocks = s:CodeBlocks(a:lines)
  for l:index in range(a:start, len(a:lines) - 1)
    let l:line = a:lines[l:index]
    if !empty(s:CodeBlockAt(l:index + 1, l:blocks))
      continue
    endif
    let l:heading = matchlist(l:line, '^\(#\{2,3}\)\s\+\(\S.*\)$')
    if !empty(l:heading)
      let l:level = len(l:heading[1])
      let l:title = trim(substitute(l:heading[2], '\s\+#\+\s*$', '', ''))
    elseif l:line =~# '^\S' && l:line !~# '^#'
          \ && get(a:lines, l:index + 1, '') =~# '^-\{80}\s*$'
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
    if empty(l:block)
      echo 'Noesis: no headings found'
      return
    endif
    let l:output = l:opening + [''] + l:body
  else
    let l:output = l:opening + ['', '<!-- INDEX {{{']
          \ + l:entries + ['INDEX }}} -->', ''] + l:body
  endif
  call setline(1, l:output)
  if line('$') > len(l:output)
    silent! undojoin
    call deletebufline('%', len(l:output) + 1, '$')
  endif
  if !empty(l:entries)
    call cursor(len(l:opening) + 2, 1)
    normal! zMzv
  endif
endfunction

function! noesis#index_jump() abort
  let l:lines = getline(1, '$')
  let l:block = s:IndexBlock(l:lines)
  let l:entry = line('.') - 1
  if empty(l:block)
    return
  endif
  let l:headings = s:Headings(l:lines, l:block.end + 1)
  " Entry order distinguishes identical titles; re-read positions after edits.
  if map(copy(l:headings), 'v:val.entry') !=# l:lines[l:block.first:l:block.end - 1]
    echo 'Noesis: headings changed; refresh the index with <LocalLeader>g'
    return
  endif
  if l:entry >= l:block.first && l:entry < l:block.end
    let l:destination = l:headings[l:entry - l:block.first].line
  else
    let l:index = index(map(copy(l:headings), 'v:val.line'), line('.'))
    if l:index < 0
      return
    endif
    let l:destination = l:block.first + l:index + 1
  endif
  call cursor(l:destination, 1)
  normal! zvzt
  let l:scroll = winheight(0) * 3 / 10 - winline()
  if l:scroll > 0
    execute 'normal! ' . l:scroll . "\<C-Y>"
  endif
endfunction

" # SEARCH

function! noesis#grep(pattern) abort
  if !executable('rg')
    throw 'Noesis: rg is not installed'
  endif
  let l:command = 'rg --vimgrep --smart-case --hidden --glob='
        \ . shellescape('*.md')
        \ . ' --glob=' . shellescape('!*.gpg.md')
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
