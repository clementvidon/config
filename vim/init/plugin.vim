" init/plugin
" Created: 230524 19:45:06 by clem9nt@imac
" Updated: 230524 19:45:06 by clem9nt@imac
" Maintainer: Clément Vidon

" packadd cfilter                                 " filter qf content
" packadd matchit                                 " closing tag match
" packadd justify                                 " justify selection

call plug#begin('$DOTVIM/.plugged')
" Plug 'github/copilot.vim'
Plug 'tpope/vim-repeat'                         " repeat extension
Plug 'tpope/vim-surround'                       " surround operator
Plug 'tpope/vim-commentary'                     " comment out
Plug 'ludovicchabant/vim-gutentags'             " tags manager
Plug 'arcticicestudio/nord-vim'                 " colorscheme
Plug 'junegunn/seoul256.vim'                    " colorscheme
Plug 'nvim-treesitter/nvim-treesitter',         " better syntax / indent
            \ {'do': ':TSUpdate'}
Plug 'w0rp/ale'                                 " lsp config
Plug 'prisma/vim-prisma'                        " prisma
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

let g:seoul256_background = 256
try
    color nord | set bg=dark
catch /^Vim\%((\a\+)\)\=:E185/
    echo "Colorscheme not installed."
endtry

" https://github.com/bryley/neoai.nvim
" https://github.com/neovim/nvim-lspconfig
" https://github.com/nvim-lua/completion-nvim

set omnifunc=ale#completion#OmniFunc
let g:ale_cpp_cc_options = '-Wall -Wextra -Werror -std=c++98 -Wconversion -Wsign-conversion -pedantic -Iinclude -Iincludes -Iinc -Iincs'
" let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 0
let g:ale_set_signs = 0
let g:ale_completion_enabled = 1
let g:ale_virtualtext_prefix = ""
" let g:ale_lint_on_text_changed = 'never'
" let b:ale_exclude_highlights = ['line too long', '*is declared*']
let g:ale_lint_on_enter = 0

let g:ale_emit_conflict_warnings = 0
let g:ale_lint_delay = 0
hi ALEVirtualTextError ctermfg=1
let g:ale_linters = {
            \'javascript': ['eslint'],
            \'typescript': ['eslint', 'tsserver', 'prettier'],
            \'cpp': ['clang'],
            \}
let g:ale_fixers = {
            \'javascript': ['eslint'],
            \'json': ['prettier'],
            \'typescript': [],
            \'markdown': ['prettier'],
            \'cpp': ['clang-format'],
            \'bash': ['shfmt'],
            \}

" \'typescript': ['eslint', 'prettier'],
imap <Left> <Plug>(copilot-dismiss)
imap <Right> <Plug>(copilot-suggest)
imap <Down> <Plug>(copilot-next)
imap <Up> <Plug>(copilot-previous)
let g:copilot_filetypes = {
            \ '*': v:false,
            \ 'javascript': v:true,
            \ 'typescript': v:true,
            \ 'markdown': v:true,
            \ 'python': v:true,
            \ 'html': v:true,
            \ 'css': v:true,
            \ 'make': v:true,
            \ 'bash': v:true,
            \ 'zsh': v:true,
            \ 'vim': v:true,
            \ 'cpp': v:true,
            \ 'lua': v:true,
            \ 'c': v:true
            \ }

autocmd BufReadPre *
            \ let f=getfsize(expand("<afile>"))
            \ | if f > 100000 || f == -2
                \ | let b:copilot_enabled = v:false
                \ | endif

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
            \'noesis/**',
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
