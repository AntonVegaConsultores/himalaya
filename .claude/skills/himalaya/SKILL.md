---
name: himalaya
description: How to manage Vega Consultores email via himalaya CLI through a kitty terminal. Use this skill when the user asks to read, search, or send emails, or work with the himalaya config in ~/Vegaconsultores/himalaya/.
---

# Himalaya email management

You manage email for Vega Consultores using the himalaya CLI running in a kitty terminal. The config is at `~/Vegaconsultores/himalaya/config.toml`.

## Key constraint: interactive authentication

Every himalaya invocation requires the user to type a password + touch a YubiKey. This has two major consequences:

1. **Minimize the number of himalaya invocations.** Always prefer commands that batch work (e.g. `message read ID1 ID2 ID3` instead of three separate reads).
2. **Never redirect stdin** when sending emails. Use `"$(cat file)"` as argument, not `< file`, because stdin must stay free for keepassxc-cli authentication.

## Terminal workflow

Himalaya runs in a separate kitty terminal (the user will tell you which one). Use the same send-text + diff pattern as SSH:

1. **Send** a command: `kitten @ --to "unix:/tmp/kitty-PID" send-text "command\n"`
2. **Read** the result: `kitty-ctx diff PID`

**Do both in the same turn.** Do not yield between send-text and diff. The user controls timing — they approve the diff call only after the command finishes and they've authenticated.

## Common operations

Always set the config path first.
In the fish terminal: `set CFG ~/Vegaconsultores/himalaya/config.toml`
In a bash script: `CFG=~/Vegaconsultores/himalaya/config.toml`

### List emails

```bash
himalaya -c $CFG envelope list -s 20
himalaya -c $CFG envelope list -a vega-administracion -s 20
himalaya -c $CFG envelope list -f "INBOX.Elementos enviados" -s 10
```

> The `-a` flag goes AFTER the subcommand (`envelope list -a ...`), not before it.

### Search

```bash
himalaya -c $CFG envelope list -s 20 from user@example.com
himalaya -c $CFG envelope list -s 20 from foo or from bar
himalaya -c $CFG envelope list -s 20 subject "Kit Digital" and after 2026-05-01
```

### Read multiple emails (single auth)

```bash
himalaya -c $CFG message read 27298 27293 27279
```

### Read emails from a specific folder

```bash
himalaya -c $CFG message read -f "INBOX.Elementos enviados" 2905 2868
```

### Send email with attachment

**Use `template send` when composing emails.** It compiles MML (processes `<#part>` tags into real MIME attachments). `message send` is for pre-built MIME/RFC822 (e.g. forwarding exported `.eml` files) and does NOT process MML tags.

Create an MML file in `~/Vegaconsultores/himalaya/drafts/`:

```
From: administracion@vegaconsultores.es
To: recipient@example.com
Cc: copy@example.com
Subject: Subject line

Body text here.

<#part filename=/absolute/path/to/file.zip><#/part>
```

Send it (note: `$(cat ...)` not `< file`):

```bash
himalaya -c $CFG template send -a vega-administracion "$(cat drafts/mail.mml)"
```

`template send` authenticates **twice** per invocation: once for IMAP (save copy to sent) and once for SMTP (send). This is normal.

### Batch send via script

```bash
#!/usr/bin/env bash
# Use /usr/bin/env bash, NOT /bin/bash (NixOS)
CFG=~/Vegaconsultores/himalaya/config.toml
himalaya -c "$CFG" template send -a vega-administracion "$(cat drafts/mail-1.mml)"
himalaya -c "$CFG" template send -a vega-administracion "$(cat drafts/mail-2.mml)"
```

Each invocation requires two authentications (IMAP + SMTP).

### Reply to or forward an email

By default, use the `template` workflow (generate → edit file → send). `message reply/forward` opens `$EDITOR` interactively — useful if the user wants to edit manually, but not the default.

```bash
# Reply (add -A for reply-all)
himalaya -c $CFG template reply -a vega-administracion 27298 > drafts/reply.mml
# Edit drafts/reply.mml, then send:
himalaya -c $CFG template send -a vega-administracion "$(cat drafts/reply.mml)"

# Forward
himalaya -c $CFG template forward -a vega-administracion 27298 > drafts/fwd.mml
# Edit drafts/fwd.mml (fill To:, add text/attachments), then send:
himalaya -c $CFG template send -a vega-administracion "$(cat drafts/fwd.mml)"
```

The generated templates include In-Reply-To/References headers for correct threading.

### Chain commands to reduce auths

When searching across accounts, chain with `&&` in a single command:

```bash
himalaya -c $CFG envelope list -a vega-marketing -s 10 from example && himalaya -c $CFG envelope list -a vega-administracion -s 10 from example
```

This still requires one auth per invocation, but runs them back-to-back without needing to send separate commands.

## Accounts

| Name | Email | Default |
|---|---|---|
| `vega-marketing` | marketing@vegaconsultores.es | yes |
| `vega-administracion` | administracion@vegaconsultores.es | no |
| `vega-antonvazquez` | antonvazquez@vegaconsultores.es | no |

## IMAP folders

| Alias | Real name |
|---|---|
| inbox | INBOX |
| sent | INBOX.Elementos enviados |
| drafts | INBOX.Borrador |
| trash | INBOX.Papelera |
| spam | INBOX.Spam |

## Contacts

Collaborator contacts are stored in `~/Vegaconsultores/himalaya/contactos-colaboradores.vcf` — a **vCard 3.0** file (one `BEGIN:VCARD … END:VCARD` block per person, CRLF line endings). Read it before composing emails to get the right addresses.

- A contact can have **several** `EMAIL` / `TEL` lines. The one tagged `pref` (e.g. `EMAIL;TYPE=work,pref:`) is the preferred address — use it by default.
- `ORG` is the company, `NICKNAME` is the CRM alias, `CATEGORIES` is the role.
- When editing, keep CRLF line endings and `VERSION:3.0`. Validate with `nix run nixpkgs#vcard -- contactos-colaboradores.vcf` (compound Spanish names trigger harmless "split name" warnings; exit code 0 = valid).

## Gotchas

- **NixOS shebangs**: use `#!/usr/bin/env bash`, never `#!/bin/bash`.
- **Large output**: `kitty-ctx diff` saves to a temp file when output exceeds 150 lines. Read the temp file with the Read tool.
- **Credentials are sensitive**: never read or display password output. Only send keepassxc-cli commands to the interactive terminal, never capture their stdout.
