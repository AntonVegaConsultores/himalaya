# Himalaya — Correo de Vega Consultores

Configuración de [himalaya](https://github.com/pimalaya/himalaya) para gestionar las cuentas de correo de Vega Consultores desde la terminal.

## Cuentas configuradas

| Cuenta | Email | Default |
|---|---|---|
| `vega-marketing` | marketing@vegaconsultores.es | sí |
| `vega-administracion` | administracion@vegaconsultores.es | no |
| `vega-antonvazquez` | antonvazquez@vegaconsultores.es | no |

Todas conectan al mismo servidor IMAP/SMTP (`serv328.controldeservidor.com`).

## Requisitos

- himalaya CLI
- YubiKey conectada
- Base de datos KeePassXC (`pass-verde.kdbx`) **abierta** en KeePassXC
- Entradas en la kdbx: `mail/vega-marketing`, `mail/vega-administracion`, `mail/vega-antonvazquez`

## Autenticación

Las contraseñas se obtienen de KeePassXC vía `keepass-unlock.sh`, un wrapper que muestra un prompt visible antes de pedir credenciales:

```
🔐 Introduce contraseña + YubiKey para: mail/vega-marketing
```

Sin este wrapper, keepassxc-cli pide la contraseña en silencio y no queda claro cuándo hay que interactuar.

## Uso básico

Todos los comandos usan `-c` para apuntar a este config:

```bash
CFG=~/Vegaconsultores/himalaya/config.toml
```

### Listar correos recientes

```bash
himalaya -c $CFG envelope list -s 20
```

Con otra cuenta:

```bash
himalaya -c $CFG envelope list -a vega-administracion -s 20
```

> **Nota:** el flag `-a` va después del subcomando (`envelope list`), no antes.

### Listar correos en otra carpeta

```bash
himalaya -c $CFG envelope list -f "INBOX.Elementos enviados" -s 10
```

### Buscar correos por remitente, destinatario o asunto

```bash
himalaya -c $CFG envelope list -s 20 from usuario@ejemplo.com
himalaya -c $CFG envelope list -s 20 subject "Kit Digital"
himalaya -c $CFG envelope list -s 20 from foo or from bar
```

### Leer correos

Un correo:

```bash
himalaya -c $CFG message read 27298
```

Varios correos a la vez (una sola autenticación):

```bash
himalaya -c $CFG message read 27298 27293 27279
```

Esto es preferible a leerlos uno a uno ya que **cada invocación de himalaya requiere autenticación**.

### Enviar correos con adjuntos

Himalaya tiene dos comandos de envío:
- `template send` — recibe MML (formato legible con headers + body + tags `<#part>`), lo compila a MIME y lo envía. Para componer correos.
- `message send` — recibe MIME crudo ya construido (formato RFC822). Para reenviar `.eml` exportados o integrar con herramientas que generan MIME.

Al componer correos usar siempre `template send`.

1. Crear un fichero MML en `drafts/`:

```
From: administracion@vegaconsultores.es
To: destinatario@ejemplo.com
Cc: copia@ejemplo.com
Subject: Asunto del correo

Cuerpo del mensaje aquí.

<#part filename=/ruta/absoluta/al/adjunto.zip><#/part>
```

2. Enviar:

```bash
himalaya -c $CFG template send -a vega-administracion "$(cat drafts/mi-correo.mml)"
```

> **Importante:** usar `"$(cat archivo)"` en lugar de `< archivo` para que stdin quede libre para la autenticación interactiva de keepassxc-cli.

> **Nota:** `template send` pide autenticación dos veces (IMAP para guardar copia en enviados + SMTP para enviar).

### Enviar varios correos en lote

Crear un script que encadene los envíos. Cada uno requerirá dos autenticaciones (IMAP + SMTP):

```bash
#!/usr/bin/env bash
CFG=~/Vegaconsultores/himalaya/config.toml
himalaya -c "$CFG" template send -a vega-administracion "$(cat drafts/mail-1.mml)"
himalaya -c "$CFG" template send -a vega-administracion "$(cat drafts/mail-2.mml)"
```

### Responder o reenviar un correo

Por defecto usar el flujo `template` (generar → editar fichero → enviar). `message reply/forward` abre `$EDITOR` interactivamente — útil si se quiere editar a mano, pero no es el flujo habitual.

```bash
# Responder (añadir -A para reply-all)
himalaya -c $CFG template reply -a vega-administracion 27298 > drafts/reply.mml
# Editar drafts/reply.mml, luego enviar:
himalaya -c $CFG template send -a vega-administracion "$(cat drafts/reply.mml)"

# Reenviar
himalaya -c $CFG template forward -a vega-administracion 27298 > drafts/fwd.mml
# Editar drafts/fwd.mml (rellenar To:, añadir texto/adjuntos), luego enviar:
himalaya -c $CFG template send -a vega-administracion "$(cat drafts/fwd.mml)"
```

Las plantillas generadas incluyen los headers `In-Reply-To` y `References` para enhebrar correctamente.

## Estructura del repositorio

```
.
├── config.toml                  # Configuración de cuentas himalaya
├── keepass-unlock.sh            # Wrapper de autenticación con prompt visible
├── drafts/                      # Borradores de correos (gitignored)
│   └── *.mml
├── contactos-colaboradores.csv  # Directorio de contactos (gitignored)
├── .gitignore
└── README.md
```

## Fichero de contactos

`contactos-colaboradores.csv` no se versiona (contiene datos personales). Su estructura es:

```csv
empresa,alias,contacto,email,telefono,rol,principal
NOMBRE EMPRESA,ALIAS CRM,Nombre Persona,email@ejemplo.com,+34 XXX XXX XXX,colaborador,si
```

- **empresa**: nombre real de la empresa
- **alias**: nombre con el que se conoce en el CRM (puede diferir del nombre real)
- **contacto**: nombre de la persona (vacío para emails genéricos)
- **email**: una fila por cada dirección de email
- **telefono**: con prefijo +34
- **rol**: `colaborador`, `cliente`, etc.
- **principal**: `si` para el email preferente de contacto, `no` para el resto

## Carpetas IMAP

| Alias | Carpeta real |
|---|---|
| inbox | INBOX |
| sent | INBOX.Elementos enviados |
| drafts | INBOX.Borrador |
| trash | INBOX.Papelera |
| spam | INBOX.Spam |
