#!/usr/bin/env bash
# 03 — Repositório Flathub.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

command -v flatpak >/dev/null 2>&1 \
  || die "flatpak não instalado. Instale com: sudo apt install flatpak"

if flatpak remotes --columns=name 2>/dev/null | grep -Fxq flathub; then
  ok "Flathub já está configurado."
else
  log "Adicionando o repositório Flathub..."
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  ok "Flathub configurado."
fi
