augroup filetype_motoko
    autocmd!
    " --------------------------------- OPTIONS >>>

    " .......................... BUILTIN

    au FileType motoko,mo,gdmo set filetype=motoko
    au FileType motoko set syntax=go
    au FileType motoko setl expandtab tabstop=2 shiftwidth=2 textwidth=80
    au FileType motoko setl softtabstop=2 autoindent cindent
    au FileType motoko setl ls=2
    au FileType motoko let &makeprg = "make --no-print-directory --jobs -C " . fnamemodify(findfile('Makefile', '.;'), ":h") . " $*"
    au FileType motoko setl formatprg=clang-format\ --style=file
    au FileType motoko let maplocalleader = "gh"

    " .......................... PLUGIN

    au FileType motoko let g:gutentags_enabled = 1
    au FileType motoko let b:surround_45 = '("\r");'

    " <<<

    " --------------------------------- MAPPINGS >>>

    " .......................... PRIMARY (GH?)

    au Filetype motoko nn <silent><buffer> <LocalLeader> <nop>

    " ............... MAKE

    "   make
    au Filetype motoko nn <silent><buffer> mm :w<CR>
                \:silent !clear<CR>
                \:make!<CR>

    " ............... CLEAN CODE

    "   Format
    au Filetype motoko nn <silent><buffer> <LocalLeader>f :call ClangFormat()<CR>:w<CR>

    " <<<
augroup END
