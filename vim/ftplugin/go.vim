" @filename  go.vim
" @created   230522 18:04:16  by  clem9nt@imac
" @updated   230522 18:04:16  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal norelativenumber
setlocal laststatus=2
setlocal autoread
setlocal path=.,, " ./**
setlocal foldmethod=marker
setlocal foldmarker={{{,}}}

let maplocalleader="gh"

let g:gutentags_enabled = 1
let b:surround_45='("\r")'

"   mappings


nn <buffer> <LocalLeader> <nop>

"   settings
nn <buffer> <LocalLeader>, :write<CR>:e $DOTVIM/ftplugin/go.vim<CR>

"   execute single-file
nn <buffer> <LocalLeader>e :write<CR>:!clear && go run %<CR>
nn <buffer> <LocalLeader>E :write<CR>:!clear && go run -race -vet -work -mod=readonly %<CR>

"   execute multi-file
nn <buffer> <LocalLeader>E :write<CR>:!clear && go run .<CR>

"   test
nn <buffer> <LocalLeader>t :write<CR>:!clear && go test<CR>
nn <buffer> <LocalLeader>T :write<CR>:!clear && go test -v<CR>

if !exists("*ToggleGoTestFile")
function! ToggleGoTestFile()
  let l:current_file = expand('%:t')
  if l:current_file =~ '_test\.go$'
    let l:srcs_file = substitute(l:current_file, '_test\.go$', '.go', '')
    execute 'edit ' . l:srcs_file
    echo l:srcs_file
  else
    let l:test_file = substitute(l:current_file, '\.go$', '_test.go', '')
    execute 'edit ' . l:test_file
    echo l:test_file
  endif
endfunction
endif

" Map the function to <LocalLeader>s in normal mode for the current buffer
nnoremap <buffer> <LocalLeader>s :call ToggleGoTestFile()<CR>


"   benchmark
nn <buffer> <LocalLeader>b :write<CR>:!clear && go test -bench=.<CR>

"   coverage
nn <buffer> <LocalLeader>c :write<CR>
            \:!go test -covermode=count -coverprofile=/tmp/countcoverprofile.out<CR>
            \:!clear && go tool cover -func=/tmp/countcoverprofile.out<CR>

"   race
nn <buffer> <LocalLeader>r :write<CR>:!clear && go test -race<CR>

"   print template
nn <buffer> <LocalLeader>p ofmt.Printf("\n")<Esc>==0f\i

"   print wrapper
nn <buffer> <LocalLeader>P 0<<V:norm f;Di<Esc>Ifmt.Printf("'%v'\n", <Esc>A)<Esc>==0f%l

"   list file functions
nn <buffer> <LocalLeader>f :g/^func /#<CR>
