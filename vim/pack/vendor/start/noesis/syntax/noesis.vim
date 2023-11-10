" syntax/noesis
" Created: 230524 20:46:36 by clem9nt@imac
" Updated: 230728 12:55:51 by clem@spectre
" Maintainer: Clément Vidon

if exists("b:current_syntax")
    finish
endif


"   syntax


syn sync fromstart

syn region noesisH1 start="^##\@!"        end="#*\s*$"
syn region noesisH2 start="^###\@!"       end="#*\s*$"
syn region noesisH3 start="^####\@!"      end="#*\s*$"
syn region noesisH4 start="^#####\@!"     end="#*\s*$"
syn region noesisH5 start="^######\@!"    end="#*\s*$"
syn region noesisH6 start="^#######\@!"   end="#*\s*$"

syn match noesisHeader "^[a-zA-Z0-9( ):,.\-\&]*\n^-\{3,}$"
syn match noesisHeader "^[A-Z0-9( ):,.\-\&]*\n^=\{3,}$"
syn match noesisHeader "^\s\{72}\[\d\{6}]$"

syn match noesisUrl contains=@NoSpell "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[A-Za-z0-9/-]"
syn match noesisLink "\(\s@\|^@\|(@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\|\ze#\|\ze,\)"

" syn match noesisCodeblock "^\s\{4,32}\S.*$" contains=noesisKeywordPos,todoKeywordNeg,noesisUrl
syn match noesisBlockquote "^\s\{0,3}>\{1,2}\s"
syn match noesisBlockquote "^\s\{0,3}>$"

if has("conceal")
    set conceallevel=2
    set concealcursor=n
    syn region noesisCode       concealends matchgroup=noesisDelim start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`" contains=@NoSpell
    syn region noesisItalic     concealends matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region noesisBold       concealends matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region noesisBoldItalic concealends matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
    " syn region noesisStrike     concealends matchgroup=noesisDelim start="\S\@<=\~\|\~\S\@="         end="\S\@<=\~\|\~\S\@="         skip="\\\~"
else
    syn region noesisCode                   matchgroup=noesisDelim start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`"
    syn region noesisItalic                 matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region noesisBold                   matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region noesisBoldItalic             matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
    " syn region noesisStrike                 matchgroup=noesisDelim start="\S\@<=\~\|\~\S\@="         end="\S\@<=\~\|\~\S\@="         skip="\\\~"
endif

syn match noesisKeywordPos "\<TODO\>"
syn match noesisKeywordPos "\<WIP\>"
syn match noesisKeywordNeg "\W\zs!\{3}\ze\(\W\|\)"
syn match noesisKeywordNeg "\<X\>"
syn match noesisKeywordNeg "\<XXX\>"


" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

"   highlight


if &background == "dark"

    hi noesisH1                       ctermfg=85
    hi noesisH2                       ctermfg=85
    hi noesisH3                       ctermfg=85
    hi noesisH4                       ctermfg=85
    hi noesisH5                       ctermfg=85
    hi noesisH6                       ctermfg=85

    hi noesisHeader                   ctermfg=231

    hi noesisUrl                      ctermfg=103
    hi noesisLink                     ctermfg=105

    hi noesisBlockquote               ctermfg=103
    hi noesisCodeblock                ctermfg=115

    " TODO check 218 182 146 110 74
    hi noesisCode                     ctermfg=115
    hi noesisItalic                   ctermfg=111   cterm=italic
    hi noesisBold                     ctermfg=3     cterm=bold
    hi noesisBoldItalic               ctermfg=214
    " hi noesisStrike                   ctermfg=168

    hi noesisKeywordPos                 ctermfg=190
    hi noesisKeywordNeg                 ctermfg=207

elseif &background == "light"

    hi noesisH1                       ctermfg=27
    hi noesisH2                       ctermfg=27
    hi noesisH3                       ctermfg=27
    hi noesisH4                       ctermfg=27
    hi noesisH5                       ctermfg=27
    hi noesisH6                       ctermfg=27

    hi noesisUrl cterm=underline      ctermfg=147
    hi noesisLink                     ctermfg=105

    hi noesisCode                     ctermfg=101
    hi noesisItalic                   ctermbg=230
    hi noesisBold                     ctermbg=229
    hi noesisBoldItalic               ctermbg=195
    " hi noesisStrike                   ctermfg=174

endif


let b:current_syntax = "noesis"
