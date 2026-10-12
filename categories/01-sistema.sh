#!/usr/bin/env bash
# 01 — Atualização do sistema e codecs.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

ensure_sudo

log "Atualizando listas e aplicando upgrades do sistema base..."
sudo apt-get update
sudo apt-get upgrade -y

log "Garantindo os codecs de mídia proprietários (áudio/vídeo)..."
sudo apt-get install -y mint-meta-codecs

ok "Sistema atualizado e codecs instalados."
