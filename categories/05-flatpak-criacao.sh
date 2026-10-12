#!/usr/bin/env bash
# 06 — Criação e edição gráfica/vídeo (Flatpak).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

flatpak_install \
  org.gimp.GIMP \
  org.inkscape.Inkscape \
  com.obsproject.Studio \
  org.kde.kdenlive

ok "Suíte de criação pronta."
