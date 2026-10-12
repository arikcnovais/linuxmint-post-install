#!/usr/bin/env bash
# 10 — Ferramentas de linha de comando via apt.
# Sem duplicar o que o Mint já traz: curl, wget e neofetch foram removidos
# (os dois primeiros já vêm no sistema; o neofetch está abandonado).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

ensure_sudo
apt_install \
  git \
  htop \
  p7zip-full \
  unrar \
  build-essential \
  neovim \
  gamemode

ok "Ferramentas instaladas (inclui neovim e gamemode)."
log "Dica: ative o GameMode por jogo (ex.: Prism Launcher/Steam) para priorizar CPU/GPU."
