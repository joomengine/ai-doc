#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/common.sh"
if [[ ${1:-} == --help || $# -ne 2 ]]; then
	printf '%s\n' 'Usage: bash tools/validate-power-repository.sh REPO_DIR CATALOG_DIR' 'Validate canonical index paths, identity, settings, SPKs, source/body consistency,' 'and GUID references against the local index plus an ordered catalog.' 'Exit 0: static checks pass; 1: malformed data/check failure; 2: unresolved GUIDs.' 'PHP syntax is checked when php is available. No code is executed or compiled.' 'This is a conservative authoring profile, not a replacement for the JCB compiler.'
	[[ ${1:-} == --help ]] && exit 0; exit 2
fi
repository=$(realpath -e -- "$1"); catalog=$(realpath -e -- "$2")
index_file=$(safe_file "$repository" super-powers.json)
validate_index "$index_file"
check_catalog "$catalog"
work=$(mktemp -d); trap 'rm -rf -- "$work"' EXIT
catalog_entries "$catalog" > "$work/catalog.jsonl"
jq -r '.guid' "$work/catalog.jsonl" > "$work/known"
jq -r 'keys[]' "$index_file" >> "$work/known"
: > "$work/unresolved"; : > "$work/expected-settings"
count=0; skipped_bodies=0; php_checks=0
php_command=(php -n)
if command -v php >/dev/null 2>&1 && ! php -n -r 'exit(function_exists("token_get_all") ? 0 : 1);'; then
	php_command+=(-d "extension=${PHP_TOKENIZER_EXTENSION:-tokenizer}")
	"${php_command[@]}" -r 'exit(function_exists("token_get_all") ? 0 : 1);' || fail 'PHP tokenizer is required; install php-common or set PHP_TOKENIZER_EXTENSION to its tokenizer extension path'
fi
while IFS= read -r entry; do
	guid=$(jq -r '.guid' <<<"$entry")
	settings=$(safe_file "$repository" "$(jq -r '.settings' <<<"$entry")")
	body=$(safe_file "$repository" "$(jq -r '.power' <<<"$entry")")
	code=$(safe_file "$repository" "$(jq -r '.code' <<<"$entry")")
	printf '%s\n' "$settings" >> "$work/expected-settings"
	jq -e -s 'length==1' "$settings" >/dev/null || fail "Expected one settings document: $guid"
	settings_type=$(jq -er '.type' "$settings")
	jq -e --arg settings_type "$settings_type" -f "$TOOLS_DIR/jq/settings.jq" "$settings" >/dev/null || fail "Settings outside documented authoring profile: $guid"
	jq -e --argjson entry "$entry" '.guid==$entry.guid and .name==$entry.name and .type==$entry.type' "$settings" >/dev/null || fail "Index/settings identity mismatch: $guid"
	# Exact body preservation works for ordinary exports. Placeholder/custom-code
	# expansion is compiler-dependent and requires the integration gate instead.
	if grep -Eq '\[\[\[|\[CUSTOMCODE=|\[EXTERNALCODE=|Super___|Joomla___|Text::' "$body"; then
		printf 'NOTE: compiler-expanded body needs JCB comparison: %s\n' "$guid" >&2
		skipped_bodies=$((skipped_bodies + 1))
		comparison=skip
	else
		comparison=compare
	fi
	if command -v php >/dev/null 2>&1; then
		printf '%s\n' "$entry" > "$work/entry.json"
		"${php_command[@]}" "$TOOLS_DIR/php/inspect-power.php" "$code" "$settings" "$work/entry.json" "$body" "$comparison" || fail "PHP source/representation check failed: $guid"
		php -n -l "$code" > "$work/php-lint" 2>&1 || { cat "$work/php-lint" >&2; fail "PHP lint failed: $guid"; }
		php_checks=$((php_checks + 1))
	fi
	jq -r -f "$TOOLS_DIR/jq/dependencies.jq" "$settings" > "$work/references"
	jq -rn --rawfile body "$body" --slurpfile settings "$settings" '[$body, ($settings[0] | .. | strings)][] | scan("Super___([0-9a-f]{8}_[0-9a-f]{4}_[0-9a-f]{4}_[0-9a-f]{4}_[0-9a-f]{12})___Power") | .[0] | gsub("_";"-")' >> "$work/references"
	while IFS= read -r dependency; do
		if ! grep -Fqx -- "$dependency" "$work/known"; then printf '%s -> %s\n' "$guid" "$dependency" >> "$work/unresolved"; fi
	done < <(sort -u "$work/references")
	count=$((count + 1))
done < <(jq -c '.[]' "$index_file")
# Missing/orphan definitions are easy to overlook when hand-editing an index.
if [[ -d $repository/src ]]; then
	while IFS= read -r -d '' settings; do
		settings=$(realpath -e -- "$settings")
		grep -Fqx -- "$settings" "$work/expected-settings" || fail "Unindexed settings.json: $settings"
	done < <(find "$repository/src" -name settings.json -print0)
fi
shadowed=$(jq -s '[group_by(.guid)[]|select(length>1)]|length' "$work/catalog.jsonl")
if (( shadowed > 0 )); then printf 'NOTE: %s catalog GUIDs have ordered shadowed definitions; inspect catalog shadowing.json.\n' "$shadowed" >&2; fi
if [[ -s $work/unresolved ]]; then
	printf 'UNRESOLVED: these references are absent from the supplied catalog, not proven invalid:\n' >&2
	sort -u "$work/unresolved" >&2
	exit 2
fi
printf 'PASS: %s powers; %s PHP syntax checks; %s bodies require compiler comparison.\n' "$count" "$php_checks" "$skipped_bodies"
if ! command -v php >/dev/null 2>&1; then printf 'NOTE: php unavailable; syntax, declaration/namespace and body checks were not run.\n' >&2; fi
printf 'JCB import, compile, target compatibility, runtime behaviour and full dependency closure remain integration checks.\n'
