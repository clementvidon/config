# Achiever

Task editing in Vim. Configure filenames before plugins load:

```vim
let g:achiever_filenames = ['tasks.md']
```

Achiever adds its behavior to the existing filetype, such as
`markdown.achiever`. To activate it manually:

```vim
:setlocal filetype=markdown.achiever
```

## Task format

```text
- description
- YYMMDD HH:MM description
- YYMMDD HH:MM HH:MM description
```

Tasks start at column one, with a non-empty description. Times use the 24-hour
clock; invalid timestamps are rejected. Checking a task rounds the current
time to the nearest five minutes.

## Usage

The default prefix is `gh`, configurable with `g:achiever_local_leader`.

| Key | Action |
| --- | --- |
| `ghk` | Check a task |
| `ghc` | Clear a task |
| `ghf` | Fix its starting time |
| `ghF` | Fix its ending time |
| `ghd` | Show its duration |
| `ghx` | Toggle task details |

Customize actions with `g:achiever_mappings`. In insert mode, `wwo` expands to
`- work:` and `lli` to `- life:`.
