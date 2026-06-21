#!/usr/bin/env bash
# Wrapper para keepassxc-cli que muestra un prompt visible al usuario
ENTRY="$1"
# Ruta de la kdbx: override con $PASS_VERDE_KDBX; por defecto, bajo $HOME.
KDBX="${PASS_VERDE_KDBX:-$HOME/GDrive/Personal/Secrets/pass-verde.kdbx}"
echo -e "\n🔐 Introduce contraseña + YubiKey para: $ENTRY" > /dev/tty
keepassxc-cli show -s -a Password -y 2 "$KDBX" "$ENTRY"
