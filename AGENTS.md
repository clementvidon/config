# Repository guidelines

This repository manages macOS and Ubuntu configuration with GNU Stow.

## Structure

- Keep deployable configuration under `stow/<package>/`, mirroring paths below
  `$HOME`.
- Packages are discovered automatically. Do not duplicate package or command
  inventories in code, tests, or documentation.
- Small personal commands may live in `stow/scripts/.local/bin`; repository
  maintenance commands belong in `scripts/`.
- Keep generated state, caches, secrets, and downloaded dependencies out of the
  repository.
- Apply these rules throughout the repository and follow any more specific
  AGENTS.md in the directory being changed.

## Configuration style

For top-level sections in Stow configurations, use three-line comment headings:
`# =============================================================================`,
`# Section`, and the same separator. Use the file's comment prefix (`#`, `--`,
or `//`). Keep explanatory comments short. Vim and IdeaVim use their own style;
native configuration sections need no comment heading.

## Documentation

- Write for someone who has no knowledge of the author's setup or past work.
- Keep the root README focused on setup, everyday usage, and contribution.
  Put tool-specific instructions beside the relevant configuration.
- Include only information needed to use or maintain the documented feature.
  Omit personal workflow advice, historical reminders, speculative warnings,
  and unrelated special cases.
- Make instructions actionable. Use generic examples and explain required
  inputs or prerequisites where they are used.
- Prefer examples and discovery commands over lists that must be maintained.
- Document real platform exceptions close to the code that implements them.
- Keep each rule in one place. AGENTS.md files define maintenance constraints;
  READMEs explain usage. Retain concrete security and data-loss constraints
  where they affect the feature.
- Documentation cleanup must preserve the scope and strength of maintenance
  rules. Verify suspected obsolete guidance against the code; ask the user
  before removing it when its relevance remains uncertain.

## Commits

- When asked to commit, group changes into atomic commits, each delivering one
  coherent outcome. Include its code and documentation together; apply the
  testing policy below to any test changes.
- Use Conventional Commits: `type(scope): short imperative description`.
  Describe the intended feature, user experience, or maintenance goal. Add a
  short body when needed to explain the problem and resulting behavior; include
  implementation details only when they help explain that outcome.
- Use the affected configuration package as the scope, or `repo` for
  repository-wide changes; for example, `feat(vim): navigate notes from their
  outline` or `fix(zsh): restore the prompt in new terminals`.

## Testing policy

- Keep configuration checks broad: syntax, loading, repository structure, and
  generic Stow behavior (dry runs, idempotency, conflicts, and clean removal).
- Discover packages and configuration inputs automatically. Adding, removing,
  or adjusting ordinary configuration must not require editing tests, expected
  values, fixtures, or inventories. A new format may justify one generic syntax
  validator; it does not justify tests for each setting or file.
- Do not assert individual preferences, mappings, commands, exact output or log
  text, or snapshots of configuration contents. Do not test personal commands.
- Detailed regression tests are limited to stable installer contracts and
  documented security guarantees. Within those tests, check only the behavior
  or state needed to establish the guarantee, not unrelated configuration.
- Every new test must identify a concrete uncovered failure within this scope.
  Do not duplicate coverage, enumerate speculative edge cases, or add tests
  merely because configuration changed. Keep dependencies to a minimum.
- When changing an installer or security guarantee, update only the affected
  checks. Once required checks pass, stop unless a specific risk remains.

## Verification

Run `./install.sh check` and `git diff --check` after relevant changes.
