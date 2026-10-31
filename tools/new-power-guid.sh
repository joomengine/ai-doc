#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/common.sh"
if [[ ${1:-} == --help || $# -lt 1 ]]; then
	printf '%s\n' 'Usage: bash tools/new-power-guid.sh CATALOG_DIR [LOCAL_REPO ...]' 'Generate a cryptographically random UUIDv4 absent from all seven official indexes' 'and each supplied working-repository index. Requires a complete live catalog no' 'older than 24 hours. This does not reserve the UUID or prove universal uniqueness.' 'Requires Linux /proc/sys/kernel/random/uuid or OpenSSL for randomness.'
	[[ ${1:-} == --help ]] && exit 0; exit 2
fi
catalog=$(realpath -e -- "$1"); shift
check_catalog "$catalog"
jq -e '.mode=="live" and (["joomengine/super-powers","joomengine/search","joomengine/psr","joomengine/phpseclib","joomengine/openai","joomengine/gitea","joomengine/minify"] - [.repositories[].id] | length==0)' "$catalog/manifest.json" >/dev/null || fail 'GUID creation requires a live catalog containing all seven official repositories'
created=$(jq -er '.created_at|fromdateiso8601' "$catalog/manifest.json") || fail 'Invalid catalog timestamp'
now=$(date -u +%s)
(( now >= created && now - created <= 86400 )) || fail 'Catalog is older than 24 hours or dated in the future; fetch it again'
for repository in "$@"; do validate_index "$repository/super-powers.json"; done
work=$(mktemp -d); trap 'rm -rf -- "$work"' EXIT
catalog_entries "$catalog" | jq -r '.guid' > "$work/used"
for repository in "$@"; do jq -r 'keys[]' "$repository/super-powers.json" >> "$work/used"; done
for ((attempt=0; attempt<10; attempt++)); do
	if [[ -r /proc/sys/kernel/random/uuid ]]; then
		read -r guid < /proc/sys/kernel/random/uuid
	else
		need openssl
		hex=$(openssl rand -hex 16)
		variant=$(printf '%x' "$(( (16#${hex:16:1} & 3) | 8 ))")
		guid="${hex:0:8}-${hex:8:4}-4${hex:13:3}-${variant}${hex:17:3}-${hex:20:12}"
	fi
	[[ $guid =~ ^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$ ]] || fail 'Random source did not produce a UUIDv4'
	if ! grep -Fqx -- "$guid" "$work/used"; then printf '%s\n' "$guid"; exit 0; fi
done
fail 'Repeated UUID collisions; inspect the random source'
