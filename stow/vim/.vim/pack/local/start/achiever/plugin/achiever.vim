" Achiever defaults and automatic dotted-filetype composition.

"   load guard

if exists('g:loaded_achiever')
  finish
endif
let g:loaded_achiever = 1

"   defaults

if !exists('g:achiever_local_leader')
  let g:achiever_local_leader = 'gh'
endif

if !exists('g:achiever_filenames')
  let g:achiever_filenames = [ 'achiever_todo', 'achiever_done', 'achiever.md' ]
endif

if !exists('g:achiever_task_detail_prefix')
  let g:achiever_task_detail_prefix = '--'
endif

if !exists('g:achiever_mappings')
  let g:achiever_mappings = {
        \ 'k': 'achiever#task_check()',
        \ 'c': 'achiever#task_clear()',
        \ 'F': 'achiever#task_fix("time_end")',
        \ 'f': 'achiever#task_fix("time_beg")',
        \ 'd': 'achiever#task_duration(getline("."))',
        \ 'x': 'achiever#task_detail_toggle_view("' . g:achiever_task_detail_prefix . '")',
        \ }
endif

"   filetype composition

function! s:Detect() abort
  " Vim loads dotted filetypes in order: the base first, then task helpers.
  if index(split(&l:filetype, '\.'), 'achiever') < 0
    let &l:filetype = empty(&l:filetype) ? 'achiever' : &l:filetype . '.achiever'
  endif
endfunction

"   autocommands

augroup achiever_settings
  autocmd!
  let s:achiever_filenames = join(map(copy(g:achiever_filenames), 'fnameescape(v:val)'), ',')
  " Wait until filetype detection and modelines have finished.
  execute 'autocmd BufWinEnter ' . s:achiever_filenames . ' nested call s:Detect()'
augroup END
