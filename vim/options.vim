" --------------------------------- UI >>>
filetype plugin indent on           "   filetype, plugin, indent auto-detect
set fillchars+=vert:\  "            "   custom vert window separator
augroup custom_hi
    autocmd!
    au ColorScheme * hi LineNr ctermbg=NONE
    au ColorScheme * sy enable maxlines=200 "   'syn on' overrule custom settings
    au ColorScheme * hi CursorLine gui=underline cterm=underline ctermbg=NONE
    au ColorScheme * hi Comment term=bold ctermfg=103 " 103 104
augroup END

if system("uname -s") == "Darwin\n"
    color nord | set bg=dark
    " color seoul256 | set bg=light
elseif system("uname -s") == "Linux\n"
    " color seoul256 | set bg=light
    color nord | set bg=dark
endif

" <<<
" --------------------------------- ERGONOMIC >>>
set ignorecase smartcase            "   ignore case except if uppercase used
set listchars=tab:>\ ,trail:-       "   strings to use for :list command
set nowrap                          "   disable screen line wrapping
set ofu=syntaxcomplete#Complete     "   func to be used in C-X C-O completion
set ruler                           "   cursor pos%[y:x] in statusline
set showcmd                         "   cursor pos%[y:x] in statusline
set showmatch                       "   set showmatch
set shortmess-=S                    "   displays [x/y] for search pattern occurences
set wildmenu                        "   displays possible completion matches
set spelllang=en,fr                 "   spell lang suggestions
set sessionoptions-=curdir          "   mksession cd to the session file dir
set sessionoptions+=sesdir          "   mksession cd to the session file dir
set laststatus=0                    "   hide the bottom bare with the current path/filename
if empty(glob($DOTVIM . "/spell"))
    exec 'silent !mkdir $DOTVIM/spell'
endif
set spellfile=$DOTVIM/spell/custom.utf-8.add
" <<<
" --------------------------------- INDENTATION >>>
set autoindent                      "   auto indent
set expandtab                       "   insert spaces instead tab
set formatoptions+=j                "   see ':h fo-table'
set shiftround                      "   indent to the nearest tab mark
set shiftwidth=4 tabstop=4          "   shift and tab width in spaces
" <<<
" --------------------------------- PATH >>>
set pa=.,$DOTVIM                    "   :find path
set wig=.git                        "   wildmenu results to hide
" <<<
" --------------------------------- PERFORMANCES >>>
set lazyredraw                      "   increase macro fluidity
set maxmempattern=100000            "   pattern matching memory in kB (max 2kk)
set ttimeoutlen=0                   "   mapping and keycode delays (fix esc)
set updatetime=100                  "   gitgutter update faster
" <<<
" --------------------------------- SECURITY >>>
set belloff=all                     "   no more ring the bell
set history=9999                    "   extends cmdline history
set nomodeline secure               "   disables shell access / modelines
if empty(glob($DOTVIM . "/.backup"))
    exec 'silent !mkdir $DOTVIM/.backup'
endif
set backupdir=$DOTVIM/.backup//,/tmp//   "   backup files directory
if empty(glob($DOTVIM . "/.swp"))
    exec 'silent !mkdir $DOTVIM/.swp'
endif
set directory=$DOTVIM/.swp//,/tmp//      "   undo files directory
if empty(glob($DOTVIM . "/.undo"))
    exec 'silent !mkdir $DOTVIM/.undo'
endif
set undodir=$DOTVIM/.undo//,/tmp//       "   undo files directory
set undofile                        "   enable undofiles
set viminfo+='100,<50,s10,h,n$DOTVIM/.viminfo " viminfo location
" <<<
" --------------------------------- EXTERNAL PRG >>>
"   GREP
if executable('ag')
    " grep [<flags>] <pattern> [<files>]
    set grepformat^=%f:%l:%c:%m
    set grepprg=ag\ --vimgrep\ $*   " faster grep
endif

let &makeprg = 'if [ -f Makefile ]; then make $* 1>/dev/null; elif [ -f "../Makefile" ]; then make -C .. $* 1>/dev/null;
            \ elif [ -f ../../Makefile ]; then make -C ../.. $* 1>/dev/null;
            \ elif [ -f ../../../Makefile ]; then make -C ../../.. $* 1>/dev/null;
            \fi'
" <<<
" --------------------------------- MISC >>>
" fix remote shell arrows keys
"set t_ku=OA
"set t_kd=OB
"set t_kr=OC
"set t_kl=OD
" <<<
