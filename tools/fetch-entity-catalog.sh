#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/entity-common.sh"
if [[ ${1:-} == --help ]]; then
	printf '%s\n' 'Usage: bash tools/fetch-entity-catalog.sh field-types|snippets NEW_DIR [REGISTRY_JSON] [--sources SOURCE_MAP_JSON]' 'Fetch current ordered indexes at exact commits, never execute code.' 'The optional JSON object maps canonical registry IDs to explicit public HTTPS' 'repository URLs. Unknown IDs, credentials, queries and fragments are rejected.' 'Unmapped IDs use their registry URL. Each selected source is fetched once;' 'failed fetches publish no catalog, with no guessed mirrors or fallback retries.' 'Manifest id/url remain canonical; fetch_url records the selected transport URL.' 'Requires the domain core repository. Additional snippet-type indexes may be absent;' 'the mandatory core snippet-type index may not. Destination must not exist.'
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
[[ ${#positional[@]} -ge 2 && ${#positional[@]} -le 3 ]] || fail 'Expected DOMAIN NEW_DIR [REGISTRY_JSON]; use --help'
entity_domain "${positional[0]}"; need git
output=$(realpath -m -- "${positional[1]}")
registry=${positional[2]:-"$TOOLS_DIR/../registries/$ENTITY_REGISTRY"}
[[ ! -e $output ]] || fail "Destination exists: $output"
validate_entity_registry "$registry"
sources=$(read_fetch_sources "$source_file" "$registry")
mkdir -p -- "$(dirname -- "$output")"
temporary=$(mktemp -d "${output}.tmp.XXXXXXXX")
trap 'rm -rf -- "$temporary"' EXIT
mkdir "$temporary/indexes"; : > "$temporary/repositories.jsonl"
order=0
while IFS= read -r repository; do
	id=$(jq -r '.id' <<<"$repository"); url=$(jq -r '.url' <<<"$repository"); branch=$(jq -r '.branch' <<<"$repository")
	fetch_url=$(jq -r --arg id "$id" --arg url "$url" '.[$id] // $url' <<<"$sources")
	mapped=$(jq -r --arg id "$id" 'has($id)' <<<"$sources")
	git check-ref-format --branch "$branch" >/dev/null || fail "Invalid branch: $id"
	printf 'Fetching %s (%s)\n' "$id" "$branch" >&2
	git init -q "$temporary/fetch"
	fetch_public_branch "$temporary/fetch" "$fetch_url" "$branch" "$mapped" || fail "Fetch failed for $id from $fetch_url; no fallback attempted"
	commit=$(git -C "$temporary/fetch" rev-parse --verify FETCH_HEAD)
	: > "$temporary/artifacts.jsonl"; : > "$temporary/absent.jsonl"
	while IFS=$'\t' read -r entity source _prefix; do
		if ! git -C "$temporary/fetch" cat-file -e "$commit:$source" 2>/dev/null; then
			if [[ $entity == snippet_type && $id != "$ENTITY_CORE" ]]; then
				jq -nc --arg path "$source" '$path' >> "$temporary/absent.jsonl"
				printf 'NOTE: optional %s absent in %s\n' "$source" "$id" >&2
				continue
			fi
			fail "Required index $source absent from $id"
		fi
		file="indexes/$order-$entity.json"
		git -C "$temporary/fetch" show "$commit:$source" > "$temporary/$file"
		validate_entity_index "$temporary/$file" "$entity"
		checksum=$(sha256sum "$temporary/$file"); checksum=${checksum%% *}
		jq -nc --arg entity "$entity" --arg source "$source" --arg file "$file" --arg sha "$checksum" '{entity:$entity,source_path:$source,file:$file,sha256:$sha}' >> "$temporary/artifacts.jsonl"
	done < <(entity_specs)
	jq -nc --argjson source "$repository" --arg fetch_url "$fetch_url" --arg commit "$commit" --slurpfile indexes "$temporary/artifacts.jsonl" --slurpfile absent "$temporary/absent.jsonl" '$source|{id,url,branch}+{fetch_url:$fetch_url,commit:$commit,indexes:$indexes,absent_optional_indexes:$absent}' >> "$temporary/repositories.jsonl"
	rm -rf -- "$temporary/fetch"
	order=$((order + 1))
done < <(jq -c '.repositories[]' "$registry")
registry_hash=$(sha256sum "$registry"); registry_hash=${registry_hash%% *}
jq -s --arg kind "$ENTITY_KIND" --arg created "$(date -u +%FT%TZ)" --arg hash "$registry_hash" '{version:1,kind:$kind,mode:"live",created_at:$created,registry_sha256:$hash,repositories:.}' "$temporary/repositories.jsonl" > "$temporary/manifest.json"
check_entity_catalog "$temporary"
entity_catalog_entries "$temporary" | jq -s '.' > "$temporary/entries.json"
jq -c '.[]' "$temporary/entries.json" | entity_resolution > "$temporary/resolution.json"
rm "$temporary/repositories.jsonl" "$temporary/artifacts.jsonl" "$temporary/absent.jsonl"
mv -- "$temporary" "$output"
printf 'Catalog saved: %s (%s ordered occurrences)\n' "$output" "$(jq length "$output/entries.json")"
