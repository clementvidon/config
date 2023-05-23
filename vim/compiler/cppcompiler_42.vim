" @filename  cppcompiler.vim
" @created   230523 16:31:09  by  cvidon@e3r2p17.clusters.42paris.fr
" @updated   230523 16:31:09  by  cvidon@e3r2p17.clusters.42paris.fr
" @author    Clément Vidon

" TODO to use cppcompiler_42 for all c++ files
" enter ':compiler cppcompiler_42' to set
" and ':make' to run

if exists("current_compiler")
  finish
endif
let current_compiler = "cppcompiler"

if exists(":compiler")
  silent! unlet g:makeprg
endif

setlocal errorformat=%f:%l:\ %m
setlocal makeprg="make --no-print-directory --jobs -C " . fnamemodify(findfile('Makefile', '.;'), ":h") . " $*"
" setlocal makeprg="c++"
"             \ . " -Wall -Wextra -Werror -std=c++98"
"             \ . " -Wconversion -Wsign-conversion -pedantic"
"             \ . " %"
