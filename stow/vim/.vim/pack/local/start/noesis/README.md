# Noesis

Vim tools for `.noe` notes: navigation, search, HTML export, and translation.

## Configuration

The notes directory defaults to `~/noesis`. Set `NOESIS_ROOT` in the shell or
configure it before plugins load:

```vim
let g:noesis_root = expand('~/notes')
```

## Usage

Follow the [file conventions](CONVENTIONS.md) for headings, spacing, and index
layout. `<LocalLeader>h1` prefixes the current line with `# `;
`<LocalLeader>h2` underlines it with 60 `-` characters.

`<LocalLeader>I` creates or refreshes the index. `<LocalLeader>i` toggles between
an index entry and its heading, positioning the target about 30% down the window
when space permits. Refresh after adding, removing, renaming, or reordering
indexed headings.

`:Grep pattern` searches unencrypted `.noe` files under the notes directory
using ripgrep (`rg`). Achiever can add task editing through the
`noesis.achiever` filetype.

`<LocalLeader>X` exports the current note to HTML. Optional
`g:noesis_export_author`, `g:noesis_export_copyright`, and
`g:noesis_export_footer` customize the output; the footer accepts HTML.
Export is disabled for sensitive buffers.

`:Fr text`, `:En text`, and `:Sy text` translate or find synonyms through
`llm-text` from the scripts package. These commands require a configured `llm`
provider for the model selected in `llm-text`, and send the supplied text to
that provider when invoked.
