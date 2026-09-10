# Vim GPG

## Purpose

The plugin decrypts and re-encrypts text files matching `*.gpg.*` while
disabling Vim persistence that could retain plaintext.

## Threat model

Closed files contain OpenPGP ciphertext. While a file is open, its plaintext is
present in Vim's process memory. This plugin does not protect against root, the
kernel, endpoint monitoring capable of reading the process, screen capture, or
keylogging. The security of the GPG key and `gpg-agent` is a separate boundary.

Arbitrary commands, clipboard operations, filters, or other plugins can still
transmit buffer contents. This plugin prevents unencrypted file writes through
Vim's normal write paths and disables the persistence mechanisms it controls;
it is not a sandbox for every action possible inside Vim. Commands that
explicitly bypass autocommands, such as `:noautocmd`, and direct Vimscript file
I/O are outside this guarantee.

## Guarantees

Sensitive buffers use `noswapfile` and `noundofile`. Backup and Vim info
persistence remain disabled for the whole session after plaintext is exposed,
so later registers, searches, or command history cannot persist it.
These protections are installed before editing begins and are not retroactive.
Opening a new encrypted path or assigning one to an unnamed buffer with `:file`
installs them before the first plaintext is entered.

Cleartext is sent to GPG through pipes rather than shell-filter temporary files.
Only successfully generated armored ciphertext replaces a destination. A disk
fingerprint prevents overwriting a file changed since it was read. Appending
ciphertext and writing a managed plaintext buffer to an unencrypted filename
are refused.

New files use mode `0600`; rewrites preserve existing Unix permission bits.
Atomic replacement creates a new inode, so ACLs, extended attributes, and other
metadata are not guaranteed to survive. The plugin handles text files, not
arbitrary binary data. Its line-oriented pipeline follows Vim's text-buffer
semantics and does not promise byte-for-byte preservation of final line endings.

## Requirements and configuration

The plugin requires `gpg`, `/bin/sh`, and Vim job/channel support. The optional
agent-restart mapping `glgr` requires `gpgconf`; the isolated test harness also
uses `gpg-connect-agent`. Set the encryption recipient before the plugin loads:

```vim
let g:vim_gpg_recipient = 'YOUR-GPG-FINGERPRINT'
```

## Read and write behavior

A successful read replaces ciphertext in memory with plaintext and records the
fingerprint of the exact ciphertext version that produced it, together with the
logical filename and its resolved destination. If that filename or one of its
parent directories is a symlink and is later retargeted, writing through the
same name is refused; reload the new destination or save as an explicit other
name. A write encrypts into a staging directory beside the destination, applies
the required permission bits, verifies that the destination has not changed,
and renames the ciphertext atomically. Failures before that replacement leave
the existing destination intact and remove staging files. Once replacement
succeeds, errors from post-write hooks are reported but cannot roll back the
completed encrypted write. Write hooks receive the original source buffer,
range, and exact destination filename even when a Pre hook changes the current
buffer or Vim's range marks.

## Manual transforms

The remaining `glg*` mappings provide manual decryption, visual-range
encryption/decryption, symmetric encryption, and GPG agent restart. These are
content transforms, not a safe conversion mechanism for an existing plaintext
file: plaintext may already have reached swap, undo, backups, or history. For a
new confidential note, open its `*.gpg.*` filename before typing any plaintext.
Manual transforms make the current buffer sensitive and disable persistence,
but they do not turn an ordinary filename into GPG-managed encrypted storage.

## Tests

Run `test/run.sh`. The headless suite creates a temporary home, GnuPG keyring,
and disposable key; it never reads the configured personal recipient or
keyring.
