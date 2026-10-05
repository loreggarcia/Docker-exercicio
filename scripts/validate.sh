#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
case "${1:-}" in
  basic) example=01-basic-compose ;;
  multistage) example=02-multistage-web ;;
  *) echo "Uso: $0 basic|multistage" >&2; exit 2 ;;
esac
for tool in docker curl python3; do
  command -v "$tool" >/dev/null || { echo "Ferramenta ausente: $tool" >&2; exit 1; }
done
docker compose version >/dev/null
docker info >/dev/null || { echo "Daemon Docker inacessível; execução não realizada." >&2; exit 1; }
compose=(docker compose -f "$root/examples/$example/compose.yaml")
"${compose[@]}" config --quiet
# Verifica antes de criar recursos; uma corrida posterior será reportada pelo Compose.
python3 - <<'CHECK'
import socket
with socket.socket() as s:
    try: s.bind(('0.0.0.0', 8080))
    except OSError as error:
        raise SystemExit(f'Porta 8080 indisponível: {error}. Nenhum processo será encerrado.')
CHECK
project="echo-guide-${1}-$(date +%s)-$$"
compose+=(-p "$project")
if [[ -n $("${compose[@]}" ps -aq) ]]; then
  echo "Projeto $project já existe; recusando alterar recursos existentes." >&2; exit 1
fi
tmp=$(mktemp -d)
started=0
finish() {
  status=$?
  trap - EXIT
  set +e
  if (( status != 0 && started == 1 )); then
    "${compose[@]}" ps -a
    "${compose[@]}" logs --tail=100
  fi
  if (( started == 1 )); then
    "${compose[@]}" down --remove-orphans
    cleanup_status=$?
    if (( status == 0 && cleanup_status != 0 )); then status=$cleanup_status; fi
  fi
  rm -rf "$tmp"
  exit "$status"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
echo "Projeto isolado: $project"
started=1
"${compose[@]}" up --build -d
ready=0
deadline=$((SECONDS + 60))
while (( SECONDS < deadline )); do
  if curl --silent --fail --max-time 2 http://localhost:8080/api/health -o "$tmp/health.json"; then ready=1; break; fi
  sleep 2
done
(( ready == 1 )) || { echo "Saúde não disponível na janela de espera de 60 segundos." >&2; exit 1; }
python3 - "$tmp/health.json" <<'CHECK'
import json,sys
assert json.load(open(sys.argv[1])) == {'status':'ok','service':'api'}
CHECK
code=$(curl --silent --show-error --max-time 5 -o "$tmp/echo.json" -w '%{http_code}' http://localhost:8080/api/echo -H 'Content-Type: application/json' -d '{"message":"Hello Docker"}')
[[ "$code" == 200 ]] || { echo "Echo válido retornou $code" >&2; exit 1; }
python3 - "$tmp/echo.json" <<'CHECK'
import json,sys
assert json.load(open(sys.argv[1])) == {'message':'Hello Docker'}
CHECK
for body in '{"message":""}' '{' 'null' '[]' '{"message":42}'; do
  code=$(curl --silent --show-error --max-time 5 -o "$tmp/error.json" -w '%{http_code}' http://localhost:8080/api/echo -H 'Content-Type: application/json' -d "$body")
  [[ "$code" == 400 ]] || { echo "Entrada inválida retornou $code" >&2; exit 1; }
  python3 - "$tmp/error.json" <<'CHECK'
import json,sys
assert isinstance(json.load(open(sys.argv[1])).get('error'), str)
CHECK
done
code=$(curl --silent --show-error --max-time 5 -X POST -o "$tmp/error.json" -w '%{http_code}' http://localhost:8080/api/echo)
[[ "$code" == 400 ]]
python3 - "$tmp/error.json" <<'CHECK'
import json,sys
assert isinstance(json.load(open(sys.argv[1])).get('error'), str)
CHECK
curl --silent --show-error --fail --max-time 5 http://localhost:8080/ -o "$tmp/index.html"
python3 - "$tmp/index.html" <<'CHECK'
import sys
assert 'Echo App' in open(sys.argv[1]).read()
CHECK
"${compose[@]}" ps
"${compose[@]}" config --format json > "$tmp/compose.json"
python3 - "$tmp/compose.json" <<'CHECK'
import json,sys
services=json.load(open(sys.argv[1]))['services']
assert not services['api'].get('ports')
assert services['frontend']['ports'][0]['target']==80
CHECK
echo 'PASSOU: saúde, página, contrato válido, erros 400 e publicação delimitada.'
