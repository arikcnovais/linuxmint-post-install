#!/usr/bin/env bash
# 11 — ArtCraft Launcher (AppImage) + integração no menu via Gear Lever.
#
# Baixa o AppImage Linux mais recente direto do GitHub oficial
# (github.com/storytold/craft-launcher), confere o SHA-256 publicado na
# release e integra no menu de aplicativos com o Gear Lever.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

command -v curl >/dev/null 2>&1 || die "curl não encontrado."

DEST="$HOME/Applications"
ALVO="$DEST/ArtCraft-Launcher.AppImage"
mkdir -p "$DEST"

case "$(uname -m)" in
  x86_64 | amd64) ARCH=x86_64 ;;
  aarch64 | arm64) ARCH=aarch64 ;;
  *) die "Arquitetura não suportada: $(uname -m)" ;;
esac

log "Consultando o último release do ArtCraft Launcher (linux-$ARCH)..."
META="$(curl -fsSL https://api.github.com/repos/storytold/craft-launcher/releases/latest \
  | python3 -c '
import json, sys
arch = sys.argv[1]
data = json.load(sys.stdin)
for asset in data.get("assets", []):
    if asset["name"].endswith("linux-%s.AppImage" % arch):
        print(asset["browser_download_url"])
        print(asset.get("digest") or "")
        break
' "$ARCH")"

URL="$(printf '%s\n' "$META" | sed -n '1p')"
SHA="$(printf '%s\n' "$META" | sed -n '2p' | sed 's/^sha256://')"
[ -n "$URL" ] || die "Não encontrei o asset linux-$ARCH.AppImage no último release."

log "Baixando $URL"
curl -fL --progress-bar -o "$ALVO.part" "$URL"

if [ -n "$SHA" ]; then
  if printf '%s  %s\n' "$SHA" "$ALVO.part" | sha256sum -c - >/dev/null 2>&1; then
    ok "Checksum SHA-256 verificado."
  else
    rm -f "$ALVO.part"
    die "Checksum inválido — download descartado."
  fi
else
  warn "A release não informou SHA-256; seguindo sem verificação."
fi

mv -f "$ALVO.part" "$ALVO"
chmod +x "$ALVO"
ok "AppImage salvo em $ALVO"

# --- Integração no menu de aplicativos (Gear Lever) ---
if flatpak_installed it.mijorus.gearlever; then
  log "Integrando no menu de aplicativos pelo Gear Lever..."
  if flatpak run it.mijorus.gearlever --integrate "$ALVO"; then
    ok "Integração concluída — procure por 'ArtCraft' no menu."
  else
    warn "O Gear Lever não integrou automaticamente. Abra o Gear Lever e"
    warn "arraste o arquivo para a janela: $ALVO"
  fi
else
  warn "Gear Lever não está instalado. Rode a categoria 'utilitarios' e"
  warn "execute esta categoria de novo, ou integre manualmente com:"
  warn "  flatpak run it.mijorus.gearlever --integrate \"$ALVO\""
fi
