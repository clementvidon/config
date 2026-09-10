# Achiever

Personal task editing helpers for Vim. The plugin activates on configured file
names and appends `achiever` to their filetype (for example `noesis.achiever`).
Files without a filetype use `achiever` alone.

Vim loads the base ftplugin and syntax first, then Achiever's buffer-local task
behavior. Noesis is optional: a task file can keep its `.noe`, `.md` or other
name; no special extension is required. Use `:setfiletype achiever` to activate
it in an untyped buffer, or `:setlocal filetype=markdown.achiever` to combine it
with another filetype.

Tasks use `- description`, `- YYMMDD HH:MM description`, or
`- YYMMDD HH:MM HH:MM description`. Descriptions may begin with any
non-whitespace character. Times use the 24-hour range `00:00` through `23:59`;
timestamp-shaped metadata with an invalid time is rejected rather than treated
as a description. Checking a task rounds the current instant to the nearest
five minutes, keeping the date and time coherent across midnight.

## Configuration

```vim
let g:achiever_filenames = ['todos.noe', 'achiever.md']
```

Mappings can also be replaced through `g:achiever_mappings`.
Their default local prefix is `gh`.

## Usage

### Mappings

- `k`: check a task
- `c`: clear a task
- `F`: fix its ending time
- `f`: fix its starting time
- `d`: display its duration
- `x`: toggle task-detail display

### Abbreviations

- `wwo` expands to `- work:`
- `lli` expands to `- life:`
