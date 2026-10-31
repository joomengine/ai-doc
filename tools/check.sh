#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/common.sh"
source "$TOOLS_DIR/lib/entity-common.sh"
if [[ ${1:-} == --help ]]; then
	printf '%s\n' 'Usage: bash tools/check.sh' 'Offline checks: shell syntax; all JSON parses; relative Markdown link files exist;' 'registry structure; regression tests. Does not fetch URLs or validate anchors.'
	exit 0
fi
[[ $# == 0 ]] || fail 'Usage: bash tools/check.sh'
root=$(cd "$TOOLS_DIR/.." && pwd)
while IFS= read -r -d '' script; do bash -n "$script"; done < <(find "$root/tools" "$root/tests" -type f -name '*.sh' -print0)
while IFS= read -r -d '' json; do jq -e -s 'length==1' "$json" >/dev/null || fail "Expected one valid JSON document: $json"; done < <(find "$root" -path "$root/.git" -prune -o -type f -name '*.json' -print0)
# Check Markdown destinations, ignoring fenced examples and remote links.
link_pattern='\[[^]]*\]\(([^)]*)\)'
# All operations inside this loop are read-only.
# shellcheck disable=SC2094
while IFS= read -r -d '' markdown; do
	fenced=0; line_number=0
	while IFS= read -r line || [[ -n $line ]]; do
		line_number=$((line_number + 1))
		if [[ $line =~ ^[[:space:]]*\`\`\` || $line =~ ^[[:space:]]*~~~ ]]; then fenced=$((1 - fenced)); continue; fi
		(( fenced == 0 )) || continue
		while [[ $line =~ $link_pattern ]]; do
			match=${BASH_REMATCH[0]}; target=${BASH_REMATCH[1]}
			line=${line#*"$match"}
			[[ $target == http:* || $target == https:* || $target == mailto:* || $target == \#* ]] && continue
			target=${target%% \"*}; target=${target#<}; target=${target%>}; target=${target%%\#*}; target=${target%%\?*}
			[[ -z $target ]] && continue
			[[ -e $(dirname "$markdown")/$target ]] || fail "Broken local link $target at $markdown:$line_number"
		done
	done < "$markdown"
done < <(find "$root" -path "$root/.git" -prune -o -type f -name '*.md' -print0)
if [[ -f $root/registries/power-repositories.json ]]; then
	jq -e '.version==1 and (.repositories|type=="array" and length>=7) and ([.repositories[].id]|length==(unique|length)) and all(.repositories[]; (.id|type=="string") and (.url|type=="string") and (.branch|type=="string") and .index=="super-powers.json")' "$root/registries/power-repositories.json" >/dev/null || fail 'Invalid Power registry'
fi
if [[ -f $root/registries/modules.json ]]; then
	jq -e 'def nonempty: type=="string" and length>0; .version==1 and (.modules|type=="array") and ([.modules[].id]|length==(unique|length)) and all(.modules[]; . as $m | (.id|nonempty) and (.path|nonempty) and (.scope|nonempty) and (.entrypoint|nonempty and startswith($m.path+"/")) and (.source_baseline|nonempty) and (.test_workflow|nonempty and startswith($m.path+"/")) and (["in-progress","documented","deprecated"]|index($m.status)!=null) and (.verification.static|nonempty) and (.verification.integration|nonempty))' "$root/registries/modules.json" >/dev/null || fail 'Invalid module registry'
	while IFS= read -r destination; do safe_file "$root" "$destination" >/dev/null; done < <(jq -r '.modules[]|.entrypoint,.source_baseline,.test_workflow' "$root/registries/modules.json")
fi
for domain in field-types snippets; do
	entity_domain "$domain"
	validate_entity_registry "$root/registries/$ENTITY_REGISTRY"
done
bash "$TOOLS_DIR/check-skills.sh"
if [[ -f $root/packages/model-contracts.json ]]; then
	jq -e '.version==1 and (.entities|type=="array") and ([.entities[].entity]|length==(unique|length)) and .counts.logical_entities==(.entities|length) and .counts.database_entities==([.entities[]|select(.kind=="database")]|length) and .counts.serialized_top_level_fields==([.entities[].field_count]|add)' "$root/packages/model-contracts.json" >/dev/null || fail 'Invalid package inventory'
	while IFS= read -r destination; do safe_file "$root/packages" "$destination" >/dev/null; done < <(jq -r '.entities[]|.reference,.guide,.schema' "$root/packages/model-contracts.json")
fi
bash "$root/tests/run-fetch-tests.sh"
bash "$root/tests/run-tests.sh"
bash "$root/tests/run-entity-tests.sh"
bash "$root/tests/run-package-tests.sh"
printf 'PASS: offline documentation and tooling checks.\n'
