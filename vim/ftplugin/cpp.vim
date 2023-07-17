" @filename  cpp.vim
" @created   230522 18:02:54  by  clem9nt@imac
" @updated   230522 18:02:58  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal norelativenumber
setlocal laststatus=2
setlocal path+=
            \$PWD/inc/**,
            \$PWD/incs/**,
            \$PWD/include/**,
            \$PWD/includes/**,
            \$PWD/src/**,
            \$PWD/srcs/**,
            \$PWD/source/**,
            \$PWD/sources/**

let maplocalleader="gh"

let g:gutentags_enabled = 1
let b:surround_45='("\r");'


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   make
nn <silent><buffer> mm :w<CR>
            \:!clear<CR>
            \:make!<CR>
            \:cwindow<CR>

"   make clean
nn <silent><buffer> mc :w<CR>
            \:!clear<CR>
            \:make! clean<CR>

"   make re
nn <silent><buffer> mr :w<CR>
            \:!clear<CR>
            \:make! re<CR>
            \:cwindow<CR>

"   make sure
nn <silent><buffer> ms :w<CR>
            \:!clear<CR>
            \:make! sure<CR>
            \:cwindow<CR>

"   make asan
nn <silent><buffer> ma :w<CR>
            \:!clear<CR>
            \:make! asan<CR>
            \:cwindow<CR>

"   make leak
nn <silent><buffer> ml :w<CR>
            \:!clear<CR>
            \:make! leak<CR>

"   make exec
nn <silent><buffer> me :w<CR>
            \:!clear<CR>
            \:make! exec<CR>

"   make test
nn <silent><buffer> mt :w<CR>
            \:!clear<CR>
            \:make! test<CR>

"   make help
nn <silent><buffer> mh :w<CR>
            \:!clear<CR>
            \:make! each<CR>

"   prod compile run
nn <silent><buffer> <LocalLeader>xx :w\|lcd %:h<CR>
            \
            \:silent !clear; rm -f a.out /tmp/_err<CR>
            \:silent !c++ -Wall -Wextra -Werror -Wno-unused -std=c++98 % 2>/tmp/_err<CR>
            \:silent cfile /tmp/_err<CR>:silent 5cwindow<CR>
            \:silent !clear<CR>:!./a.out<CR>

"   dev compile run
nn <silent><buffer> <LocalLeader>xd :w\|lcd %:h<CR>
            \
            \:silent !clear; rm -f a.out /tmp/_err<CR>
            \:silent !c++
            \ -Wall -Wextra -Werror -std=c++98
            \ -Wconversion -Wsign-conversion -pedantic
            \ -fsanitize=address,undefined,integer,nullability,vptr
            \ -fno-optimize-sibling-calls -fno-omit-frame-pointer -Og -D DEV
            \ % 2>/tmp/_err<CR>:silent cfile /tmp/_err<CR>:silent 5cwindow<CR>
            \:silent !clear; ./a.out<CR>

"   prod compile run + leaks
if system("uname -s") == "Darwin\n"
    nn <silent><buffer> <LocalLeader>xl :w\|lcd %:h<CR>
                \
                \:silent !clear; rm -f a.out /tmp/_err<CR>
                \:silent !c++
                \ -Wall -Wextra -Werror -std=c++98
                \ -fno-omit-frame-pointer -Og -D DEV
                \ % 2>/tmp/_err<CR>:silent cfile /tmp/_err<CR>:silent 5cwindow<CR>
                \:silent !clear; leaks -q -atExit -- ./a.out<CR>
elseif system("uname -s") == "Linux\n"
    nn <silent><buffer> <LocalLeader>xl :w\|lcd %:h<CR>
                \
                \:silent !clear; rm -f a.out /tmp/_err<CR>
                \:silent !c++
                \ -Wall -Wextra -Werror -std=c++98
                \ -fno-omit-frame-pointer -Og -D DEV
                \ % 2>/tmp/_err<CR>:silent cfile /tmp/_err<CR>:silent 5cwindow<CR>
                \:silent cfile /tmp/_err<CR>:silent 5cwindow<CR>
                \:silent !clear; valgrind -q ./a.out<CR>
endif

"   docstring skeleton
nn <silent><buffer> <LocalLeader>d mdj
            \
            \:keeppatterns ?^\a<CR>
            \O<Esc>O/**<Esc>o<C-w>* @brief       TODO<CR><CR>
            \@param[out]  TODO<CR>
            \@param[in]   TODO<CR>
            \@return      TODO<CR>
            \<BS>/<Esc>=ip
            \jfT

"   format
nn <silent><buffer> <LocalLeader>f :call clangformat#()<CR>:w<CR>

"   print TODO cf. c.vim
nn <silent><buffer> <LocalLeader>p ostd::cout << "" << std::endl;<Esc>==0f"a

"   print wrap
nn <silent><buffer> <LocalLeader>w 0<<V:norm f;Di<Esc>Istd::cout << <Esc>A << std::endl;<Esc>==EEW

"   print location
nn <silent><buffer> <LocalLeader>. ostd::cout << "(" << __FILE__ << ": " << __func__  << ": l." << __LINE__ << ")" << std::endl;<Esc>==0f(

"   toggle .hpp/.cpp
nn <silent><buffer> <LocalLeader>s :call cpp_defswap#()<CR>

"   class nav TODO
nn <silent><buffer> gzc  mm:r !ls -1 inc*<CR>V`[J
            \
            \V:s/\.hpp /\\\\|/g<CR>f.D0
            \i\(\/\/.*\\|^ \* .*\)\@<!\(<Esc>A\)<Esc>
            \dd/<C-r>"<BS><CR>`m

"   functions nav
nn <silent><buffer> gzf /^\a<CR>

"   Functions list
nn <silent><buffer> gzF :keeppatterns g/^\a<CR>

"   coplien class template
nn <silent><buffer> gzi :call cpp_classinit#()<CR>


"   text objects


"   functions
xn <silent><buffer> if <Esc>k/^}$<CR>V%j0ok$
xn <silent><buffer> af <Esc>k/^}$<CR>V%?^$<CR>j
ono <silent><buffer> if :normal Vif<CR>
ono <silent><buffer> af :normal Vaf<CR>

"   functions + docstring
xn <silent><buffer> aF <Esc>k/^}$<CR>V%?/\*<CR>oj
ono <silent><buffer> aF :normal VaF<CR>


"   abbreviations


iabbr <silent><buffer> mmain int main( void ) {<CR>return 0;<CR>}<Esc>kO<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> {{ {<CR>}<Esc>O<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> [[ [<CR>]<Esc>O<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> (( ()<Left><C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> "" ""<Left><C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> '' ''<Left><C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> iif if () {<CR>}<Esc>kf)i<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> eelse else {<CR>}<C-O>O<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> eelseif else if () {<CR>}<Esc>kf)i<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> wwhile while () {<CR>}<Esc>kf)i<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> ffor for () {<CR>}<Esc>kf)i<C-R>=eatchar#('\s')<CR>

iabbr <silent><buffer> sstr std::string
iabbr <silent><buffer> sstrc std::string const& <C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> cin std::cin
iabbr <silent><buffer> cer std::cerr
iabbr <silent><buffer> cou std::cout
iabbr <silent><buffer> cen std::endl
iabbr <silent><buffer> ccin std::cin >>;<Left>
iabbr <silent><buffer> ccer std::cerr <<;<Left>
iabbr <silent><buffer> ccou std::cout <<;<Left>
iabbr <silent><buffer> ccen std::cout << std::endl;<Esc>^
iabbr <silent><buffer> pcer std::cerr << "" << std::endl;<Esc>14hi<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> pcou std::cout << "" << std::endl;<Esc>14hi<C-R>=eatchar#('\s')<CR>
