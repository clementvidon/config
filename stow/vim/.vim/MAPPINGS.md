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

Markdown is the file format. Noesis is the note environment activated for `.md`
files beneath a directory named `noesis` (case-insensitive), or every `.md`
when `g:noesis_all_markdown` is enabled. Other Markdown files remain `markdown`.
Achiever is an
optional task capability that composes with either (`noesis.achiever` or
`markdown.achiever`) and other host filetypes.

Noesis owns note editing under `<LocalLeader>`, with buffer-local bindings.
Bare `gh` is reserved in these buffers. Generic indentation and reflow
are blocked, including the personal Space `=` shortcut, to protect note layout.
Use the explicit note-editing actions instead.

## Plugin namespaces

Keep plugin mappings with their integration; personal actions can share a
namespace when they serve the same purpose. Within a namespace, `h` opens
help where available, `t` is the main toggle, and `j/k` navigate ordered
items. These are conventions, not a stable API. Inspect the current bindings:

```vim
:map <Leader>
:map <LocalLeader>
```

Contextual mappings appear only where their feature is active. Achiever layers
task behavior on the host filetype; see its [activation contract](pack/local/start/achiever/README.md).
Use `:verbose map` with a prefix to find where bindings were defined.

## Public mapping API

Local plugins expose three distinct interfaces:

| Interface | Contract |
| --- | --- |
| `<Plug>(plugin-action)` | Stable mapping API |
| Ex command | Optional user-facing interface |
| Default mapping | Ergonomic default, not an API |

Remap the public `<Plug>` API without calling internal functions. For example,
in `~/.vim/after/ftplugin/noesis.vim`:

```vim
nmap <buffer> <LocalLeader>b <Plug>(noesis-bold)
xmap <buffer> <LocalLeader>b <Plug>(noesis-bold)
```

Include custom buffer mappings in `b:undo_ftplugin` so filetype changes remove
them. Plugin READMEs explain how to disable default bindings. Discover public
mappings with `:map <Plug>` in an appropriate buffer. Use `:command` to discover
available Ex interfaces, such as `:command Achiever` or `:command GPG`.
