#!/usr/bin/env bash
# 09 — Utilitários: permissões de sandbox e gerenciador de AppImage.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

flatpak_install \
  com.github.tchx84.Flatseal \
  it.mijorus.gearlever

ok "Utilitários prontos."
