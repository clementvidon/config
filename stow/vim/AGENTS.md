# Vim maintenance rules

## Scope

These rules apply to `.vimrc` and `.vim/**`. This file is repository guidance;
`.stow-local-ignore` keeps it out of the deployed home directory.

## Architectural invariants

- Vim remains a lightweight terminal editor, not an IDE.
- Prefer native Vim behavior and existing tooling over new plugins.
- Prefer deleting unused behavior over adding an abstraction to preserve it.
- Keep standard filetypes on Vim's runtime; ALE provides the shared Ops lint
  and explicit formatting interface.
- Do not add language-specific compilation, execution, debugging, snippets,
  automatic tags, LSP, semantic completion, or format-on-save behavior.
- Keep the configuration portable across macOS and remote Ubuntu/Linux systems;
  discover executables through `$PATH`.
- Keep third-party plugins pinned to explicit commits.
- Do not reformat or casually modify vendored `.vim/autoload/plug.vim`.
- Preserve the upstream structure and attribution of `redact-pass`; it remains
  independently usable.
- Add no plugin without a concrete need that native Vim and current tooling
  cannot reasonably satisfy.

## Sensitive-buffer invariants

GPG and redact-pass intentionally share the first two markers while remaining
independent plugins. Their local implementations must not become a generic
sensitive-buffer framework.

- `g:vim_sensitive_session` is sticky for the lifetime of the Vim process after
  sensitive plaintext is exposed. Global persistence must remain disabled.
- `b:vim_sensitive_buffer` marks a buffer containing sensitive plaintext. Swap
  and persistent undo must be disabled before plaintext is read or entered.
- Configured automatic integrations, including ALE, must not process a buffer
  marked `b:vim_sensitive_buffer` or serialize its plaintext to temporary files.
- `b:vim_gpg_managed_buffer` is the stronger marker owned by Vim GPG. Do not
  apply its encrypted-write restrictions to every sensitive buffer.
- GPG failures before atomic replacement must leave the existing destination
  unchanged; post-write hook errors cannot roll back a completed replacement.
- The GPG pipeline must never write plaintext to temporary files.
- GPG disk fingerprints remain bound to their canonical path and to the exact
  ciphertext version that produced the buffer plaintext.
- Encrypted writes retain validated ciphertext, same-filesystem staging,
  disk-state revalidation, and atomic replacement.

## Testing policy

- Run `.vim/pack/local/start/gpg/test/run.sh` after changes to encrypted I/O,
  persistence protection, fingerprints, staging, write events, or
  sensitive-buffer handling.
- Add tests only for security-sensitive, destructive, stateful, or
  regression-prone behavior.
- Do not add tests merely for coverage of mappings or declarative options.

## Noesis invariants

- Noesis owns note-specific behavior only; do not reintroduce Git repository
  synchronization.
- `:Grep` remains self-contained, uses ripgrep, and excludes encrypted notes.
- Translation commands remain explicitly user-triggered, and their privacy
  boundary remains documented.

## Achiever invariants

The canonical task grammar is:

- `- description`
- `- YYMMDD HH:MM description`
- `- YYMMDD HH:MM HH:MM description`

Do not reintroduce subtasks without an explicit new requirement. Checking,
clearing, fixing, duration calculation, and syntax highlighting must remain
consistent with this grammar.

## Code organization

- Start non-trivial first-party Vimscript files with a one-line purpose comment.
- Use lightweight lowercase section comments such as `"   commands` for real
  responsibility boundaries; do not add decorative banners.
- Explain reasons, Vim constraints, security assumptions, and trade-offs rather
  than narrating obvious code.
- Keep script-local helpers near the behavior they support.
- Use two-space indentation and retain the existing continuation indentation.
- Keep prose near 80 columns and code near 100 when splitting improves
  readability. Long mappings and regular expressions may remain intact.
- Use `scriptencoding utf-8` in first-party scripts containing literal Unicode.
- Save and restore `&cpoptions` only when a plugin is intended to stand alone
  and benefits from Vim-compatible parsing.
- Avoid abstractions that make small Vimscript harder to audit.

Prefer this order where the sections exist:

- `.vimrc`: bootstrap, persistent state, plugin loading, appearance, editor
  options, search/navigation, private helpers, commands, autocommands, mappings.
- `plugins.vim`: local plugin configuration, third-party settings grouped by
  plugin, then plugin declarations.
- `mappings.vim`: private helpers, then mappings grouped by user-facing scope.
- `plugin/*.vim`: load guard, defaults, private helpers, commands,
  autocommands, mappings.
- `ftplugin/*.vim`: load guard, buffer configuration, commands, mappings,
  `b:undo_ftplugin`.
- `autoload/*.vim`: feature groups, with private helpers next to the public API
  using them.
- `syntax/*.vim`: syntax definitions, highlights/helper, `ColorScheme` hook,
  then `b:current_syntax`.

The mappings `sve` and `sv.` intentionally leave `:vertical split` open for Vim
completion. `svp` is the completed previous-buffer form. Do not reduce them to
the `:vertical` modifier alone.

## Change rule

Before changing behavior, identify the affected invariant. Update the relevant
README and tests in the same change when modifying security, persistence,
encrypted I/O, external data transmission, plugin reproducibility, external
dependencies, or architectural boundaries.

Run `./install.sh check` and `git diff --check` after relevant changes.
