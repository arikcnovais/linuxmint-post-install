#!/usr/bin/env bash
# 02 — Firewall (ufw) e regras opcionais de rede local.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

ensure_sudo
apt_install ufw

if sudo ufw status | grep -q '^Status: active'; then
  ok "ufw já está ativo."
else
  sudo ufw --force enable
  ok "ufw ativado."
fi

# Warpinator / KDE Connect usam as portas 1714:1764. Libere com:
#   LOCAL_SHARE=1 ./setup.sh seguranca
if [ "${LOCAL_SHARE:-0}" = "1" ]; then
  log "Liberando 1714:1764/udp e /tcp (Warpinator / KDE Connect) na rede local..."
  sudo ufw allow 1714:1764/udp
  sudo ufw allow 1714:1764/tcp
  ok "Transferência local liberada."
else
  warn "Transferência local (Warpinator/KDE Connect) NÃO liberada."
  warn "Para liberar: LOCAL_SHARE=1 bash categories/02-seguranca.sh"
fi
