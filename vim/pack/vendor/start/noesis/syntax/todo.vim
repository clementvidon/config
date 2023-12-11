" syntax/todo
" Created: 230727 22:10:11 by clem@spectre
" Updated: 230807 17:29:24 by clem@spectre
" Maintainer: Clément Vidon

" if exists("b:current_syntax")
"     finish
" endif


"   syntax


syn match todoTime /^[-~+=]\zs\s(\s[a-zA-Z0-9: ]*\s)\ze\s./
syn match todoDone /^[-~+=]\zs\s\d\{6}\(\s\d\d:\d\d\)\{1,2}\ze\s./


" syn match todoTag  "\(\d\d:\d\d\|\s)\|^-\|^\~\)\@<=\s[a-zA-Z0-9/_.-~+=]\{8}:\s"

syn match todoTagMaingoal /\s\<maingoal\>:\s/
syn match todoTag  /\s\<sidework\>:\s/
syn match todoTag  /\s\<achiever\>:\s/
syn match todoTag  /\s\<work_env\>:\s/
syn match todoTag  /\s\<life_env\>:\s/
syn match todoTag  /\s\<self_rel\>:\s/
syn match todoTag  /\s\<soc_rela\>:\s/
syn match todoTag  /\s\<fam_rela\>:\s/

syn match todoDetail /\s\zs(\s.\{-}\s)\ze\(\s\|$\)/ contains=noesisKeywordNeg
syn match todoFeedback /\s\zs{\s.\{-}\s}$/
syn match todoUnplanned /^\~\s/ contains=todoDone,todoTag


"   highlight


if &background == "dark"

    hi todoTime                 ctermfg=103
    hi todoDone                 ctermfg=60

    hi todoTagMaingoal          ctermfg=175
    hi todoTag                  ctermfg=139
    hi todoDetail               ctermfg=103
    hi todoFeedback             ctermfg=194
    hi todoUnplanned            ctermfg=yellow

elseif &background == "light"

    "   TODO

endif


" let b:current_syntax = "todo"
