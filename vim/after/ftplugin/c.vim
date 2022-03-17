augroup FILETYPE_C
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    "   COMMENTS
    " au FileType c,cpp syn match Comments "\/\/.*$\|\/\*\_.\{-}\*\/"
    " au FileType c,cpp hi link Comments NonText
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType qf setl wrap
    au FileType c,cpp setl showmatch
    au FileType c,cpp setl list
    au FileType c,cpp setl noexpandtab cindent tw=80
    au FileType c,cpp setl path+=$DOTVIM/after/ftplugin/
    au FileType c,cpp,make setl path+=include/**,../include/**,src/**,../src/**
    au FileType c,cpp setl foldmethod=marker
    au FileType c,cpp setl foldmarker={{{,}}}

    " Compile
    au FileType c,cpp let b:cc = "gcc"
    au FileType c,cpp let b:cflags = "-Wall -Wextra -Werror -Wconversion -Wsign-conversion"
    au FileType c,cpp let b:sanitizer = "-fsanitize=address,undefined,signed-integer-overflow"
    au FileType c,cpp let b:valgrind = "valgrind -q --leak-check=yes --show-leak-kinds=all --track-fds=yes"
    au FileType c,cpp let b:librairies = ""
    au FileType c,cpp let b:rule = ""
    " }}}
    " --------------------------------- PLUGINS {{{
    au FileType c,cpp let g:gutentags_enabled = 1
    au FileType c,cpp let b:surround_45 = '("\r");'
    " }}}
    " --------------------------------- MAPPINGS {{{

    "   COMPILE [& RUN] ONE

    "   :make
    au Filetype c,cpp,make nn <silent><buffer> <Space>7 :wa<CR>
                \
                \:exec 'make -j ' . b:rule <CR>:cw<CR>
    au Filetype c,cpp,make nn <silent><buffer> <Space>& :wa<CR>
                \
                \:make -j sanitize<CR>:cw<CR>

    "   valgrind
    au Filetype c nn <silent><buffer> <Space>4 :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;' . b:valgrind . ' ./a.out \|cat -e'<CR>

    "   sanitizer
    au Filetype c nn <silent><buffer> <Space>5 :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' ' . b:sanitizer . ' % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out \|cat -e'<CR>

    "   nothing
    au Filetype c nn <silent><buffer> <Space>% :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc . ' -Wno-everything % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out \|cat -e'<CR>

    "   COMPILE [& RUN] ALL

    au Filetype c nn <silent><buffer> <Space>8 :wa\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' ' . b:sanitizer . ' *.c ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>:
                \:exec '!clear;./a.out \|cat -e'<CR>

    au Filetype c nn <silent><buffer> <Space>* :wa\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc . ' -Wno-everything *.c ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out \|cat -e'<CR>

    ""   COMPILE & RUN % & C-Z
    "au Filetype c,cpp nn <silent><buffer> <Space>5 :silent! w \| lc %:h \| se t_ti= t_tr= <CR>
    "            \:silent ! clang -Wall -Wextra -Werror -fsanitize=address %
    "            \ 2>/tmp/c_qf_err<CR>:cfile /tmp/c_qf_err<CR>
    "            \:let cmd=system('./a.out\|cat -e')<CR>:silent ! rm a.out 2>/dev/null<CR>
    "       \:se t_ti& t_te& \| 3cw \| echom "----["strftime('%H:%M')"]----"<CR>:echom cmd<CR>i<Esc>:echo cmd"\n"<CR>

    "   INDENT FUNCTION
    au Filetype c,cpp nn <silent><buffer> gq mm?^\a<CR>j=%`m:let @/=""<CR>

    "   LIST FILE FUNCTIONS
    au Filetype c,cpp nn <silent><buffer> <Space>f :keeppatterns g/^\a/#<CR>

    "   PARENTHESIS AND BRACKETS
    au Filetype c ino <silent><buffer> \<space> ()<Esc>o{<CR>}<Esc>kk$i

    "   FUNCTION DOC
    au Filetype c nn <silent><buffer> <space>D mdj:keeppatterns ?^\a<CR>O<Esc>O/*<Esc>o<C-w>**<Esc>o*/<Esc>=ipjA<Space><BS><Esc>

    "   NORMINETTE
    au Filetype cpp nn <silent><buffer> <Space>n :w\|lc %:h<CR>:!clear; norminette -R CheckDefine %<CR>
    au Filetype c nn <silent><buffer> <Space>n :w\|lc %:h<CR>:!clear; norminette -R CheckForbiddenSourceHeader %<CR>

    "   PRINTF
    au Filetype c nn <silent><buffer> <Space>p mpodprintf(2, "\n");<Esc>==f\
    au Filetype c nn <silent><buffer> <Space>P mpodprintf(2, "%\n", );<Esc>==f%

    "   MARKER
    au Filetype c nn <silent><buffer> <Space>m mmodprintf(2, "---[%s: %s: %d]---\n",
                \__FILE__, __func__, __LINE__);<Esc>==f%
    au Filetype c nn <silent><buffer> <Space>M mmodprintf(2, "<'\\\\`-._,-'\\\\`-._,-'\\\\`-._,-'\\\\`>\n");<Esc>==

    " }}}
augroup END
