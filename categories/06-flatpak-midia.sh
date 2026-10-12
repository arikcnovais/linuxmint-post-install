#!/usr/bin/env bash
# 06 — Mídia e entretenimento (Flatpak).
# FreeTube é software livre (GPL) e independente.
# Fora por padrão: Spotube e outros clientes ligados a serviços de streaming.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

flatpak_install io.freetubeapp.FreeTube

ok "FreeTube instalado."
