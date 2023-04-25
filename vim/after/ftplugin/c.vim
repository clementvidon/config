augroup filetype_c
    autocmd!
    " --------------------------------- OPTIONS >>>

    " .......................... BUILTIN

    au FileType qf setl wrap
    au FileType c,cpp setl expandtab tabstop=2 shiftwidth=2 textwidth=80
    au FileType c,cpp setl softtabstop=2 autoindent cindent
    au FileType c,cpp setl ls=2
    au FileType c,cpp let &makeprg = "make --no-print-directory --jobs -C " . fnamemodify(findfile('Makefile', '.;'), ":h") . " $*"
    au FileType c,cpp setl formatprg=clang-format\ --style=file
    au FileType c,cpp,make setl path+=$PWD/inc/,$PWD/incs/,$PWD/include/,$PWD/includes/,$PWD/src/**,$PWD/srcs/**,$PWD/source/**,$PWD/sources/**
    au FileType c,cpp let maplocalleader = "gh"

    " function FileUID()
    "     return 'b:' . substitute(expand('%:p') , '\W', '', 'g')
    " endfunction
    " au FileType c,cpp,make au BufRead,BufNewFile,BufEnter,VimEnter
    "             \ execute 'let ' . FileUID() . ' = 0'
    " au FileType c,cpp,make au BufWritePost
    "             \ execute 'let ' . FileUID() . ' = 1'
    " au FileType c,cpp au BufDelete
    "             \ exec 'let b:verif = exists("' . FileUID() . '") && (' . FileUID() . ')' |
    "             \ if b:verif |
    "             \   execute ':call Header("//") | silent write' |
    "             \   let b:verif = 0 |
    "             \ endif

    " .......................... PLUGIN

    au FileType c,cpp let g:gutentags_enabled = 1
    au FileType c,cpp let b:surround_45 = '("\r");'

    " <<<

    " --------------------------------- MAPPINGS >>>

    au Filetype c,cpp nn <silent><buffer> <Space>= <nop>
    au Filetype c,cpp nn <silent><buffer> sh :fin *hpp
    au Filetype c,cpp nn <silent><buffer> sc :fin *cpp

    " .......................... PRIMARY (GH?)

    au Filetype c,cpp nn <silent><buffer> <LocalLeader> <nop>

    " ............... MAKE

    "   make
    au Filetype c,cpp nn <silent><buffer> mm :w<CR>
                \:!clear<CR>
                \:make!<CR>
                \:cw<CR>

    "   clean
    au Filetype c,cpp nn <silent><buffer> mc :w<CR>
                \:!clear<CR>
                \:make! clean<CR>

    "   re
    au Filetype c,cpp nn <silent><buffer> mr :w<CR>
                \:!clear<CR>
                \:make! re<CR>
                \:cw<CR>

    "   sure
    au Filetype c,cpp nn <silent><buffer> ms :w<CR>
                \:!clear<CR>
                \:make! sure<CR>
                \:cw<CR>

    "   asan
    au Filetype c,cpp nn <silent><buffer> ma :w<CR>
                \:!clear<CR>
                \:make! asan<CR>
                \:cw<CR>

    "   leak
    au Filetype c,cpp nn <silent><buffer> ml :w<CR>
                \:!clear<CR>
                \:make! leak<CR>

    "   exec
    au Filetype c,cpp nn <silent><buffer> me :w<CR>
                \:!clear<CR>
                \:make! exec<CR>

    "   test
    au Filetype c,cpp nn <silent><buffer> mt :w<CR>
                \:!clear<CR>
                \:make! test<CR>

    "   help
    au Filetype c,cpp nn <silent><buffer> mh :w<CR>
                \:!clear<CR>
                \:make! each<CR>

    " \:make! re<CR>
    " \:!valgrind -q ./$(ls -t \| head -1)<CR>

    " ............... COMPILE

    "   Compile + Run
    au Filetype c nn <silent><buffer> <LocalLeader>xx :w\|lc %:h<CR>
                \
                \:silent !clear; rm -f a.out /tmp/_err<CR>
                \:silent !clang -Wall -Wextra -Werror -Wno-unused % 2>/tmp/_err<CR>
                \:silent cfile /tmp/_err<CR>:silent 5cw<CR>
                \:!clear; ./a.out<CR>

    au Filetype cpp nn <silent><buffer> <LocalLeader>xx :w\|lc %:h<CR>
                \
                \:silent !clear; rm -f a.out /tmp/_err<CR>
                \:silent !c++ -Wall -Wextra -Werror -Wno-unused -std=c++98 % 2>/tmp/_err<CR>
                \:silent cfile /tmp/_err<CR>:silent 5cw<CR>
                \:!clear; ./a.out<CR>

    "   Compile Strict + Run + Debug Asan
    au Filetype c nn <silent><buffer> <LocalLeader>xa :w\|lc %:h<CR>
                \
                \:silent !clear; rm -f a.out /tmp/_err<CR>
                \:silent !clang
                \ -Wall -Wextra -Werror
                \ -Wconversion -Wsign-conversion -pedantic
                \ -fsanitize=address,undefined,integer,nullability,vptr
                \ -fno-optimize-sibling-calls -fno-omit-frame-pointer -Og -D DEV
                \ % 2>/tmp/_err<CR>:silent cfile /tmp/_err<CR>:silent 5cw<CR>
                \:!clear; ./a.out<CR>

    au Filetype cpp nn <silent><buffer> <LocalLeader>xa :w\|lc %:h<CR>
                \
                \:silent !clear; rm -f a.out /tmp/_err<CR>
                \:silent !c++
                \ -Wall -Wextra -Werror -std=c++98
                \ -Wconversion -Wsign-conversion -pedantic
                \ -fsanitize=address,undefined,integer,nullability,vptr
                \ -fno-optimize-sibling-calls -fno-omit-frame-pointer -Og -D DEV
                \ % 2>/tmp/_err<CR>:silent cfile /tmp/_err<CR>:silent 5cw<CR>
                \:!clear; ./a.out<CR>

    "   Compile + Run + Debug Leaks
    if system("uname -s") == "Darwin\n"
        au Filetype cpp nn <silent><buffer> <LocalLeader>xv :w\|lc %:h<CR>
                    \
                    \:silent !clear; rm -f a.out /tmp/_err<CR>
                    \:silent !c++
                    \ -Wall -Wextra -Werror -std=c++98
                    \ -fno-omit-frame-pointer -Og -D DEV
                    \ % 2>/tmp/_err<CR>:silent cfile /tmp/_err<CR>:silent 5cw<CR>
                    \:!clear; leaks -q -atExit -- ./a.out<CR>

    elseif system("uname -s") == "Linux\n"
        au Filetype cpp nn <silent><buffer> <LocalLeader>xv :w\|lc %:h<CR>
                    \
                    \:silent !clear; rm -f a.out /tmp/_err<CR>
                    \:silent !c++
                    \ -Wall -Wextra -Werror -std=c++98
                    \ -fno-omit-frame-pointer -Og -D DEV
                    \ % 2>/tmp/_err<CR>:silent cfile /tmp/_err<CR>:silent 5cw<CR>
                    \:silent cfile /tmp/_err<CR>:silent 5cw<CR>
                    \:!clear; valgrind -q ./a.out<CR>
    endif

    " ............... CLEAN CODE

    "   Docstring
    au Filetype c,cpp nn <silent><buffer> <LocalLeader>d mdj
                \
                \:keeppatterns ?^\a<CR>
                \O<Esc>O/**<Esc>o<C-w>* @brief       TODO<CR><CR>
                \@param[out]  TODO<CR>
                \@param[in]   TODO<CR>
                \@return      TODO<CR>
                \<BS>/<Esc>=ip
                \jfT

    "   Format
    au Filetype c,cpp nn <silent><buffer> <LocalLeader>f :call ClangFormat()<CR>:w<CR>

    " ............... DEV

    "   Print
    au Filetype c nn <silent><buffer> <LocalLeader>p odprintf (1, "\n");<Esc>==f"a
    au Filetype cpp nn <silent><buffer> <LocalLeader>p ostd::cout << "" << std::endl;<Esc>==f"a

    "   Print wrapped
    au Filetype c nn <silent><buffer> <LocalLeader>w 0<<V:norm f;Di<Esc>Idprintf(1, "> %%\n", <Esc>A);<Esc>==f%
    au Filetype cpp nn <silent><buffer> <LocalLeader>w 0<<V:norm f;Di<Esc>Istd::cout << <Esc>A << std::endl;<Esc>==EEW

    "   Print location
    au Filetype c nn <silent><buffer> <LocalLeader>. odprintf (1, "(%s: %s: l.%d)\n", __FILE__, __func__, __LINE__);<Esc>==f(
    au Filetype cpp nn <silent><buffer> <LocalLeader>. ostd::cout << "(" << __FILE__ << ": " << __func__  << ": l." << __LINE__ << ")" << std::endl;<Esc>==f(

    " ............... NAV

    "   Switch from %.hpp to %.cpp and vis versa
    function SwitchHppCpp()
        if  (expand('%:t:r') =~# "[A-Z]")
            if match(expand('%:e'), 'cpp')
                exec 'find ' . expand("%:t:r") . '.cpp'
            elseif match(expand('%:e'), 'hpp')
                exec 'find ' . expand("%:t:r") . '.hpp'
                " edit %<.hpp
            endif
        endif
    endfunction
    au Filetype cpp nn <silent><buffer> <LocalLeader>s :call SwitchHppCpp()<CR>

    " .......................... SECONDARY (GZ?)

    "   Class nav
    au Filetype c,cpp nn <silent><buffer> gzc  mm:r !ls -1 inc*<CR>V`[J
                \
                \V:s/\.hpp /\\\\|/g<CR>f.D0
                \i\(\/\/.*\\|^ \* .*\)\@<!\(<Esc>A\)<Esc>
                \dd/<C-r>"<BS><CR>`m

    "   Functions nav
    au Filetype c,cpp nn <silent><buffer> gzf /^\a<CR>

    "   Functions list
    au Filetype c,cpp nn <silent><buffer> gzF :keeppatterns g/^\a<CR>

    "   Put/update Header
    au Filetype cpp nn <silent><buffer> gzh :call Header("//")<CR>
    au Filetype make nn <silent><buffer> gzh :call Header("#")<CR>

    "   New Class
    function ClassInitCpp()
        if  (expand("%:e") == "cpp")
            if  (expand(line('$')) == 1 && getline(1) =~ '^$')
                "   Class.cpp
                let className = expand("%:t:r")
                call append(line("$"), "#include <iostream>")
                call append(line("$"), "#include <string>")
                call append(line("$"), "")
                call append(line("$"), "#include \"" . className . ".hpp\"")
                call append(line("$"), "")
                call append(line("$"), "/*  STANDARD")
                call append(line("$"), "------------------------------------------------- */")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Default Constructor")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "" . className . "::" . className . "( void ) {")
                call append(line("$"), "#if defined( DEV )")
                call append(line("$"), "  std::cerr << __FILE__ << \" CONSTRUCTED \" << *this;")
                call append(line("$"), "  std::cerr << std::endl;")
                call append(line("$"), "#endif")
                call append(line("$"), "  return;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Copy Constructor")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "" . className . "::" . className . "( " . className . " const& src ) {")
                call append(line("$"), "  *this = src;")
                call append(line("$"), "#if defined( DEV )")
                call append(line("$"), "  std::cerr << __FILE__ << \" COPY CONSTRUCTED \" << *this << \" FROM \" << src;")
                call append(line("$"), "  std::cerr << std::endl;")
                call append(line("$"), "#endif")
                call append(line("$"), "  return;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Destructor")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "" . className . "::~" . className . "( void ) {")
                call append(line("$"), "#if defined( DEV )")
                call append(line("$"), "  std::cerr << __FILE__ << \" DESTRUCTED \" << *this;")
                call append(line("$"), "  std::cerr << std::endl;")
                call append(line("$"), "#endif")
                call append(line("$"), "  return;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Copy Assignment Operator")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "" . className . "& " . className . "::operator=( " . className . " const& rhs ) {")
                call append(line("$"), "#if defined( DEV )")
                call append(line("$"), "  std::cerr << rhs << \" ASSIGNED TO \" << *this;")
                call append(line("$"), "  std::cerr << std::endl;")
                call append(line("$"), "#endif")
                call append(line("$"), "  if( this == &rhs ) {")
                call append(line("$"), "    return *this;")
                call append(line("$"), "  }")
                call append(line("$"), "  // TODO")
                call append(line("$"), "  return *this;")
                call append(line("$"), "/* #if defined( DEV ) */")
                call append(line("$"), "/*   std::cerr << __FILE__ << \" COPY ASSIGNMENT OPERATOR DISABLED\"; */")
                call append(line("$"), "/*   std::cerr << std::endl; */")
                call append(line("$"), "/* #endif */")
                call append(line("$"), "/*   (void)rhs; */")
                call append(line("$"), "/*   return *this; */")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Print State")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "void " . className . "::print( std::ostream& o ) const {")
                call append(line("$"), "  o << \"\";  // TODO")
                call append(line("$"), "  return;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Output Operator Handling")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "std::ostream& operator<<( std::ostream& o, " . className . " const& i ) {")
                call append(line("$"), "  i.print( o );")
                call append(line("$"), "  return o;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/* ---------------------------------------------- */")
                0delete
                call search("void")
            endif
        elseif  (expand("%:e") == "hpp")
            if  (expand(line('$')) == 1 && getline(1) =~ '^$')
                "   Class.hpp
                let className = expand("%:t:r")
                let includeGuard = toupper (className . '_HPP_')
                call append(line("$"), "#ifndef " . includeGuard)
                call append(line("$"), "#define " . includeGuard)
                call append(line("$"), "")
                call append(line("$"), "#include <iosfwd>")
                call append(line("$"), "#include <string>")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * TODO")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "class " . className . " {")
                call append(line("$"), " public:")
                call append(line("$"), "  " . className . "( void );")
                call append(line("$"), "  " . className . "( " . className . " const& src );")
                call append(line("$"), "  virtual ~" . className . "( void );")
                call append(line("$"), "  " . className . "& operator=( " . className . " const& rhs );")
                call append(line("$"), "  virtual void print( std::ostream& o ) const;")
                call append(line("$"), "")
                call append(line("$"), " private:")
                call append(line("$"), "};")
                call append(line("$"), "")
                call append(line("$"), "std::ostream& operator<<( std::ostream& o, " . className . " const& i );")
                call append(line("$"), "")
                call append(line("$"), "#endif  // " . includeGuard)
                0delete
                call search("void")
            elseif !(getline(expand(line('$'))) =~ '#endif') && !(getline(1) =~ '#ifndef')
                "   Class.hpp include guard
                let className = expand("%:t:r")
                let includeGuard = toupper (className . '_HPP_')
                call append(1, "#ifndef " . includeGuard)
                call append(2, "#define " . includeGuard)
                call append(3, "")
                call append(line("$"), "")
                call append(line("$"), "#endif  // " . includeGuard)
            endif
        endif
    endfunction
    au Filetype c,cpp nn <silent><buffer> gzi :call ClassInitCpp()<CR>

    " .......................... TEXT OBJECTS

    "   Functions
    au Filetype c,cpp xn <silent><buffer> if <Esc>k/^}$<CR>V%j0ok$
    au Filetype c,cpp xn <silent><buffer> af <Esc>k/^}$<CR>V%?^$<CR>j
    au Filetype c,cpp ono <silent><buffer> if :normal Vif<CR>
    au Filetype c,cpp ono <silent><buffer> af :normal Vaf<CR>

    "   Functions + docstring
    au Filetype c,cpp xn <silent><buffer> aF <Esc>k/^}$<CR>V%?/\*<CR>oj
    au Filetype c,cpp ono <silent><buffer> aF :normal VaF<CR>

    " .......................... ABBREVIATIONS
    "
    au Filetype cpp iabbr <silent><buffer> mmain int main () {<CR>return 0;<CR>}<Esc>kO<C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> {{ {<CR>}<Esc>O<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> [[ [<CR>]<Esc>O<C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> (( ()<Left><C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> "" ""<Left><C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> '' ''<Left><C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> iif if () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> eelse else {<CR>}<C-O>O<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> eelseif else if () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> wwhile while () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> ffor for () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> sstr std::string<CR>
    au Filetype cpp iabbr <silent><buffer> sstrc std::string const& <C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> cin std::cin
    au Filetype cpp iabbr <silent><buffer> cer std::cerr
    au Filetype cpp iabbr <silent><buffer> cou std::cout
    au Filetype cpp iabbr <silent><buffer> cen std::endl

    au Filetype cpp iabbr <silent><buffer> ccin std::cin >>;<Left>
    au Filetype cpp iabbr <silent><buffer> ccer std::cerr <<;<Left>
    au Filetype cpp iabbr <silent><buffer> ccou std::cout <<;<Left>
    au Filetype cpp iabbr <silent><buffer> ccen std::cout << std::endl;<Esc>^

    au Filetype cpp iabbr <silent><buffer> pcer std::cerr << "" << std::endl;<Esc>14hi<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> pcou std::cout << "" << std::endl;<Esc>14hi<C-R>=Eatchar('\s')<CR>

    " <<<

    " --------------------------------- HIGHLIGHTS >>>

    " .......................... COLORS

    if &background == "dark"
        au FileType c,cpp hi Search ctermbg=NONE ctermfg=105
        au FileType c hi mycDebug ctermfg=158
        " au FileType cpp hi cCustomClass ctermfg=158
        au FileType c,cpp hi cString ctermfg=102
        au FileType c,cpp hi cppString ctermfg=102
        au FileType c,cpp hi cTodo ctermfg=84
        au FileType c,cpp hi cComment ctermfg=103
        au FileType c,cpp hi link cCommentL cComment
        au FileType c,cpp hi link cCommentStart cComment
    elseif &background == "light"
        au FileType c,cpp hi Search ctermbg=229 ctermfg=NONE
        au FileType c hi mycDebug ctermfg=31
        " au FileType cpp hi cCustomClass ctermfg=31
        au FileType c,cpp hi cString ctermfg=245
        au FileType c,cpp hi cTodo ctermfg=205
        au FileType c,cpp hi cComment ctermfg=103
        au FileType c,cpp hi link cCommentL cComment
        au FileType c,cpp hi link cCommentStart cComment
    endif

    " .......................... PATTERN

    " au FileType cpp syn match cCustomClass "\v\w@<!(\u+[a-zA-Z0-9])[a-z0-9]*\w@!" contains=cIncluded,cInclude
    au FileType c,cpp syn match mycDebug "printf\|dprintf" contains=cString,cComment,cCommentL
    au FileType c,cpp syn keyword cTodo DONE
    au FileType c,cpp syn keyword cTodo WHY
    au FileType c,cpp syn keyword cTodo TRY

    " .......................... OFF

    au FileType c,cpp hi link cConditional cleared
    au FileType c,cpp hi link cRepeat cleared
    " au FileType c,cpp hi link cStatement cleared
    au FileType c,cpp hi link cCharacter cleared
    au FileType c,cpp hi link cConstant cleared
    au FileType c,cpp hi link cDefine cleared
    au FileType c,cpp hi link cInclude cleared
    au FileType c,cpp hi! link cIncluded cleared
    au FileType c,cpp hi link cNumber cleared
    au FileType c,cpp hi link cOperator cleared
    au FileType c,cpp hi link cPreCondit cleared
    au FileType c,cpp hi link cSpecial cleared
    au FileType c,cpp hi link cStorageClass cleared
    au FileType c,cpp hi link cStructure cleared
    au FileType c,cpp hi link cType cleared
    au FileType c,cpp hi link cTypedef cleared
    au FileType c,cpp hi link cppBoolean cleared
    au FileType c,cpp hi link cppNumber cleared
    au FileType c,cpp hi link cppStatement cleared
    au FileType c,cpp hi link cppStructure cleared
    au FileType c,cpp hi link cppType cleared
    au FileType c,cpp hi link cppOperator cleared
    au FileType c,cpp hi link cppModifier cleared
    au FileType c,cpp hi link cppExceptions cleared

    " <<<
augroup END
