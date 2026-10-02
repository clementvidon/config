# Noesis file conventions

Noesis notes use Markdown syntax and the following layout, usually with a `.md`
extension. These conventions apply to notes activated through the
[Noesis environment](README.md). Optional task records follow [Achiever's grammar](../achiever/README.md#task-format).

## Headings

| Level | Style | Purpose | In the index |
| --- | --- | --- | --- |
| H1 | `# Title` | One document title, on the first line | No |
| H2 | Title underlined with 80 `-` characters | Main section | Yes |
| H3 | `### Title` | Subsection | Yes |
| H4–H6 | `#### Title` through `###### Title` | Local detail | No |

`## Title` is also accepted for H2. Prefer the underline for main sections.
Place it directly below the title, with no blank line between them.
Highlighting and indexing of underlined headings require exactly 80 `-`
characters.

For numbered H2 headings, use `1 - Title`, `2 - Title`, etc. Do not use
`1. Title` or `1) Title`, as these can be parsed as ordered-list items rather
than Setext headings.

Use exactly one blank line before and after each heading block. The document
starts directly with its H1. Use one blank line between paragraphs as well.
Heading highlighting requires a blank line on each side of the block, or a
file boundary in its place.

## Index

Place the index after the document title, with one blank line before and
after the complete block. Open it with `<!-- INDEX {{{` and close it with
`INDEX }}} -->`. The HTML comment hides the index in rendered Markdown while
the markers keep it foldable in Vim.

Index H2 and H3 headings in document order, including unnumbered headings.
Indent H2 entries by two spaces and H3 entries by four. Omit the document title,
the index itself, and headings inside code blocks.

## Example

```markdown
# Service handbook

<!-- INDEX {{{
  1 - Applications
    Service A
INDEX }}} -->

1 - Applications
--------------------------------------------------------------------------------

Overview of the applications.

### Service A

Description of the service.

#### Operations contact

Contact details.
```
