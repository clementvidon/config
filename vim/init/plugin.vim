" init/plugin
" Created: 230524 19:45:06 by clem9nt@imac
" Updated: 230524 19:45:06 by clem9nt@imac
" Maintainer: Clément Vidon

" packadd cfilter                                 " filter qf content
" packadd matchit                                 " closing tag match
" packadd justify                                 " justify selection

call plug#begin('$DOTVIM/.plugged')
Plug 'github/copilot.vim'
Plug 'tpope/vim-repeat'                         " repeat extension
Plug 'tpope/vim-surround'                       " surround operator
Plug 'tpope/vim-commentary'                     " comment out
Plug 'ludovicchabant/vim-gutentags'             " tags manager
Plug 'arcticicestudio/nord-vim'                 " colorscheme
Plug 'junegunn/seoul256.vim'                    " colorscheme
" Plug 'evanleck/vim-svelte', {'branch': 'main'}  " svelte filetype
" Plug 'othree/html5.vim'                         " html indent (vim-svelte dep)
" Plug 'andrewradev/tagalong.vim'                 " html auto-rename second tag
" Plug 'gregsexton/matchtag'                      " html highlight second tag
" Plug 'mattn/emmet-vim'                          " html css shortcuts
" Plug 'pangloss/vim-javascript'                  " js advanced filetype
" Plug 'junegunn/limelight.vim'                   " function focus
" Plug 'junegunn/goyo.vim'                        " window focus
" Plug 'tidalcycles/vim-tidal'                    " tidal filetype
" Plug 'sophacles/vim-processing'                 " processing filetype
call plug#end()

color nord | set bg=dark

imap <Left> <Plug>(copilot-dismiss)
imap <Down> <Plug>(copilot-next)
imap <Up> <Plug>(copilot-previous)
imap <Right> <Plug>(copilot-suggest)
let g:copilot_filetypes = {
            \ 'gitcommit': v:true,
            \ 'markdown': v:true,
            \ 'yaml': v:true
            \ }

" let g:seoul256_background = 256

" let g:user_emmet_install_global = 0
" let g:user_emmet_leader_key = ','
" let g:user_emmet_mode = 'i'
" if exists('EmmetInstall')
"     autocmd! FileType html,css,javascript,php EmmetInstall
" endif

" let g:goyo_width = 90
" let g:goyo_height = '100%'

let g:gutentags_enabled = 0
let g:gutentags_ctags_exclude = [
            \'*.svelte',
            \'*.h',
            \'*.md',
            \'*.noe',
            \'*.gpg.*',
            \'doc/**',
            \'test/**',
            \'Noesis/**',
            \'Makefile'
            \]
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.project_root', 'Makefile', '.git']
if $LOGNAME == "cvidon"
    let g:gutentags_ctags_executable = '/usr/bin/ctags'
endif

" let g:limelight_conceal_ctermfg = 'DarkGray'
" let g:limelight_default_coefficient = 0.5

let g:netrw_banner = 0
let g:netrw_dirhistmax = 0
