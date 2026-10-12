#!/usr/bin/env bash
# 12 — Limpeza de pacotes residuais.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

ensure_sudo

log "Removendo dependências órfãs do apt..."
sudo apt-get autoremove -y
sudo apt-get autoclean

if command -v flatpak >/dev/null 2>&1; then
  log "Removendo runtimes Flatpak não utilizados..."
  flatpak uninstall --unused -y || warn "Nada para remover ou flatpak indisponível."
fi

ok "Limpeza concluída."
