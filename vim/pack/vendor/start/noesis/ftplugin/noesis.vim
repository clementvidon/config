" ftplugin/noesis
" Created: 230524 20:45:19 by clem9nt@imac
" Updated: 230601 14:58:07 by cvidon@e2r3p15.clusters.42paris.fr
" Maintainer: Clément Vidon

"   options


runtime macros/justify.vim

setlocal suffixesadd+=.noe
setlocal suffixesadd+=.gpg.noe
setlocal path=.,$NOESIS,$DOTVIM/pack/vendor/start/noesis/**
setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
let maplocalleader = "gh"


"   mappings


nn <buffer><silent> <LocalLeader> <nop>
nn <silent><buffer> <space>= <nop>
vn <silent><buffer> <space>= <nop>
vn <silent><buffer> = <nop>
nn <silent><buffer> = <nop>
vn <silent><buffer> gq <nop>
nn <silent><buffer> gq <nop>
nn <silent><buffer> gwG <nop>
nn <silent><buffer> gwgo <nop>
nn <silent><buffer> gwgg <nop>
nn <buffer><silent> <Leader>e <nop>
nn <silent><buffer> K <nop>

"   info
nn <silent><buffer> <LocalLeader>? :echo "
            \\n
            \================[Noesis]================\n
            \                                      \|\n
            \ HTML_EXPORT       : Space X          \|\n
            \                                      \|\n
            \"<CR>


"   export as html TODO func
nn <silent><buffer> <LocalLeader>X :set term=xterm-256color<CR>:TOhtml<CR>
            \
            \:silent! %s/\.noesisItalic { .\{-} }$/.noesisItalic { color: #87AFFF; font-style: italic; }/g<CR>
            \:silent! %s/\.noesisBold { .\{-} }$/.noesisBold { color: #EBCB8B; font-weight: bold; }/g<CR>
            \:silent! %s/\.Todo { .\{-} }$/.Todo { color: #EBCB8B; font-weight: bold; }/g<CR>
            \:silent! %s/background-color: \#000000; }$/background-color: \#2e333f; }/g<CR>
            \/--><CR>Oa { color: #8787af; font-size: inherit; }<CR>
            \footer { font-style: italic; font-size: inherit; font-size: 0.8em; }<Esc>
            \:silent! g/\.noesis.\{-} { .\{-} }$/norm f}clfont-size: inherit; }<CR>
            \:silent! %s/\* { font-size: 1em; }$/\* { font-size: 1.1em; }/g<CR>
            \go/title<CR>o<meta name="author" content="Clement VIDON"><Esc>
            \o<meta name="copyright" content="&copy; Clément VIDON. All Rights Reserved."><Esc>
            \G?body<CR>o<footer><CR><a href="https://github.com/clemedon">
            \Contact:<!-- --cv-- --> cvidon<!-- c--v -->@student.<!-- cv -->42.fr - Copyright: &copy; Clément VIDON. All Rights Reserved.
            \</a><CR></footer>
            \<Esc>

"   index generator TODO func
nn <silent><buffer> <LocalLeader>I :let @a=''<CR>zR
            \
            \:silent! keeppatterns g/^\nINDEX\n=*\n->>>/norm V}}jd<CR>
            \:silent! keeppatterns g/^\(-\\|=\)\{40,80}/-1y A<CR>
            \3G"apo<CR>INDEX<CR><Esc>80i=<Esc>o<Esc>0O->>><Esc>}}o<<<-<Esc>kk
            \:let @a=""<CR>
            \vip>gv:g/[a-z][a-z]\C/norm >><CR>
            \:let @/=""<CR>
            \zMzo

"   index nav TODO func
nn <silent><buffer> <LocalLeader>i :let @a=trim(getline('.'))<CR>
            \
            \:silent! keeppatterns /^\s\{0,4}<C-R>a$<CR>
            \zt5<C-y>
            \:let @a=''<CR>

"   noesis grep TODO neovim support
com! -nargs=+ Grep exec 'grep! -i --exclude="*.gpg.noe" <args> $NOESIS/*.noe' | cw


"   git pull
nn <silent><buffer> <LocalLeader>pl :cd %:h\|sil !git pull<CR>:redraw!<CR>

"   git add commit push TODO
nn <silent><buffer> <LocalLeader>ps :echo "Push"<CR>:w\|lc %:h<CR>
            \
            \:sil cd $NOESIS/<CR>
            \:sil !git add -f .<CR>
            \:sil !git commit -m "Push"<CR>:sil !git push origin main<CR>
            \:q<CR>:redr!<CR>

"   french to english
nn <buffer><silent> <LocalLeader>len v$y:En <C-R>"<CR>
vn <buffer><silent> <LocalLeader>len y:En <C-R>"<CR>

"   english to french
nn <buffer><silent> <LocalLeader>lfr v$y:Fr <C-R>"<CR>
vn <buffer><silent> <LocalLeader>lfr y:Fr <C-R>"<CR>

"   english synonym
vn <buffer><silent> <LocalLeader>sy y:Sy <C-R>"<CR>

"   string to H1
nn <buffer><silent> <LocalLeader>h1 VUo<C-O>80i=<Esc>:put=strftime('%y%m%d')<CR>
            \73i<Space><Esc>r[A]<Esc>2k0

"   string to H2
nn <buffer><silent> <LocalLeader>h2 :s/\v<(.)(\w*)/\u\1\L\2/g<CR>o<C-O>40i-<Esc>k0

no <C-K>% <Nop>
exec "digraphs es " . 0x2091
exec "digraphs hs " . 0x2095
exec "digraphs is " . 0x1D62
exec "digraphs js " . 0x2C7C
exec "digraphs ks " . 0x2096
exec "digraphs ls " . 0x2097
exec "digraphs ms " . 0x2098
exec "digraphs ns " . 0x2099
exec "digraphs os " . 0x2092
exec "digraphs ps " . 0x209A
exec "digraphs rs " . 0x1D63
exec "digraphs ss " . 0x209B
exec "digraphs ts " . 0x209C
exec "digraphs us " . 0x1D64
exec "digraphs vs " . 0x1D65
exec "digraphs xs " . 0x2093

exec "digraphs aS " . 0x1d43
exec "digraphs bS " . 0x1d47
exec "digraphs cS " . 0x1d9c
exec "digraphs dS " . 0x1d48
exec "digraphs eS " . 0x1d49
exec "digraphs fS " . 0x1da0
exec "digraphs gS " . 0x1d4d
exec "digraphs hS " . 0x02b0
exec "digraphs iS " . 0x2071
exec "digraphs jS " . 0x02b2
exec "digraphs kS " . 0x1d4f
exec "digraphs lS " . 0x02e1
exec "digraphs mS " . 0x1d50
exec "digraphs nS " . 0x207f
exec "digraphs oS " . 0x1d52
exec "digraphs pS " . 0x1d56
exec "digraphs rS " . 0x02b3
exec "digraphs sS " . 0x02e2
exec "digraphs tS " . 0x1d57
exec "digraphs uS " . 0x1d58
exec "digraphs vS " . 0x1d5b
exec "digraphs wS " . 0x02b7
exec "digraphs xS " . 0x02e3
exec "digraphs yS " . 0x02b8
exec "digraphs zS " . 0x1dbb

exec "digraphs AS " . 0x1D2C
exec "digraphs BS " . 0x1D2E
exec "digraphs DS " . 0x1D30
exec "digraphs ES " . 0x1D31
exec "digraphs GS " . 0x1D33
exec "digraphs HS " . 0x1D34
exec "digraphs IS " . 0x1D35
exec "digraphs JS " . 0x1D36
exec "digraphs KS " . 0x1D37
exec "digraphs LS " . 0x1D38
exec "digraphs MS " . 0x1D39
exec "digraphs NS " . 0x1D3A
exec "digraphs OS " . 0x1D3C
exec "digraphs PS " . 0x1D3E
exec "digraphs RS " . 0x1D3F
exec "digraphs TS " . 0x1D40
exec "digraphs US " . 0x1D41
exec "digraphs VS " . 0x2C7D
exec "digraphs WS " . 0x1D42


"   task check, fix, diff, clear
nn <silent><buffer> <LocalLeader>k :call task_check#()<CR>
nn <silent><buffer> <LocalLeader>F :call task_fix#("time_end")<CR>
nn <silent><buffer> <LocalLeader>f :call task_fix#("time_beg")<CR>
nn <buffer><silent> <LocalLeader>t :call time_diff#(getline('.'))<CR>
nn <silent><buffer> <LocalLeader>c <Esc>
            \
            \:call setline('.', substitute(getline('.'), '-\zs \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '-\zs \d\d\d\d\d\d \d\d:\d\d\ze.', '', 'e'))<CR>
            \0


"   abbreviations

iabbr <silent><buffer> mma - main: 0000<Esc>viW
iabbr <silent><buffer> ssi - side: 0000<Esc>viW
iabbr <silent><buffer> lli - life: 0000<Esc>viW
