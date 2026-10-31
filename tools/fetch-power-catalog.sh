#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/common.sh"
if [[ ${1:-} == --help ]]; then
	printf '%s\n' 'Usage: bash tools/fetch-power-catalog.sh NEW_CATALOG_DIR [REGISTRY_JSON] [--sources SOURCE_MAP_JSON]' 'Fetch each registry branch once, save its exact commit and index hash.' 'The optional JSON object maps canonical registry IDs to explicit public HTTPS' 'repository URLs. Unknown IDs, credentials, queries and fragments are rejected.' 'Unmapped IDs use their registry URL. No guessed mirrors or fallback retries.' 'Manifest id/url remain canonical; fetch_url records the selected transport URL.' 'Requires Bash, git, jq and GNU coreutils. No repository code is executed.' 'Output directory must not already exist; failed fetches publish no catalog.'
	exit 0
fi
positional=(); source_file=''
while [[ $# -gt 0 ]]; do
	case $1 in
		--sources) [[ $# -ge 2 && -n $2 && -z $source_file ]] || fail 'Provide --sources exactly once with a JSON map'; source_file=$2; shift 2 ;;
		--*) fail "Unknown option: $1" ;;
		*) positional+=("$1"); shift ;;
	esac
done
[[ ${#positional[@]} -ge 1 && ${#positional[@]} -le 2 ]] || fail 'Expected NEW_CATALOG_DIR [REGISTRY_JSON]; use --help'
need git
output=$(realpath -m -- "${positional[0]}")
registry=${positional[1]:-"$TOOLS_DIR/../registries/power-repositories.json"}
[[ ! -e $output ]] || fail "Output already exists: $output"
jq -e -s 'length==1' "$registry" >/dev/null || fail 'Expected one registry document'
jq -e '.version==1 and (.repositories|type=="array" and length>0) and ([.repositories[].id]|length==(unique|length)) and all(.repositories[]; (.id|test("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")) and .url == ("https://github.com/"+.id+".git") and (.branch|type=="string" and length>0) and .index=="super-powers.json")' "$registry" >/dev/null || fail 'Registry does not match supported public GitHub registry format'
sources=$(read_fetch_sources "$source_file" "$registry")
mkdir -p -- "$(dirname -- "$output")"
temporary=$(mktemp -d "${output}.tmp.XXXXXXXX")
trap 'rm -rf -- "$temporary"' EXIT
mkdir "$temporary/indexes"
: > "$temporary/sources.jsonl"
order=0
while IFS= read -r row; do
	id=$(jq -r '.id' <<<"$row"); url=$(jq -r '.url' <<<"$row"); branch=$(jq -r '.branch' <<<"$row"); index=$(jq -r '.index' <<<"$row")
	fetch_url=$(jq -r --arg id "$id" --arg url "$url" '.[$id] // $url' <<<"$sources")
	mapped=$(jq -r --arg id "$id" 'has($id)' <<<"$sources")
	git check-ref-format --branch "$branch" >/dev/null || fail "Invalid branch for $id"
	printf 'Fetching %s (%s)\n' "$id" "$branch" >&2
	git init -q "$temporary/fetch"
	fetch_public_branch "$temporary/fetch" "$fetch_url" "$branch" "$mapped" || fail "Fetch failed for $id from $fetch_url; no fallback attempted"
	commit=$(git -C "$temporary/fetch" rev-parse --verify FETCH_HEAD)
	index_file="indexes/$order.json"
	git -C "$temporary/fetch" show "$commit:$index" > "$temporary/$index_file"
	validate_index "$temporary/$index_file"
	checksum=$(sha256sum "$temporary/$index_file"); checksum=${checksum%% *}
	jq -nc --argjson source "$row" --arg fetch_url "$fetch_url" --arg commit "$commit" --arg file "$index_file" --arg sha256 "$checksum" '$source | {id,url,branch,index} + {fetch_url:$fetch_url,commit:$commit,index_file:$file,sha256:$sha256}' >> "$temporary/sources.jsonl"
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
