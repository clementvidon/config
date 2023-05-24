" syntax/memo
" Created: 230524 19:53:30 by clem9nt@imac
" Updated: 230524 19:53:30 by clem9nt@imac
" Maintainer: Clément Vidon

if exists("b:current_syntax")
    finish
endif


"   syntax


syn region memoH1 start="^##\@!"        end="#*\s*$"
syn region memoH2 start="^###\@!"       end="#*\s*$"
syn region memoH3 start="^####\@!"      end="#*\s*$"
syn region memoH4 start="^#####\@!"     end="#*\s*$"
syn region memoH5 start="^######\@!"    end="#*\s*$"
syn region memoH6 start="^#######\@!"   end="#*\s*$"

syn match memoListMarker "^\%(\s\{0,3\}\)[-*+]\%(\s\+\S\)\@="
syn match memoOrderedListMarker "^\%(\s\{0,3}\)\<\d\+\.\%(\s\+\S\)\@="

syn match memoBlockquote "^>\%(\s\|$\)"
syn match memoUrl contains=@NoSpell "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[A-Za-z0-9/-]"
syn match memoLink "\(\s@\|^@\|(@\)\@<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\|\ze#\|\ze,\)"

if has("conceal")
    set conceallevel=2
    set concealcursor=n
    syn region memoCode       concealends matchgroup=memoDelimiter start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`"
    syn region memoItalic     concealends matchgroup=memoDelimiter start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region memoBold       concealends matchgroup=memoDelimiter start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region memoBoldItalic concealends matchgroup=memoDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
else
    syn region memoCode                   matchgroup=memoDelimiter start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`"
    syn region memoItalic                 matchgroup=memoDelimiter start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
    syn region memoBold                   matchgroup=memoDelimiter start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
    syn region memoBoldItalic             matchgroup=memoDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
endif
syn match memoCodeLine contains=@NoSpell "^\s\{4}.*$"
syn match memoCodeMarker "^```.*$"
syn region memoCodeBlock matchgroup=memoCodeMarker start="^```" end="^```" skip="\\``"

syn match memoTaskCheck /^\[\]\ze ./
syn match memoTaskCheck /^\[[0-9: ]*\]\ze ./
syn match memoTaskChecked /^\[\d\{6} \d\{2}:\d\{2}\]\ze ./
syn match memoTaskChecked /^\[\d\{6} \d\{2}:\d\{2} \d\{2}:\d\{2}\]\ze ./

syn keyword memoBoldItalic TODO
syn keyword memoBoldItalic XXX
syn keyword memoBoldItalic X


"   highlight


" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

if &background == "dark"

    hi memoH1                       ctermfg=85
    hi memoH2                       ctermfg=85
    hi memoH3                       ctermfg=85
    hi memoH4                       ctermfg=85
    hi memoH5                       ctermfg=85
    hi memoH6                       ctermfg=85

    hi memoListMarker               ctermfg=85
    hi memoOrderedListMarker        ctermfg=85

    hi memoBlockquote               ctermfg=147
    hi memoUrl cterm=underline      ctermfg=103
    hi memoLink                     ctermfg=104

    hi memoCode                     ctermfg=151
    hi memoCodeLine                 ctermfg=151
    hi memoCodeBlock                ctermfg=151

    hi memoCodeMarker               ctermfg=154
    hi memoItalic                   ctermfg=230
    hi memoBold                     ctermfg=228
    hi memoBoldItalic               ctermfg=220

    hi memoTaskCheck                ctermfg=140
    hi memoTaskChecked              ctermfg=102

    hi memoDelimiter                ctermfg=238

elseif &background == "light"

    hi memoH1                       ctermfg=27
    hi memoH2                       ctermfg=27
    hi memoH3                       ctermfg=27
    hi memoH4                       ctermfg=27
    hi memoH5                       ctermfg=27
    hi memoH6                       ctermfg=27

    hi memoListMarker               ctermfg=27
    hi memoOrderedListMarker        ctermfg=27

    hi memoBlockquote               ctermfg=93
    hi memoUrl cterm=underline      ctermfg=147
    hi memoLink                     ctermfg=105

    hi memoCode                     ctermfg=101
    hi memoCodeLine                 ctermfg=101
    hi memoCodeBlock                ctermfg=101
    hi memoCodeMarker               ctermfg=178

    hi memoItalic                   ctermbg=230
    hi memoBold                     ctermbg=229
    hi memoBoldItalic               ctermbg=195

    hi memoTaskCheck                ctermfg=250
    hi memoTaskChecked              ctermfg=101

    hi memoDelimiter                ctermfg=255

endif

let b:current_syntax = "syntaxmemo"
