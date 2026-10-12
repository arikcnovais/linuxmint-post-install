#!/usr/bin/env bash
# 04 — Comunicação (Flatpak).
# Só software livre: o cliente oficial do Telegram.
#
# Fora por padrão:
#   - Thunderbird: já vem nativo no Mint.
#   - Vesktop/Discord e afins: dependem de serviços proprietários.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

flatpak_install org.telegram.desktop

ok "Telegram instalado."
