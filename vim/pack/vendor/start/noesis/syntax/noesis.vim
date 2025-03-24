" syntax/noesis
" Created: 230524 20:46:36 by clem9nt@imac
" Updated: 240110 15:45:31 by clem@spectre
" Maintainer: Clément Vidon (clemedon)

" if exists("b:current_syntax")
"     finish
" endif


"   syntax


syn sync fromstart

syn region noesisH1 start="^##\@!"        end="#*\s*$"
syn region noesisH2 start="^###\@!"       end="#*\s*$"
syn region noesisH3 start="^####\@!"      end="#*\s*$"
syn region noesisH4 start="^#####\@!"     end="#*\s*$"
syn region noesisH5 start="^######\@!"    end="#*\s*$"
syn region noesisH6 start="^#######\@!"   end="#*\s*$"

syn match noesisHeader "^.*\n^-\{3,}$"
syn match noesisHeader "^.*\n^=\{3,}$"
syn match noesisHeader "^\s\{72}\[\d\{6}]$"

syn match noesisUrl contains=@NoSpell "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[A-Za-z0-9/-]"
syn match noesisLink "\(\s@\|^@\|(@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\)"
syn match noesisTag  "\(\s#\|^#\|(#\)\@<=[a-zA-Z0-9/_]\{-}\ze\(\s\|:\|;\|,\|$\|)\)"

syn match noesisBlockquote "^\s\{0,5}>\{1,2}\s"
syn match noesisBlockquote "^\s\{0,5}>$"
syn match noesisBlockquote "^\s\{0,5}>$"

if has("conceal")
    set conceallevel=3
    set concealcursor=vn
    syn region noesisCode       concealends matchgroup=noesisDelim start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`" contains=@NoSpell
    syn region noesisItalic     concealends matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region noesisBold       concealends matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region noesisBoldItalic concealends matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
else
    syn region noesisCode                   matchgroup=noesisDelim start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`" contains=@NoSpell
    syn region noesisItalic                 matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region noesisBold                   matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region noesisBoldItalic             matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
endif

syn region noesisCode start="```" end="```" contains=@NoSpell

syn keyword Todo TODO FIXME X XXX WIP

"   highlight


" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

if &background == "dark"

    hi Folded                         ctermfg=105 ctermbg=NONE cterm=italic

    hi noesisH1                       ctermfg=85
    hi noesisH2                       ctermfg=85
    hi noesisH3                       ctermfg=85
    hi noesisH4                       ctermfg=85
    hi noesisH5                       ctermfg=85
    hi noesisH6                       ctermfg=85

    hi noesisHeader                   ctermfg=231

    hi noesisUrl                      ctermfg=103
    hi noesisLink                     ctermfg=105
    hi noesisTag                      ctermfg=210

    hi noesisBlockquote               ctermfg=103

    hi noesisCode                     ctermfg=146 cterm=italic
    hi noesisItalic                   ctermfg=145 cterm=italic
    hi noesisBold                     ctermfg=219 cterm=bold
    hi noesisBoldItalic               ctermfg=205

elseif &background == "light"

    hi Folded                         ctermfg=105 ctermbg=NONE cterm=italic

    hi noesisH1                       ctermfg=20
    hi noesisH2                       ctermfg=20
    hi noesisH3                       ctermfg=20
    hi noesisH4                       ctermfg=20
    hi noesisH5                       ctermfg=20
    hi noesisH6                       ctermfg=20

    hi noesisHeader                   ctermfg=232

    hi noesisUrl                      ctermfg=138 cterm=underline
    hi noesisLink                     ctermfg=33
    " hi noesisTag                      ctermfg=TODO

    hi noesisBlockquote               ctermfg=171

    hi noesisCode                     ctermfg=65  cterm=italic
    hi noesisItalic                   ctermfg=88  cterm=italic
    hi noesisBold                     ctermfg=160 cterm=bold
    hi noesisBoldItalic               ctermfg=196

endif


" let b:current_syntax = "noesis"
