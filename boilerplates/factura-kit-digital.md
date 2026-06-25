# `factura-kit-digital.mml` — notas

Envío de la factura de Kit Digital al beneficiario, pidiendo el pago del IVA y,
a ser posible, el justificante de la transferencia. Adjunta el PDF y el `.xsig`.

## Marcadores

| Marcador | Qué poner | Ejemplo |
|---|---|---|
| `{{NOMBRE}}` | Nombre de pila del beneficiario | `Imanol` |
| `{{EMAIL_BENEFICIARIO}}` | Email destino | `imaizagi@gmail.com` |
| `{{NUM_FACTURA}}` | Nº de factura Odoo (sale 2 veces) | `2026/0033` |
| `{{SOLUCION}}` | Categoría/solución KD | `Sitio Web y Presencia Básica en Internet` |
| `{{IVA}}` | Importe del IVA en € (base × 21 %) | `420` |
| `{{RUTA_PDF}}` | Ruta absoluta del PDF | `/home/anton/Downloads/2026_0033.pdf` |
| `{{RUTA_XSIG}}` | Ruta absoluta del Facturae | `/home/anton/Vegaconsultores/plazosKD/odoo/facturae/facturae_2026-0033.xsig` |

## Notas

- **Cc colaboradores (opcional):** si el beneficiario lo gestiona un colaborador,
  añade una línea `Cc:` tras `To:`. Ej. 104Cubes:
  `Cc: patricia.garcia@104cubes.com, luis.garcia@104cubes.com`
- **IBAN:** cuenta Santander de Golden Eggs (`ES13 0049 0007 2029 1223 5246`).
  Verifícalo si cambia.
- **Variante "ya enviada":** si la factura ya se mandó antes y solo falta el
  justificante del pago del IVA, no uses esta plantilla tal cual: cambia el
  asunto a `Justificante del pago del IVA - Kit Digital` y el cuerpo para indicar
  que la factura ya se envió y que ahora solo se necesita el justificante.
