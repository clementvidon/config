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

Native tag navigation uses `CTRL-]`, `CTRL-T`, `g]`, `:tag`, and `:tselect`.
Generate a project `tags` file explicitly, for example with optional
`universal-ctags`:

```sh
ctags -R .
```

`sgr` searches whole-word textual references for the word under the cursor
with `rg`, then opens the quickfix window. `sg` starts a free-form `rg` search.
Searches include hidden project files such as `.github` while excluding `.git`
and generated dependency/build directories.

## Reloading

`mso` is the supported full reload command. It writes and sources the
configuration, reloads the current buffer so its ftplugins reapply their local
options, and restores the view. A raw `:source ~/.vimrc` only re-executes the
vimrc and is not a complete filetype reload.

## Clipboard

Remote clipboard support is optional. `<Leader>y` uses Vim's clipboard or a
clipboard command found on `$PATH`. `<Space>p` exists only when Vim has
clipboard support. OSC52 is intentionally left to the terminal or tmux
configuration.

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
