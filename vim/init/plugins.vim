" @filename  plugins.vim
" @created   230522 22:05:00  by  clem9nt@imac
" @updated   230522 22:05:00  by  clem9nt@imac
" @author    Clément Vidon


"   plugins manager


" packadd cfilter                                     " filter qf content
" packadd matchit                                     " closing tag match


call plug#begin('$DOTVIM/.plugged')

"   general
Plug 'tpope/vim-repeat'                             " repeat extension
Plug 'tpope/vim-surround'                           " surround operator
Plug 'tpope/vim-commentary'                         " comment out
Plug 'ludovicchabant/vim-gutentags'                 " tags manager
Plug 'arcticicestudio/nord-vim'                     " colorscheme
Plug 'junegunn/seoul256.vim'                        " colorscheme

"   svelte
" Plug 'othree/html5.vim'
" Plug 'pangloss/vim-javascript'
" Plug 'evanleck/vim-svelte', {'branch': 'main'}

"   html css
" Plug 'ap/vim-css-color'                             " color preview
" Plug 'andrewradev/tagalong.vim'                     " au-ren closing tag
" Plug 'gregsexton/matchtag'                          " hi matching html tag
" Plug 'mattn/emmet-vim'                              " html css emmet

"   javascript
" Plug 'pangloss/vim-javascript'                      " better syntax

"   php
" Plug 'sumpygump/php-documentor-vim'                 " php doc generator
" Plug 'arnaud-lb/vim-php-namespace'                  " insert the use statement
" Plug 'alvan/vim-php-manual'                         " php man entry

"   toys
" Plug 'junegunn/limelight.vim'                       " function focus
" Plug 'junegunn/goyo.vim'                            " function focus

"   creative coding
" Plug 'tidalcycles/vim-tidal'                        " live coding
" Plug 'sophacles/vim-processing'                     " processing vim

call plug#end()


"   plugins options


"   colors
let g:dracula_italic = 0
let g:seoul256_background = 256

"   emmet
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key = ','
let g:user_emmet_mode = 'i'
if exists('EmmetInstall')
    autocmd! FileType html,css,javascript,php EmmetInstall
endif

"   goyo
let g:goyo_width = 90
let g:goyo_height = '100%'

"   gutentags
let g:gutentags_enabled = 0
let g:gutentags_ctags_exclude = [
            \'*.svelte',
            \'*.h',
            \'doc/**',
            \'test/**',
            \'Makefile'
            \'*.md'
            \]
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.project_root', 'Makefile', '.git']
if $LOGNAME == "cvidon"
    let g:gutentags_ctags_executable = '/usr/bin/ctags'
endif

"   limelight
let g:limelight_conceal_ctermfg = 'DarkGray'
let g:limelight_default_coefficient = 0.5

"   netrw
let g:netrw_banner = 0
let g:netrw_dirhistmax = 0

"   rainbow
let g:rainbow_active = 0
