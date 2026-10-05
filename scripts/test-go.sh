#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
command -v go >/dev/null
export GOCACHE="${GOCACHE:-/tmp/echo-guide-go-cache}"
for folder in exercises/02-go-multistage/api reference-solutions/02-go-multistage/api; do
  (cd "$root/$folder" && go test ./...)
done
