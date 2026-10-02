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

The option defaults to `0`. The workspace used for note search and navigation
is configured separately. It defaults to `~/noesis`; set `NOESIS_ROOT` in the
shell or configure it before plugins load:

```vim
let g:noesis_root = expand('~/notes')
```

## Usage

Follow the [file conventions](CONVENTIONS.md) for headings, spacing, and index
layout. Use `ghh` to discover note-editing bindings. Noesis provides headings,
inline styles, links, quotes, and code blocks. Generic indentation and reflow
(including Space `=`) are blocked to preserve document layout.

Normal-mode word selection follows Vim's `iw`. Formatting mappings add markup;
they do not toggle it. Italic, bold, links, and inline code apply within one
paragraph.
Italic and bold leave surrounding whitespace outside their markers. Rectangular
selections (`Ctrl-V`) are not supported.

Use `Vghc` for a one-line code block or extend the line selection before
pressing `ghc`. Fence lines surround the selected lines without changing their
indentation. Code delimiters grow as needed to accommodate existing backticks.
The cursor enters insert mode at the end of the opening fence, ready for a
language name such as `python` or `sh`.
Quotes operate on complete lines, including blank lines; applying the mapping
again adds another quote level.

Text formatting mappings preserve registers and undo with one `u`. Except for
links and fenced code blocks, they preserve the cursor's position in the text
and finish in normal mode. Links enter insert mode between the parentheses,
ready for the URL to be pasted.

`<LocalLeader>g` creates or refreshes the index. `<LocalLeader>j` toggles between
an index entry and its heading, positioning the target about 30% down the window
when space permits. Refresh after adding, removing, renaming, or reordering
indexed headings.
If no indexed headings remain, refreshing removes the existing index.

`:Grep pattern` searches unencrypted `.md` files under the notes directory
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
