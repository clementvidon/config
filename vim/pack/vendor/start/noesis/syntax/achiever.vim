" syntax/achiever
" Created: 230727 22:10:11 by clem@spectre
" Updated: 230807 17:29:24 by clem@spectre
" Maintainer: Clément Vidon

" if exists("b:current_syntax")
"     finish
" endif


"   syntax


syn match achieverTime /\s(\s[a-zA-Z0-9: ]*\s)\ze\s/
syn match achieverDone /\s\d\{6}\(\s\d\d:\d\d\)\{1,2}\ze\s/
syn match achieverDone /\s\d\d:\d\d\s\d\d:\d\d\ze\s/


" syn match achieverTag  "\(\d\d:\d\d\|\s)\|^-\|^\~\)\@<=\s[a-zA-Z0-9/_.-~+=]\{8}:\s"

syn match achieverTagMainwork /\s\<mainwork\>:\s/
syn match achieverTag  /\s\<sidework\>:\s/
syn match achieverTag  /\s\<achiever\>:\s/
syn match achieverTag  /\s\<work_env\>:\s/
syn match achieverTag  /\s\<life_env\>:\s/

syn match achieverDetail /\s\zs(\s.\{-}\s)\ze\(\s\|$\)/ contains=noesisKeywordNeg
syn match achieverFeedback /\s\zs{\s.\{-}\s}/
syn match achieverDeviate /^\s\{,7}\zs\~\ze\s\s\@!/



"   highlight


if &background == "dark"

    hi achieverTime                 ctermfg=103
    hi achieverDone                 ctermfg=60

    hi achieverTagMainwork          ctermfg=175
    hi achieverTag                  ctermfg=139
    hi achieverDetail               ctermfg=103
    hi achieverFeedback             ctermfg=194
    hi achieverDeviate              ctermbg=1

elseif &background == "light"

    "   TODO

endif


" let b:current_syntax = "achiever"
