set nocp
let &runtimepath.=',$DOTVIM'

"           VIMRC

source $DOTVIM/plugins.vim
source $DOTVIM/options.vim
source $DOTVIM/functions.vim
source $DOTVIM/mappings.vim

"           FTPLUGIN

source $DOTVIM/after/ftplugin/css.vim
source $DOTVIM/after/ftplugin/html.vim
source $DOTVIM/after/ftplugin/javascript.vim
source $DOTVIM/after/ftplugin/json.vim
" source $DOTVIM/after/ftplugin/php.vim
" source $DOTVIM/after/ftplugin/tidal.vim
" source $DOTVIM/after/ftplugin/yml.vim
source $DOTVIM/after/ftplugin/c.vim
source $DOTVIM/after/ftplugin/markdown.vim
source $DOTVIM/after/ftplugin/notes.vim
source $DOTVIM/after/ftplugin/python.vim
source $DOTVIM/after/ftplugin/qf.vim
source $DOTVIM/after/ftplugin/vim.vim

"           PLUGINS

source $DOTVIM/autoload/plugin/redact_pass.vim
" source /home/clem/.config/vim/autoload/plugin/stdheader.vim

"           STARTUP

augroup startup
    autocmd!
    au VimEnter * if @% == '' | setl path+=$DOTVIM/** | endif
    au VimEnter * if @% == '' | nn <buffer><silent> <CR> :e $NOTES/**/todo.md<CR>GMz. | endif
augroup END
