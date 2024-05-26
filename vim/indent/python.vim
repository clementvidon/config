" @filename  python.vim
" @created   230522 19:09:16  by  clem9nt@imac
" @updated   230522 19:09:16  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal cindent
setlocal expandtab
setlocal formatprg="black --quiet - 2>/tmp/vim_format_errors" " TODO replace 'black' with 'ruff'
setlocal tw=80
setlocal list listchars=multispace:│\ \ \  " jj
