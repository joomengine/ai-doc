#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
exec bash "$TOOLS_DIR/lib/validate-entity-repository.sh" snippets "$@"
