" Task timestamp, duration, linking, and detail-formatting operations.

" # TASK TIMESTAMPS

let s:time = '\%([01]\d\|2[0-3]\):[0-5]\d'
let s:date_time = '\d\{6} ' . s:time
let s:clock_token = '\d\d:\d\d'
let s:task_open = '^- ' . s:date_time . ' \%('
      \ . s:clock_token . '\%(\s\|$\)\)\@!\S'
let s:task_closed = '^- ' . s:date_time . ' ' . s:time . ' \S'
let s:metadata_shaped = '^- \d\{6} ' . s:clock_token . '\%(\s\|$\)'

function! s:InvalidTimestampMetadata(line) abort
  if a:line !~# s:metadata_shaped
    return 0
  endif
  let l:fields = split(a:line)
  if len(l:fields) < 3 || l:fields[2] !~# '^' . s:time . '$'
    return 1
  endif
  return len(l:fields) >= 4 && l:fields[3] =~# '^' . s:clock_token . '$'
        \ && l:fields[3] !~# '^' . s:time . '$'
endfunction

function! achiever#task_check() abort
  let l:cursor = getpos('.')
  let [l:datestamp, l:timestamp] = split(s:RoundedTimestamp())
  let l:line = getline('.')

  if s:InvalidTimestampMetadata(l:line)
    echo 'task check: invalid time metadata'
  elseif l:line =~# s:task_closed
    let l:newline = substitute(l:line,
          \ '^- ' . s:date_time . ' \zs' . s:time . '\ze ', l:timestamp, '')
  elseif l:line =~# s:task_open
    let l:newline = substitute(l:line,
          \ '^- ' . s:date_time . '\zs \ze\S', ' ' . l:timestamp . ' ', '')
  elseif l:line =~# s:metadata_shaped
    echo 'task check: invalid time metadata'
  elseif l:line =~# '^- \S'
    let l:newline = substitute(l:line,
          \ '^-\zs \ze.', ' ' . l:datestamp . ' ' . l:timestamp . ' ', '')
  endif
  if exists('l:newline')
    call setline('.', l:newline)
    echom 'task check: ' . l:datestamp . ' ' . l:timestamp
  endif
  call setpos('.', l:cursor)
endfunction

function! s:RoundedTimestamp(...) abort
  let l:now = get(a:, 1, localtime())
  let l:rounded = (l:now + 150) / 300 * 300
  return strftime('%y%m%d %H:%M', l:rounded)
endfunction

function! achiever#task_clear() abort
  if s:InvalidTimestampMetadata(getline('.'))
    echo 'task clear: invalid time metadata'
    return
  endif
  call setline('.', substitute(
        \ getline('.'),
        \ '^-\zs ' . s:date_time . '\%( ' . s:time . '\)\?\ze ',
        \ '',
        \ 'e'))
endfunction

" # TASK LINKING

function! s:TaskForLinking() abort
  let l:task = getline('.')
  if s:InvalidTimestampMetadata(l:task) || (l:task !~# s:task_closed && l:task !~# s:task_open)
    echo 'Task linking: the current line is not a valid task'
    return ''
  endif
  return l:task
endfunction

function! achiever#task_link_begin() abort
  let l:task = s:TaskForLinking()
  if empty(l:task)
    return
  endif
  let l:source = s:FindMatchingLine(line('.') + 1, s:task_closed, '^$', 1)
  if !l:source
    echo 'Task linking: no sibling task found'
    return
  endif
  let l:time = matchstr(getline(l:source), '^- ' . s:date_time . ' \zs' . s:time . '\ze ')
  let l:updated = substitute(l:task, '^- \d\{6} \zs' . s:time . '\ze ', l:time, '')
  if l:updated !=# l:task
    call setline('.', l:updated)
  endif
endfunction

function! achiever#task_link_end() abort
  let l:task = s:TaskForLinking()
  if empty(l:task)
    return
  endif
  let l:source = s:FindMatchingLine(line('.') - 1, s:task_closed . '\|' . s:task_open, '^$', -1)
  if !l:source
    echo 'Task linking: no sibling task found'
    return
  endif
  let l:time = matchstr(getline(l:source), '^- \d\{6} \zs' . s:time . '\ze ')
  if l:task =~# s:task_closed
    let l:updated = substitute(l:task, '^- ' . s:date_time . ' \zs' . s:time . '\ze ', l:time, '')
  else
    let l:updated = substitute(l:task, '^\(- ' . s:date_time . '\)\zs', ' ' . l:time, '')
  endif
  if l:updated !=# l:task
    call setline('.', l:updated)
  endif
endfunction

function! s:FindMatchingLine(start_line, pattern, abort_pattern, step) abort
  let l:line = a:start_line
  while l:line >= 1 && l:line <= line('$')
    if getline(l:line) =~# a:pattern
      return l:line
    elseif getline(l:line) =~# a:abort_pattern
      break
    endif
    let l:line += a:step
  endwhile
  return 0
endfunction

" # DURATIONS

function! s:TaskDuration(line) abort
  let l:time_pair = matchstr(a:line,
        \ '^- \d\{6} \zs' . s:time . ' ' . s:time . '\ze \S')
  if empty(l:time_pair)
    return -1
  endif
  let [l:start, l:end] = map(split(l:time_pair),
        \ '(str2nr(v:val[:1]) * 60 + str2nr(v:val[3:])) * 60')
  return l:end - l:start + (l:end < l:start ? 24 * 60 * 60 : 0)
endfunction

function! achiever#task_duration(line) abort
  let l:duration = s:TaskDuration(a:line)
  echo l:duration < 0 ? 'No valid time range found.'
        \ : 'Duration: ' . s:FormatSeconds(l:duration)
endfunction

function! achiever#task_duration_add() abort
  let l:duration = s:TaskDuration(getline('.'))
  if l:duration < 0
    echo 'No valid time range found.'
    return
  endif
  let b:achiever_total_difference_seconds =
        \ get(b:, 'achiever_total_difference_seconds', 0) + l:duration
  call achiever#task_duration_total()
endfunction

function! achiever#task_duration_total() abort
  echo 'Total duration: '
        \ . s:FormatSeconds(get(b:, 'achiever_total_difference_seconds', 0))
endfunction

function! achiever#task_duration_reset() abort
  let b:achiever_total_difference_seconds = 0
  call achiever#task_duration_total()
endfunction

function! s:FormatSeconds(seconds) abort
  let l:hours = a:seconds / 3600
  let l:minutes = (a:seconds % 3600) / 60
  return printf('%02d:%02d', l:hours, l:minutes)
endfunction

" # DETAIL FORMATTING

function! achiever#task_detail_toggle_view(prefix) abort
  let l:current_line = getline('.')
  let l:lnum = line('.')

  if l:current_line =~# ' work: ' || l:current_line =~# ' life: '
    let l:separator = '\V ' . escape(a:prefix, '\') . ' '
    if len(split(l:current_line, l:separator)) > 2
      let l:parts = split(l:current_line, l:separator)
      call setline(l:lnum, l:parts[0] . ' ' . a:prefix . ' ' . l:parts[1])
      if len(l:parts) > 1
        call append(l:lnum, map(l:parts[2:], {_, val -> '  ' . a:prefix . ' ' . val}))
      endif
    else
      let l:next_lines = []
      let l:current_lnum = l:lnum + 1
      let l:start_delete = l:current_lnum

      let l:prefix_pattern = '^\s\+\V' . escape(a:prefix, '\') . ' '
      while getline(l:current_lnum) =~# l:prefix_pattern
        call add(l:next_lines, substitute(getline(l:current_lnum), l:prefix_pattern, '', ''))
        let l:current_lnum += 1
      endwhile

      let l:end_delete = l:current_lnum - 1

      if l:end_delete >= l:start_delete
        call deletebufline('', l:start_delete, l:end_delete)
      endif

      if !empty(l:next_lines)
        let l:joined = ' ' . a:prefix . ' ' . join(l:next_lines, ' ' . a:prefix . ' ')
        call setline(l:lnum, l:current_line . l:joined)
      endif
    endif
  endif
endfunction
