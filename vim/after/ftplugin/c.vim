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
    au FileType c,cpp,make setl path+=$PWD/include/,$PWD/src/**
    au FileType c,cpp let maplocalleader = "gh"

    " .......................... PLUGIN

    au FileType c,cpp let g:gutentags_enabled = 1
    au FileType c,cpp let b:surround_45 = '("\r");'

    " <<<

    " --------------------------------- MAPPINGS >>>

    " .......................... PRIMARY (GH?)

    au Filetype c,cpp nn <silent><buffer> <LocalLeader> <nop>

    " ............... MAKE

    "   clean
    au Filetype c,cpp nn <silent><buffer> <LocalLeader>c :w<CR>
                \:make! clean<CR>
                \:cw<CR>

    "   make
    au Filetype c,cpp nn <silent><buffer> <LocalLeader>m :w<CR>
                \:make!<CR>
                \:cw<CR>

    "   asan
    au Filetype c,cpp nn <silent><buffer> <LocalLeader>a :w<CR>
                \:make! asan<CR>
                \:cw<CR>

    "   run
    au Filetype c,cpp nn <silent><buffer> <LocalLeader>r :w<CR>
                \:make! run<CR>

    "   run-valgrind
    au Filetype c,cpp nn <silent><buffer> <LocalLeader>v :w<CR>
                \:make! run-valgrind<CR>

    " \:make! re<CR>
    " \:!valgrind -q ./$(ls -t \| head -1)<CR>

    " ............... COMPILE

    "   Compile + run
    au Filetype c nn <silent><buffer> <LocalLeader>x :w\|lc %:h<CR>
                \
                \:!rm -f a.out /tmp/_err<CR>
                \:silent !clang -Werror -Wall -Wextra -pedantic -W % 2>/tmp/_err<CR>
                \:cfile /tmp/_err<CR>
                \:5cw<CR>
                \:!clear; ./a.out<CR>

    au Filetype cpp nn <silent><buffer> <LocalLeader>x :w\|lc %:h<CR>
                \
                \:!rm -f a.out /tmp/_err<CR>
                \:silent !c++ -Werror -Wall -Wextra -std=c++98 -pedantic -W % 2>/tmp/_err<CR>
                \:cfile /tmp/_err<CR>
                \:5cw<CR>
                \:!clear; ./a.out<CR>

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
    au Filetype c,cpp nn <silent><buffer> <LocalLeader>f :call FormatCurrentFile()<CR>:w<CR>

    " ............... DEBUG

    "   Print wrapped
    au Filetype c nn <silent><buffer> <LocalLeader>w 0<<V:norm f;Di<Esc>Idprintf(2, "> %\n", <Esc>A);<Esc>==f%a
    au Filetype cpp nn <silent><buffer> <LocalLeader>w 0<<V:norm f;Di<Esc>Istd::cerr << ">" << <Esc>A << std::endl;<Esc>==f"a

    "   Print location
    au Filetype c nn <silent><buffer> <LocalLeader>l odprintf (2, "(%s: %s: l.%d)\n", __FILE__, __func__, __LINE__);<Esc>==f(
    au Filetype cpp nn <silent><buffer> <LocalLeader>l ostd::cerr << "(" << __FILE__ << ": " << __func__  << ": l." << __LINE__ << ")" << std::endl;<Esc>==f(

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

    "   Functions nav
    au Filetype c,cpp nn <silent><buffer> gzf /^\a<CR>

    "   Functions list
    au Filetype c,cpp nn <silent><buffer> gzF :keeppatterns g/^\a<CR>

    "   New Class
    function ClassInitCpp()
        if  (expand("%:e") == "cpp")
            if  (expand(line('$')) == 1 && getline(1) =~ '^$')
                "   Class.cpp
                let className = expand("%:t:r")
                call append(line("$"), "#include <iostream>")
                call append(line("$"), "#include <sstream>")
                call append(line("$"), "#include <string>")
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
                call append(line("$"), "  return;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Copy Constructor")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "" . className . "::" . className . "( " . className . " const& src ) {")
                call append(line("$"), "  *this = src;")
                call append(line("$"), "  return;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Destructor")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "" . className . "::~" . className . "( void ) {")
                call append(line("$"), "  return;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Copy Assignment Operator")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "" . className . "& " . className . "::operator=( " . className . " const& rhs ) {")
                call append(line("$"), "  if( this == &rhs ) {")
                call append(line("$"), "    return *this;")
                call append(line("$"), "  }")
                call append(line("$"), "  return *this;")
                call append(line("$"), "}")
                call append(line("$"), "")
                call append(line("$"), "/**")
                call append(line("$"), " * @brief       Print State")
                call append(line("$"), " */")
                call append(line("$"), "")
                call append(line("$"), "void " . className . "::print( std::ostream& o ) const {")
                call append(line("$"), "  o << \"" . className . "\";")
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
                call append(line("$"), "#include <iostream>")
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
                call append(line("$"), "  " . className . "&  operator=( " . className . " const& rhs );")
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
    au Filetype c,cpp xn <silent><buffer> if /^}$<CR>on%j0ok$
    au Filetype c,cpp xn <silent><buffer> af /^}$<CR>on%?^$<CR>j
    au Filetype c,cpp ono <silent><buffer> if :normal Vif<CR>
    au Filetype c,cpp ono <silent><buffer> af :normal Vaf<CR>

    "   Functions + docstring
    au Filetype c,cpp xn <silent><buffer> aF /^}$<CR>on%?^$<CR>n
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

    au Filetype cpp iabbr <silent><buffer> sstr std::string<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> sstrc std::string const<C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> cccin   std::cin >>;<Left>
    au Filetype cpp iabbr <silent><buffer> cccerr  std::cerr <<;<Left>
    au Filetype cpp iabbr <silent><buffer> cccout  std::cout <<;<Left>
    au Filetype cpp iabbr <silent><buffer> eeendl  std::cout << std::endl;<Esc>0fl

    au Filetype cpp iabbr <silent><buffer> ccin    std::cin
    au Filetype cpp iabbr <silent><buffer> ccerr   std::cerr
    au Filetype cpp iabbr <silent><buffer> ccout   std::cout
    au Filetype cpp iabbr <silent><buffer> eendl   std::endl<C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> pcerr std::cerr << "" << std::endl;<Esc>14hi<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> pcout std::cout << "" << std::endl;<Esc>14hi<C-R>=Eatchar('\s')<CR>

    " <<<

    " --------------------------------- HIGHLIGHTS >>>

    " .......................... COLORS

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

    " .......................... PATTERN

    " au FileType c,cpp syn match mycConstant "\v\w@<!(\u|_+[A-Z0-9])[A-Z0-9_]*\w@!"
    " au FileType c,cpp hi link mycConstant cConstant
    au FileType c,cpp syn match mycDebug "printf\|dprintf" contains=cString,cComment,cCommentL
    au FileType c,cpp syn keyword cTodo DONE
    au FileType c,cpp syn keyword cTodo WHY
    au FileType c,cpp syn keyword cTodo TRY

    " .......................... OFF

    " au FileType c,cpp hi link cConditional cleared
    " au FileType c,cpp hi link cRepeat cleared
    " au FileType c,cpp hi link cStatement cleared
    au FileType c,cpp hi link cCharacter cleared
    au FileType c,cpp hi link cConstant cleared
    au FileType c,cpp hi link cDefine cleared
    au FileType c,cpp hi link cInclude cleared
    au FileType c,cpp hi link cIncluded cleared
    au FileType c,cpp hi link cIncluded cleared
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

    " <<<

augroup END
