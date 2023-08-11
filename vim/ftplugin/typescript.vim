" @filename  typescript.vim
" @created   230522 18:11:05  by  clem9nt@imac
" @updated   230522 18:11:05  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal path=$PWD,$PWD/src/**,
let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   overwrite sf
nn <buffer> sf :fin *


"   execute
nn <silent><buffer> <LocalLeader>x :w\|lcd %:h<CR>:!clear; node %<CR>

"   clear
nn <silent><buffer> <LocalLeader>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>

"   format
nn <silent><buffer> <LocalLeader>f :w<CR>:! prettier --write %<CR>:e<CR>
nn <silent><buffer> <LocalLeader>F :w<CR>:! npm run format<CR>:e<CR>

"   lint
nn <silent><buffer> <LocalLeader>l :w<CR>:! eslint % --fix<CR>:e<CR>
nn <silent><buffer> <LocalLeader>L :w<CR>:! npm run lint<CR>:e<CR>

"   print
nn <silent><buffer> <LocalLeader>p oconsole.log()<Esc>==f)i

"   print wrap
nn <silent><buffer> <LocalLeader>w 0<<V:norm f;Di<Esc>Iconsole.log(<Esc>A);<Esc>==f)h

"   put expr value
nn <silent><buffer> <LocalLeader>e :lcd %:h<CR>
            \
            \:silent echo "Cleanup the line."<CR>
            \0f;C;<Esc>
            \:silent echo "Duplicate the line."<CR>
            \0lYp
            \:silent echo "Wrap the current line expression into a print."<CR>
            \0<<Iconsole.log(<Esc>$i)<Esc>:w<CR>
            \:silent echo "Print its value in a comment"<CR>
            \:undojoin \| r!node % 2>/dev/null<CR>`[V`]<C-V>0I//> <Esc>
            \:silent echo "Delete line"<CR>
            \kddkJ


"   plugins


"   ale hover
nn <LocalLeader>h :ALEHover<CR>

"   ale code action
nn <LocalLeader>a :ALECodeAction<CR>

"   ale detail
nn <LocalLeader>d :ALEDetail<CR>
