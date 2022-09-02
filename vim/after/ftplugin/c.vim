augroup filetype_c
    autocmd!
    " --------------------------------- HIGHLIGHTS >>>
    if &background == "dark"
        au FileType c,cpp hi Search ctermbg=NONE ctermfg=105
        au FileType c,cpp hi cDebug ctermfg=158
        au FileType c,cpp hi cString ctermfg=102
        au FileType c,cpp hi cTodo ctermfg=84
        au FileType c,cpp hi cComment ctermfg=103
        au FileType c,cpp hi link cCommentL cComment
        au FileType c,cpp hi link cCommentStart cComment
    elseif &background == "light"
        au FileType c,cpp hi Search ctermbg=229 ctermfg=NONE
        au FileType c,cpp hi cDebug ctermfg=31
        au FileType c,cpp hi cString ctermfg=245
        au FileType c,cpp hi cTodo ctermfg=205
        au FileType c,cpp hi cComment ctermfg=103
        au FileType c,cpp hi link cCommentL cComment
        au FileType c,cpp hi link cCommentStart cComment
    endif
    au FileType c,cpp hi link cCharacter cleared
    au FileType c,cpp hi link cConditional cleared
    au FileType c,cpp hi link cConstant cleared
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
    au FileType c,cpp syn match cDebug "printf\|dprintf" contains=cString,cComment,cCommentL
    " <<<
    " --------------------------------- OPTIONS >>>
    au FileType qf setl wrap
    au FileType c,cpp setl showmatch
    au FileType c,cpp setl noexpandtab cindent textwidth=80
    au FileType c,cpp,make setl path+=$PWD/include/,$PWD/*src/**
    au FileType c,cpp setl foldmethod=marker
    au FileType c,cpp setl foldmarker=>>>,<<<

    " Compile
    au FileType c,cpp let b:name = "philo"
    au FileType c,cpp let b:cc = "clang"
    au FileType c,cpp let b:cflags = "-Wall -Wextra -Werror -Wconversion -Wsign-conversion"
    au FileType c,cpp let b:san = "-fsanitize=address,undefined,signed-integer-overflow -g"
    au FileType c,cpp let b:valgrind = "valgrind -q --leak-check=yes --show-leak-kinds=all --track-fds=yes"
    au FileType c,cpp let b:librairies = ""
    " <<<
    " --------------------------------- PLUGINS >>>
    au FileType c,cpp let g:gutentags_enabled = 1
    au FileType c,cpp let b:surround_45 = '("\r");'
    " <<<
    " --------------------------------- MAPPINGS >>>

    "   Make + run

    au Filetype c,cpp,make nn <silent><buffer> mm :wa<CR>
                \
                \:!clear<CR>:make run<CR>

    au Filetype c,cpp,make nn <silent><buffer> mM :wa<CR>
                \
                \:!clear<CR>:make re run<CR>

    "   Make sani + run

    au Filetype c,cpp,make nn <silent><buffer> ms :wa<CR>
                \
                \:!clear<CR>:make san run<CR>

    au Filetype c,cpp,make nn <silent><buffer> mS :wa<CR>
                \
                \:!clear<CR>:make fclean san run<CR>

    "   Make + valgrind run

    au Filetype c,cpp,make nn <silent><buffer> mv :wa<CR>
                \
                \:!clear<CR>:make valgrind_run<CR>

    au Filetype c,cpp,make nn <silent><buffer> mV :wa<CR>
                \
                \:!clear<CR>:make re valgrind_run<CR>

    "   COMPILE [& RUN] ALL

    "   valgrind
    au Filetype c nn <silent><buffer> <Space>4 :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' -x c % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;' . b:valgrind . ' ./a.out \|cat -e'<CR>

    "   sanitizer
    au Filetype c nn <silent><buffer> <Space>5 :w\|lc %:h<CR>
                \
                \:exec '!clear;'<CR>
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' ' . b:san . ' -x c % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out'<CR>
    " \:exec '!clear;./a.out /bin/ls "\|" /usr/bin/grep microshell ";" /bin/echo hello\|cat -e'<CR>

    "   nothing
    au Filetype c nn <silent><buffer> <Space>% :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc . ' -Wno-everything  -x c % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out'<CR>

    "   COMPILE [& RUN] ALL

    au Filetype c nn <silent><buffer> <Space>8 :wa\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' ' . b:san . ' -x c % *.c ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>:
                \:exec '!clear;./a.out'<CR>

    au Filetype c nn <silent><buffer> <Space>* :wa\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc . ' -Wno-everything -x c % *.c ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out'<CR>

    ""   COMPILE & RUN % & C-Z
    "au Filetype c,cpp nn <silent><buffer> <Space>5 :silent! w \| lc %:h \| se t_ti= t_tr= <CR>
    "            \:silent ! clang -Wall -Wextra -Werror -fsanitize=address %
    "            \ 2>/tmp/c_qf_err<CR>:cfile /tmp/c_qf_err<CR>
    "            \:let cmd=system('./' . b:name . '\|cat -e')<CR>:silent ! rm ' . b:name . ' 2>/dev/null<CR>
    "       \:se t_ti& t_te& \| 3cw \| echom "----["strftime('%H:%M')"]----"<CR>:echom cmd<CR>i<Esc>:echo cmd"\n"<CR>

    "   INDENT FUNCTION
    au Filetype c,cpp nn <silent><buffer> =f mm?^\a<CR>j=%`m:let @/=""<CR>

    "   SEARCH FUNCTIONS
    au Filetype c,cpp nn <silent><buffer> <Space>f /^\a<CR>
    "   LIST FILE FUNCTIONS
    au Filetype c,cpp nn <silent><buffer> <Space>F :keeppatterns g/^\a<CR>

    "   PARENTHESIS AND BRACKETS
    au Filetype c ino <silent><buffer> \<space> ()<Esc>o{<CR>}<Esc>kk$i

    "   PARAGRAPH TAB TO SPACES
    au Filetype c,cpp,make nn <silent><buffer> <space>S mp
                \
                \<Esc>:set expandtab<CR>vip:retab<CR>:set expandtab!<CR>
                \`p
    " TODO
    " au Filetype c nn <silent><buffer> <space>s :set expandtab<CR>
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

    "   FUNCTIONS DOCSTRING
    au Filetype c nn <silent><buffer> <space>D mdj
                \
                \:keeppatterns ?^\a<CR>
                \O<Esc>O/*<Esc>o<C-w>** @brief<Tab><Tab><Esc>o*/<Esc>=ip
                \jA

    "   FILTERED NORMINETTE
    au Filetype c,cpp nn <silent><buffer> <Space>n :w<CR>:!clear; norminette % \| grep -Ev
                \ "TOO_MANY_FUNCS\|EMPTY_LINE_FUNCTION\|INVALID_HEADER\|WRONG_SCOPE_COMMENT\|TOO_MANY_LINES\|LINE_TOO_LONG"<CR>
    "   NORMINETTE
    au Filetype c,cpp nn <silent><buffer> <Space>N :w<CR>:!clear; norminette %<CR>

    "   PRINT
    au Filetype c nn <silent><buffer> <Space>p mpodprintf (2, "\n");<Esc>==f\i
    "   PRINT WRAP
    au Filetype c nn <silent><buffer> <Space>P 0<<V:norm f;Di<Esc>Idprintf(2, "> %\n", <Esc>A);<Esc>==f%a

    "   MARKER
    au Filetype c nn <silent><buffer> <Space>m <nop>
    au Filetype c nn <silent><buffer> <Space>mm mmodprintf (2, "(%s: %s: %d)\n",
                \__FILE__, __func__, __LINE__);<Esc>==f%
    " <<<
augroup END
