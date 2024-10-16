" init/plugin
" Created: 230524 19:45:06 by clem9nt@imac
" Updated: 230524 19:45:06 by clem9nt@imac
" Maintainer: Clément Vidon


"   plug settings


nn gj <nop>

let g:achiever_filenames = [ 'todo.noe', 'done.gpg.noe', 'achiever.md', 'achiever.noe', 'achiever' ]
let g:achiever_leader = 'gh'

let g:ale_enabled = 0
" let b:ale_exclude_highlights = ['line too long', 'foo.*bar']
let g:ale_virtualtext_cursor = 'all'
let ale_lsp_show_message_severity = 'information'

" let g:ale_completion_delay = 0
" let g:ale_completion_enabled = 0
" let g:ale_completion_max_suggestions = 10
" let g:ale_completion_excluded_words = ['it', 'describe']
" set omnifunc=ale#completion#OmniFun

" let g:ale_echo_msg_error_str = 'Error'
" let g:ale_echo_msg_format = '%linter%: %code: %%s'

" let g:ale_keep_list_window_open = 0
" let g:ale_list_window_size = 10
" let g:ale_loclist_msg_format = '%linter%: %code: %%s'
" let g:ale_set_loclist = 1
" let g:ale_set_quickfix = 1
"
" let g:ale_lsp_show_message_format = '%severity%:%linter%: %s'
"
let g:ale_maximum_file_size = 10000

nn gja? :nn gja<CR>
nn gjaa :ALEToggle<CR>
nn gjac :ALECodeAction<CR>
nn gjad :ALEDetail<CR>
nn gjah :ALEHover<CR>
nn gjai :ALEInfo<CR>
nn gjan :ALENext<CR>
nn gjap :ALEPrevious<CR>
nn gjaN :ALELast<CR>
nn gjaP :ALEFirst<CR>
nn gjaR :ALEDisable<CR>:ALEEnable<CR>

"     " highlight ALEError                      ctermfg=1
"     " highlight ALEStyleError                 ctermfg=
"     " highlight ALEWarning                    ctermfg=
"     " highlight ALEWarningSign                ctermfg=
"     " highlight ALEErrorSign                  ctermfg=#BF616A
"     " highlight ALEInfo                       ctermfg=
"
"     " highlight ALEVirtualTextError           ctermfg=219
"     " highlight ALEVirtualTextStyleError      ctermfg=183
"     " highlight ALEVirtualTextWarning         ctermfg=218
"     " highlight ALEVirtualTextStyleWarning    ctermfg=182
"     " highlight ALEVirtualTextInfo            ctermfg=103

let g:ale_linters = {
            \'javascript': ['eslint'],
            \'typescript': ['tsserver', 'prettier'],
            \'typescriptreact': ['tsserver', 'prettier'],
            \'cpp': ['clang', 'clangd'],
            \'go': ['gopls'],
            \}

" \'python': ['pylint'],
"     "     \'go': ['golangci-lint', 'gofmt'],
"
"     " let g:ale_fix_on_save_ignore = 1
"     let g:ale_fixers = {
"                 \'javascript': ['eslint'],
"                 \'json': ['prettier'],
"                 \'typescript': ['eslint', 'prettier', 'tslint'],
"                 \'typescriptreact': ['eslint', 'prettier', 'tslint'],
"                 \'markdown': ['prettier'],
"                 \'cpp': ['clang-format'],
"                 \'bash': ['shfmt'],
"                 \}
"                 " \'go': ['gofmt'],
"
"     let g:ale_cpp_cc_options = '-Wall -Wextra -Werror -std=c++98 -Wconversion -Wsign-conversion -pedantic -Iinclude -Iincludes -Iinc -Iincs -I.'

if has('copilot')
    imap <Left>     <Plug>(copilot-dismiss)
    imap <Right>    <Plug>(copilot-suggest)
    imap <Down>     <Plug>(copilot-next)
    imap <Up>       <Plug>(copilot-previous)
endif

let g:copilot_filetypes = {
            \ '*': v:false,
            \ 'bash': v:true,
            \ 'go': v:true,
            \ 'c': v:true,
            \ 'cpp': v:true,
            \ 'css': v:true,
            \ 'dockerfile': v:true,
            \ 'html': v:true,
            \ 'json': v:true,
            \ 'javascript': v:true,
            \ 'javascriptreact': v:true,
            \ 'lua': v:true,
            \ 'make': v:true,
            \ 'markdown': v:true,
            \ 'python': v:true,
            \ 'typescript': v:true,
            \ 'typescriptreact': v:true,
            \ 'vim': v:true,
            \ 'yaml': v:true,
            \ 'zsh': v:true,
            \ }

let s:copilot_enabled = 0
function! CopilotToggle()
    if s:copilot_enabled
        Copilot disable
        let s:copilot_enabled = 0
        echo "Copilot disabled"
    else
        Copilot enable
        let s:copilot_enabled = 1
        echo "Copilot enabled"
    endif
endfunction
nnoremap gjct :call CopilotToggle()<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" let g:user_emmet_install_global = 0
" let g:user_emmet_leader_key = ','
" let g:user_emmet_mode = 'i'
" let g:user_emmet_settings = {
"             \  'javascript.jsx' : {
"                 \      'extends' : 'jsx',
"                 \  },
"                 \}
" if exists('EmmetInstall')
"     autocmd! FileType html,css,javascript,php,typescript,typescriptreact EmmetInstall
" endif

let g:gitgutter_enabled = 0
nn gjgg :GitGutterToggle<CR>
nn gjgr :GitGutterDisable<CR>:GitGutterEnable<CR>
nn gjgG :GitGutterBufferToggle<CR>
nn gjgn :GitGutterNextHunk<CR>
nn gjgp :GitGutterPrevHunk<CR>
nn gjgq :GitGutterQuickFix<CR>
nn gjgd :GitGutterDiffOrig<CR>
nn gjgu :GitGutterUndoHunk<CR>

let g:go_debug_windows = {
            \'vars':       'rightbelow 60vnew',
            \'stack':      'rightbelow 10new',
            \}

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
            \'git/noesis/**',
            \'Makefile'
            \]
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.tags_root', 'Makefile', '.git']
if $LOGNAME == "cvidon"
    let g:gutentags_ctags_executable = '/usr/bin/ctags'
endif

" let g:limelight_conceal_ctermfg = 'DarkGray'
" let g:limelight_default_coefficient = 0.5

let g:netrw_banner = 0
let g:netrw_dirhistmax = 0

let g:seoul256_background = 256

"   plug manager


" packadd termdebug
" packadd cfilter                                 " filter qf content
" packadd matchit                                 " closing tag match
" packadd justify                                 " justify selection

call plug#begin('$DOTVIM/.plugged')
" Plug 'clemedon/vim-reselect-two'

Plug 'AndrewRadev/linediff.vim'                 " view applied tailwind value on element
Plug 'github/copilot.vim'
Plug 'tpope/vim-repeat'                         " repeat extension
Plug 'tpope/vim-surround'                       " surround operator
Plug 'tpope/vim-commentary'                     " comment out
Plug 'ludovicchabant/vim-gutentags'             " tags manager
Plug 'arcticicestudio/nord-vim'                 " colorscheme
Plug 'junegunn/seoul256.vim'                    " colorscheme
" Plug 'nvim-treesitter/nvim-treesitter',
"             \ {'do': ':TSUpdate'}
" Plug 'neovim/nvim-lspconfig'
"
Plug 'w0rp/ale'                                   " lsp config TODO
" Plug 'prisma/vim-prisma'                        " prisma
" Plug 'peitalin/vim-jsx-typescript'              " typescriptreact indent

" https://github.com/bryley/neoai.nvim
" https://github.com/neovim/nvim-lspconfig
" https://github.com/nvim-lua/completion-nvim
" https://github.com/jackmort/chat-gpt.nvim

" Plug 'leafOfTree/vim-svelte-plugin'
Plug 'fatih/vim-go'

Plug 'davidhalter/jedi-vim'
Plug 'vim-scripts/indentpython.vim'
" Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'

" Plug 'andrewradev/tagalong.vim'                 " html auto-rename second tag
" Plug 'gregsexton/matchtag'                      " html highlight second tag
" Plug 'mattn/emmet-vim'                          " html css shortcuts
" Plug 'pangloss/vim-javascript'                  " js advanced filetype
" Plug 'junegunn/limelight.vim'                   " function focus
" Plug 'junegunn/goyo.vim'                        " window focus
" Plug 'tidalcycles/vim-tidal'                    " tidal filetype
" Plug 'sophacles/vim-processing'                 " processing filetype
" Plug 'MaximilianLloyd/tw-values.nvim'           " view applied tailwind value on element
call plug#end()
