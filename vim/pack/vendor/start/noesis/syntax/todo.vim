" syntax/todo
" Created: 230727 22:10:11 by clem@spectre
" Updated: 230728 13:26:22 by clem@spectre
" Maintainer: Clément Vidon

" if exists("b:current_syntax")
"     finish
" endif


"   syntax


syn match todoTaskTime /^\(-\|\~\)\zs\s(\s[a-zA-Z0-9: ]*\s)\ze\s./
syn match todoTaskDone /^\(-\|\~\)\zs\s\d\{6}\(\s\d\d:\d\d\)\{1,2}\ze\s./


syn match todoTaskDetail /\s\zs(\s[a-zA-Z0-9 ,-]*\s)\ze\(\s\|$\)/
syn match todoTaskFeedback /\s\zs{\s[a-zA-Z0-9]*\s}$/
syn match todoTaskUnplanned /^\~\s/ contains=todoTaskDone


"   highlight


if &background == "dark"

    hi todoTaskTime                 ctermfg=103
    hi todoTaskDone                 ctermfg=60

    hi todoTaskDetail               ctermfg=103
    hi todoTaskFeedback             ctermfg=194
    hi todoTaskUnplanned            ctermfg=138


elseif &background == "light"

    "   TODO

endif


" let b:current_syntax = "todo"
