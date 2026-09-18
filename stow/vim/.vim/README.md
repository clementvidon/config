# Vim configuration

## Architecture

`.vimrc` contains the core Vim-only configuration. Plugin declarations and
settings live in `plugins.vim`; general mappings live in `mappings.vim`.

Vim has four filetype levels:

1. Noesis and Achiever own rich, task-specific behavior.
2. Standard filetypes retain Vim's runtime behavior by default. First-party
   overrides are exceptional and must document their reason; quickfix wrapping
   is the current small example.
3. Supported Ops filetypes use Vim's runtime plus the shared ALE interface for
   linting and manual formatting.
4. Unknown filetypes retain the global configuration without additional
   filetype-specific overrides.

Self-contained personal plugins live under `pack/local/start`. Each one owns
its detection, commands, mappings, and documentation so it can later move to a
dedicated repository without changing the rest of the runtime.

## Editing policy

Vim is the lightweight terminal editor; full IDE and code-generation workflows
live elsewhere. Native tags and textual `rg` searches belong in Vim. Language
servers, semantic completion, debugging, refactoring, and rich workspace
navigation do not. Adding an IDE plugin or server requires an explicit new
justification.

An `after/ftplugin` is permitted only when Vim's runtime and ALE cannot express
a needed behavior. It must document that reason. Do not add language-specific
compile, run, test, debugger, snippet, automatic tag generation, LSP,
completion, or automatic-formatting behavior.

## Ops linting and formatting

ALE linting runs when a supported non-sensitive Ops buffer opens, its filetype
changes, or it is saved. Buffers marked `b:vim_sensitive_buffer` are excluded so
ALE cannot serialize their plaintext to temporary files. It never runs while
typing, and formatting is always explicit via `gjaf`. Terraform formatting is
canonical and always permitted. YAML formatting requires a repository yamlfmt
configuration. Shell and JSON formatting are not configured.

Automatic integrations must exclude a sensitive buffer where they actually
process or serialize its contents, including work queued before the buffer
became sensitive. This configuration applies that rule to ALE and GitGutter.

| Filetype | Linters | Manual fixer |
| --- | --- | --- |
| `sh` | `shellcheck` | none |
| `yaml` | `yamllint` | `yamlfmt`, with repository config |
| `json` | `jsonlint` | none |
| `dockerfile` | `hadolint` | none |
| `terraform` | `tflint` | `terraform fmt` |
| `make` | `checkmake` | none |

Project yamllint and Hadolint configuration is passed explicitly to the
corresponding linter when found inside the repository. Checkmake uses its
defaults because its current ALE integration does not safely quote configured
paths. Project configuration files are trusted as policy, but ALE resolves all
linter and fixer executables from `PATH`; it never runs executables supplied by
the checkout. Systemd files use Vim's runtime; run `systemd-analyze verify`
manually for the appropriate system or user scope. Run `terraform validate`
manually from the project directory; ALE's built-in integration does not bind
that command to the buffer's directory. TFLint does.

## Search and tags

`sf` prepares `:find *fragment*.ext`, with the cursor between the stars and
the current file's extension filled in. Type any part of the filename, then
use Tab to complete and cycle through matches, and Enter to open one. With
no extension, the pattern is `*fragment*`; the suffix is always editable.
The split and tab find mappings use the same prompt.

Find searches recursively below Vim's working directory (`:pwd`). Use `:lcd`
to narrow it to a subtree, or `:lcd %:p:h` to start from the current file's
directory. Noesis retains its note-specific search paths. Native find uses
`wildignore`, not `.gitignore`, and does not automatically traverse hidden
directories. Traversal is synchronous and has no configured time limit.

Native tag navigation uses `CTRL-]`, `CTRL-T`, `g]`, `:tag`, and `:tselect`.
Generate a project `tags` file explicitly, for example with optional
`universal-ctags`:

```sh
ctags -R .
```

`sgr` searches whole-word textual references for the word under the cursor
with `rg`, then opens the quickfix window. `sg` starts a free-form `rg` search.
Both mappings report an error if `rg` is unavailable; `sgr` treats the word as
literal text, not as a regular expression.
Searches include hidden project files such as `.github` while excluding `.git`
and generated dependency/build directories. Native find and `:grep` derive
their directory exclusions from the same list in `.vimrc`, at every depth.
Ripgrep additionally honors project ignore files.

## Persistent undo

Undo history is stored only in `$XDG_STATE_HOME/vim/undo`, defaulting to
`~/.local/state/vim/undo`. The directory is created or corrected to mode
`0700`. If it remains unavailable, Vim silently disables persistent undo for
existing and new buffers; in-memory undo remains available. Fix the directory
and reload to enable persistence again for the current and new buffers;
sensitive buffers remain excluded. Only swap keeps a `/tmp` fallback.

## Reloading

`mso` is the supported full reload command. It writes and sources the
configuration, reloads the current buffer so its ftplugins reapply their local
options, and restores the view. A raw `:source ~/.vimrc` only re-executes the
vimrc and is not a complete filetype reload.
Removed mappings remain active in an existing session; restart Vim after
deleting mappings rather than relying on a reload to remove them.

## Calculator

`glbc` replaces the current line with its arithmetic result, retaining its
indentation. It uses Vim's floating-point arithmetic, not an external process.
Decimal commas or points, scientific notation, parentheses and `+ - * /` are
supported: `(1,5 + 2) / 2` becomes `1.75`. Invalid expressions and non-finite
results leave the line unchanged. This is approximate arithmetic, not `bc`'s
arbitrary-precision language; variables, functions and powers are not supported.

## Clipboard

`<Leader>y` copies the unnamed register; `<Leader>p` pastes the local system
clipboard. Both require `clipboard` from the `scripts` Stow package on `PATH`.
That command owns provider selection and SSH transport, shared with `copy`;
see the repository README's clipboard section. Over SSH, copying uses OSC 52
to reach the client terminal. Paste using the client terminal's paste action,
not `<Leader>p`; remote clipboard reads are deliberately unsupported.

Clipboard tools exchange plain text, so Vim-specific blockwise register types
are not preserved. Paste uses the expression register and preserves yank/delete
registers.

Clipboard access is explicitly user-triggered and exports text outside Vim's
persistence protections. External providers run through `system()`, which may
use temporary files. Do not use these mappings for text that must stay entirely
inside Vim. The personal `copy` command is not called: it labels file contents
and is not a raw clipboard transport.

## Dependencies and updates

The configuration targets terminal Vim on Unix-like systems. Windows portability
is not a design goal. Core implementation assumptions include `/bin/sh`, `/tmp`,
and Unix permission bits. Some explicit commands additionally use `tmux`,
`sudo`, macOS or Unix clipboard tools, and Bash for the GPG test harness.

Vim 8.2.0807 or newer is supported. Encrypted files require jobs and channels.
Vim is required. Git is required to install and update plugins. Optional `rg`
enables project and Noesis search. Linters, formatters, `universal-ctags`, and
clipboard providers are also optional and discovered through `$PATH`.

Downloaded vim-plug plugins and generated state are stored outside `~/.vim`.
Declarations pin each plugin to a validated commit. To update deliberately,
choose and review an upstream commit, replace its pin, run `:PlugUpdate`, then
run the repository checks and commit the new hash.
