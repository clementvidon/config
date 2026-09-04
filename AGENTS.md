# Repository guidelines

This repository manages personal macOS and Ubuntu configuration with GNU Stow.

## Structure

- Keep deployable configuration under `stow/<package>/`, mirroring paths below
  `$HOME`.
- Packages are discovered automatically. Do not duplicate package or command
  inventories in code, tests, or documentation.
- Small personal commands may live in `stow/scripts/.local/bin`; repository
  maintenance commands belong in `scripts/`.
- Keep generated state, caches, secrets, and downloaded dependencies out of the
  repository.

## Documentation

- Keep documentation short and focused on stable usage and invariants.
- Prefer examples and discovery commands over lists that must be maintained.
- Document real platform exceptions close to the code that implements them.

## Checks

- Check configuration syntax, repository structure, and generic Stow behavior:
  dry runs, idempotency, conflicts, and clean removal.
- Discover inputs automatically. Adding, changing, or removing a package,
  configuration file, or personal command must not require changing a check.
- Do not test personal commands. Avoid assertions on exact output or log text.
- Keep dependencies and explicit checks to a minimum; retain only stable
  installer contracts such as supported platforms and specially managed assets.

## Verification

Run `./install.sh check` and `git diff --check` after relevant changes.
