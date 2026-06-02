#!/usr/bin/env bash
# Wrapper para keepassxc-cli que muestra un prompt visible al usuario
ENTRY="$1"
echo -e "\n🔐 Introduce contraseña + YubiKey para: $ENTRY" > /dev/tty
keepassxc-cli show -s -a Password -y 2 /home/anton/GDrive/Personal/Secrets/pass-verde.kdbx "$ENTRY"
