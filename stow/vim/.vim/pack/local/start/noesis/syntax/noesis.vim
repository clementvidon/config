" Syntax and terminal highlights for Noesis notes.

"   syntax definitions
syntax sync fromstart

syntax region noesisH1 start="^##\@!"        end="#*\s*$"
syntax region noesisH2 start="^###\@!"       end="#*\s*$"
syntax region noesisH3 start="^####\@!"      end="#*\s*$"
syntax region noesisH4 start="^#####\@!"     end="#*\s*$"
syntax region noesisH5 start="^######\@!"    end="#*\s*$"
syntax region noesisH6 start="^#######\@!"   end="#*\s*$"

syntax match noesisHeader "^.*\n^-\{3,}$"
syntax match noesisHeader "^.*\n^=\{3,}$"
syntax match noesisHeader "^\s\{72}\[\d\{6}]$"

syntax match noesisUrl contains=@NoSpell "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[A-Za-z0-9/-]"
" Bound look-behind to its actual prefix, without limiting multiline sync.
syntax match noesisLink "\(\s@\|^@\|(@\)\@2<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\)"
syntax match noesisTag  "\(\s#\|^#\|(#\)\@2<=[a-zA-Z0-9/_]\{-}\ze\(\s\|:\|;\|,\|$\|)\)"

syntax match noesisBlockquote "^\s\{0,5}>\{1,2}\s"
syntax match noesisBlockquote "^\s\{0,5}>$"

if has("conceal")
  syntax region noesisCode       concealends matchgroup=noesisDelim start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`" contains=@NoSpell
  syntax region noesisItalic     concealends matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
  syntax region noesisBold       concealends matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
  syntax region noesisBoldItalic concealends matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
else
  syntax region noesisCode                   matchgroup=noesisDelim start="\S\@<=`\|`\S\@="           end="\S\@<=`\|`\S\@="           skip="\\`" contains=@NoSpell
  syntax region noesisItalic                 matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
  syntax region noesisBold                   matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
  syntax region noesisBoldItalic             matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
endif

syntax region noesisCode start="```" end="```" contains=@NoSpell

syntax keyword Todo TODO FIXME X XXX WIP

"   highlights
" FG: for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" BG: for i in {0..255}; do printf '\e[48;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
" dark:  0:black  1:red  2:green  3:yellow  4:blue  5:magenta  6:cyan  7:white
" light: 8:black  9:red 10:green 11:yellow 12:blue 13:magenta 14:cyan 15:white

function! s:Colors() abort
  if &background ==# 'dark'

    highlight noesisH1                       ctermfg=85
    highlight noesisH2                       ctermfg=85
    highlight noesisH3                       ctermfg=85
    highlight noesisH4                       ctermfg=85
    highlight noesisH5                       ctermfg=85
    highlight noesisH6                       ctermfg=85

    highlight noesisHeader                   ctermfg=231

    highlight noesisUrl                      ctermfg=103
    highlight noesisLink                     ctermfg=105
    highlight noesisTag                      ctermfg=210

    highlight noesisBlockquote               ctermfg=103

    highlight noesisCode                     ctermfg=146 cterm=italic
    highlight noesisItalic                   ctermfg=145 cterm=italic
    highlight noesisBold                     ctermfg=219 cterm=bold
    highlight noesisBoldItalic               ctermfg=205

  elseif &background ==# 'light'

    highlight noesisH1                       ctermfg=20
    highlight noesisH2                       ctermfg=20
    highlight noesisH3                       ctermfg=20
    highlight noesisH4                       ctermfg=20
    highlight noesisH5                       ctermfg=20
    highlight noesisH6                       ctermfg=20

    highlight noesisHeader                   ctermfg=232

    highlight noesisUrl                      ctermfg=138 cterm=underline
    highlight noesisLink                     ctermfg=33
    highlight noesisTag                      ctermfg=125
    highlight noesisBlockquote               ctermfg=171

    highlight noesisCode                     ctermfg=65  cterm=italic
    highlight noesisItalic                   ctermfg=88  cterm=italic
    highlight noesisBold                     ctermfg=160 cterm=bold
    highlight noesisBoldItalic               ctermfg=196

  endif
endfunction
call s:Colors()

"   colorscheme integration

augroup noesis_colors
  autocmd!
  autocmd ColorScheme * call <SID>Colors()
augroup END

let b:current_syntax = 'noesis'
