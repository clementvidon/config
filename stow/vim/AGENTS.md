# Vim maintenance

## Design

- Keep Vim a lightweight terminal editor. Prefer native behavior and existing
  tooling; add plugins only for needs they cannot reasonably satisfy.
- Remove unused behavior instead of adding abstractions to preserve it.
- Use Vim's standard filetypes and ALE for shared linting and manual formatting.
  Add a first-party filetype override only when the runtime and ALE cannot meet
  the need; document that reason beside the override.
- Do not add language servers, semantic completion, language-specific build,
  run or debugging integrations, snippets, automatic tags, or format-on-save.
- Support macOS and Ubuntu; resolve executables through `PATH`.
- Pin third-party plugins to commits. Do not reformat or casually modify
  vendored `autoload/plug.vim`. Preserve the upstream structure, attribution,
  and standalone use of `redact-pass`.
- Keep local plugins self-contained. Noesis owns note behavior; Achiever owns
  task behavior. Their READMEs describe configuration and supported formats.
- Keep Noesis search self-contained and exclude encrypted notes. Translation
  must be explicitly invoked and document which provider receives the text.
- Keep Achiever parsing, editing, duration calculation, and highlighting
  consistent with its documented task grammar.

## Sensitive data

GPG and redact-pass share sensitivity markers but remain independent plugins.
Do not replace them with a shared sensitive-buffer framework.

- `g:vim_sensitive_session` stays set after plaintext is exposed; global
  persistence must stay disabled for the rest of the process.
- `b:vim_sensitive_buffer` disables swap and persistent undo before plaintext
  is read or entered. Automatic integrations must neither process nor serialize
  these buffers, including work queued before they became sensitive.
- `b:vim_gpg_managed_buffer` belongs to GPG and adds encrypted-write
  restrictions. Other sensitive buffers retain their own write behavior.
- The GPG pipeline must never write plaintext to temporary files.
- Bind disk fingerprints to the canonical path and ciphertext that produced
  the buffer. Retain ciphertext validation, staging on the destination
  filesystem, disk-state revalidation, and atomic replacement.
- Failures before replacement preserve the destination. Post-write hook errors
  cannot undo a completed replacement.

## Vimscript style

- Start non-trivial first-party files with a one-line purpose comment.
- Use `" # SECTION` for responsibility boundaries and `" ## subsection` when
  a long section needs navigation. Qualify repeated names, such as
  `" ## ALE / mappings`. Leave one blank line around headings. Do not add
  decorative banners or headings to trivial files.
- Explain reasons, Vim constraints, and security assumptions; keep helpers
  near the behavior they support.
- Use two-space indentation and retain existing continuation indentation.
  Aim for 80 columns in prose and 100 in code when splitting aids readability.
- Use `scriptencoding utf-8` for literal Unicode. Save and restore `&cpoptions`
  for standalone plugins that need Vim-compatible parsing.
- Keep core settings in `.vimrc`, plugin settings and declarations in
  `plugins.vim`, and general mappings in `mappings.vim`.
- Group plugin files by defaults, helpers, commands, autocommands, and mappings.
  Keep plugin declarations after their settings. Give ftplugins a
  `b:undo_ftplugin`; finish syntax files with `b:current_syntax`.

## Testing policy

- Limit general Vim checks to smoke tests: startup, reload, and representative
  file opening without errors. Keep a small representative set of files;
  do not add a fixture for each filetype, plugin, or configuration change.
- Apply the root testing policy. General checks must not test individual
  abbreviations, tool arguments, or plugin internals either.
- Reserve detailed Vim regressions for security guarantees, including encrypted
  I/O, plaintext persistence, sensitive-buffer isolation, and prevention of
  unintended code execution. Each assertion must support the protected outcome.

## Verification

- Run `.vim/pack/local/start/gpg/test/run.sh` from this directory after changes
  to encrypted I/O, persistence protection, or sensitive-buffer handling.
- Before changing behavior, identify the affected invariant. Update usage
  documentation when behavior or dependencies change, and affected security
  checks when their guarantees change, within the testing policy above.
- Run the repository checks specified in the root AGENTS.md.
