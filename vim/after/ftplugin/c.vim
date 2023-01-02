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

    au FileType c,cpp hi link cppBoolean cleared
    au FileType c,cpp hi link cCharacter cleared
    " au FileType c,cpp hi link cConditional cleared
    au FileType c,cpp hi link cDefine cleared
    au FileType c,cpp hi link cInclude cleared
    au FileType c,cpp hi link cIncluded cleared
    au FileType c,cpp hi link cNumber cleared
    au FileType c,cpp hi link cOperator cleared
    au FileType c,cpp hi link cPreCondit cleared
    " au FileType c,cpp hi link cRepeat cleared
    au FileType c,cpp hi link cSpecial cleared
    " au FileType c,cpp hi link cStatement cleared
    au FileType c,cpp hi link cppStatement cleared
    au FileType c,cpp hi link cStorageClass cleared
    au FileType c,cpp hi link cStructure cleared
    au FileType c,cpp hi link cppStructure cleared
    au FileType c,cpp hi link cTypedef cleared
    au FileType c,cpp hi link cType cleared
    au FileType c,cpp hi link cppType cleared
    au FileType c,cpp hi link cppNumber cleared
    au FileType c,cpp hi! link cIncluded cleared
    au FileType c,cpp hi link cConstant cleared
    " au FileType c,cpp syn match mycConstant "\v\w@<!(\u|_+[A-Z0-9])[A-Z0-9_]*\w@!"
    " au FileType c,cpp hi link mycConstant cConstant
    au FileType c,cpp syn match mycDebug "printf\|dprintf" contains=cString,cComment,cCommentL
    au FileType c,cpp syn keyword cTodo DONE
    au FileType c,cpp syn keyword cTodo WHY
    au FileType c,cpp syn keyword cTodo TRY
    " <<<

    " --------------------------------- OPTIONS >>>

    au FileType qf setl wrap
    au FileType c,cpp setl expandtab tabstop=2 shiftwidth=2 textwidth=80
    au FileType c,cpp setl formatprg=clang-format\ --style=file
    au FileType c,cpp let mapleader="<BS>"
    au FileType c,cpp,make setl path+=$PWD/include/,$PWD/src/**

    " <<<

    " --------------------------------- PLUGINS >>>

    au FileType c,cpp let g:gutentags_enabled = 1
    au FileType c,cpp let b:surround_45 = '("\r");'

    " <<<

    " --------------------------------- MAPPINGS >>>

    " -------------------------- PRIMARY (GH?)

    " --------------- RUN

    "   Make + run
    au Filetype c,cpp nn <silent><buffer> ghm :w<CR>
                \
                \:!clear; make -j asan && ./$(ls -t \| head -1)<CR>

    "   Make + valgrind run
    au Filetype c,cpp nn <silent><buffer> ghv :w<CR>
                \
                \:!clear; make -j && valgrind -q ./$(ls -t \| head -1)<CR>

    "   Compile + run
    au Filetype c nn <silent><buffer> ghr :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out'<CR>
                \:exec 'silent !clang -Wno-everything  -x c % 2>/tmp/' . %<CR>
                \:cfile /tmp/%<CR>:5cw<CR>
                \:exec '!clear;./a.out'<CR>

    " --------------- CLEAN CODE

    "   Docstring
    au Filetype c,cpp nn <silent><buffer> ghd mdj
                \
                \:keeppatterns ?^\a<CR>
                \O<Esc>O/*<Esc>o<C-w>* @brief       .<CR><CR>
                \@param[out]  .<CR>
                \@param[in]   .<CR>
                \@return      .<CR>
                \<BS>/<Esc>=ip
                \jf.

    "   Format
    au Filetype c,cpp nn ghf :call FormatCurrentFile()<CR>

    " --------------- DEBUG

    "   Print anything
    au Filetype c nn <silent><buffer> ghp odprintf (2, "\n");<Esc>==f\i
    au Filetype cpp nn <silent><buffer> ghp ostd::cerr << "" << std::endl;<Esc>==f"a

    "   Print wrapped
    au Filetype c nn <silent><buffer> ghw 0<<V:norm f;Di<Esc>Idprintf(2, "> %\n", <Esc>A);<Esc>==f%a
    au Filetype cpp nn <silent><buffer> ghw 0<<V:norm f;Di<Esc>Istd::cerr << "" << <Esc>A << std::endl;<Esc>==f"a

    "   Print location
    au Filetype c nn <silent><buffer> ghl odprintf (2, "(%s: %s: l.%d)\n", __FILE__, __func__, __LINE__);<Esc>==f(
    au Filetype cpp nn <silent><buffer> ghl ostd::cerr << "(" << __FILE__ << ": " << __func__  << ": l." << __LINE__ << ")" << std::endl;<Esc>==f(

    " -------------------------- SECONDARY (Z??)

    "   Functions nav
    au Filetype c,cpp nn <silent><buffer> zfn /^\a<CR>

    "   Functions list
    au Filetype c,cpp nn <silent><buffer> zfl :keeppatterns g/^\a<CR>

    " -------------------------- TEXT OBJECTS

    "   Functions
    au Filetype c,cpp xn <silent><buffer> if /^}$<CR>on%j0ok
    au Filetype c,cpp xn <silent><buffer> af /^}$<CR>on%{
                \:}<Esc>
    au Filetype c,cpp ono <silent><buffer> if :normal Vif<CR>
    au Filetype c,cpp ono <silent><buffer> af :normal Vaf<CR>

    "   Functions + docstring
    au Filetype c,cpp xn <silent><buffer> aF /^}$<CR>on%{{
                \:}<Esc>
    au Filetype c,cpp ono <silent><buffer> aF :normal VaF<CR>

    " -------------------------- ABBREVIATIONS

    iabbr <silent><buffer> if if () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>
    iabbr <silent><buffer> else else {<CR>}<C-O>O<C-R>=Eatchar('\s')<CR>
    iabbr <silent><buffer> elseif else if () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>

    iabbr <silent><buffer> while while () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>

augroup END
