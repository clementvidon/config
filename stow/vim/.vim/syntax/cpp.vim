" syntax/cpp
" Created: 230524 19:51:01 by clem9nt@imac
" Updated: 230524 19:51:01 by clem9nt@imac
" Maintainer: Clément Vidon

if &filetype ==# 'cpp'

"   syntax


syn match cCustomClass "\v\w@<!(\u+[a-zA-Z0-9])[a-z0-9]*\w@!" contains=cIncluded,cInclude


"   highlight


if &background == "dark"
    hi Search ctermbg=NONE ctermfg=105
    " hi cCustomClass ctermfg=158
    hi cString ctermfg=102
    hi cppString ctermfg=102
    hi cTodo ctermfg=84
    hi cComment ctermfg=103
    hi link cCommentL cComment
    hi link cCommentStart cComment
elseif &background == "light"
    hi Search ctermbg=229 ctermfg=NONE
    " hi cCustomClass ctermfg=31
    hi cString ctermfg=245
    hi cTodo ctermfg=205
    hi cComment ctermfg=103
    hi link cCommentL cComment
    hi link cCommentStart cComment
endif

hi link cCharacter cleared
hi link cConditional cleared
hi link cConstant cleared
hi link cDefine cleared
hi link cInclude cleared
hi link cLabel cleared
hi link cNumber cleared
hi link cOperator cleared
hi link cPreCondit cleared
hi link cRepeat cleared
hi link cSpecial cleared
hi link cStatement cleared
hi link cStorageClass cleared
hi link cStructure cleared
hi link cType cleared
hi link cTypedef cleared
hi link cppBoolean cleared
hi link cppExceptions cleared
hi link cppModifier cleared
hi link cppNumber cleared
hi link cppOperator cleared
hi link cppStatement cleared
hi link cppStructure cleared
hi link cppType cleared
hi! link cIncluded cleared


endif " prevent vim from loading this config for related filetypes
