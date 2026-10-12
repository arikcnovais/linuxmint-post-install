#!/usr/bin/env bash
#
# lib/common.sh — funções auxiliares compartilhadas.
# Carregado via `source` pelos scripts de categoria. Não execute direto.

set -euo pipefail

if [ -t 1 ]; then
  C_RESET=$'\033[0m'
  C_BLUE=$'\033[1;34m'
  C_GREEN=$'\033[1;32m'
  C_YELLOW=$'\033[1;33m'
  C_RED=$'\033[1;31m'
else
  C_RESET='' C_BLUE='' C_GREEN='' C_YELLOW='' C_RED=''
fi

log()  { printf '%s==>%s %s\n'  "$C_BLUE"   "$C_RESET" "$*"; }
ok()   { printf '%s ok %s %s\n' "$C_GREEN"  "$C_RESET" "$*"; }
warn() { printf '%s  ! %s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
die()  { printf '%s  x %s %s\n' "$C_RED"    "$C_RESET" "$*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# sudo
# ---------------------------------------------------------------------------

require_not_root() {
  [ "$(id -u)" -ne 0 ] || die "Não rode como root. O script chama sudo quando necessário."
}

ensure_sudo() {
  require_not_root
  command -v sudo >/dev/null 2>&1 || die "sudo não encontrado."
  sudo -v || die "Não foi possível autenticar com sudo."
  # Mantém o timestamp do sudo válido enquanto o script roda.
  ( while true; do sudo -n true 2>/dev/null || true; sleep 50; done ) &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
}

# ---------------------------------------------------------------------------
# apt
# ---------------------------------------------------------------------------

__APT_UPDATED=""

apt_update() {
  if [ -z "$__APT_UPDATED" ]; then
    log "Atualizando listas de pacotes (apt update)..."
    sudo apt-get update
    __APT_UPDATED=1
  fi
}

apt_install() {
  apt_update
  log "Instalando via apt: $*"
  sudo apt-get install -y --no-install-recommends "$@"
}

# ---------------------------------------------------------------------------
# flatpak
# ---------------------------------------------------------------------------

flatpak_installed() {
  flatpak list --app --columns=application 2>/dev/null | grep -Fxq "$1"
}

flatpak_install() {
  command -v flatpak >/dev/null 2>&1 \
    || die "flatpak não está instalado. Rode a categoria 'flathub' ou: sudo apt install flatpak"

  local pendentes=() app
  for app in "$@"; do
    if flatpak_installed "$app"; then
      ok "$app já instalado — pulando."
    else
      pendentes+=("$app")
    fi
  done

  if [ "${#pendentes[@]}" -eq 0 ]; then
    return 0
  fi

  log "Instalando via Flatpak: ${pendentes[*]}"
  flatpak install -y flathub "${pendentes[@]}"
}
