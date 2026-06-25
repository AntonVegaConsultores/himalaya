# boilerplates — textos base reutilizables de correo

Plantillas de correo **reutilizables** (boilerplate), en formato MML, para no
reescribir desde cero los envíos recurrentes. A diferencia de `drafts/` (cajón
efímero de borradores concretos, **gitignored**), esta carpeta **sí se versiona**.

No confundir con el comando `template` de himalaya (que es la composición de un
mensaje MML concreto). Aquí guardas el *boilerplate*; luego lo rellenas y el
resultado se manda con `himalaya … template send`.

## Convención: cada plantilla lleva su doc al lado

Cada boilerplate son **dos ficheros con el mismo nombre base**:

- `<nombre>.mml` — la plantilla con marcadores `{{...}}`.
- `<nombre>.md` — sus notas operativas: qué hace, tabla de marcadores y avisos.

Así las notas viven pegadas a su plantilla y se versionan juntas; no hay una
lista central que mantener. **Para ver qué plantillas hay, lista el directorio**
(`ls boilerplates/*.mml`) y abre el `.md` homónimo de la que te interese.

> No mantengas aquí un índice de plantillas: se desincroniza. El directorio es
> el índice.

## Flujo de uso

1. Copia el boilerplate a `drafts/` con un nombre concreto:
   ```bash
   cp boilerplates/<nombre>.mml drafts/<algo-concreto>.mml
   ```
2. Sustituye los marcadores `{{...}}` por los datos reales (los tienes
   documentados en `boilerplates/<nombre>.md`).
3. Envía (pide auth IMAP + SMTP):
   ```bash
   CFG=~/Vegaconsultores/himalaya/config.toml
   himalaya -c "$CFG" template send -a vega-administracion "$(cat drafts/<algo-concreto>.mml)"
   ```

## Añadir una plantilla nueva

Crea el par `<nombre>.mml` + `<nombre>.md`. No hay que tocar este README.
