- https://vimways.org/2018/from-vimrc-to-vim/

- :help lua-guide

    ~/.config/nvim
    |-- after/
    |-- ftplugin/
    |-- lua/
    |  |-- myluamodule.lua
    |  |-- other_modules/
    |     |-- anothermodule.lua
    |     |-- init.lua
    |-- plugin/
    |-- syntax/
    |-- init.vim

If you'd like to run any other Lua script *on startup automatically*, then you
can simply put it in *plugin/* in your 'runtimepath'.

If you want to *load Lua files on demand*, you can place them in the *lua/*
directory in your 'runtimepath' and load them with require.

    require("other/myluamodule") -- load 'nvim/lua/other/myluamodule.lua'
    require("other.myluamodule") -- same

This is the Lua equivalent of *Vimscript*'s *autoload* mechanism

*ftplugin* is only loaded for the *specific filetype* it corresponds to

    .../ftplugin/stuff.vim
    .../ftplugin/stuff_foo.vim
    .../ftplugin/stuff/bar.vim

*after* is used to overwrite the normal plugin loading

TODO "for something that applies to all filetypes put in plugin but if possible
try to load it in autoload"

Handle the error thrown by a module which doesnt exist or contains an error:

    local ok, mymod = pcall(require, 'module_with_error')
    if not ok then
      print("Module had an error")
    else
      mymod.function()
    end

Unlike :source, calling :require twice won't rerun the file but instead return
the cached file.




+"   COPILOT
+
+imap <Left> <Plug>(copilot-dismiss)
+imap <Down> <Plug>(copilot-next)
+imap <Up> <Plug>(copilot-previous)
+imap <Right> <Plug>(copilot-suggest)

+"   COPILOT
+"
+let g:copilot_filetypes = {
+            \ 'gitcommit': v:true,
+            \ 'markdown': v:true,
+            \ 'yaml': v:true
+            \ }

+Plug 'github/copilot.vim'               "   COPILOT

.vimrc      set vim options / load plugins / set plugins options
ftplugin    filetype specific settings (loaded right after the 'filetype' cmd)
ftdetect    files that detect the filetype of a file
syntax      syntax highlighting files for different filetypes
plugin      plugins loaded after the vimrc (can override previous settings)
autoload    functions loaded on demand (can be called from plugin files)
after       files that are loaded after other files (for overriding)
pack        plugins installed with vim's built-in package manager

compiler
