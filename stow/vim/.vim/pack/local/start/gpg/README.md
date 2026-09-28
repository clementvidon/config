# Vim GPG

Edit encrypted text files matching `*.gpg.*`. The plugin decrypts on opening
and encrypts on saving.

## Setup

Requires `gpg`, `/bin/sh`, and Vim with job/channel support. Set your recipient
fingerprint before plugins load (in `plugins.vim` for this configuration):

```vim
let g:vim_gpg_recipient = 'YOUR-GPG-FINGERPRINT'
```

Open an encrypted filename before entering text:

```vim
:edit notes.gpg.txt
```

Use `:write` to save encrypted content. Appending and saving to an unencrypted
filename are refused. If the file changes on disk or a symlink is retargeted,
reload it or save under a new encrypted filename.

## Storage

Plaintext passes to GPG through pipes. Validated ciphertext replaces the file
atomically; failures before replacement leave the destination intact. Errors
in post-write hooks occur after the encrypted file has been saved.

New files use mode `0600`; rewrites preserve Unix permission bits. Replacement
may discard ACLs and extended attributes. The plugin uses Vim text-buffer
semantics, including line-ending handling.

Swap and persistent undo are disabled for sensitive buffers. Backups and
viminfo stay disabled for the rest of the session because registers and
history may retain plaintext. These protections apply from activation onward;
they do not erase plaintext previously saved by Vim.
Explicit commands, clipboard operations, other plugins, and writes bypassing
autocommands can still export plaintext.

## Manual transforms

`:GPGDecrypt` decrypts text, `:GPGEncrypt` encrypts to the configured recipient,
and `:GPGEncryptSymmetric` uses symmetric encryption. These commands accept a
line range and default to the whole buffer. Select text visually before typing
the command to transform only those lines.

`:GPGRestartAgent` restarts the GPG agent and requires `gpgconf`.

Transforms disable persistence but retain the filename. An ordinary file keeps
its normal write behavior. Use a `*.gpg.*` file for automatic encrypted storage.

## Tests

From this directory, run `test/run.sh`. It uses a temporary home and disposable
GnuPG keyring, and additionally requires Bash and `gpg-connect-agent`.
Cleanup stops only the test keyring's agent, including when setup fails.

## Mapping API

Space `eh` lists default bindings; `:command GPG` lists commands. Set
`g:vim_gpg_no_mappings = 1` before plugins load to disable defaults. Commands and
`<Plug>(vim-gpg-...)` mappings remain available; for example, map a key to
`<Plug>(vim-gpg-decrypt)`. See the
[mapping model](../../../../../../../docs/vim-mappings.md) for discovery and remapping.
