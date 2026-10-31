#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/common.sh"
if [[ ${1:-} == --help ]]; then
	printf '%s\n' 'Usage: bash tools/check-skills.sh' 'Check declared skill entry points and the restricted YAML frontmatter profile.' 'This does not install skills, emulate an agent, or prove task completion.'
	exit 0
fi
[[ $# == 0 ]] || fail 'Usage: bash tools/check-skills.sh'
root=$(cd "$TOOLS_DIR/.." && pwd)
registry="$root/registries/skills.json"
jq -e 'def nonempty: type=="string" and length>0; .version==1 and (.distribution_name|nonempty) and .distribution_root=="." and (.skills|type=="array" and length>0) and ([.skills[].name]|length==(unique|length)) and ([.skills[].path]|length==(unique|length)) and all(.skills[]; . as $skill | (.name|nonempty) and (.path|nonempty) and (["ecosystem-router","model","integration"]|index($skill.role)!=null))' "$registry" >/dev/null || fail 'Invalid skill registry'
while IFS=$'\t' read -r name path; do
	file=$(safe_file "$root" "$path")
	[[ $path == SKILL.md || $path == */SKILL.md ]] || fail "Not a skill entry point: $path"
	[[ $name =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && ${#name} -le 64 ]] || fail "Invalid skill name: $name"
	if [[ $path == SKILL.md ]]; then
		[[ $name == "$(jq -r .distribution_name "$registry")" ]] || fail 'Root skill name must match the distribution directory'
	else
		[[ $name == "$(basename -- "$(dirname -- "$path")")" ]] || fail "Skill name must match its directory: $path"
	fi
	# Deliberately restricted YAML: two scalar fields, with a JSON-quoted
	# description. JSON strings are valid YAML double-quoted scalars here.
	mapfile -t header < <(head -n 4 -- "$file")
	[[ ${#header[@]} == 4 && ${header[0]} == --- && ${header[1]} == "name: $name" && ${header[2]} == 'description: '* && ${header[3]} == --- ]] || fail "Invalid skill frontmatter profile: $path"
	description=${header[2]#description: }
	jq -e -s 'length==1 and (.[0]|type=="string" and length>0 and length<=1024)' <<< "$description" >/dev/null || fail "Invalid skill description: $path"
	[[ $(wc -l < "$file") -le 500 ]] || fail "Skill entry point is too large; split reference material: $path"
done < <(jq -r '.skills[]|[.name,.path]|@tsv' "$registry")
declared=$(jq -r '.skills[].path' "$registry" | LC_ALL=C sort)
found=$(find "$root" -path "$root/.git" -prune -o -type f -name SKILL.md -printf '%P\n' | LC_ALL=C sort)
[[ $declared == "$found" ]] || fail 'Skill registry and SKILL.md files differ'
while IFS= read -r path; do
	jq -e --arg path "$path" 'any(.skills[]; .path==$path and .role=="model")' "$registry" >/dev/null || fail "Module skill is not registered: $path"
done < <(jq -r '.modules[].skill_entrypoint // ""' "$root/registries/modules.json")
printf 'PASS: skill entry points and distribution registry.\n'
