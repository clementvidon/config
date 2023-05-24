" syntax/c
" Created: 230524 19:50:22 by clem9nt@imac
" Updated: 230524 19:50:22 by clem9nt@imac
" Maintainer: Clément Vidon

if exists("b:current_syntax")
    finish
endif


"   syntax


syn match mycDebug "printf\|dprintf" contains=cString,cComment,cCommentL


"   highlight


if &background == "dark"
    hi Search ctermbg=NONE ctermfg=105
    hi mycDebug ctermfg=158
    hi cString ctermfg=102
    hi cTodo ctermfg=84
    hi cComment ctermfg=103
    hi link cCommentL cComment
    hi link cCommentStart cComment
elseif &background == "light"
    hi Search ctermbg=229 ctermfg=NONE
    hi mycDebug ctermfg=31
    hi cString ctermfg=245
    hi cTodo ctermfg=205
    hi cComment ctermfg=103
    hi link cCommentL cComment
    hi link cCommentStart cComment
endif

hi link cConditional cleared
hi link cRepeat cleared
" hi link cStatement cleared
hi link cCharacter cleared
hi link cConstant cleared
hi link cDefine cleared
hi link cInclude cleared
hi! link cIncluded cleared
hi link cNumber cleared
hi link cOperator cleared
hi link cPreCondit cleared
hi link cSpecial cleared
hi link cStorageClass cleared
hi link cStructure cleared
hi link cType cleared
hi link cTypedef cleared

let b:current_syntax = "syntaxc"
