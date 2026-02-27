" syntax/achiever.vim
if exists("b:current_syntax")
    finish
endif

syn keyword Todo TODO FIXME X XXX WIP

" syn match achieverTaskNamespaceSign /\(\s\a\a\a\a:\s\)\@<=\(@\)/                                " TODO
" syn match achieverTaskNamespace /\(\s\a\a\a\a:\s@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\)/       " TODO
syn match achieverTaskTimestamp /\(\s\)\zs\(\d\d\d\d\d\d\s\d\d:\d\d\)\ze\(\s\)/                 " ' <000000 00:00> '
syn match achieverTaskTimestamp /\(\s\d\d\d\d\d\d\s\d\d:\d\d\s\)\@<=\(\d\d:\d\d\)\ze\(\s\)/     " ' 000000 00:00 <00:00> '
syn match achieverTaskPrefixWork /\(\swork:\s\)/                                                " ' <work:> '
syn match achieverTaskPrefixLife /\(\slife:\s\)/                                                " ' <life:> '
" syntax match achieverTaskLifeText /\(\slife:\s\)\@<=.*$/                        " ' life: <…>('
syntax match achieverTaskLifeText /\(\slife:\s\)\@<=.\{-}\ze\(\s& work: \|\s& life: \|\s+ work: \|\s+ life: \|$\)/
" syntax match achieverTaskDetail /\(\s\a\a\a\a:\s.*\)\@<=(\s.\{-}\s)/
" syntax match achieverTaskFeedback /\(\s\a\a\a\a:\s.*\)\@<={\s.\{-}\s}/
syntax match achieverTaskTempComment /--\s.*/

if &background ==# 'dark'
    highlight default achieverTaskLifeText          ctermfg=103
    " highlight default achieverTaskNamespaceSign     ctermfg=105
    " highlight default achieverTaskNamespace         ctermfg=141
    highlight default achieverTaskTimestamp         ctermfg=60
    " highlight default achieverTaskPrefixMain        ctermfg=211
    highlight default achieverTaskPrefixWork        ctermfg=175
    highlight default achieverTaskPrefixLife        ctermfg=139
    highlight default achieverTaskTempComment       ctermfg=8
    " highlight default achieverTaskDetail            ctermfg=146
    " highlight default achieverTaskFeedback          ctermfg=182
elseif &background ==# 'light'
    highlight default achieverTaskLifeText          ctermfg=146
    " highlight default achieverTaskNamespaceSign     ctermfg=138
    " highlight default achieverTaskNamespace         ctermfg=102
    highlight default achieverTaskTimestamp         ctermfg=103
    " highlight default achieverTaskPrefixMain        ctermfg=205
    highlight default achieverTaskPrefixWork        ctermfg=170
    highlight default achieverTaskPrefixLife        ctermfg=134
    highlight default achieverTaskTempComment       ctermfg=7
    " highlight default achieverTaskDetail            ctermfg=146
    " highlight default achieverTaskFeedback          ctermfg=139
endif

let b:current_syntax = 'achiever'

