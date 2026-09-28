# Achiever

Task editing layered on the current filetype. `achiever.md` and `*.achiever.md`
activate it automatically; use `:AchieverEnable` for any other suitable buffer.
`:AchieverDisable` removes task bindings, abbreviations, and state,
then restores the host filetype and its previous wrapping behavior. Activation
never changes document contents.

Achiever is an optional task capability, independent of the Markdown format
and the Noesis note environment. Inside `g:noesis_root`, Markdown notes compose
as `noesis.achiever`; outside it they compose as `markdown.achiever`. Other host
filetypes can also use the capability.

Tasks are log records that stay on one logical line. While enabled, Achiever
disables automatic hard wrapping and visual wrapping for the whole buffer,
including prose. It leaves indentation and comment conventions to the host
filetype. Noesis additionally blocks generic indentation and reflow commands.

## Task format

```text
- description
- YYMMDD HH:MM description
- YYMMDD HH:MM HH:MM description
```

Tasks start at column one, with a non-empty description. Times use the 24-hour
clock; invalid timestamps are rejected. Checking a task rounds the current
time to the nearest five minutes.

## Usage and customization

Space `hh` lists active bindings. Duration display does not alter the running
total: use `<Plug>(achiever-duration-add)` to accumulate it,
`<Plug>(achiever-duration-total)` to inspect it, and
`<Plug>(achiever-duration-reset)` to clear it. The total is buffer-local and
lasts until reset, disable, a filetype change, or buffer closure.

Insert-mode abbreviations `wwo` and `lli` expand to work and life task labels.
Set `g:achiever_task_detail_prefix` before activation to change the detail marker
(default `--`).

Set `g:achiever_no_mappings = 1` before activation to disable default bindings.
`<Plug>(achiever-...)` mappings remain available in active buffers;
for example, map a key to `<Plug>(achiever-check)`. See the
[mapping model](../../../../../../../docs/vim-mappings.md) for discovery and remapping.
