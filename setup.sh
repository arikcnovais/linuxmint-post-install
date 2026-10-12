#!/usr/bin/env bash
#
# setup.sh — orquestrador do roteiro de pós-instalação do Linux Mint 22.3.
#
#   ./setup.sh                 abre o menu interativo
#   ./setup.sh all             executa todas as categorias na ordem
#   ./setup.sh jogos           executa uma categoria
#   ./setup.sh apt jogos       executa várias
#   ./setup.sh --list          lista as categorias
#
# Cada categoria também pode ser executada sozinha, ex.:
#   bash categories/11-artcraft.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CATS="$ROOT/categories"
source "$ROOT/lib/common.sh"

ORDER=(sistema seguranca flathub comunicacao criacao midia jogos utilitarios apt artcraft limpeza)

declare -A DESCRICAO=(
  [sistema]="Atualiza o sistema e instala os codecs de mídia"
  [seguranca]="Ativa o firewall (ufw)"
  [flathub]="Registra o repositório Flathub"
  [comunicacao]="Telegram"
  [criacao]="GIMP, Inkscape, OBS Studio e Kdenlive"
  [midia]="FreeTube"
  [jogos]="Prism Launcher e RetroArch"
  [utilitarios]="Flatseal e Gear Lever"
  [apt]="git, htop, 7zip, unrar, build-essential, neovim e gamemode"
  [artcraft]="Baixa o ArtCraft Launcher (AppImage) e integra pelo Gear Lever"
  [limpeza]="Remove pacotes órfãos (apt + flatpak)"
)

declare -A SCRIPT=(
  [sistema]="01-sistema.sh"
  [seguranca]="02-seguranca.sh"
  [flathub]="03-flathub.sh"
  [comunicacao]="04-flatpak-comunicacao.sh"
  [criacao]="05-flatpak-criacao.sh"
  [midia]="06-flatpak-midia.sh"
  [jogos]="07-flatpak-jogos.sh"
  [utilitarios]="08-flatpak-utilitarios.sh"
  [apt]="09-apt-ferramentas.sh"
  [artcraft]="10-artcraft.sh"
  [limpeza]="11-limpeza.sh"
)

mostrar_lista() {
  echo "Categorias disponíveis:"
  echo
  local i=1 slug
  for slug in "${ORDER[@]}"; do
    printf '  %2d) %-12s %s\n' "$i" "$slug" "${DESCRICAO[$slug]}"
    i=$((i + 1))
  done
  echo "       all          Executa todas na ordem acima"
  echo
}

run_cat() {
  local slug="$1"
  local file="${SCRIPT[$slug]:-}"

  if [ -z "$file" ]; then
    die "Categoria desconhecida: '$slug'. Use --list para ver as opções."
  fi
  if [ ! -f "$CATS/$file" ]; then
    die "Script não encontrado: $CATS/$file"
  fi

  printf '\n%s━━━ %s — %s %s━━━\n' "$C_BLUE" "$slug" "${DESCRICAO[$slug]}" "$C_RESET"
  if bash "$CATS/$file"; then
    ok "Categoria '$slug' concluída."
  else
    warn "Categoria '$slug' terminou com erro (código $?)."
    FALHAS=$((FALHAS + 1))
  fi
}

menu() {
  mostrar_lista
  read -r -p "Escolha (números separados por espaço, ou 'all'): " escolha

  if [ "$escolha" = "all" ]; then
    ALVOS=("${ORDER[@]}")
  else
    ALVOS=()
    local n slug
    for n in $escolha; do
      if [[ "$n" =~ ^[0-9]+$ ]]; then
        if [ "$n" -ge 1 ] && [ "$n" -le "${#ORDER[@]}" ]; then
          slug="${ORDER[$((n - 1))]}"
          ALVOS+=("$slug")
        else
          warn "Número fora do intervalo, ignorando: $n"
        fi
      else
        ALVOS+=("$n")
      fi
    done
  fi
}

ALVOS=()
FALHAS=0

case "${1:-}" in
  "" )           menu ;;
  -h|--help)     mostrar_lista; exit 0 ;;
  --list)        mostrar_lista; exit 0 ;;
  all)           ALVOS=("${ORDER[@]}") ;;
  * )            ALVOS=("$@") ;;
esac

if [ "${#ALVOS[@]}" -gt 0 ]; then
  for slug in "${ALVOS[@]}"; do
    run_cat "$slug"
  done
fi

echo
if [ "$FALHAS" -eq 0 ]; then
  ok "Tudo pronto. Reinicie a sessão (ou o sistema) para concluir."
else
  warn "$FALHAS categoria(s) falharam — veja o log acima."
fi
