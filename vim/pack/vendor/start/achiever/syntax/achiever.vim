" syntax/achiever.vim
if exists("b:current_syntax")
    finish
endif

syn match achieverTaskNamespaceSign /\(\s\a\a\a\a:\s\)\@<=\(@\)/                                    " TODO
syn match achieverTaskNamespace /\(\s\a\a\a\a:\s@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\)/   " TODO
syn match achieverTaskTimestamp /\(\s\)\zs\(\d\d\d\d\d\d\s\d\d:\d\d\)\ze\(\s\)/                 " ' <000000 00:00> '
syn match achieverTaskTimestamp /\(\s\d\d\d\d\d\d\s\d\d:\d\d\s\)\@<=\(\d\d:\d\d\)\ze\(\s\)/     " ' 000000 00:00 <00:00> '
syn match achieverTaskPrefixMain /\(\smain:\s\)/                                                " ' <main:> '
syn match achieverTaskPrefixSide /\(\sside:\s\)/                                                " ' <side:> '
syn match achieverTaskPrefixLife /\(\slife:\s\)/                                                " ' <life:> '
syn match achieverTaskDetail /\(^-.*\s\a\a\a\a:\s.*\)\@<=\(\s--\s.*$\)/                         " ' main: foobar <-- bar>'
syn match achieverTaskDetail /\(^\s\s--\s.*$\)\ze/                                              " '  line above is a task'

if &background ==# 'dark'
    highlight default achieverTaskNamespaceSign     ctermfg=105
    highlight default achieverTaskNamespace         ctermfg=141

    highlight default achieverTaskTimestamp         ctermfg=103
    highlight default achieverTaskPrefixMain        ctermfg=211
    highlight default achieverTaskPrefixSide        ctermfg=175
    highlight default achieverTaskPrefixLife        ctermfg=139
    highlight default achieverTaskDetail            ctermfg=146
elseif &background ==# 'light'
    " highlight default achieverTaskNamespaceSign     ctermfg=TODO
    " highlight default achieverTaskNamespace         ctermfg=TODO
    highlight default achieverTaskTimestamp         ctermfg=103
    highlight default achieverTaskPrefixMain        ctermfg=205
    highlight default achieverTaskPrefixSide        ctermfg=170
    highlight default achieverTaskPrefixLife        ctermfg=134
    highlight default achieverTaskDetail            ctermfg=146
endif

let b:current_syntax = 'achiever'

