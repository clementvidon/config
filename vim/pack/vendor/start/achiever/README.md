# Achiever

This plugin adds custom mappings and functionality to files named "achiever", without altering their original filetypes.
The plugin is designed to be non-intrusive and efficient.

## Installation

Use your preferred Vim plugin manager. For example, with vim-plug:

```vim
Plug 'clementvidon/vim-achiever'
```

## Configuration

Customize the local leader key for the plugin mappings: `let g:achiever_local_leader = 'gh'`

## Usage

### Mappings

LocalLeader k  → Check task
LocalLeader c  → Clear task

LocalLeader F  → Fix task ending time
LocalLeader f  → Fix task starting time

LocalLeader f  → Print task time duration

### Abbreviations

mma  → Expands to "- main:"
ssi  → Expands to "- side:"
lli  → Expands to "- life:"
