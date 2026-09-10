" Task timestamp, duration, linking, and detail-formatting operations.

"   task timestamps

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

"   task linking

function! achiever#task_fix(option) abort
  let l:cursor = getpos('.')
  let l:destination_line = line('.')
  let l:destination = getline(l:destination_line)

  if !s:InvalidTimestampMetadata(l:destination)
        \ && (l:destination =~# s:task_closed || l:destination =~# s:task_open)
    let l:task_timestamp_pattern = '^- ' . s:date_time
          \ . '\%( ' . s:time . '\)\? '
    if a:option ==# 'time_beg'
      let l:step = 1
      let l:source_task_pattern = s:task_closed
      let l:source_time_pattern = '^- ' . s:date_time . ' \zs' . s:time . '\ze '
      let l:destination_time_pattern = '^- \d\{6} \zs' . s:time . '\ze '
    elseif a:option ==# 'time_end'
      let l:step = -1
      let l:source_task_pattern = s:task_closed . '\|' . s:task_open
      let l:source_time_pattern = '^- \d\{6} \zs' . s:time . '\ze '
      let l:destination_time_pattern = '^- ' . s:date_time . ' \zs' . s:time . '\ze '
    endif
  else
    echo 'task_fix: The current line is not a valid task.'
  endif

  if exists('l:step')
    let l:source_line = s:FindMatchingLine(
          \ l:destination_line + l:step, l:source_task_pattern, '^$', l:step)
    if l:source_line == 0
      echo 'task_fix: No sibling task found.'
      return 1
    endif
    let l:source_time = matchstr(getline(l:source_line), l:source_time_pattern)
    let l:destination_time = matchstr(l:destination, l:destination_time_pattern)
    if l:source_time ==# l:destination_time
      echo 'task_fix: Nothing to be done.'
      return 1
    endif
    if empty(l:destination_time) && a:option ==# 'time_end'
      let l:updated = substitute(l:destination,
            \ '^\(- ' . s:date_time . '\)\zs', ' ' . l:source_time, '')
    else
      let l:updated = substitute(
            \ l:destination, l:destination_time_pattern, l:source_time, '')
    endif
    call setline('.', l:updated)
    echom 'task_fix: ' . matchstr(l:updated, l:task_timestamp_pattern)
  endif

  call setpos('.', l:cursor)
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

"   durations

function! achiever#task_duration(line) abort
  let l:time_pair = matchstr(
        \ a:line,
        \ '^- \d\{6} \zs' . s:time . ' ' . s:time . '\ze \S')
  if empty(l:time_pair)
    if s:InvalidTimestampMetadata(a:line)
      echo 'Invalid time range.'
      return
    endif
    if get(b:, 'achiever_total_difference_seconds', 0) != 0
      echo 'Total duration: ' . s:FormatSeconds(b:achiever_total_difference_seconds)
      let l:choice = input('No time range found. Reset total duration? y/n ')
      if tolower(l:choice) ==# 'y'
        let b:achiever_total_difference_seconds = 0
      endif
    else
      echo 'No time range found in the line.'
    endif
    return
  endif
  let [l:time1, l:time2] = split(l:time_pair)
  let [l:hour1, l:minute1] = map(split(l:time1, ':'), 'str2nr(v:val)')
  let [l:hour2, l:minute2] = map(split(l:time2, ':'), 'str2nr(v:val)')
  let l:timestamp1 = (l:hour1 * 60 + l:minute1) * 60
  let l:timestamp2 = (l:hour2 * 60 + l:minute2) * 60
  if l:timestamp1 > l:timestamp2
    let l:timestamp2 += 24 * 60 * 60
  endif
  let l:duration = l:timestamp2 - l:timestamp1
  let b:achiever_total_difference_seconds =
        \ get(b:, 'achiever_total_difference_seconds', 0) + l:duration

  echo 'This duration: ' . s:FormatSeconds(l:duration)
  echo 'All durations: ' . s:FormatSeconds(b:achiever_total_difference_seconds)
endfunction

function! s:FormatSeconds(seconds) abort
  let l:hours = a:seconds / 3600
  let l:minutes = (a:seconds % 3600) / 60
  return printf('%02d:%02d', l:hours, l:minutes)
endfunction

"   detail formatting

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
