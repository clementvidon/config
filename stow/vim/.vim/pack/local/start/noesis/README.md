# Noesis

A personal Markdown note environment: editing, navigation, search, HTML export,
and translation. Markdown is the file format; Noesis supplies the workspace
behavior. By default, `.md` files beneath a directory named `noesis` activate
its filetype; the directory name is case-insensitive. Other Markdown files
remain ordinary `markdown`.

## Configuration

To activate Noesis for every `.md` file, set this before opening documents:

```vim
let g:noesis_all_markdown = 1
```

The option defaults to `0` in the plugin; this repository enables it.
Search and note-link navigation use the nearest enclosing directory named
`noesis`, case-insensitively. Outside such a directory, workspace search is
unavailable, even when Noesis editing is enabled.

Personal vocabulary shortcuts use `g:noesis_root`, independently of the current
buffer. It defaults to `~/noesis`; set `NOESIS_ROOT` in the shell or configure it
before plugins load:

```vim
let g:noesis_root = expand('~/notes')
```

## Usage

Follow the [file conventions](CONVENTIONS.md) for headings, spacing, and index
layout. Use `ghh` to discover note-editing bindings. Vim's native `gw` operator
reflows text while preserving list indentation. Formatting actions add markup
rather than toggling it; inline formatting applies within one paragraph and
does not support rectangular selections.

In Noesis, Insert-mode Enter keeps the current indentation. Normal-mode `O`
starts a new line above at the left margin.

Refresh the index after adding, removing, renaming, or reordering headings. If
no indexed headings remain, refreshing removes the existing index.

`:Grep pattern` searches unencrypted `.md` files under the current note's
enclosing `noesis` directory
using ripgrep (`rg`). Achiever can add task editing through the
`noesis.achiever` filetype; use `:AchieverEnable` to activate it explicitly.

`<LocalLeader>x` exports the current note to HTML. Optional
`g:noesis_export_author`, `g:noesis_export_copyright`, and
`g:noesis_export_footer` customize the output; the footer accepts HTML.
Export is disabled for sensitive buffers.

`:Fr text`, `:En text`, and `:Sy text` translate or find synonyms through
`llm-text` from the scripts package. These commands require a configured `llm`
provider for the model selected in `llm-text`, and send the supplied text to
that provider when invoked.

## Mapping API

Set `g:noesis_no_mappings = 1` before opening notes to disable default `gh`
bindings. `<Plug>(noesis-...)` mappings are available globally, independently of
the note filetype; default bindings remain contextual. Native filetype overrides
(such as wrapped-line `j/k`) still apply. See the
[mapping guide](../../../../MAPPINGS.md) for the mapping model and remapping
examples.
