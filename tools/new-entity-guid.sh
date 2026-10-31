#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/entity-common.sh"
if [[ ${1:-} == --help || $# -lt 2 ]]; then
	printf '%s\n' 'Usage: bash tools/new-entity-guid.sh field-types|snippets CATALOG_DIR [LOCAL_REPO ...]' 'Generate a secure UUIDv4 absent from core, all additional catalog indexes, and local' 'working indexes. Requires a complete domain catalog fetched within 24 hours.' 'Existing-item updates and intentional overrides keep their GUID; do not allocate one.' 'Snippets check both snippet and snippet_type identities. Prints one candidate only.'
	[[ ${1:-} == --help ]] && exit 0; exit 2
fi
entity_domain "$1"; catalog=$(realpath -e -- "$2"); shift 2
check_entity_catalog "$catalog"; fresh_entity_catalog "$catalog"
work=$(mktemp -d); trap 'rm -rf -- "$work"' EXIT
entity_catalog_entries "$catalog" > "$work/entries.jsonl"
for repository in "$@"; do
	local_entity_entries "$(realpath -e -- "$repository")" > "$work/local.jsonl"
	check_local_entity_identities "$work/local.jsonl"
	cat "$work/local.jsonl" >> "$work/entries.jsonl"
done
jq -r '.guid' "$work/entries.jsonl" > "$work/guids"
for ((attempt=0; attempt<10; attempt++)); do
	if [[ -r /proc/sys/kernel/random/uuid ]]; then read -r guid < /proc/sys/kernel/random/uuid
	else
		need openssl; hex=$(openssl rand -hex 16); variant=$(printf '%x' "$(( (16#${hex:16:1} & 3) | 8 ))")
		guid="${hex:0:8}-${hex:8:4}-4${hex:13:3}-${variant}${hex:17:3}-${hex:20:12}"
	fi
	[[ $guid =~ ^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$ ]] || fail 'Random source returned malformed UUIDv4'
	if ! grep -Fqx -- "$guid" "$work/guids"; then printf '%s\n' "$guid"; exit 0; fi
done
fail 'Repeated UUID collisions; inspect random source'
