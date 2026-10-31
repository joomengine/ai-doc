#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
TOOLS_DIR="$root/tools"
source "$TOOLS_DIR/lib/entity-common.sh"
work=$(mktemp -d); trap 'rm -rf -- "$work"' EXIT
passed=0
expect() {
	local expected=$1 label=$2 status=0; shift 2
	"$@" > "$work/output" 2>&1 || status=$?
	if [[ $status != "$expected" ]]; then printf 'FAIL: %s (expected %s; got %s)\n' "$label" "$expected" "$status" >&2; cat "$work/output" >&2; exit 1; fi
	passed=$((passed + 1)); printf 'PASS: %s\n' "$label"
}
edit() { jq "$2" "$1" > "$work/edit.json"; mv "$work/edit.json" "$1"; }
reset_field() { rm -rf "$work/field"; cp -R "$root/field-types/examples/minimal-repository" "$work/field"; }
reset_snippets() { rm -rf "$work/snippets"; cp -R "$root/snippets/examples/minimal-repository" "$work/snippets"; }
# Synthetic indexes isolate the regression suite from networks and source changes.
# Their live/timestamp labels exercise gates; they are not live-source evidence.
make_catalog() {
	local kind=$1 directory=$2 entity source _prefix file checksum
	entity_domain "$kind"; mkdir -p "$directory/indexes"; : > "$work/artifacts"
	while IFS=$'\t' read -r entity source _prefix; do
		file="indexes/0-$entity.json"; printf '{}\n' > "$directory/$file"
		checksum=$(sha256sum "$directory/$file"); checksum=${checksum%% *}
		jq -nc --arg entity "$entity" --arg source "$source" --arg file "$file" --arg sha "$checksum" '{entity:$entity,source_path:$source,file:$file,sha256:$sha}' >> "$work/artifacts"
	done < <(entity_specs)
	jq -n --arg kind "$kind" --arg id "$ENTITY_CORE" --arg date "$(date -u +%FT%TZ)" --slurpfile indexes "$work/artifacts" '{version:1,kind:$kind,mode:"live",created_at:$date,repositories:[{id:$id,url:("https://github.com/"+$id+".git"),branch:"master",commit:"1111111111111111111111111111111111111111",indexes:$indexes,absent_optional_indexes:[]}]}' > "$directory/manifest.json"
}
replace_catalog_index() {
	local directory=$1 entity=$2 source=$3 checksum
	cp "$source" "$directory/indexes/0-$entity.json"
	checksum=$(sha256sum "$directory/indexes/0-$entity.json"); checksum=${checksum%% *}
	edit "$directory/manifest.json" ".repositories[0].indexes |= map(if .entity==\"$entity\" then .sha256=\"$checksum\" else . end)"
}
make_catalog field-types "$work/field-catalog"
make_catalog snippets "$work/snippet-catalog"
reset_field; reset_snippets
field_guid=$(jq -r 'keys[0]' "$work/field/index.json")
snippet_guid=$(jq -r 'keys[0]' "$work/snippets/snippet-index.json")
type_guid=$(jq -r 'keys[0]' "$work/snippets/snippet-type.json")
field_item="$work/field/src/$field_guid/item.json"
snippet_item="$work/snippets/src/$snippet_guid/item.json"
field_command=(bash "$root/tools/validate-field-type-repository.sh" "$work/field" "$work/field-catalog")
snippet_command=(bash "$root/tools/validate-snippet-repository.sh" "$work/snippets" "$work/snippet-catalog")
expect 0 'complete Field Type fixture and new identity validate' "${field_command[@]}" --new-guid "$field_guid"
expect 0 'complete Snippet/type fixture and new identities validate' "${snippet_command[@]}" --new-guid "$snippet_guid" --new-guid "$type_guid"
grep -Fq 'UNVERIFIED: 1 library GUID' "$work/output"
edit "$field_item" '.properties |= [.[]]'
expect 0 'native property list is accepted' "${field_command[@]}"
edit "$field_item" '.properties |= tojson'
expect 1 'encoded properties string is rejected before double encoding' "${field_command[@]}"
reset_field
edit "$field_item" '.properties |= (. + {duplicate:(.[]|select(.name=="type"))})'
expect 1 'duplicate property names are rejected' "${field_command[@]}"
reset_field
edit "$field_item" '.properties |= with_entries(.value.mandatory="yes")'
expect 1 'invalid property flag is rejected' "${field_command[@]}"
reset_field
edit "$field_item" '.short_description="\u0000\t example \r\n\u000b"'
edit "$work/field/index.json" 'with_entries(.value.desc="example")'
expect 0 'index summary follows PHP ASCII trim' "${field_command[@]}"
edit "$field_item" '.short_description="\t\n"'
edit "$work/field/index.json" 'with_entries(.value.desc=null)'
expect 0 'empty trimmed summary is null' "${field_command[@]}"
reset_field
edit "$field_item" '.datalenght="128"'
expect 1 'non-option length requires Other selector' "${field_command[@]}"
reset_field
edit "$field_item" '.has_defaults=1|.datalenght="Other"|.datalenght_other=""'
expect 1 'active Other length requires its companion value' "${field_command[@]}"
reset_field
edit "$work/field/index.json" 'with_entries(.value.settings="../outside.json")'
expect 1 'traversing item path is rejected' "${field_command[@]}"
reset_field
cp "$field_item" "$work/outside.json"; rm "$field_item"; ln -s "$work/outside.json" "$field_item"
expect 1 'escaping item symlink is rejected' "${field_command[@]}"
reset_field
mkdir -p "$work/field/src/unindexed"; cp "$field_item" "$work/field/src/unindexed/item.json"
expect 1 'unindexed item is rejected' "${field_command[@]}"
reset_field
printf '{}\n' >> "$field_item"
expect 1 'multiple item JSON roots are rejected' "${field_command[@]}"
reset_field
edit "$snippet_item" '."@dependencies" |= map(if .entity=="snippet_type" then .value="00000000-0000-4000-8000-000000000001" else . end)'
expect 1 'dependency metadata must agree with type field' "${snippet_command[@]}"
reset_snippets
edit "$snippet_item" '."@dependencies" += [{key:"guid",value:"00000000-0000-4000-8000-000000000001",entity:"fieldtype",table:"#__componentbuilder_fieldtype",direction:"out"}]'
expect 1 'unsupported extra dependency is not silently treated as resolved' "${snippet_command[@]}"
reset_snippets
edit "$snippet_item" '.type="00000000-0000-4000-8000-000000000001" | ."@dependencies" |= map(if .entity=="snippet_type" then .value="00000000-0000-4000-8000-000000000001" else . end)'
expect 2 'unresolved Snippet Type is a separate incomplete-closure result' "${snippet_command[@]}"
reset_snippets
edit "$snippet_item" '.url=""'
expect 1 'required snippet URL cannot be empty' "${snippet_command[@]}"
reset_snippets
edit "$snippet_item" '.heading=""'
expect 1 'required snippet heading cannot be empty' "${snippet_command[@]}"
reset_snippets
edit "$snippet_item" '.contributor_name=("x"*51)'
expect 1 'new-only authoring gate enforces current contributor form limit' "${snippet_command[@]}" --new-guid "$snippet_guid"
expect 0 'maintenance does not silently discard historical attribution' "${snippet_command[@]}"
reset_snippets
edit "$work/snippets/snippet-type.json" "to_entries|map(.key=\"$snippet_guid\"|.value.guid=\"$snippet_guid\"|.value.path=\"src/snippet_type/$snippet_guid\"|.value.settings=\"src/snippet_type/$snippet_guid/item.json\")|from_entries"
expect 1 'unrelated local snippet and type cannot share a GUID' "${snippet_command[@]}"
reset_snippets
expect 0 'secure Field Type UUID allocation' bash "$root/tools/new-entity-guid.sh" field-types "$work/field-catalog" "$work/field"
grep -Eq '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$' "$work/output"
expect 0 'secure Snippet UUID allocation includes both indexes' bash "$root/tools/new-entity-guid.sh" snippets "$work/snippet-catalog" "$work/snippets"
expect 1 'missing catalog cannot allocate an identity' bash "$root/tools/new-entity-guid.sh" field-types "$work/no-catalog"
expect 1 'another entity domain is not a collision baseline' bash "$root/tools/new-entity-guid.sh" field-types "$work/snippet-catalog"
cp "$work/field-catalog/manifest.json" "$work/field-manifest"
edit "$work/field-catalog/manifest.json" '.repositories[0].id="example/project"|.repositories[0].url="https://github.com/example/project.git"'
expect 1 'project-only catalog cannot replace official core' bash "$root/tools/new-entity-guid.sh" field-types "$work/field-catalog"
cp "$work/field-manifest" "$work/field-catalog/manifest.json"
edit "$work/field-catalog/manifest.json" '.created_at="2000-01-01T00:00:00Z"'
expect 1 'stale catalog cannot allocate a new identity' bash "$root/tools/new-entity-guid.sh" field-types "$work/field-catalog"
expect 1 'stale catalog cannot approve a newly authored identity' "${field_command[@]}" --new-guid "$field_guid"
cp "$work/field-manifest" "$work/field-catalog/manifest.json"
printf ' ' >> "$work/field-catalog/indexes/0-fieldtype.json"
expect 1 'modified catalog fails integrity checks' bash "$root/tools/new-entity-guid.sh" field-types "$work/field-catalog"
printf '{}\n' > "$work/field-catalog/indexes/0-fieldtype.json"
replace_catalog_index "$work/field-catalog" fieldtype "$work/field/index.json"
expect 0 'same-item Field Type maintenance preserves identity' "${field_command[@]}"
expect 1 'new Field Type cannot reuse a core identity' "${field_command[@]}" --new-guid "$field_guid"
replace_catalog_index "$work/snippet-catalog" snippet "$work/snippets/snippet-index.json"
replace_catalog_index "$work/snippet-catalog" snippet_type "$work/snippets/snippet-type.json"
expect 0 'same-item Snippet maintenance preserves identity' "${snippet_command[@]}"
expect 1 'new Snippet cannot reuse a core identity' "${snippet_command[@]}" --new-guid "$snippet_guid"
expect 1 'new Snippet Type cannot reuse a core classification identity' "${snippet_command[@]}" --new-guid "$type_guid"
rm -rf "$work/snippets/src/snippet_type"; rm "$work/snippets/snippet-type.json"
expect 0 'type can resolve from a catalog with no local type index' "${snippet_command[@]}"
reset_snippets
# Explicit project override comes first; every core occurrence must still remain.
edit "$work/field-catalog/manifest.json" '.repositories = [(.repositories[0]|.id="example/override"|.url="https://github.com/example/override.git")] + .repositories'
entity_domain field-types
entity_catalog_entries "$work/field-catalog" | entity_resolution > "$work/resolution.json"
expect 0 'ordered resolution retains selected and shadowed provenance' jq -e 'length==1 and .[0].selected.repository=="example/override" and .[0].selected.order==0 and .[0].shadowed[0].repository=="joomengine/joomla-fieldtypes" and .[0].shadowed[0].order==1' "$work/resolution.json"
expect 1 'new identity collision scan includes shadowed core occurrences' "${field_command[@]}" --new-guid "$field_guid"
cp "$work/snippet-catalog/manifest.json" "$work/snippet-manifest"
edit "$work/snippet-catalog/manifest.json" '.repositories[0].indexes |= map(select(.entity!="snippet_type"))'
expect 1 'core snippet type catalog cannot be omitted' bash "$root/tools/new-entity-guid.sh" snippets "$work/snippet-catalog"
cp "$work/snippet-manifest" "$work/snippet-catalog/manifest.json"
mkdir "$work/empty"; printf '{}\n' > "$work/empty/index.json"
expect 0 'empty Field Type repository has a valid starting index' bash "$root/tools/validate-field-type-repository.sh" "$work/empty" "$work/field-catalog"
printf '{}\n' > "$work/empty/snippet-index.json"; printf '{}\n' > "$work/empty/snippet-type.json"
expect 0 'empty Snippet repository has valid starting indexes' bash "$root/tools/validate-snippet-repository.sh" "$work/empty" "$work/snippet-catalog"
printf 'Passed %s Field Type/Snippet regression checks.\n' "$passed"
