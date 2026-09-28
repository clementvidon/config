# Vim mapping model

`<Leader>` is Space; `<LocalLeader>` is `gh`. A leader is a namespace, not a
scope: `<buffer>` makes a mapping local to the current buffer.

## Personal and contextual actions

Personal bindings use mnemonic families: `m` for lifecycle, `s` for lookup and
search (`sn` for notes), and `gl` for Vim state and utilities. Frequent actions
have direct Space shortcuts: `w` opens the native `<C-W>` window namespace,
`y/p` use the clipboard, and `=` indents the buffer.

General buffer, location-list, and quickfix navigation stays in the native-style
`[` / `]` family. Plugin navigation stays within its plugin namespace.

Noesis owns Markdown note editing under `<LocalLeader>`, with buffer-local
bindings. Bare `gh` is reserved in these buffers. Generic indentation and reflow
are blocked, including the personal Space `=` shortcut, to protect note layout.
Use the explicit note-editing actions instead.

## Autonomous plugins

| Namespace | Integration |
| --- | --- |
| Space `a` | ALE |
| Space `h` | Achiever |
| Space `g` | GitGutter |
| Space `e` | GPG |

Within a namespace, `h` opens help (currently its mapping list), `t` is the main
toggle, and `j/k` mean next/previous when ordered navigation exists. Other letters
belong to the feature's vocabulary: ALE `ai` means info, Noesis `ghi` means
italic, and Achiever `hk` checks a task.

Use Space `ah`, `hh`, `gh`, or `eh` for plugin help, and `ghh` for Noesis help.
To inspect the exact current bindings directly:

```vim
:map <Leader>a
:map <Leader>h
:map <Leader>g
:map <Leader>e
:map <LocalLeader>
```

Contextual mappings appear only where their feature is active. Achiever layers
task behavior on the host filetype; see its [activation contract](../stow/vim/.vim/pack/local/start/achiever/README.md).
Use `:verbose map` with a prefix to find where bindings were defined.

## Public mapping API

Local plugins separate commands, stable `<Plug>(plugin-action)` mappings, and
optional default bindings. Remap the public `<Plug>` API without calling internal
functions. For example, in `~/.vim/after/ftplugin/noesis.vim`:

```vim
nmap <buffer> <LocalLeader>b <Plug>(noesis-bold)
xmap <buffer> <LocalLeader>b <Plug>(noesis-bold)
```

Include custom buffer mappings in `b:undo_ftplugin` so filetype changes remove
them. Plugin READMEs explain how to disable default bindings. Discover commands
with `:command Noesis`, `:command Achiever`, or `:command GPG`, and public mappings
with `:map <Plug>` in an appropriate buffer.
