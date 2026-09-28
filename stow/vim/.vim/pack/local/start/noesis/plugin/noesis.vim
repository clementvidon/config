" Noesis defaults and language commands.

" # BOOTSTRAP AND ROOT

if exists('g:loaded_noesis')
  finish
endif
let g:loaded_noesis = 1

if !exists('g:noesis_root')
  let g:noesis_root = empty($NOESIS_ROOT)
        \ ? expand('~/noesis')
        \ : expand($NOESIS_ROOT)
endif

" # COMMANDS

" These commands deliberately do not accept | as a command separator: note
" text must remain data even when it contains Ex metacharacters.
command! -nargs=+ Fr call noesis#translate('tof', <q-args>)
command! -nargs=+ En call noesis#translate('toe', <q-args>)
command! -nargs=+ Sy call noesis#synonym(<q-args>)
