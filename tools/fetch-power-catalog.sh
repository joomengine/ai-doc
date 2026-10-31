#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/common.sh"
if [[ ${1:-} == --help || $# -lt 1 || $# -gt 2 ]]; then
	printf '%s\n' 'Usage: bash tools/fetch-power-catalog.sh NEW_CATALOG_DIR [REGISTRY_JSON]' 'Fetch each registry branch once, save its exact commit and index hash.' 'Requires Bash, git, jq and GNU coreutils. No repository code is executed.' 'Output directory must not already exist; failed fetches publish no catalog.'
	[[ ${1:-} == --help ]] && exit 0; exit 2
fi
need git
output=$(realpath -m -- "$1")
registry=${2:-"$TOOLS_DIR/../registries/power-repositories.json"}
[[ ! -e $output ]] || fail "Output already exists: $output"
jq -e '.version==1 and (.repositories|type=="array" and length>0) and ([.repositories[].id]|length==(unique|length)) and all(.repositories[]; (.id|test("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")) and .url == ("https://github.com/"+.id+".git") and (.branch|type=="string" and length>0) and .index=="super-powers.json")' "$registry" >/dev/null || fail 'Registry does not match supported public GitHub registry format'
mkdir -p -- "$(dirname -- "$output")"
temporary=$(mktemp -d "${output}.tmp.XXXXXXXX")
trap 'rm -rf -- "$temporary"' EXIT
mkdir "$temporary/indexes"
: > "$temporary/sources.jsonl"
order=0
while IFS= read -r row; do
	id=$(jq -r '.id' <<<"$row"); url=$(jq -r '.url' <<<"$row"); branch=$(jq -r '.branch' <<<"$row"); index=$(jq -r '.index' <<<"$row")
	git check-ref-format --branch "$branch" >/dev/null || fail "Invalid branch for $id"
	printf 'Fetching %s (%s)\n' "$id" "$branch" >&2
	git init -q "$temporary/fetch"
	git -C "$temporary/fetch" -c core.hooksPath=/dev/null -c protocol.file.allow=never fetch -q --depth=1 --no-tags "$url" "refs/heads/$branch"
	commit=$(git -C "$temporary/fetch" rev-parse --verify FETCH_HEAD)
	index_file="indexes/$order.json"
	git -C "$temporary/fetch" show "$commit:$index" > "$temporary/$index_file"
	validate_index "$temporary/$index_file"
	checksum=$(sha256sum "$temporary/$index_file"); checksum=${checksum%% *}
	jq -nc --argjson source "$row" --arg commit "$commit" --arg file "$index_file" --arg sha256 "$checksum" '$source | {id,url,branch,index} + {commit:$commit,index_file:$file,sha256:$sha256}' >> "$temporary/sources.jsonl"
	rm -rf -- "$temporary/fetch"
	order=$((order + 1))
done < <(jq -c '.repositories[]' "$registry")
registry_hash=$(sha256sum "$registry"); registry_hash=${registry_hash%% *}
jq -s --arg created_at "$(date -u +%FT%TZ)" --arg registry_sha256 "$registry_hash" '{version:1,mode:"live",created_at:$created_at,registry_sha256:$registry_sha256,repositories:.}' "$temporary/sources.jsonl" > "$temporary/manifest.json"
catalog_entries "$temporary" | jq -s '.' > "$temporary/entries.json"
jq '[group_by(.guid)[] | select(length>1) | sort_by(.order) | {guid:.[0].guid,selected:.[0],shadowed:.[1:]}]' "$temporary/entries.json" > "$temporary/shadowing.json"
rm "$temporary/sources.jsonl"
mv -- "$temporary" "$output"
printf 'Catalog saved: %s (%s occurrences; %s shadowed GUIDs)\n' "$output" "$(jq length "$output/entries.json")" "$(jq length "$output/shadowing.json")"
