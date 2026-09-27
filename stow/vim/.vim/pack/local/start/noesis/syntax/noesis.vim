" Syntax and terminal highlights for Noesis notes.

" # SYNTAX DEFINITIONS

syntax sync minlines=200

" Check surrounding blank lines without consuming a shared separator.
" Use \_^ and \_$ because these anchors follow or precede other atoms.
let s:before_heading = '\%(\%^\|^[ \t]*\n\)\@<='
let s:after_heading = '\%(\n[ \t]*$\|\%$\)\@='
for s:level in range(1, 6)
  execute 'syntax match noesisH' . s:level . ' /' . s:before_heading
        \ . '\_^' . repeat('#', s:level) . '\s\+\S.*\_$' . s:after_heading . '/'
endfor
execute 'syntax match noesisH2 /' . s:before_heading
      \ . '\_^[^# \t].*\n-\{80}\s*\_$' . s:after_heading . '/'
unlet s:before_heading s:after_heading s:level

syntax match noesisHeader "^\s\{72}\[\d\{6}]$"

syntax match noesisUrl contains=@NoSpell "\v<(((https?|ftp|gopher|telnet|ssh)://|(mailto|file|news|about|ed2k|irc|sip|magnet):)[^' \t<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' \t<>"]+)[A-Za-z0-9/-]"
" Bound look-behind to its actual prefix, without limiting multiline sync.
syntax match noesisLink "\(\s@\|^@\|(@\)\@2<=[a-zA-Z0-9/_.\-~]\{-}\(\ze\s\|$\)"
syntax match noesisLink "\[\%([^][\\]\|\\.\|\n\)\+\](\%([^()\\]\|\\.\|([^()]*)\)*)"
syntax match noesisTag  "\(\s#\|^#\|(#\)\@2<=[a-zA-Z0-9/_]\{-}\ze\(\s\|:\|;\|,\|$\|)\)"

syntax match noesisBlockquote "^[ \t]\{0,3}\%(>[ \t]\?\)\+"

if has("conceal")
  syntax region noesisCode concealends matchgroup=noesisDelim start="`\@1<!\z(`\+\)" end="`\@1<!\z1`\@!\|^[ \t]*$" contains=@NoSpell
  syntax region noesisItalic     concealends matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
  syntax region noesisBold       concealends matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
  syntax region noesisBoldItalic concealends matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
else
  syntax region noesisCode matchgroup=noesisDelim start="`\@1<!\z(`\+\)" end="`\@1<!\z1`\@!\|^[ \t]*$" contains=@NoSpell
  syntax region noesisItalic                 matchgroup=noesisDelim start="\S\@<=\*\|\*\S\@="         end="\S\@<=\*\|\*\S\@="         skip="\\\*"
  syntax region noesisBold                   matchgroup=noesisDelim start="\S\@<=\*\*\|\*\*\S\@="     end="\S\@<=\*\*\|\*\*\S\@="     skip="\\\*"
  syntax region noesisBoldItalic             matchgroup=noesisDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" skip="\\\*"
endif

syntax region noesisCode start="^[ \t]\{0,3}\z(`\{3,}\)[^`]*$" end="^[ \t]\{0,3}\z1`*[ \t]*$" contains=@NoSpell keepend
syntax region noesisCode start="^[ \t]\{0,3}\z([~]\{3,}\).*$" end="^[ \t]\{0,3}\z1[~]*[ \t]*$" contains=@NoSpell keepend

syntax keyword Todo TODO FIXME X XXX WIP

" # HIGHLIGHTS

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

" # COLORSCHEME INTEGRATION

augroup noesis_colors
  autocmd!
  autocmd ColorScheme * call <SID>Colors()
augroup END

let b:current_syntax = 'noesis'
