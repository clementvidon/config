" Vim mistakes empty or comment-only Terraform files for TinyFugue.
autocmd BufRead,BufNewFile *.tf setlocal filetype=terraform
