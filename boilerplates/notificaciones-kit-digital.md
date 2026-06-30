# `notificaciones-kit-digital.mml` — notas

Envío recurrente del **ZIP de notificaciones de Kit Digital** a un colaborador,
con el resumen de novedades de la tanda. Un correo por colaborador. Los ZIP los
genera el proyecto **plazosKD** (`processed_zone/notificaciones_<EMPRESA>.zip`,
uno por equipo); este boilerplate es solo el correo que los acompaña.

## Cuándo se usa

Tras correr el pipeline de plazosKD, cada `notificaciones_<EMPRESA>.zip` lleva
dentro un `notificaciones.csv` con una columna **`novedad`** (`sin cambios` /
`actualización` / `nueva`). **Solo se envía correo al colaborador que tenga al
menos una fila distinta de `sin cambios`.** Si todas son `sin cambios`, no se
manda nada esa tanda.

> Excepción Juan (TATO): no quiere recibir el ZIP. Si su CSV trae novedades, en
> vez de este correo se le mandan **indicaciones concretas de trabajo** (otro
> formato). Ver [Reparto por equipo] en el README de plazosKD.

## Marcadores

| Marcador | Qué poner | Ejemplo |
|---|---|---|
| `{{TO}}` | Destinatario(s) principal(es) | `Orión García <orion@estudiog404.com>` |
| `{{CC}}` | Copias (si no hay, **borra la línea `Cc:` entera**) | `jorge.javier.fajin@faconlead.com, info@gespronet.es` |
| `{{SALUDO}}` | Saludo | `Hola Orión,` · `Hola Patricia, hola Luis:` · `Hola:` |
| `{{FRASE_ADJUNTO}}` | Frase de apertura (ajusta singular/plural) | `Te adjunto el ZIP con el estado actual de las notificaciones de Kit Digital correspondientes a los expedientes que gestionas.` |
| `{{NOVEDADES}}` | Bloque de novedades (ver formato abajo) | — |
| `{{VERAS_VEREIS}}` | `verás` (singular) / `veréis` (plural) | `verás` |
| `{{CIERRE}}` | Frase de cierre | `Cualquier duda, me dices.` · `Cualquier duda, nos decís.` |
| `{{FIRMA}}` | Firma | `Antón` (corta) o el bloque completo de VEGA CONSULTORES |
| `{{RUTA_ZIP}}` | Ruta **absoluta** al ZIP | `/home/anton/Vegaconsultores/plazosKD/processed_zone/notificaciones_ORION.zip` |

## Formato del bloque `{{NOVEDADES}}`

Agrupa por tipo de novedad. Una línea por acuerdo, con la **fecha límite** de la
columna `fecha_limite` (no la de "expira", ver nota). Ejemplos:

```
Novedades respecto al último envío:

Nuevas:
- KD/0000482412 — Autos Godoy, S.L. (Sitio Web, Fase 1) — Requerimiento de documentación. Fecha límite: 27 de julio.
- KD/0000836931 — Maderas Laracha, S.L. (Sitio Web, Fase 2) — Aviso de vencimiento de justificación. Fecha límite para tener lista la justificación: 28 de julio.

Actualización:
- KD/0000811671 — Inmaculada Concepción Peña Fuciños (Sitio Web, Fase 2) — el aviso de vencimiento de justificación que anticipamos ya se ha abierto. Fecha límite para tener lista la justificación: 17 de julio.
```

Con una sola novedad, usa el singular: `Novedad respecto al último envío:` y una
única línea sin subtítulo.

## Notas

- **`nueva` vs `actualización`.** `nueva` = notificación que no estaba en envíos
  previos. `actualización` = una ya conocida que ha cambiado de estado (lo típico:
  un aviso que anticipamos y **ya se ha abierto**; redáctalo así).
- **Subsanación = acción del beneficiario.** Si el tipo es *Subsanación*, indícalo
  explícito ("hay que corregir y reenviar lo indicado en el documento"): no es un
  mero aviso, requiere trabajo.
- **Fecha límite ≠ "expira".** En el CSV, `estado_notificacion` puede traer
  `Pendiente (expira AAAA-MM-DD)`: esa fecha es cuándo la notificación se
  abre/acepta por silencio en sede, **no** el plazo para actuar. Para el correo usa
  siempre `fecha_limite` (el plazo real de justificación/respuesta).
- **Singular vs plural.** Colaborador individual → `te/gestionas/verás/me dices` +
  firma `Antón`. Equipo (104Cubes, FACONLEAD…) → `os/vuestra cartera/veréis/nos
  decís` + bloque de firma completo.
- **Destinatarios.** Sácalos de `contactos-colaboradores.vcf` (usa el `EMAIL`
  tagged `pref`). 104Cubes no está en el vcf: `patricia.garcia@104cubes.com`,
  `luis.garcia@104cubes.com`.
- **Sin `Cc`:** borra la línea `Cc:` entera del `.mml` (no la dejes vacía).

## Flujo

```bash
cp boilerplates/notificaciones-kit-digital.mml drafts/notif-<EMPRESA>-<fecha>.mml
# rellena los {{...}}; borra la línea Cc: si no hay copias
himalaya template send -a vega-administracion "$(cat drafts/notif-<EMPRESA>-<fecha>.mml)"
```
