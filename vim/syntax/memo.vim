" Vim syntax file
" Language: Memo
" URL: https://github.com/clemedon/memo.vim
" Maintainer:   Clément Vidon  <cvidon@student.42.fr>
" Last Change:  2022 Aug

if exists("b:current_syntax")
    finish
endif
" --------------------------------- SYNTAX >>>
" Headers
syn region memoH1 start="^##\@!" end="#*\s*$"
syn region memoH2 start="^###\@!" end="#*\s*$"
syn region memoH3 start="^####\@!" end="#*\s*$"
syn region memoH4 start="^#####\@!" end="#*\s*$"
syn region memoH5 start="^######\@!" end="#*\s*$"
syn region memoH6 start="^#######\@!" end="#*\s*$"

" List
syn match memoListMarker "^\%(\s\{0,3\}\)[-*+]\%(\s\+\S\)\@="
syn match memoOrderedListMarker "^\%(\s\{0,3}\)\<\d\+\.\%(\s\+\S\)\@="

" Blockquote
syn match memoBlockquote "^>\%(\s\|$\)"

" Url
syn match memoUrl contains=@NoSpell "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[A-Za-z0-9/-]"

" Link
syn match memoLink "\(\s@\|^@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\|\ze#\)"

if has("conceal")
    set conceallevel=2
    set concealcursor=n
    " Code Italic Bold BoldItalic
    syn region memoCode concealends matchgroup=memoDelimiter start="\S\@<=`\|`\S\@=" end="\S\@<=`\|`\S\@=" skip="\\`"
    syn region memoItalic concealends matchgroup=memoDelimiter start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" skip="\\\*"
    syn region memoBold concealends matchgroup=memoDelimiter start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" skip="\\\*"
    syn region memoBoldItalic concealends matchgroup=memoDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
else
    " Code Italic Bold BoldItalic
    syn region memoCode matchgroup=memoDelimiter start="\S\@<=`\|`\S\@=" end="\S\@<=`\|`\S\@=" skip="\\`"
    syn region memoItalic matchgroup=memoDelimiter start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" skip="\\\*"
    syn region memoBold matchgroup=memoDelimiter start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" skip="\\\*"
    syn region memoBoldItalic matchgroup=memoDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
endif

" Code
syn match memoCodeLine "^\s\{4}.*$"
syn match memoCodeMarker "^```.*$"
syn region memoCodeBlock matchgroup=memoCodeMarker start="^```" end="^```" skip="\\``"

" Task Stamp/Tag
syn match memoTaskStamp contains=@NoSpell "\(^\[.\{-}\]\)\(\[.\{-}\(\]\|\]$\)\)\@="
syn match memoTaskTag "\(^\[.\{-}\]\)\@<=\[.\{-}\(\]\|\]$\)"

" Task Perso
syn match memoTaskPerso "\(\]\[\(rout\|>>\)\]\)\@<=.*"

" Escape
syn match memoEscape "\\."

" Keywords
syn keyword memoBoldItalic TODO
syn keyword memoBoldItalic DONE
syn keyword memoBoldItalic XXX

" <<<
" --------------------------------- COLORS >>>
" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

if &background == "dark"
    " Headers               : vivid light green
    hi memoH1 ctermfg=85
    hi link memoH2 memoH1
    hi link memoH3 memoH1
    hi link memoH4 memoH1
    hi link memoH5 memoH1
    hi link memoH6 memoH1

    " List                  : vivid light green
    hi link memoListMarker memoH1
    hi link memoOrderedListMarker memoH1

    " Blockquote            : light violet
    hi memoBlockquote ctermfg=147

    " Url                   : dark pale purple
    hi memoUrl cterm=underline ctermfg=103
    " Link                  : vivid pink, dark purple
    hi memoLink ctermfg=103

    " Code                  : pale light green
    hi memoCode ctermfg=151
    hi link memoCodeLine memoCode
    hi link memoCodeBlock memoCode

    " Code Marker
    hi memoCodeMarker ctermfg=154

    " Italic                : pale light yellow
    hi memoItalic ctermfg=230
    " Bold                  : vivid yellow
    hi memoBold ctermfg=221
    " BoldItalic            : pale dark orange
    hi memoBoldItalic ctermfg=209

    " Task Stamp/Tag        : dark grey, pale light brown
    hi memoTaskStamp ctermfg=240
    hi memoTaskTag ctermfg=248
    " Task Perso            : pale dark blue
    hi memoTaskPerso ctermfg=8

    " Delimiter             : dark grey
    hi memoDelimiter ctermfg=238
    " Escape                : dark grey
    hi memoEscape ctermfg=105

elseif &background == "light"
    " Headers                   : vivid blue
    hi memoH1 ctermfg=27
    hi link memoH2 memoH1
    hi link memoH3 memoH1
    hi link memoH4 memoH1
    hi link memoH5 memoH1
    hi link memoH6 memoH1

    " List                      : vivid blue
    hi link memoListMarker memoH1
    hi link memoOrderedListMarker memoH1

    " Blockquote                : vivid purple
    hi memoBlockquote ctermfg=93

    " Urls                      : pale light purple
    hi memoUrl cterm=underline ctermfg=147
    " Link                      : vivid pink, light purple
    hi memoLink ctermfg=105

    " Code                      : pale dark green
    hi memoCode ctermfg=101
    hi link memoCodeLine memoCode
    hi link memoCodeBlock memoCode

    " Code Marker
    hi memoCodeMarker ctermfg=178

    " Italic                    : pale light yellow
    hi memoItalic ctermbg=230
    " Bold                      : light yellow
    hi memoBold ctermbg=229
    " Bolditalic                : light blue
    hi memoBoldItalic ctermbg=195

    " Task Stamp/Tag            : light grey, dark gray
    hi memoTaskStamp ctermfg=250
    hi memoTaskTag ctermfg=101
    " Task Perso                : light
    hi memoTaskPerso ctermfg=7

    " Delimiter                 : light grey
    hi memoDelimiter ctermfg=255
    " Escape                    : dark grey
    hi memoEscape ctermfg=213
endif
" <<<
let b:current_syntax = "memo"
