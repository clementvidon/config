# Noesis file conventions

Write `.noe` notes using Markdown syntax, with the following layout.

## Headings

| Level | Style | Purpose | In the index |
| --- | --- | --- | --- |
| H1 | `# Title` | One document title, on the first line | No |
| H2 | Title underlined with 60 `-` characters | Main section | Yes |
| H3 | `### Title` | Subsection | Yes |
| H4–H6 | `#### Title` through `###### Title` | Local detail | No |

`## Title` is also accepted for H2. Prefer the underline for main sections.
Place it directly below the title, with no blank line between them.

Use exactly one blank line before and after each heading block. The document
starts directly with its H1. Use one blank line between paragraphs as well.

## Index

Place the index after the opening paragraph, with one blank line before and
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
  1. Applications
    Service A
INDEX }}} -->

1. Applications
------------------------------------------------------------

Overview of the applications.

### Service A

Description of the service.

#### Operations contact

Contact details.
```
