#!/usr/bin/env bash
# Shared routines; sourced by the public tools, never evaluate repository content.
set -euo pipefail
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || fail "Required command missing: $1"; }
for required_command in jq realpath sha256sum; do need "$required_command"; done
safe_file() {
	local root=$1 relative=$2 resolved
	[[ $relative != /* && $relative != *$'\n'* && $relative != *$'\r'* && $relative != *$'\t'* ]] || fail "Unsafe relative path: $relative"
	[[ ! $relative =~ (^|/)\.\.?(/|$) ]] || fail "Unsafe relative path: $relative"
	resolved=$(realpath -e -- "$root/$relative") || fail "Missing file: $root/$relative"
	[[ $resolved == "$root/"* && -f $resolved ]] || fail "File escapes repository or is not regular: $relative"
	printf '%s\n' "$resolved"
}
validate_index() {
	jq -e -s 'length==1' "$1" >/dev/null || fail "Expected one JSON document: $1"
	jq -e -f "$TOOLS_DIR/jq/index.jq" "$1" >/dev/null || fail "Invalid canonical power index: $1"
}
check_catalog() {
	local catalog=$1 row index_file checksum actual
	[[ -f $catalog/manifest.json ]] || fail "Missing catalog manifest: $catalog"
	jq -e -s 'length==1' "$catalog/manifest.json" >/dev/null || fail 'Expected one catalog manifest document'
	jq -e '.version == 1 and (.repositories|type == "array" and length > 0) and all(.repositories[]; (.id|test("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")) and .url == ("https://github.com/"+.id+".git") and (.branch|type=="string" and length>0) and .index=="super-powers.json" and (.commit|test("^[0-9a-f]{40}$")) and (.sha256|test("^[0-9a-f]{64}$")) and (.index_file|test("^indexes/[0-9]+\\.json$"))) and ([.repositories[].id]|length == (unique|length))' "$catalog/manifest.json" >/dev/null || fail 'Malformed catalog manifest'
	while IFS= read -r row; do
		index_file=$(safe_file "$catalog" "$(jq -r '.index_file' <<<"$row")")
		checksum=$(jq -r '.sha256' <<<"$row")
		actual=$(sha256sum "$index_file"); actual=${actual%% *}
		[[ $actual == "$checksum" ]] || fail "Catalog checksum mismatch: $index_file"
		validate_index "$index_file"
	done < <(jq -c '.repositories[]' "$catalog/manifest.json")
}
# Emit all occurrences in configured order. Never silently flatten shadowed GUIDs.
catalog_entries() {
	local catalog=$1 row index_file order=0
	while IFS= read -r row; do
		index_file=$(jq -r '.index_file' <<<"$row")
		jq -c --argjson source "$row" --argjson order "$order" 'to_entries[] | {guid:.key, repository:$source.id, revision:$source.commit, order:$order, entry:.value}' "$catalog/$index_file"
		order=$((order + 1))
	done < <(jq -c '.repositories[]' "$catalog/manifest.json")
}
