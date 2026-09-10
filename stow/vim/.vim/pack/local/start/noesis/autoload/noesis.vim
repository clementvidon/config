" Note operations; no dependency on the surrounding personal configuration.

"   language tools

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

function! noesis#translate(from, to, text) abort
  if !executable('trans')
    throw 'Noesis: trans is not installed'
  endif
  let l:command = 'trans -from ' . shellescape(a:from)
        \ . ' -to ' . shellescape(a:to) . ' -brief 2>/dev/null'
  let l:translation = systemlist(l:command, a:text)
  if v:shell_error
    throw 'Noesis: trans failed'
  endif
  call append(line('.'), l:translation)
endfunction

function! noesis#translate_audio(text) abort
  if !executable('trans')
    throw 'Noesis: trans is not installed'
  endif
  silent !clear
  call system('trans -from fr -to en -brief -play 2>/dev/null', a:text)
  if v:shell_error
    throw 'Noesis: trans failed'
  endif
  redraw!
endfunction

function! noesis#synonym(text) abort
  if !executable('synonym')
    throw 'Noesis: synonym is not installed'
  endif
  let l:output = system('synonym ' . shellescape(a:text))
  if v:shell_error
    throw 'Noesis: synonym failed'
  endif
  echo l:output
endfunction

"   HTML export

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

"   index

function! noesis#index() abort
  let l:lines = getline(1, '$')
  let l:start = index(l:lines, 'INDEX')
  if l:start >= 0 && get(l:lines, l:start + 2, '') ==# '{{{'
    let l:end = index(l:lines, '}}}', l:start + 3)
    if l:end < 0
      throw 'Noesis: existing index is not closed'
    endif
    call remove(l:lines, l:start, l:end)
    if get(l:lines, l:start, 'nonempty') ==# ''
      call remove(l:lines, l:start)
    endif
  endif
  let l:entries = []
  for l:index in range(1, len(l:lines) - 1)
    if l:lines[l:index] =~# '^[-=]\{40,}'
      let l:title = trim(l:lines[l:index - 1])
      if !empty(l:title)
        call add(l:entries, (l:title =~# '[a-z0-9]$' ? '    ' : '  ') . l:title)
      endif
    endif
  endfor
  if empty(l:entries)
    echo 'Noesis: no underlined headings found'
    return
  endif
  let l:output = ['INDEX', repeat('=', 80), '{{{'] + l:entries + ['}}}', ''] + l:lines
  call setline(1, l:output)
  if line('$') > len(l:output)
    silent! undojoin
    call deletebufline('%', len(l:output) + 1, '$')
  endif
  normal! ggzM3Gzo
endfunction

function! noesis#index_jump() abort
  let l:pattern = '^\s\{0,4}\V' . escape(trim(getline('.')), '\') . '\m$'
  if search(l:pattern, 'w')
    normal! zt
  endif
endfunction

"   search

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
