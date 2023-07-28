" syntax/noesis
" Created: 230524 20:46:36 by clem9nt@imac
" Updated: 230728 12:55:51 by clem@spectre
" Maintainer: Clément Vidon

if exists("b:current_syntax")
    finish
endif


"   syntax


syn region noesisH1 start="^##\@!"        end="#*\s*$"
syn region noesisH2 start="^###\@!"       end="#*\s*$"
syn region noesisH3 start="^####\@!"      end="#*\s*$"
syn region noesisH4 start="^#####\@!"     end="#*\s*$"
syn region noesisH5 start="^######\@!"    end="#*\s*$"
syn region noesisH6 start="^#######\@!"   end="#*\s*$"

syn match noesisUrl contains=@NoSpell "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[A-Za-z0-9/-]"
syn match noesisLink "\(\s@\|^@\|(@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\|\ze#\|\ze,\)"

if has("conceal")
    set conceallevel=2
    set concealcursor=n
    syn region noesisCode       concealends matchgroup=noesisDelim start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`"
    syn region noesisItalic     concealends matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region noesisBold       concealends matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region noesisBoldItalic concealends matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
    syn region noesisStrike     concealends matchgroup=noesisDelim start="\S\@<=\~\|\~\S\@="         end="\S\@<=\~\|\~\S\@="         skip="\\\~"
else
    syn region noesisCode                   matchgroup=noesisDelim start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`"
    syn region noesisItalic                 matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region noesisBold                   matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region noesisBoldItalic             matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
    syn region noesisStrike                 matchgroup=noesisDelim start="\S\@<=\~\|\~\S\@="         end="\S\@<=\~\|\~\S\@="         skip="\\\~"
endif


"   highlight


if &background == "dark"

    hi noesisH1                       ctermfg=85
    hi noesisH2                       ctermfg=85
    hi noesisH3                       ctermfg=85
    hi noesisH4                       ctermfg=85
    hi noesisH5                       ctermfg=85
    hi noesisH6                       ctermfg=85

    " hi noesisUrl cterm=underline      ctermfg=103
    hi noesisUrl                      ctermfg=250
    hi noesisLink                     ctermfg=104

    hi noesisCode                     ctermfg=117
    hi noesisItalic                   ctermfg=3
    hi noesisBold                     ctermfg=214
    hi noesisBoldItalic               ctermfg=209
    hi noesisStrike                   ctermfg=174

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
    hi noesisStrike                   ctermfg=174

endif


let b:current_syntax = "noesis"
