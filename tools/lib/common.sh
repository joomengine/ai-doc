#!/usr/bin/env bash
# Shared routines; sourced by the public tools, never evaluate repository content.
set -euo pipefail
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || fail "Required command missing: $1"; }
for required_command in jq realpath sha256sum; do need "$required_command"; done
# Deliberately bounded public HTTPS syntax. Does not prove ownership or DNS reachability.
public_repository_url() {
	jq -e 'type=="string" and test("^https://([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z][A-Za-z0-9-]*(:[0-9]{1,5})?/[A-Za-z0-9._~/-]+$") and (test("(^|/)\\.\\.?(/|$)")|not) and (capture("^https://[^/:]+(?::(?<port>[0-9]+))?/")|if .port==null then true else (.port|tonumber)>0 and (.port|tonumber)<=65535 end)' >/dev/null
}
read_fetch_sources() {
	local source_file=$1 registry=$2 source_map unknown url
	if [[ -z $source_file ]]; then printf '{}\n'; return; fi
	jq -e -s 'length==1 and (.[0]|type=="object")' "$source_file" >/dev/null || fail 'Source map must contain exactly one JSON object'
	source_map=$(jq -c . "$source_file")
	unknown=$(jq -r --slurpfile registry "$registry" 'keys[] as $id | select([$registry[0].repositories[].id]|index($id)==null)|$id' <<<"$source_map")
	[[ -z $unknown ]] || fail "Source map has unknown registry IDs: $unknown"
	while IFS= read -r url; do
		public_repository_url <<<"$url" || fail 'Source map URLs must be public HTTPS repository URLs without credentials, query, fragment, whitespace or traversal'
	done < <(jq -c '.[]' <<<"$source_map")
	printf '%s\n' "$source_map"
}
validate_fetch_urls() {
	local url
	while IFS= read -r url; do public_repository_url <<<"$url" || fail 'Invalid catalog fetch_url'; done < <(jq -c '.repositories[]|select(has("fetch_url"))|.fetch_url' "$1")
}
fetch_public_branch() {
	local directory=$1 url=$2 branch=$3 mapped=$4 effective_url
	if [[ $mapped == true ]]; then
		need timeout
		# --get-url expands insteadOf rules without contacting the remote. Never
		# print a rewritten value: caller configuration may embed credentials.
		effective_url=$(git -C "$directory" ls-remote --get-url "$url") || fail 'Cannot determine effective mapped Git URL'
		[[ $effective_url == "$url" ]] || fail 'Git URL rewriting changes the explicitly selected source; refusing mapped fetch'
		GIT_TERMINAL_PROMPT=0 GIT_ASKPASS=/bin/false timeout --signal=TERM --kill-after=5s 60s git -C "$directory" -c core.hooksPath=/dev/null -c protocol.file.allow=never -c credential.helper= -c http.extraHeader= -c http.followRedirects=false fetch -q --depth=1 --no-tags "$url" "refs/heads/$branch"
	else
		git -C "$directory" -c core.hooksPath=/dev/null -c protocol.file.allow=never fetch -q --depth=1 --no-tags "$url" "refs/heads/$branch"
	fi
}
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
	validate_fetch_urls "$catalog/manifest.json"
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
