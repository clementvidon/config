# Noesis

Vim tools for Markdown notes: navigation, search, HTML export, and translation.
Opening a `.md` file activates the Noesis filetype regardless of its directory.

## Configuration

The notes directory defaults to `~/noesis`. Set `NOESIS_ROOT` in the shell or
configure it before plugins load:

```vim
let g:noesis_root = expand('~/notes')
```

## Usage

Follow the [file conventions](CONVENTIONS.md) for headings, spacing, and index
layout. Use `ghh` to discover note-editing bindings and `:command Noesis` to
inspect commands. Noesis provides headings, inline styles, links, quotes, code
blocks, and style removal. Generic indentation and reflow (including Space `=`)
are blocked to preserve document layout.

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

`<LocalLeader>u` removes one simple surrounding style at a time, preserving its
text. For example, with the cursor on `word`, `> **word**` becomes `> word`, then
`word`. Inline removal handles plain asterisk emphasis, code spans, and simple
links on the current line. It also removes headings, quote prefixes on the
current line, and complete code fences. Removing a link keeps its label and
discards its URL. Code contents stay literal until their delimiters are removed.

Inline styles spanning multiple lines, arbitrary nesting, and links with escaped
labels or nested URL parentheses are outside the removal grammar. Unmatched or
ambiguous markup is left unchanged. This also applies to complex styles created
by composing the insertion mappings. With no enclosing style, nothing changes.

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
bindings. Buffer-local commands and `<Plug>(noesis-...)` mappings remain
available. Native filetype overrides (such as wrapped-line `j/k`) still apply.
Inspect commands with `:command Noesis`; names ending in `Selection` use the
last visual selection. See the [mapping guide](../../../../../../../docs/vim-mappings.md)
for the mapping model and remapping examples.
