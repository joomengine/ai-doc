#!/usr/bin/env bash
# Domain-specific records share retrieval mechanics, never their payload contracts.
source "$TOOLS_DIR/lib/common.sh"
# ENTITY_REGISTRY is part of the API consumed by the fetch command.
# shellcheck disable=SC2034
entity_domain() {
	case "$1" in
		field-types) ENTITY_KIND=field-types; ENTITY_CORE=joomengine/joomla-fieldtypes; ENTITY_INDEX=index.json; ENTITY_REGISTRY=field-type-repositories.json ;;
		snippets) ENTITY_KIND=snippets; ENTITY_CORE=joomengine/snippets; ENTITY_INDEX=snippet-index.json; ENTITY_REGISTRY=snippet-repositories.json ;;
		*) fail 'Domain must be field-types or snippets' ;;
	esac
}
entity_specs() {
	if [[ $ENTITY_KIND == field-types ]]; then printf 'fieldtype\tindex.json\tsrc\n'; else printf 'snippet\tsnippet-index.json\tsrc\nsnippet_type\tsnippet-type.json\tsrc/snippet_type\n'; fi
}
validate_entity_index() {
	local file=$1 entity=$2
	jq -e -s 'length==1' "$file" >/dev/null || fail "Expected one index JSON document: $file"
	jq -e --arg entity "$entity" -f "$TOOLS_DIR/jq/entity-index.jq" "$file" >/dev/null || fail "Invalid $entity index: $file"
}
validate_entity_registry() {
	jq -e -s 'length==1' "$1" >/dev/null || fail 'Expected one registry document'
	jq -e --arg index "$ENTITY_INDEX" --arg core "$ENTITY_CORE" '.version==1 and (.repositories|type=="array" and length>0) and ([.repositories[].id]|length==(unique|length)) and any(.repositories[]; .id==$core and .required_for_collision_check==true) and all(.repositories[]; (.id|test("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")) and .url==("https://github.com/"+.id+".git") and (.branch|type=="string" and length>0) and .index==$index)' "$1" >/dev/null || fail "Invalid $ENTITY_KIND registry or missing mandatory core $ENTITY_CORE"
}
check_entity_catalog() {
	local catalog=$1 repository artifact file checksum actual
	[[ -f $catalog/manifest.json ]] || fail "Missing catalog manifest: $catalog"
	jq -e -s 'length==1' "$catalog/manifest.json" >/dev/null || fail 'Expected one catalog manifest'
	jq -e --arg kind "$ENTITY_KIND" --arg core "$ENTITY_CORE" '.version==1 and .kind==$kind and (.repositories|type=="array" and length>0) and ([.repositories[].id]|length==(unique|length)) and any(.repositories[]; .id==$core) and all(.repositories[]; (.id|test("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")) and .url==("https://github.com/"+.id+".git") and (.branch|type=="string" and length>0) and (.commit|test("^[0-9a-f]{40}$")) and (.indexes|type=="array" and length>0) and ([.indexes[].entity]|length==(unique|length)) and all(.indexes[]; (.file|test("^indexes/[0-9]+-[a-z_]+\\.json$")) and (.sha256|test("^[0-9a-f]{64}$"))))' "$catalog/manifest.json" >/dev/null || fail "Invalid $ENTITY_KIND catalog or absent core $ENTITY_CORE"
	while IFS= read -r repository; do
		if [[ $ENTITY_KIND == field-types ]]; then
			jq -e '.indexes|length==1 and .[0].entity=="fieldtype" and .[0].source_path=="index.json"' <<<"$repository" >/dev/null || fail 'Wrong fieldtype index mapping'
		else
			jq -e --arg core "$ENTITY_CORE" '. as $r | any(.indexes[]; .entity=="snippet" and .source_path=="snippet-index.json") and all(.indexes[]; (.entity=="snippet" and .source_path=="snippet-index.json") or (.entity=="snippet_type" and .source_path=="snippet-type.json")) and (if .id==$core then any(.indexes[]; .entity=="snippet_type") else true end)' <<<"$repository" >/dev/null || fail 'Missing snippet index or mandatory core snippet types'
		fi
		while IFS= read -r artifact; do
			file=$(safe_file "$catalog" "$(jq -r '.file' <<<"$artifact")")
			checksum=$(jq -r '.sha256' <<<"$artifact"); actual=$(sha256sum "$file"); actual=${actual%% *}
			[[ $actual == "$checksum" ]] || fail "Catalog checksum mismatch: $file"
			validate_entity_index "$file" "$(jq -r '.entity' <<<"$artifact")"
		done < <(jq -c '.indexes[]' <<<"$repository")
	done < <(jq -c '.repositories[]' "$catalog/manifest.json")
}
entity_catalog_entries() {
	local catalog=$1 repository artifact order=0
	while IFS= read -r repository; do
		while IFS= read -r artifact; do
			jq -c --argjson source "$repository" --argjson artifact "$artifact" --argjson order "$order" 'to_entries[]|{entity:$artifact.entity,guid:.key,repository:$source.id,revision:$source.commit,order:$order,entry:.value}' "$catalog/$(jq -r '.file' <<<"$artifact")"
		done < <(jq -c '.indexes[]' <<<"$repository")
		order=$((order + 1))
	done < <(jq -c '.repositories[]' "$catalog/manifest.json")
}
fresh_entity_catalog() {
	local catalog=$1 created now
	jq -e '.mode=="live"' "$catalog/manifest.json" >/dev/null || fail 'New identities require a live catalog'
	created=$(jq -er '.created_at|fromdateiso8601' "$catalog/manifest.json") || fail 'Invalid catalog timestamp'
	now=$(date -u +%s)
	(( now >= created && now - created <= 86400 )) || fail 'Catalog is older than 24 hours or future-dated; fetch again before identity allocation'
}
local_entity_entries() {
	local repository=$1 entity source _prefix index_file
	while IFS=$'\t' read -r entity source _prefix; do
		if [[ ! -f $repository/$source ]]; then
			[[ $entity == snippet_type ]] && continue
			fail "Missing local $source"
		fi
		index_file=$(safe_file "$repository" "$source")
		validate_entity_index "$index_file" "$entity"
		jq -c --arg entity "$entity" 'to_entries[]|{entity:$entity,guid:.key,entry:.value}' "$index_file"
	done < <(entity_specs)
}
entity_resolution() {
	jq -s '[group_by([.entity,.guid])[]|sort_by(.order)|{entity:.[0].entity,guid:.[0].guid,selected:.[0],shadowed:.[1:]}]'
}
check_local_entity_identities() {
	jq -e -s '[.[].guid]|length==(unique|length)' "$1" >/dev/null || fail 'Different local records must not reuse one GUID across entity indexes'
}
check_new_entity_guids() {
	local catalog=$1 local_entries=$2 candidate
	shift 2
	[[ $# == 0 ]] && return 0
	fresh_entity_catalog "$catalog"
	while [[ $# -gt 0 ]]; do
		[[ $1 == --new-guid && $# -ge 2 ]] || fail 'Expected repeated --new-guid UUID arguments'
		candidate=$2; shift 2
		[[ $candidate =~ ^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$ ]] || fail "New identity must be lowercase UUIDv4: $candidate"
		jq -e -s --arg guid "$candidate" '[.[]|select(.guid==$guid)]|length==1' "$local_entries" >/dev/null || fail "New GUID must occur exactly once locally: $candidate"
		if entity_catalog_entries "$catalog" | jq -e -s --arg guid "$candidate" 'any(.[]; .guid==$guid)' >/dev/null; then fail "New identity collides with catalog: $candidate (same-item overrides must retain identity and omit --new-guid)"; fi
	done
}
