#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
[[ ${1:-} =~ ^echo-guide-(basic|multistage)-[0-9]+-[0-9]+$ ]] || { echo "Nome de projeto inválido." >&2; exit 2; }
case "${1:-}" in
  echo-guide-basic-[0-9]*-[0-9]*) example=01-basic-compose ;;
  echo-guide-multistage-[0-9]*-[0-9]*) example=02-multistage-web ;;
  *) echo "Uso: $0 NOME_DO_PROJETO impresso pelo validador (echo-guide-basic-TIMESTAMP-PID ou multistage)." >&2; exit 2 ;;
esac
command -v docker >/dev/null
docker compose version >/dev/null
docker info >/dev/null
# Nome exato limita a limpeza ao projeto explicitamente escolhido.
docker compose -f "$root/examples/$example/compose.yaml" -p "$1" down
