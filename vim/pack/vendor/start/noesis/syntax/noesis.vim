" syntax/noesis
" Created: 230524 20:46:36 by clem9nt@imac
" Updated: 230524 20:46:36 by clem9nt@imac
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

syn match noesisListMarker "^\%(\s\{0,3\}\)[-*+~]\%(\s\+\S\)\@="
syn match noesisOrderedListMarker "^\%(\s\{0,3}\)\<\d\+\.\%(\s\+\S\)\@="

syn match noesisBlockquote "^>\%(\s\|$\)"
syn match noesisUrl contains=@NoSpell "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[A-Za-z0-9/-]"
syn match noesisLink "\(\s@\|^@\|(@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\|\ze#\|\ze,\)"

if has("conceal")
    set conceallevel=2
    set concealcursor=n
    syn region noesisCode       concealends matchgroup=noesisDelimiter start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`"
    syn region noesisItalic     concealends matchgroup=noesisDelimiter start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region noesisBold       concealends matchgroup=noesisDelimiter start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region noesisBoldItalic concealends matchgroup=noesisDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
else
    syn region noesisCode                   matchgroup=noesisDelimiter start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`"
    syn region noesisItalic                 matchgroup=noesisDelimiter start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region noesisBold                   matchgroup=noesisDelimiter start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region noesisBoldItalic             matchgroup=noesisDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
endif
syn match noesisCodeLine contains=@NoSpell "^\s\{4}.*$"
syn match noesisCodeMarker "^```.*$"
syn region noesisCodeBlock matchgroup=noesisCodeMarker start="^```" end="^```" skip="\\``"

" OLD TASKS
" syn match noesisTaskCheck /^\[\]\ze ./
" syn match noesisTaskCheck /^\[[0-9a-zA-Z: ]*\]\ze ./
" syn match noesisTaskChecked /^\[\d\{6} \d\{2}:\d\{2}\]\ze ./
" syn match noesisTaskChecked /^\[\d\{6} \d\{2}:\d\{2} \d\{2}:\d\{2}\]\ze ./


syn match noesisTaskDash /^\s\{0,1}\(-\|\~\)./ contained
syn match noesisTaskTime /^\s\{0,1}\(-\|\~\)\( \d\d:\d\d\)\{1,2}\ze ./ contains=noesisTaskDash
syn match noesisTaskTime /^\s\{0,1}\(-\|\~\) (.*)\ze ./ contains=noesisTaskDash
syn match noesisTaskDone /^\s\{0,1}\(-\|\~\) \d\d\d\d\d\d\( \d\d:\d\d\)\{1,2}\ze ./ contains=noesisTaskDash

syn keyword noesisBoldItalic TODO
syn keyword noesisBoldItalic XXX
syn keyword noesisBoldItalic X


"   highlight


" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

if &background == "dark"

    hi noesisH1                       ctermfg=85
    hi noesisH2                       ctermfg=85
    hi noesisH3                       ctermfg=85
    hi noesisH4                       ctermfg=85
    hi noesisH5                       ctermfg=85
    hi noesisH6                       ctermfg=85

    hi noesisListMarker               ctermfg=85
    hi noesisOrderedListMarker        ctermfg=85

    hi noesisBlockquote               ctermfg=147
    hi noesisUrl cterm=underline      ctermfg=103
    hi noesisLink                     ctermfg=104

    hi noesisCode                     ctermfg=151
    hi noesisCodeLine                 ctermfg=151
    hi noesisCodeBlock                ctermfg=151

    hi noesisCodeMarker               ctermfg=154
    hi noesisItalic                   ctermfg=230
    hi noesisBold                     ctermfg=228
    hi noesisBoldItalic               ctermfg=220

    hi noesisTaskDash                ctermfg=85
    hi noesisTaskTime                ctermfg=140
    hi noesisTaskDone                ctermfg=102

    hi noesisDelimiter                ctermfg=238

elseif &background == "light"

    hi noesisH1                       ctermfg=27
    hi noesisH2                       ctermfg=27
    hi noesisH3                       ctermfg=27
    hi noesisH4                       ctermfg=27
    hi noesisH5                       ctermfg=27
    hi noesisH6                       ctermfg=27

    hi noesisListMarker               ctermfg=27
    hi noesisOrderedListMarker        ctermfg=27

    hi noesisBlockquote               ctermfg=93
    hi noesisUrl cterm=underline      ctermfg=147
    hi noesisLink                     ctermfg=105

    hi noesisCode                     ctermfg=101
    hi noesisCodeLine                 ctermfg=101
    hi noesisCodeBlock                ctermfg=101
    hi noesisCodeMarker               ctermfg=178

    hi noesisItalic                   ctermbg=230
    hi noesisBold                     ctermbg=229
    hi noesisBoldItalic               ctermbg=195

    hi noesisTaskDash                ctermfg=27
    hi noesisTaskTime                ctermfg=250
    hi noesisTaskDone                ctermfg=101

    hi noesisDelimiter                ctermfg=255

endif

let b:current_syntax = "syntaxnoesis"
