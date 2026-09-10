" Syntax and terminal highlights for the Achiever filetype component.

"   syntax definitions

syntax keyword Todo TODO FIXME X XXX WIP

syntax match achieverTaskTimestamp /^- \zs\d\{6} \%([01]\d\|2[0-3]\):[0-5]\d\%( \%([01]\d\|2[0-3]\):[0-5]\d\)\?\%( \d\d:\d\d\%(\s\|$\)\)\@!\ze \S/
syntax match achieverTaskPrefixWork /\(\swork:\s\)/
syntax match achieverTaskPrefixLife /\(\slife:\s\)/
syntax match achieverTaskLifeText /\(\slife:\s\)\@7<=.\{-}\ze\(\s& work: \|\s& life: \|\s+ work: \|\s+ life: \|$\)/
execute 'syntax region achieverTaskTempComment start=/\V'
      \ . escape(get(b:, 'achiever_task_detail_prefix', get(g:, 'achiever_task_detail_prefix', '--')), '\/')
      \ . '\m\s/ end=/\(\\\|$\)/'

"   highlights

function! s:Colors() abort
  if &background ==# 'dark'
    highlight achieverTaskLifeText          ctermfg=103
    highlight achieverTaskTimestamp         ctermfg=60
    highlight achieverTaskPrefixWork        ctermfg=175
    highlight achieverTaskPrefixLife        ctermfg=139
    highlight achieverTaskTempComment       ctermfg=8
  elseif &background ==# 'light'
    highlight achieverTaskLifeText          ctermfg=146
    highlight achieverTaskTimestamp         ctermfg=103
    highlight achieverTaskPrefixWork        ctermfg=170
    highlight achieverTaskPrefixLife        ctermfg=134
    highlight achieverTaskTempComment       ctermfg=7
  endif
endfunction
call s:Colors()

"   colorscheme integration

augroup achiever_colors
  autocmd!
  autocmd ColorScheme * call <SID>Colors()
augroup END

let b:current_syntax = empty(get(b:, 'current_syntax', ''))
      \ ? 'achiever' : b:current_syntax . '.achiever'
