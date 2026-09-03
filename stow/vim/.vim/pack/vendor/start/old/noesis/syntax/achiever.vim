" syntax/achiever
" Created: 230727 22:10:11 by clem@spectre
" Updated: 240110 15:44:57 by clem@spectre
" Maintainer: Clément Vidon (clemedon)

" if exists("b:current_syntax")
"     finish
" endif


"   syntax


syn match achieverTimeClue /\(^\s\{0,2}[*-~]\s\)\@<=(\s\d\d:\d\d \d\d:\d\d\s)\ze\s/ " ( 00:00 00:00 )
syn match achieverTime /\s\d\{6}\(\s\d\d:\d\d\)\{1,2}\ze\s/                         " 000000 00:00 00:00
syn match achieverTime /\(^\s\{0,2}[*-~]\s\)\@<=\d\d:\d\d\ze\s/                     " 00:00
syn match achieverTime /\(^\s\{0,2}[*-~]\s\)\@<=\d\d:\d\d\s\d\d:\d\d\ze\s/          " 00:00 00:00

syn match achieverTagWork /\s\<work\>:\($\|\s\)/ " work:
syn match achieverTagSide /\s\<side\>:\($\|\s\)/ " side:
syn match achieverTagLife /\s\<life\>:\($\|\s\)/ " life:

syn match achieverDetail /\s\zs--\s.*\($\|\ze\s{\)/ contains=Todo,achieverFeedback  " -- detail
syn match achieverFeedback /\s\zs{\s.\{-}\s}/                                       " { feedback }
syn match achieverDeviate /^\s\{0,2}\zs\~\ze\s\s\@!/                                " ~


"   highlight


" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

if &background == "dark"

    hi achieverTimeClue             ctermfg=60
    hi achieverTime                 ctermfg=103

    hi achieverTagWork              ctermfg=211
    hi achieverTagSide              ctermfg=175
    hi achieverTagLife              ctermfg=139

    hi achieverDetail               ctermfg=103
    hi achieverFeedback             ctermfg=194
    hi achieverDeviate              ctermbg=132

elseif &background == "light"

    "   TODO

endif


" let b:current_syntax = "achiever"
