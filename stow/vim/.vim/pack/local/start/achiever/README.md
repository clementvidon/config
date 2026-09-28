# Achiever

Task editing layered on the current filetype. `achiever.md` and `*.achiever.md`
activate it automatically; use `:AchieverEnable` for any other suitable buffer.
`:AchieverDisable` removes task bindings, commands, abbreviations, and state,
then restores the host filetype and its previous wrapping behavior. Activation
never changes document contents.

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

Space `hh` lists active bindings; `:command Achiever` lists commands. Duration
display does not alter the running total: use `:AchieverDurationAdd` to accumulate
it, `:AchieverDurationTotal` to inspect it, and `:AchieverDurationReset` to clear
it. The total is buffer-local and lasts until reset, disable, a filetype change,
or buffer closure.

Insert-mode abbreviations `wwo` and `lli` expand to work and life task labels.
Set `g:achiever_task_detail_prefix` before activation to change the detail marker
(default `--`).

Set `g:achiever_no_mappings = 1` before activation to disable default bindings.
Commands and `<Plug>(achiever-...)` mappings remain available in active buffers;
for example, map a key to `<Plug>(achiever-check)`.
