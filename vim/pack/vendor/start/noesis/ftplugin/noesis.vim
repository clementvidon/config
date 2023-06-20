" ftplugin/noesis
" Created: 230524 20:45:19 by clem9nt@imac
" Updated: 230601 14:58:07 by cvidon@e2r3p15.clusters.42paris.fr
" Maintainer: Clément Vidon


" <<<

" --------------------------------- OPTIONS >>>


setlocal textwidth=80
setlocal suffixesadd+=.noe
setlocal suffixesadd+=.gpg.noe
setlocal path+=$DOTVIM/pack/vendor/start/noesis/**,
            \$NOESIS,
            \$NOESIS/Lists/**,
            \$NOESIS/Areas/**,
            \$NOESIS/Projects/**,
            \$NOESIS/Resources/**
setlocal expandtab
let maplocalleader = "gh"
" syntax sync fromstart
" setl formatoptions+=ro
" setl comments+=s:[],m:[],e:[]


" <<<
" --------------------------------- MAPPINGS >>>


"                       SAFETY :

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

"   Mapping Info
nn <silent><buffer> <LocalLeader>? :echo "
            \\n
            \================[Noesis]================\n
            \                                      \|\n
            \ HTML_EXPORT       : Space X          \|\n
            \                                      \|\n
            \ PUSH_NOESIS         : ghps             \|\n
            \ PULL_NOESIS         : ghpl             \|\n
            \                                      \|\n
            \ NOESIS_NAV FOR      : Space CR         \|\n
            \ NOESIS_NAV BAC      : Space Tab        \|\n
            \ INDEX_GEN         : Space #          \|\n
            \ INDEX_NAV         : Space 3          \|\n
            \ NOESIS_GREP         : :Grep            \|\n
            \                                      \|\n
            \ MD_LINK           : Space L          \|\n
            \                                      \|\n
            \ GPG_ENC           : ghe              \|\n
            \ GPG_DEC           : ghd              \|\n
            \                                      \|\n
            \"<CR>


"                       GENERAL :

"   Html Export TODO NoesisToHtml()
nn <silent><buffer> <LocalLeader>X :set term=xterm-256color<CR>:TOhtml<CR>
            \
            \/--><CR>Oa { color: hotpink; }<Esc>go
            \:%s/background-color: \#000000; }$/background-color: \#2e333f; }/g<CR>
            \:%s/\* { font-size: 1em; }$/\* { font-size: 1.1em; }/g<CR>
            \:%s/\.noesisH1 { color: #5fffaf; }$/.noesisH1 { color: #5fffaf; font-size: 120%; }/g<CR>
            \:%s/\.noesisUrl { color: #ff5faf; text-decoration: underline; }$/.noesisUrl { color: #ff5faf; text-decoration: underline; font-size: 90%; }/g<CR>
            \go/<span class="noesisBlockquote">&gt; </span><CR>cc<span class="noesisBlockquote">&gt; </span> cvidon@student.42.fr<Esc>go
            \:fix}}<Esc>


nn <silent><buffer> <LocalLeader>pl :cd %:h\|sil !git pull<CR>:redraw!<CR>

"   Push Noesis TODO NoesisGitPush()
" au BufRead,BufNewFile $NOESIS/Lists/*.noe nn <silent><buffer> ghps :echo "Push"<CR>:w\|lc %:h<CR>
nn <silent><buffer> <LocalLeader>ps :echo "Push"<CR>:w\|lc %:h<CR>
            \
            \:sil !rm $DOTVIM/.swp/*%*.swp<CR>
            \:sil cd $NOESIS/<CR>
            \:sil !git add -f INDEX.noe Lists Areas Projects Resources Archives<CR>
            \:sil !git commit -m "Push"<CR>:sil !git push origin main<CR>
            \:q<CR>:redr!<CR>

"   Index Gen TODO NoesisIndexGen() (regen if exist)
nn <silent><buffer> <LocalLeader>I :silent
            \
            \ :let @a=''<CR>:keeppatterns g/^##/y A<CR>3Gpo#INDEX<CR>------<Esc>0k

"   Index Nav TODO NoesisIndexNav()
nn <silent><buffer> <LocalLeader>i :keeppatterns /<C-R>=getline('.')<CR>$<CR>zt5<C-y>

"   Markdown link
nn <silent><buffer> <LocalLeader>l 0/ttp.*\/\/\\|ww\..*\.<CR>Ea)<Esc>:let @/=''<CR>Bi[](<Left><Left>

"   Noesis Grep
com! -nargs=+ Grep exec 'grep! -i <args> $NOESIS/**/*.noe' | cw


"   GPG ENC
nn <buffer><silent> <LocalLeader>enc :silent %!gpg --default-recipient Clem9nt -ae 2>/dev/null<CR>
"   GPG DEC
nn <buffer><silent> <LocalLeader>dec :silent %!gpg -d 2>/dev/null<CR>

"   Gpg enc/dec
vn <silent><buffer> <LocalLeader>gs :!gpg -ca<CR>:echo "gpg -ca # --symetric --armor"
vn <silent><buffer> <LocalLeader>ga :!gpg -ae<CR>dd:echo "gpg -ae # --"
vn <silent><buffer> <LocalLeader>gd :!gpg -qd<CR>:echo "gpg -qd"


"                       TOD0 :

"   Archive Day
nn <buffer><silent> <LocalLeader>A :call noesis#NoesisArchiveDay()<CR>
            \:sil cd $NOESIS/<CR>
            \:sil !git add -f INDEX.noe Lists Areas Projects Resources Archives<CR>
            \:sil !git commit -m "Archive"<CR>:redraw!<CR>

"   Task New
nn <silent><buffer> <LocalLeader>t O- tmp<Esc><<:call noesis#NoesisTaskCheck()<CR>ftC

"   Task Check
nn <silent><buffer> <LocalLeader>k :call noesis#NoesisTaskCheck()<CR>
            \
            \:write<CR>0

"   Task un-parenthesis
nn <silent><buffer> <LocalLeader>K <Esc>
            \
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \zs( \ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \d\d:\d\d\zs )\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~] \d\d:\d\d \d\d:\d\d\zs )\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \ze.', ' ' . strftime('%y%m%d') . ' ', ''))<CR>
            \:write<CR>0

"   Task Fix
nn <silent><buffer> <LocalLeader>F :call noesis#NoesisTaskFix("up")<CR>
nn <silent><buffer> <LocalLeader>f :call noesis#NoesisTaskFix("down")<CR>

"   Task Now
"   TODO update
nn <silent><buffer> <LocalLeader>. :silent! ?^- \(\(.*\d\d\d\d\d\d.*\)\@!.\)*$<CR>z.:let @/=""<CR>

"   Task Clear
nn <silent><buffer> <LocalLeader>c <Esc>
            \
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d \d\d:\d\d \d\d:\d\d\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d \d\d:\d\d\ze.', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d:\d\d\ze', '', 'g'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d:\d\d\ze', '', 'e'))<CR>
            \:call setline('.', substitute(getline('.'), '\s\{0,1}[-~]\zs \d\d\d\d\d\d\ze.', '', 'e'))<CR>
            \:write<CR>0

"                       HISTORY

"   rot
nn <buffer><silent> <LocalLeader>r Mmm
            \
            \:keeppatterns g/^\s/norm g??<CR>
            \`mzz3<C-O>


"   En
nn <buffer><silent> <LocalLeader>len v$y:En <C-R>"<CR>
vn <buffer><silent> <LocalLeader>len y:En <C-R>"<CR>
"   Fr
nn <buffer><silent> <LocalLeader>lfr v$y:Fr <C-R>"<CR>
vn <buffer><silent> <LocalLeader>lfr y:Fr <C-R>"<CR>

"   Sy
vn <buffer><silent> <LocalLeader>sy y:Sy <C-R>"<CR>

" <<<
" --------------------------------- DIGRAPHS >>>

no <C-K>% <Nop>
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

" <<<
augroup END
