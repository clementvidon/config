" syntax/todo
" Created: 230727 22:10:11 by clem@spectre
" Updated: 230728 13:26:22 by clem@spectre
" Maintainer: Clément Vidon

" if exists("b:current_syntax_addon")
"     finish
" endif


"   syntax


syn match todoTaskTime              /^\(-\|\~\|\*\)\zs\s(\s.*\s)\ze\s./
syn match todoTaskDone              /^\(-\|\~\|\*\)\zs\s\d\{6}\(\s\d\d:\d\d\)\{1,2}\ze\s./


syn match todoTaskFeedback          /\s{\s.*\s}$/
syn match todoTaskUnplanned         /^\~\s/ contains=todoTaskDone


"   highlight


" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

if &background == "dark"

    hi todoTaskTime                 ctermfg=103
    hi todoTaskDone                 ctermfg=60

    hi todoTaskFeedback             ctermfg=103
    hi todoTaskUnplanned            ctermfg=138

elseif &background == "light"

    hi todoTaskTime                ctermfg=250
    hi todoTaskDone                ctermfg=101

    hi todoTaskFeedback            ctermfg=grey

endif


" let b:current_syntax_addon = "todo"
