" Vim syntax file
" Language: Notes
" URL: https://github.com/clemedon/notes.vim
" Maintainer:   Clément Vidon  <cvidon@student.42.fr>
" Last Change:  2022 Aug

if exists("b:current_syntax")
    finish
endif
" --------------------------------- SYNTAX {{{
" Headers
syn region notesH1 start="^##\@!" end="#*\s*$"
syn region notesH2 start="^###\@!" end="#*\s*$"
syn region notesH3 start="^####\@!" end="#*\s*$"
syn region notesH4 start="^#####\@!" end="#*\s*$"
syn region notesH5 start="^######\@!" end="#*\s*$"
syn region notesH6 start="^#######\@!" end="#*\s*$"

" List
syn match notesListMarker "^\%(\s\{0,3\}\)[-*+]\%(\s\+\S\)\@="
syn match notesOrderedListMarker "^\%(\s\{0,3}\)\<\d\+\.\%(\s\+\S\)\@="

" Blockquote
syn match notesBlockquote "^>\%(\s\|$\)"

" Url
syn match notesUrl "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[a-z0-9/]"
" Link
syn match notesLink "\(\s@\|^@\)\@<=[a-zA-Z0-9/_.-~]\{-}\(\ze\s\|$\|\ze#\)"

" Code
syn match notesCodeBlock "^\s\{4}.*$"

if has("conceal")
    set conceallevel=2
    set concealcursor=n
    " Code Italic Bold BoldItalic
    syn region notesCode concealends matchgroup=notesDelimiter start="\S\@<=`\|`\S\@=" end="\S\@<=`\|`\S\@=" skip="\\`" oneline
    syn region notesItalic concealends matchgroup=notesDelimiter start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" skip="\\\*" oneline
    syn region notesBold concealends matchgroup=notesDelimiter start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" skip="\\\*" oneline
    syn region notesBoldItalic concealends matchgroup=notesDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*" oneline
else
    " Code Italic Bold BoldItalic
    syn region notesCode matchgroup=notesDelimiter start="\S\@<=`\|`\S\@=" end="\S\@<=`\|`\S\@=" skip="\\`" oneline
    syn region notesItalic matchgroup=notesDelimiter start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" skip="\\\*" oneline
    syn region notesBold matchgroup=notesDelimiter start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" skip="\\\*" oneline
    syn region notesBoldItalic matchgroup=notesDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*" oneline
endif

" Task Stamp/Tag
syn match notesTaskStamp "\(^\[.\{-}\]\)\(\[.\{-}\(\]\|\]$\)\)\@="
syn match notesTaskTag "\(^\[.\{-}\]\)\@<=\[.\{-}\(\]\|\]$\)"

" Task Perso
syn match notesTaskPerso "\(\]\[\(Home\|Life\|>>\)\]\)\@<=.*"

" Escape
syn match notesEscape "\\[][\\`*_{}()<>#+.!-]"

" Keywords
syn keyword notesBoldItalic TODO

" }}}
" --------------------------------- COLORS {{{
" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

if &background == "dark"
    " Headers               : vivid light green
    hi notesH1 ctermfg=85
    hi link notesH2 notesH1
    hi link notesH3 notesH1
    hi link notesH4 notesH1
    hi link notesH5 notesH1
    hi link notesH6 notesH1

    " List                  : vivid light green
    hi link notesListMarker notesH1
    hi link notesOrderedListMarker notesH1

    " Blockquote            : light violet
    hi notesBlockquote ctermfg=147

    " Url                   : dark pale purple
    hi notesUrl cterm=underline ctermfg=103
    " Link                  : vivid pink, dark purple
    hi notesLink ctermfg=103

    " Code                  : pale light green
    hi link notesCodeBlock notesCode
    hi notesCode ctermfg=151

    " Italic                : pale light yellow
    hi notesItalic ctermfg=230
    " Bold                  : vivid yellow
    hi notesBold ctermfg=221
    " BoldItalic            : pale dark orange
    hi notesBoldItalic ctermfg=209

    " Task Stamp/Tag        : dark grey, pale light brown
    hi notesTaskStamp ctermfg=240
    hi notesTaskTag ctermfg=248
    " Task Perso            : pale dark blue
    hi notesTaskPerso ctermfg=8

    " Delimiter             : dark grey
    hi notesDelimiter ctermfg=238
    " Escape                : dark grey
    hi notesEscape ctermfg=105

elseif &background == "light"
    " Headers                   : vivid blue
    hi notesH1 ctermfg=27
    hi link notesH2 notesH1
    hi link notesH3 notesH1
    hi link notesH4 notesH1
    hi link notesH5 notesH1
    hi link notesH6 notesH1

    " List                      : vivid blue
    hi link notesListMarker notesH1
    hi link notesOrderedListMarker notesH1

    " Blockquote                : vivid purple
    hi notesBlockquote ctermfg=93

    " Urls                      : pale light purple
    hi notesUrl cterm=underline ctermfg=147
    " Link                      : vivid pink, light purple
    hi notesLink ctermfg=105

    " Code                      : pale dark green
    hi notesCode ctermfg=101
    hi link notesCodeBlock notesCode

    " Italic                    : pale light yellow
    hi notesItalic ctermbg=230
    " Bold                      : light yellow
    hi notesBold ctermbg=229
    " Bolditalic                : light blue
    hi notesBoldItalic ctermbg=195

    " Task Stamp/Tag            : light grey, dark gray
    hi notesTaskStamp ctermfg=250
    hi notesTaskTag ctermfg=101
    " Task Perso                : light
    hi notesTaskPerso ctermfg=7

    " Delimiter                 : light grey
    hi notesDelimiter ctermfg=255
    " Escape                    : dark grey
    hi notesEscape ctermfg=213
endif
" }}}
let b:current_syntax = "notes"
