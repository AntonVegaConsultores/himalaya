# `firmar-justificacion-kit-digital.mml` — notas

Indica al beneficiario los pasos para firmar una **justificación** en la sede de
Red.es (espacioPyme). Sirve igual para **Fase 1** y **Fase 2** (los pasos de firma
son los mismos); solo cambia el número de fase. Úsala cuando la justificación ya
está subida y figura *pendiente de conformidad/firma de la PYME*.

## Marcadores

| Marcador | Qué poner | Ejemplo |
|---|---|---|
| `{{NOMBRE}}` | Nombre de pila del beneficiario / persona de contacto | `José Ángel` |
| `{{EMAIL_BENEFICIARIO}}` | Email destino | `consultoria@ceyges.com` |
| `{{FASE}}` | Número de fase a firmar (`1` o `2`) | `2` |
| `{{SOLUCION}}` | Categoría/solución KD | `Puesto de Trabajo Seguro` |
| `{{COD_JUSTIFICACION}}` | **Código de justificación** (con sufijo de fase; sale 2 veces) | `KD/0000825844-002` |
| `{{NUM_ACUERDO}}` | **Número de acuerdo** base, sin sufijo (sale 2 veces) | `KD/0000825844` |
| `{{NOMBRE_EMPRESA}}` | Beneficiario titular del certificado (sale 2 veces) | `Ceyges Consultoría e Intermediación, S.L.` |

## Notas

- **Código de justificación vs Número de acuerdo (para que no se líe al buscarla).**
  En la sede de Red.es cada justificación muestra dos campos:
  - *Código de justificación* → lleva sufijo de fase: `-001` = Fase 1, `-002` = Fase 2
    (p. ej. `KD/0000825844-001` es la Fase 1 y `KD/0000825844-002` la Fase 2).
  - *Número de acuerdo* → el código base **sin sufijo** (`KD/0000825844`), que es el
    **mismo para ambas fases**.

  Por eso el beneficiario debe localizar la justificación por su **Código de
  justificación** (`{{COD_JUSTIFICACION}}`): si solo se guía por el Número de acuerdo
  puede liarse y no dar con la correcta cuando le aparezcan las dos. Rellena
  `{{COD_JUSTIFICACION}}` con el sufijo correcto según `{{FASE}}`.
- **Certificado correcto = el dato crítico.** El error más típico es que el
  cliente entre con un certificado personal cuando el beneficiario es una empresa:
  entonces *no le aparece ningún acuerdo para firmar*. La plantilla ya lo avisa,
  pero recuérdalo: debe usar el certificado de `{{NOMBRE_EMPRESA}}`.
- **Autónomos:** si el beneficiario es persona física, `{{NOMBRE_EMPRESA}}` es su
  propio nombre y el certificado es el personal; el aviso sigue siendo válido.
- **Variante URGENTE (plazo cercano):** si el plazo aprieta, antepón `URGENTE – `
  al asunto y añade en el cuerpo la fecha límite (p. ej. "el plazo vence el
  viernes 26/06"). No dejes una fecha fija en el boilerplate, que se queda obsoleta.
- **Diferencia Fase 1 / Fase 2:** los pasos de firma son idénticos; cambia
  `{{FASE}}` y el sufijo de `{{COD_JUSTIFICACION}}` (`-001` / `-002`). (El resto del
  ciclo —factura/IVA en Fase 1, etc.— va en otras plantillas/correos, no en esta.)
- **Cc colaboradores (opcional):** igual que en la plantilla de factura, añade
  una línea `Cc:` tras `To:` si el expediente lo gestiona un colaborador.
