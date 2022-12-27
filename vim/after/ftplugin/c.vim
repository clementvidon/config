augroup filetype_c
    autocmd!
    " --------------------------------- HIGHLIGHTS >>>
    if &background == "dark"
        au FileType c,cpp hi Search ctermbg=NONE ctermfg=105
        au FileType c,cpp hi mycDebug ctermfg=158
        au FileType c,cpp hi cString ctermfg=102
        au FileType c,cpp hi cTodo ctermfg=84
        au FileType c,cpp hi cComment ctermfg=103
        au FileType c,cpp hi link cCommentL cComment
        au FileType c,cpp hi link cCommentStart cComment
    elseif &background == "light"
        au FileType c,cpp hi Search ctermbg=229 ctermfg=NONE
        au FileType c,cpp hi mycDebug ctermfg=31
        au FileType c,cpp hi cString ctermfg=245
        au FileType c,cpp hi cTodo ctermfg=205
        au FileType c,cpp hi cComment ctermfg=103
        au FileType c,cpp hi link cCommentL cComment
        au FileType c,cpp hi link cCommentStart cComment
    endif
    au FileType c,cpp hi link cCharacter cleared
    au FileType c,cpp hi link cConditional cleared
    au FileType c,cpp hi link cDefine cleared
    au FileType c,cpp hi link cInclude cleared
    au FileType c,cpp hi link cIncluded cleared
    au FileType c,cpp hi link cNumber cleared
    au FileType c,cpp hi link cOperator cleared
    au FileType c,cpp hi link cPreCondit cleared
    au FileType c,cpp hi link cRepeat cleared
    au FileType c,cpp hi link cSpecial cleared
    au FileType c,cpp hi link cStatement cleared
    au FileType c,cpp hi link cStorageClass cleared
    au FileType c,cpp hi link cStructure cleared
    au FileType c,cpp hi link cTypedef cleared
    au FileType c,cpp hi link cType cleared
    au FileType c,cpp hi link cppNumber cleared
    au FileType c,cpp hi! link cIncluded cleared
    au FileType c,cpp syn match mycDebug "printf\|dprintf" contains=cString,cComment,cCommentL
    au FileType c,cpp syn match mycConstant "\v\w@<!(\u|_+[A-Z0-9])[A-Z0-9_]*\w@!"
    au FileType c,cpp hi link mycConstant cConstant
    au FileType c,cpp syn keyword cTodo DONE
    au FileType c,cpp syn keyword cTodo WHY
    au FileType c,cpp syn keyword cTodo TRY
    " <<<
    " --------------------------------- OPTIONS >>>
    au FileType qf setl wrap
    au FileType c,cpp setl expandtab tabstop=2 shiftwidth=2 textwidth=80
    au FileType c,cpp let &l:formatprg="clang-format --style=Chromium"
    au FileType c,cpp let mapleader = "<BS>"
    au FileType c,cpp,make setl path+=$PWD/include/,$PWD/src/**
    " <<<
    " --------------------------------- PLUGINS >>>
    au FileType c,cpp let g:gutentags_enabled = 1
    au FileType c,cpp let b:surround_45 = '("\r");'
    " <<<
    " --------------------------------- MAPPINGS >>>
    "   compile and run one
    au Filetype c nn <silent><buffer> <Space>4 :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out'<CR>
                \:exec 'silent !clang -Wall -Wextra -Werror -x c % 2>/tmp/qf_' . %<CR>
                \:cfile /tmp/qf_%<CR>:5cw<CR>
                \:exec '!clear; ./a.out \|cat -e'<CR>
    au Filetype c nn <silent><buffer> <Space>% :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !clang -Wno-everything  -x c % 2>/tmp/qf_' . %<CR>
                \:cfile /tmp/qf_%<CR>:5cw<CR>
                \:exec '!clear;./a.out'<CR>

    "   compile and run all
    au Filetype c nn <silent><buffer> <Space>4 :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out'<CR>
                \:exec 'silent !clang -Wall -Wextra -Werror -x c *.c 2>/tmp/qf_' . %<CR>
                \:cfile /tmp/qf_%<CR>:5cw<CR>
                \:exec '!clear; ./a.out \|cat -e'<CR>
    au Filetype c nn <silent><buffer> <Space>% :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !clang -Wno-everything  -x c *.c 2>/tmp/qf_' . %<CR>
                \:cfile /tmp/qf_%<CR>:5cw<CR>
                \:exec '!clear;./a.out'<CR>

    "   search functions
    au Filetype c,cpp nn <silent><buffer> <Space>f /^\a<CR>
    "   list functions
    au Filetype c,cpp nn <silent><buffer> <Space><Space>f :keeppatterns g/^\a<CR>

    "   paragraph tabs to spaces
    au Filetype c,cpp,make nn <silent><buffer> <Space><Tab> mp
                \
                \<Esc>:set expandtab<CR>vip:retab<CR>:set expandtab!<CR>
                \`p

    " TODO
    " au Filetype c nn <silent><buffer> <Tab>s :set expandtab<CR>
    "             \
    "             \:g/@brief/norm! vip:retab<CR>
    "
    " "   TRAILING SPACES
    " function! StripTrailingSpaces()
    "     if !&binary && &filetype != 'diff'
    "         let l:view = winsaveview()
    "         keeppatterns %s/\s\+$//e
    "         call winrestview(l:view)
    "     endif
    " endfunction
    " augroup trailing_spaces
    "     au!
    "     au BufWritePre,FileWritePre * :call StripTrailingSpaces()
    " augroup END

    "   indent
    au Filetype cpp nn gq mm
                \
                \:silent %!clang-format --style=Chromium<CR>
                \`mzz

    "   functions docstring
    au Filetype c,cpp nn <silent><buffer> <Space>d mdj
                \
                \:keeppatterns ?^\a<CR>
                \O<Esc>O/*<Esc>o<C-w>* @brief      TODO<CR><BS>/<Esc>=ip
                \j$b

    "   print
    au Filetype c nn <silent><buffer> <Space>p mpodprintf (2, "\n");<Esc>==f\i
    "   print wrap
    au Filetype c nn <silent><buffer> <Space><Space>p 0<<V:norm f;Di<Esc>Idprintf(2, "> %\n", <Esc>A);<Esc>==f%a

    "   marker
    au Filetype c nn <silent><buffer> <Space>m <nop>
    au Filetype c nn <silent><buffer> <Space>mm mmodprintf (2, "(%s: %s: %d)\n",
                \__FILE__, __func__, __LINE__);<Esc>==f%
    " <<<
augroup END
