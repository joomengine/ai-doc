#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/common.sh"
if [[ ${1:-} == --help ]]; then
	printf '%s\n' 'Usage: bash tools/validate-package-repository.sh REPOSITORY [--with REPOSITORY]... [--report FILE]' 'Offline source-derived package profile; candidate first, then ordered local sources.' 'Additional sources may contain package indexes, super-powers.json, Field Type index.json,' 'or Snippet indexes. Reads exact local bytes; does not fetch or assert freshness.' 'Checks package index/record identities, confined existing files, known field envelopes,' 'subforms, declared dependencies and source Table links. File/folder bytes are not executed.' 'Exit 0 static checks pass; 1 malformed/unsafe; 2 unresolved references.' 'Optional report retains provenance/order, selected/shadowed occurrences and findings.' 'No import/compiler/runtime proof; local database-ID links and token-derived dependencies' 'are not fully resolved. See tools/README.md for exact limitations.'
	exit 0
fi
[[ $# -gt 0 ]] || fail 'Expected REPOSITORY; use --help'
repos=("$1"); shift; report=''
while [[ $# -gt 0 ]]; do
	case $1 in
		--with) [[ $# -ge 2 ]] || fail '--with requires repository'; repos+=("$2"); shift 2 ;;
		--report) [[ $# -ge 2 ]] || fail '--report requires file'; report=$2; shift 2 ;;
		*) fail "Unknown argument: $1" ;;
	esac
done
contracts=$(realpath -e "$TOOLS_DIR/../packages")
manifest=$contracts/model-contracts.json
scratch=$(mktemp -d); trap 'rm -rf -- "$scratch"' EXIT
: > "$scratch/entries.ndjson"; : > "$scratch/links.ndjson"; : > "$scratch/notes.ndjson"
json_one() { jq -e -s 'length==1' "$1" >/dev/null || fail "Expected exactly one JSON document: $1"; }
order=0; candidates=0; assets=0
for repository in "${repos[@]}"; do
	repository=$(realpath -e -- "$repository")
	revision=$(git -C "$repository" rev-parse HEAD 2>/dev/null || printf 'unversioned')
	found=0
	while IFS= read -r config; do
		entity=$(jq -r '.entity' <<<"$config"); index=$(jq -r '.index' <<<"$config")
		[[ -e $repository/$index ]] || continue
		found=1; index_file=$(safe_file "$repository" "$index"); json_one "$index_file"
		jq -e 'type=="object" and all(to_entries[]; (.key|length>0) and (.value|type=="object") and (.value.path|type=="string" and length>0) and (.value.guid|type=="string" and length>0) and (.value.name==null or (.value.name|type)=="string"))' "$index_file" >/dev/null || fail "Malformed package index: $index_file"
		contract=$contracts/reference/$entity.json
		while IFS= read -r row; do
			identity=$(jq -r '.key' <<<"$row"); entry=$(jq -c '.value' <<<"$row"); indexed=$(jq -r '.guid' <<<"$entry"); path=$(jq -r '.path' <<<"$entry")
			jq -e '.guid|contains("/")|not' <<<"$entry" >/dev/null || fail "Unsafe indexed identity: $index_file"
			jq -e '.guid|contains("\\")|not' <<<"$entry" >/dev/null || fail "Unsafe indexed identity: $index_file"
			jq -e '.guid|test("[[:cntrl:]]")|not' <<<"$entry" >/dev/null || fail "Unsafe indexed identity: $index_file"
			[[ $indexed != . && $indexed != .. ]] || fail "Unsafe indexed identity: $index_file"
			prefix=$(jq -r '.source_directory' <<<"$config"); setting=$(jq -r '.settings_name' <<<"$config")
			[[ $path == "$prefix/$indexed" ]] || fail "Noncanonical package path: $path"
			if [[ $entity != custom_code ]]; then [[ $identity == "$indexed" ]] || fail "Index key/guid mismatch: $index_file:$identity"; fi
			if [[ $entity == file_system ]]; then
				payload=$(safe_file "$repository" "$path")
				if [[ ! -s $payload ]] || cmp -s "$payload" <(printf '0'); then fail "Asset content is empty to the JCB reader: $path"; fi
				if [[ $indexed == *.zip ]]; then
					need unzip
					unzip -Z -1 "$payload" > "$scratch/zip-list" || fail "Unreadable ZIP asset: $path"
					while IFS= read -r member; do
						[[ -n $member && $member != /* && $member != *\\* && ! $member =~ (^|/)\.\.?(/|$) && ! $member =~ ^[A-Za-z]: && ! $member =~ [[:cntrl:]] ]] || fail "Unsafe ZIP member in $path"
					done < "$scratch/zip-list"
					unzip -Z -l "$payload" > "$scratch/zip-details" || fail "Unreadable ZIP details: $path"
					! grep -Eq '^l[rwx-]{9}' "$scratch/zip-details" || fail "ZIP symlink rejected: $path"
				fi
				item=$(jq -nc --arg key "$indexed" '{key:$key}')
				((order != 0)) || assets=$((assets+1))
			else
				payload=$(safe_file "$repository" "$path/$setting")
				[[ $(jq -r '.settings' <<<"$entry") == "$path/$setting" ]] || fail "Index settings disagrees with reader path: $index:$identity"
				json_one "$payload"; item=$(jq -c . "$payload")
				jq -e 'type=="object"' "$payload" >/dev/null || fail "Record is not an object: $payload"
				key=$(jq -r '.key' <<<"$config")
				[[ $(jq -r --arg key "$key" '.[$key]' "$payload") == "$identity" ]] || fail "Record identity/index key mismatch: $payload"
				if [[ $entity == custom_code ]]; then
					expected=$(jq -r 'if (.target|tostring)=="1" and (.path|type)=="string" and (.path|length)>0 then .path|gsub("/";"#") else .function_name end' "$payload")
					[[ $indexed == "$expected" ]] || fail "CustomCode index GUID mismatch: $payload"
				fi
				if ((order == 0)); then
					jq -e --slurpfile contract "$contract" -f "$TOOLS_DIR/jq/package-record.jq" "$payload" >/dev/null || fail "Record fails pinned package profile: $payload"
					jq -e --slurpfile manifest "$manifest" --slurpfile contract "$contract" '
					  . as $item | all((."@dependencies" // [])[]; . as $ref |
					    if .entity=="file" or .entity=="folder" then true else
					      [$manifest[0].entities[]|select(.entity==$ref.entity)] as $target |
					      (if ($target|length)>0 then .key==$target[0].key else true end) and
					      (if .direction=="in" then ($contract[0].config.children|index($ref.entity)!=null) and .value==$item[$contract[0].config.guid_field] else true end)
					    end)' "$payload" >/dev/null || fail "Dependency configured key/ownership mismatch: $payload"
					jq -c --slurpfile contract "$contract" -f "$TOOLS_DIR/jq/package-links.jq" "$payload" | jq -c --arg source "$path/$setting" --arg entity "$entity" '. + {source:$source,source_entity:$entity}' >> "$scratch/links.ndjson"
					candidates=$((candidates+1))
				fi
			fi
			jq -nc --arg entity "$entity" --arg identity "$identity" --arg indexed "$indexed" --arg repository "$repository" --arg revision "$revision" --argjson order "$order" --argjson item "$item" --argjson entry "$entry" '{entity:$entity,identity:$identity,indexed:$indexed,repository:$repository,revision:$revision,order:$order,entry:$entry,item:$item}' >> "$scratch/entries.ndjson"
		done < <(jq -c 'to_entries[]' "$index_file")
	done < <(jq -c '.entities[]' "$manifest")
	# External domains retain their type; a GUID from the wrong entity cannot satisfy a link.
	for pair in 'power:super-powers.json' 'fieldtype:index.json' 'snippet:snippet-index.json' 'snippet_type:snippet-type.json'; do
		external=${pair%%:*}; index=${pair#*:}
		[[ -e $repository/$index ]] || continue
		found=1; index_file=$(safe_file "$repository" "$index"); json_one "$index_file"
		jq -e 'type=="object" and all(to_entries[]; .value.guid==.key and (.key|test("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")))' "$index_file" >/dev/null || fail "Invalid external $external index: $index_file"
		jq -c --arg entity "$external" --arg repository "$repository" --arg revision "$revision" --argjson order "$order" 'to_entries[]|{entity:$entity,identity:.key,indexed:.key,repository:$repository,revision:$revision,order:$order,entry:.value,item:{guid:.key}}' "$index_file" >> "$scratch/entries.ndjson"
	done
	((found > 0)) || fail "No recognized index in $repository"
	order=$((order+1))
done
((candidates + assets > 0)) || fail 'Candidate package repository has no indexed records/assets'
jq -s '.' "$scratch/entries.ndjson" > "$scratch/entries.json"
jq 'group_by([.entity,.identity])|map(sort_by(.order)|.[0])' "$scratch/entries.json" > "$scratch/selected.json"
jq -s --slurpfile entries "$scratch/selected.json" '
  def sentinel: .==null or .=="" or .==0 or .=="0" or .== -1 or .=="-1";
  map(. as $ref |
    if .kind=="table_link" and .key=="id" then .+{status:"deferred_local_id"}
    elif (.value|sentinel) then .+{status:"ignored_sentinel"}
    elif .entity=="file" or .entity=="folder" then
      [$entries[0][]|select(.entity=="file_system" and .indexed==$ref.key and .entry.name==$ref.value)] as $matches |
      .+{status:(if ($matches|length)>0 then "resolved" else "unresolved" end),matches:[$matches[]|del(.item)]}
    else
      [$entries[0][]|select(.entity==$ref.entity and (.item[$ref.key]|tostring)==($ref.value|tostring))] as $matches |
      .+{status:(if ($matches|length)>0 then "resolved" else "unresolved" end),matches:[$matches[]|del(.item)]}
    end)' "$scratch/links.ndjson" > "$scratch/findings.json"
# Detect unindexed authoritative records in the candidate. README/assets can have unrelated names.
candidate=$(realpath -e -- "${repos[0]}")
while IFS= read -r -d '' file; do
	relative=${file#"$candidate/"}
	jq -e --arg source "$relative" 'any(.[]; .order==0 and .entry.settings==$source)' "$scratch/entries.json" >/dev/null || fail "Unindexed authoritative record: $relative"
done < <(find "$candidate/src" -type f -name item.json -print0 2>/dev/null)
while IFS= read -r config; do
	name=$(jq -r '.settings_name' <<<"$config")
	directory=$(jq -r '.source_directory' <<<"$config")
	[[ -d $candidate/$directory ]] || continue
	while IFS= read -r -d '' file; do
		relative=${file#"$candidate/"}
		jq -e --arg source "$relative" 'any(.[]; .order==0 and .entry.settings==$source)' "$scratch/entries.json" >/dev/null || fail "Unindexed child record: $relative"
	done < <(find "$candidate/$directory" -type f -name "$name" -print0)
done < <(jq -c '.entities[]|select(.identity_kind=="parent_guid")' "$manifest")
unresolved=$(jq '[.[]|select(.status=="unresolved")]|length' "$scratch/findings.json")
deferred=$(jq '[.[]|select(.status=="deferred_local_id")]|length' "$scratch/findings.json")
shadowed=$(jq '[group_by([.entity,.identity])[]|select(length>1)]|length' "$scratch/entries.json")
jq -n --slurpfile entries "$scratch/entries.json" --slurpfile findings "$scratch/findings.json" --argjson candidates "$candidates" --argjson assets "$assets" '{version:1,profile:"package-static-v1",candidate_records:$candidates,candidate_assets:$assets,occurrences:[$entries[0][]|del(.item)],resolution:[$entries[0]|group_by([.entity,.identity])[]|sort_by(.order)|{entity:.[0].entity,identity:.[0].identity,selected:(.[0]|del(.item)),shadowed:[.[1:][]|del(.item)]}],findings:$findings[0]}' > "$scratch/report.json"
if [[ -n $report ]]; then [[ ! -e $report ]] || fail 'Report destination exists'; cp -- "$scratch/report.json" "$report"; fi
printf 'Package static profile: %s records, %s assets; %s ordered overlays; %s local-ID links deferred.\n' "$candidates" "$assets" "$shadowed" "$deferred"
if ((unresolved > 0)); then jq -r '.[]|select(.status=="unresolved")|"UNRESOLVED: \(.source) \(.origin): \(.entity).\(.key)=\(.value)"' "$scratch/findings.json" >&2; exit 2; fi
printf 'PASS: implemented package static checks; import, compiler-derived dependencies and runtime remain unverified.\n'
