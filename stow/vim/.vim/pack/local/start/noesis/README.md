# Noesis

## Purpose and configuration

Noesis provides Vim support for the personal notes directory. It recognizes
every `.noe` file; Markdown files remain Markdown, including below the Noesis
root. Achiever can add its task component through dotted filetypes such as
`noesis.achiever`.

The default root is `~/noesis`. Override it per machine with `NOESIS_ROOT`, or
before plugins load with:

```vim
let g:noesis_root = expand('~/path/to/noesis')
```

HTML export reads optional `g:noesis_export_author`,
`g:noesis_export_copyright`, and `g:noesis_export_footer` values. The footer is
treated as trusted HTML. Export is refused for sensitive buffers before Vim's
HTML renderer can create a derived plaintext buffer.

## Language commands and privacy

`:Fr`, `:En`, and `:Au` use optional `trans`; `:Sy` uses optional `synonym`.
Translation and audio send note content to the configured translate-shell
backend, which may be a network service. Do not send confidential note content
unless that backend is trusted. Selected text is passed as data; Ex and shell
metacharacters in it are not interpreted.

## Search

Buffer-local `:Grep` searches `.noe` files recursively with ripgrep and excludes
`.gpg.noe` files. Those encrypted files contain ciphertext on disk, so searching
them would not expose useful note content. This command requires optional `rg`
and configures its own quickfix parsing independently of global `grepprg`.
