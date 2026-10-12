#!/usr/bin/env bash
# 07 — Jogos e emulação (Flatpak).
# Software livre e independente de lojas proprietárias:
#   - Prism Launcher: launcher de Minecraft (livre, suporta contas offline).
#   - RetroArch: frontend de emulação.
# O gamemode entra via apt na categoria 'apt'.
#
# Fora por padrão: Lutris e outros launchers que dependem de lojas/clientes
# proprietários (Steam, Epic, Battle.net etc.).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

flatpak_install \
  org.prismlauncher.PrismLauncher \
  org.libretro.RetroArch

ok "Suporte a jogos e emulação pronto."
