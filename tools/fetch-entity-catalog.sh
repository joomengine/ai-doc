#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/entity-common.sh"
if [[ ${1:-} == --help || $# -lt 2 || $# -gt 3 ]]; then
	printf '%s\n' 'Usage: bash tools/fetch-entity-catalog.sh field-types|snippets NEW_DIR [REGISTRY_JSON]' 'Fetch current ordered public GitHub indexes at exact commits, never execute code.' 'Requires the domain core repository. Additional snippet-type indexes may be absent;' 'the mandatory core snippet-type index may not. Destination must not exist.'
	[[ ${1:-} == --help ]] && exit 0; exit 2
fi
entity_domain "$1"; need git
output=$(realpath -m -- "$2")
registry=${3:-"$TOOLS_DIR/../registries/$ENTITY_REGISTRY"}
[[ ! -e $output ]] || fail "Destination exists: $output"
validate_entity_registry "$registry"
mkdir -p -- "$(dirname -- "$output")"
temporary=$(mktemp -d "${output}.tmp.XXXXXXXX")
trap 'rm -rf -- "$temporary"' EXIT
mkdir "$temporary/indexes"; : > "$temporary/repositories.jsonl"
order=0
while IFS= read -r repository; do
	id=$(jq -r '.id' <<<"$repository"); url=$(jq -r '.url' <<<"$repository"); branch=$(jq -r '.branch' <<<"$repository")
	git check-ref-format --branch "$branch" >/dev/null || fail "Invalid branch: $id"
	printf 'Fetching %s (%s)\n' "$id" "$branch" >&2
	git init -q "$temporary/fetch"
	git -C "$temporary/fetch" -c core.hooksPath=/dev/null -c protocol.file.allow=never fetch -q --depth=1 --no-tags "$url" "refs/heads/$branch"
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
	jq -nc --argjson source "$repository" --arg commit "$commit" --slurpfile indexes "$temporary/artifacts.jsonl" --slurpfile absent "$temporary/absent.jsonl" '$source|{id,url,branch}+{commit:$commit,indexes:$indexes,absent_optional_indexes:$absent}' >> "$temporary/repositories.jsonl"
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
