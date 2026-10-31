#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
source "$TOOLS_DIR/lib/entity-common.sh"
entity_domain "$1"; shift
if [[ ${1:-} == --help || $# -lt 2 ]]; then
	printf '%s\n' "Usage: bash tools/validate-${ENTITY_KIND%?}-repository.sh REPO_DIR CATALOG_DIR [--new-guid UUID ...]" 'Validate canonical indexes, item shape, identity, paths and domain relationships.' 'New identities require a fresh live core+project catalog and must not collide.' 'Default validation preserves identities for maintenance and intentional overrides.' 'Exit 0: static checks pass; 1: invalid data/profile; 2: missing snippet-type reference.' 'Never executes snippet contents; no JCB import, SQL, browser or runtime proof.'
	[[ ${1:-} == --help ]] && exit 0; exit 2
fi
repository=$(realpath -e -- "$1"); catalog=$(realpath -e -- "$2"); shift 2
check_entity_catalog "$catalog"
work=$(mktemp -d); trap 'rm -rf -- "$work"' EXIT
local_entity_entries "$repository" > "$work/local.jsonl"
check_local_entity_identities "$work/local.jsonl"
check_new_entity_guids "$catalog" "$work/local.jsonl" "$@"
printf '%s\n' "$@" > "$work/new-arguments"
entity_catalog_entries "$catalog" > "$work/catalog.jsonl"
: > "$work/expected"; : > "$work/unresolved"; : > "$work/libraries"
count=0
# local.jsonl is read twice, never modified in this loop.
# shellcheck disable=SC2094
while IFS= read -r occurrence; do
	entity=$(jq -r '.entity' <<<"$occurrence"); entry=$(jq -c '.entry' <<<"$occurrence"); guid=$(jq -r '.guid' <<<"$occurrence")
	item=$(safe_file "$repository" "$(jq -r '.settings' <<<"$entry")")
	printf '%s\n' "$item" >> "$work/expected"
	jq -e -s 'length==1' "$item" >/dev/null || fail "Expected one item JSON document: $guid"
	case "$entity" in fieldtype) filter=fieldtype-item ;; snippet) filter=snippet-item ;; snippet_type) filter=snippet-type-item ;; *) fail "Unsupported entity: $entity" ;; esac
	jq -e -f "$TOOLS_DIR/jq/$filter.jq" "$item" >/dev/null || fail "Invalid $entity item or unsupported authoring profile: $guid"
	if [[ $ENTITY_KIND == snippets ]] && grep -Fqx -- "$guid" "$work/new-arguments"; then
		if [[ $entity == snippet ]]; then
			jq -e '(.name|length<=150) and (.url|length<=150) and (.heading|length<=150) and (.usage|length>0) and all(.contributor_email,.contributor_name,.contributor_website,.contributor_company; length<=50)' "$item" >/dev/null || fail "New snippet exceeds current form limits or lacks usage guidance: $guid"
		else
			jq -e '(.name|length<=150) and (.description|length<=255)' "$item" >/dev/null || fail "New snippet type exceeds current form/storage limits: $guid"
		fi
	fi
	jq -e --argjson entry "$entry" '.guid==$entry.guid and .name==$entry.name' "$item" >/dev/null || fail "Index/item identity or name mismatch: $guid"
	if [[ $entity == fieldtype ]]; then
		jq -e --argjson entry "$entry" 'def summary: gsub("^[ \t\n\r\u0000\u000b]+|[ \t\n\r\u0000\u000b]+$";"")|if length==0 then null else . end; ((.short_description // .description)|summary)==$entry.desc' "$item" >/dev/null || fail "Fieldtype index summary differs from trimmed source description: $guid"
	elif [[ $entity == snippet ]]; then
		jq -e --argjson entry "$entry" '(.short_description // .description // null)==$entry.desc' "$item" >/dev/null || fail "Snippet index summary differs from source description: $guid"
		type=$(jq -r '.type' "$item")
		if ! jq -e -s --arg guid "$type" 'any(.[]; .entity=="snippet_type" and .guid==$guid)' "$work/local.jsonl" "$work/catalog.jsonl" >/dev/null; then printf '%s -> snippet_type %s\n' "$guid" "$type" >> "$work/unresolved"; fi
		jq -r '.library' "$item" >> "$work/libraries"
	fi
	count=$((count + 1))
done < "$work/local.jsonl"
if [[ -d $repository/src ]]; then
	while IFS= read -r -d '' item; do
		item=$(realpath -e -- "$item")
		grep -Fqx -- "$item" "$work/expected" || fail "Unindexed item.json: $item"
	done < <(find "$repository/src" -name item.json -print0)
fi
if [[ $ENTITY_KIND == snippets && ! -f $repository/snippet-type.json ]]; then printf 'NOTE: local snippet-type.json absent; referenced types must resolve in the catalog.\n' >&2; fi
if [[ -s $work/unresolved ]]; then cat "$work/unresolved" >&2; printf 'UNRESOLVED: snippet type references absent from the supplied local/catalog indexes.\n' >&2; exit 2; fi
if [[ -s $work/libraries ]]; then printf 'UNVERIFIED: %s library GUID(s) require separate package-catalog and runtime asset verification.\n' "$(sort -u "$work/libraries"|wc -l)" >&2; fi
shadowed=$(jq -s '[group_by([.entity,.guid])[]|select(length>1)]|length' "$work/catalog.jsonl")
if (( shadowed > 0 )); then printf 'NOTE: %s catalog identities have ordered overrides; inspect resolution.json.\n' "$shadowed" >&2; fi
local_matches=$(jq -n --slurpfile local "$work/local.jsonl" --slurpfile catalog "$work/catalog.jsonl" '[ $local[] | . as $candidate | select(any($catalog[]; .entity==$candidate.entity and .guid==$candidate.guid)) ]|length')
if (( local_matches > 0 )); then printf 'NOTE: %s local identities also occur in catalogs; confirm same-item maintenance/overrides and explicit consumer order. Local candidates are not automatically inserted into catalog precedence.\n' "$local_matches" >&2; fi
printf 'PASS: %s %s records; static checks only.\n' "$count" "$ENTITY_KIND"
