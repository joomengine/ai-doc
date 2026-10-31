#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf -- "$work"' EXIT
passed=0
expect() {
	local expected=$1 label=$2 status=0; shift 2
	("$@") > "$work/output" 2>&1 || status=$?
	if [[ $status != "$expected" ]]; then printf 'FAIL: %s (expected %s; got %s)\n' "$label" "$expected" "$status" >&2; cat "$work/output" >&2; exit 1; fi
	passed=$((passed+1)); printf 'PASS: %s\n' "$label"
}
edit() { jq "$2" "$1" > "$work/edit.json"; mv "$work/edit.json" "$1"; }
mkdir -p "$work/bin" "$work/canonical" "$work/mirror"
cp "$root/super-powers/examples/minimal-repository/super-powers.json" "$work/canonical/super-powers.json"
cp "$root/field-types/examples/minimal-repository/index.json" "$work/canonical/index.json"
cp "$root/snippets/examples/minimal-repository/"snippet*.json "$work/canonical/"
cp "$work/canonical/"*.json "$work/mirror/"
for file in "$work/mirror/"*.json; do edit "$file" 'with_entries(.value.name="Mirror specimen")'; done
printf '%040d\n' 1 > "$work/canonical/commit"
printf '%040d\n' 2 > "$work/mirror/commit"
export FETCH_MOCK_ROOT="$work" FETCH_MOCK_LOG="$work/git-calls.jsonl"
FETCH_REAL_GIT=$(command -v git); export FETCH_REAL_GIT
FETCH_REAL_TIMEOUT=$(command -v timeout); export FETCH_REAL_TIMEOUT
: > "$FETCH_MOCK_LOG"
# This fake git never opens a socket or executes checked-out content. The selected
# URL controls which different fixture bytes and commit the fetch will expose.
cat > "$work/bin/git" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
directory=''; settings=()
while [[ ${1:-} == -* ]]; do
	case $1 in
		-C) directory=$2; shift 2 ;;
		-c) settings+=("$2"); shift 2 ;;
		*) printf 'Unexpected mock Git option\n' >&2; exit 99 ;;
	esac
done
command=$1; shift
case $command in
	check-ref-format) exit 0 ;;
	init) mkdir -p "${@: -1}" ;;
	ls-remote)
		if [[ ${FETCH_MOCK_REWRITE:-0} == 1 ]]; then
			"$FETCH_REAL_GIT" -C "$directory" -c 'url.https://rewrite-user:rewrite-password@rewrite.example/.insteadOf=https://mirror.example/' ls-remote --get-url "${@: -1}"
		else printf '%s\n' "${@: -1}"; fi ;;
	fetch)
		url=${@: -2:1}; ref=${@: -1}
		jq -nc --arg url "$url" --arg ref "$ref" --arg prompt "${GIT_TERMINAL_PROMPT:-unset}" --args '{url:$url,ref:$ref,prompt:$prompt,settings:$ARGS.positional}' "${settings[@]}" >> "$FETCH_MOCK_LOG"
		if [[ ${FETCH_MOCK_TIMEOUT:-0} == 1 ]]; then sleep 5; fi
		[[ $url != https://failed.example/repository.git ]] || exit 42
		if [[ $url == https://mirror.example/* ]]; then source_dir="$FETCH_MOCK_ROOT/mirror"; else source_dir="$FETCH_MOCK_ROOT/canonical"; fi
		cp -R "$source_dir" "$directory/data" ;;
	rev-parse) cat "$directory/data/commit" ;;
	show) cat "$directory/data/${1#*:}" ;;
	cat-file) [[ -f $directory/data/${2#*:} ]] ;;
	*) printf 'Unexpected mock Git command: %s\n' "$command" >&2; exit 99 ;;
esac
MOCK
chmod +x "$work/bin/git"
cat > "$work/bin/timeout" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
if [[ ${FETCH_MOCK_TIMEOUT:-0} == 1 ]]; then
	[[ $1 == --signal=TERM && $2 == --kill-after=5s && $3 == 60s ]] || exit 99
	shift 3
	# Exercise actual GNU timeout and termination without waiting a full minute.
	exec "$FETCH_REAL_TIMEOUT" --signal=TERM --kill-after=1s 0.2s "$@"
fi
exec "$FETCH_REAL_TIMEOUT" "$@"
MOCK
chmod +x "$work/bin/timeout"
export PATH="$work/bin:$PATH"
TOOLS_DIR="$root/tools"
source "$TOOLS_DIR/lib/entity-common.sh"
jq -n '{version:1,repositories:[{id:"example/first",url:"https://github.com/example/first.git",branch:"main",index:"super-powers.json"},{id:"example/second",url:"https://github.com/example/second.git",branch:"stable",index:"super-powers.json"}]}' > "$work/powers.json"
jq -n '{"example/first":"https://mirror.example/different-owner/different-repository.git"}' > "$work/power-sources.json"
expect 0 'Power fetch accepts explicit transport mapping' bash "$root/tools/fetch-power-catalog.sh" "$work/powers" "$work/powers.json" --sources "$work/power-sources.json"
expect 0 'Power provenance preserves canonical IDs and ordered actual transports' jq -e '.repositories|length==2 and .[0].id=="example/first" and .[0].url=="https://github.com/example/first.git" and .[0].fetch_url=="https://mirror.example/different-owner/different-repository.git" and .[0].commit=="0000000000000000000000000000000000000002" and .[1].id=="example/second" and .[1].fetch_url==.[1].url' "$work/powers/manifest.json"
expect 0 'Power mirror bytes and first-match shadowing are retained' jq -e 'length==1 and .[0].selected.entry.name=="Mirror specimen" and .[0].selected.order==0 and .[0].shadowed[0].order==1' "$work/powers/shadowing.json"
expect 0 'Each selected Power source is fetched exactly once with mapped auth restrictions' jq -e -s 'length==2 and .[0].url=="https://mirror.example/different-owner/different-repository.git" and .[0].prompt=="0" and (.[0].settings|index("credential.helper=")!=null) and (.[0].settings|index("http.extraHeader=")!=null) and (.[0].settings|index("http.followRedirects=false")!=null) and .[1].url=="https://github.com/example/second.git" and .[1].prompt=="unset"' "$FETCH_MOCK_LOG"
expect 0 'New Power catalog validates with transport provenance' check_catalog "$work/powers"
cp "$work/powers/manifest.json" "$work/power-manifest"
edit "$work/powers/manifest.json" 'del(.repositories[].fetch_url)'
expect 0 'Old Power catalog without fetch_url remains valid' check_catalog "$work/powers"
cp "$work/power-manifest" "$work/powers/manifest.json"
edit "$work/powers/manifest.json" '.repositories[0].fetch_url="https://user:secret@mirror.example/project.git"'
expect 1 'Power manifest rejects credential-bearing transport URL' check_catalog "$work/powers"
cp "$work/power-manifest" "$work/powers/manifest.json"
# Entity fetch preserves the domain core identity even if it is second in order.
jq -n '{version:1,repositories:[{id:"example/fields",url:"https://github.com/example/fields.git",branch:"project",index:"index.json"},{id:"joomengine/joomla-fieldtypes",url:"https://github.com/joomengine/joomla-fieldtypes.git",branch:"master",index:"index.json",required_for_collision_check:true}]}' > "$work/fields.json"
jq -n '{"joomengine/joomla-fieldtypes":"https://mirror.example/verified/core-fieldtypes.git"}' > "$work/field-sources.json"
: > "$FETCH_MOCK_LOG"
expect 0 'Field Type fetch accepts mapping before positional registry argument' bash "$root/tools/fetch-entity-catalog.sh" field-types "$work/fields" --sources "$work/field-sources.json" "$work/fields.json"
expect 0 'Entity mirror bytes, core provenance and repository order are retained' jq -e '.repositories|length==2 and .[0].id=="example/fields" and .[0].fetch_url==.[0].url and .[1].id=="joomengine/joomla-fieldtypes" and .[1].url=="https://github.com/joomengine/joomla-fieldtypes.git" and .[1].fetch_url=="https://mirror.example/verified/core-fieldtypes.git"' "$work/fields/manifest.json"
expect 0 'Entity resolution retains mirror occurrence as shadowed' jq -e 'length==1 and .[0].selected.repository=="example/fields" and .[0].shadowed[0].entry.name=="Mirror specimen" and .[0].shadowed[0].order==1' "$work/fields/resolution.json"
expect 0 'Each entity source is fetched once' jq -e -s 'length==2 and .[0].ref=="refs/heads/project" and .[1].ref=="refs/heads/master"' "$FETCH_MOCK_LOG"
entity_domain field-types
expect 0 'New entity catalog validates with transport provenance' check_entity_catalog "$work/fields"
cp "$work/fields/manifest.json" "$work/field-manifest"
edit "$work/fields/manifest.json" 'del(.repositories[].fetch_url)'
expect 0 'Old entity catalog without fetch_url remains valid' check_entity_catalog "$work/fields"
cp "$work/field-manifest" "$work/fields/manifest.json"
edit "$work/fields/manifest.json" '.repositories[0].fetch_url=null'
expect 1 'Present null fetch_url is rejected instead of treated as an old manifest' check_entity_catalog "$work/fields"
cp "$work/field-manifest" "$work/fields/manifest.json"
# The second entity domain must still fetch its mandatory related type index.
jq -n '{"joomengine/snippets":"https://mirror.example/verified/snippets.git"}' > "$work/snippet-sources.json"
: > "$FETCH_MOCK_LOG"
expect 0 'Snippet mirror fetch retains both required indexes' bash "$root/tools/fetch-entity-catalog.sh" snippets "$work/snippets" --sources "$work/snippet-sources.json"
expect 0 'Snippet catalog records one fetch and two indexed artifacts' jq -e '.repositories|length==1 and .[0].fetch_url=="https://mirror.example/verified/snippets.git" and (.[0].indexes|map(.entity)|sort)==["snippet","snippet_type"]' "$work/snippets/manifest.json"
expect 0 'Snippet related indexes do not cause a second fetch' jq -e -s 'length==1' "$FETCH_MOCK_LOG"
# Bad maps must fail before fetching, with no published directory.
printf '{"example/unknown":"https://mirror.example/project.git"}\n' > "$work/bad.json"
: > "$FETCH_MOCK_LOG"
expect 1 'Unknown source-map ID is rejected before fetching' bash "$root/tools/fetch-power-catalog.sh" "$work/unknown" "$work/powers.json" --sources "$work/bad.json"
# These expressions intentionally expand only in the child Bash invocation.
# shellcheck disable=SC2016
expect 0 'Invalid mapping makes no fetch request or output directory' bash -c '[[ ! -s $1 && ! -e $2 ]]' _ "$FETCH_MOCK_LOG" "$work/unknown"
for url in 'http://mirror.example/project.git' 'https://user:secret@mirror.example/project.git' 'https://mirror.example/project.git?token=secret' 'https://mirror.example/project.git#fragment' 'https://mirror.example/../project.git' 'https://mirror.example/project git' 'https://mirror.example:99999/project.git'; do
	jq -n --arg url "$url" '{"joomengine/joomla-fieldtypes":$url}' > "$work/bad.json"
	expect 1 "Unsafe source URL rejected: ${url%%[?#]*}" bash "$root/tools/fetch-entity-catalog.sh" field-types "$work/rejected" "$work/fields.json" --sources "$work/bad.json"
done
printf '[]\n' > "$work/bad.json"
expect 1 'Source map must be an object' bash "$root/tools/fetch-power-catalog.sh" "$work/bad-shape" "$work/powers.json" --sources "$work/bad.json"
printf '{}\n{}\n' > "$work/bad.json"
expect 1 'Source map rejects multiple JSON roots' bash "$root/tools/fetch-power-catalog.sh" "$work/bad-roots" "$work/powers.json" --sources "$work/bad.json"
printf '{"example/first":"https://failed.example/repository.git"}\n' > "$work/fail.json"
: > "$FETCH_MOCK_LOG"
expect 1 'Failed Power mirror publishes no catalog and does not retry canonical URL' bash "$root/tools/fetch-power-catalog.sh" "$work/failed-power" "$work/powers.json" --sources "$work/fail.json"
# shellcheck disable=SC2016
expect 0 'Failed mirror has exactly one attempted source and no output' bash -c '[[ ! -e $1 ]] && jq -e -s '\''length==1 and .[0].url=="https://failed.example/repository.git"'\'' "$2"' _ "$work/failed-power" "$FETCH_MOCK_LOG"
jq -n '{"joomengine/joomla-fieldtypes":"https://failed.example/repository.git"}' > "$work/fail.json"
: > "$FETCH_MOCK_LOG"
expect 1 'Failed entity mirror publishes no partial catalog after prior source succeeds' bash "$root/tools/fetch-entity-catalog.sh" field-types "$work/failed-entity" "$work/fields.json" --sources "$work/fail.json"
# shellcheck disable=SC2016
expect 0 'Failed entity source preserves attempted order without fallback or output' bash -c '[[ ! -e $1 ]] && jq -e -s '\''length==2 and .[0].url=="https://github.com/example/fields.git" and .[1].url=="https://failed.example/repository.git"'\'' "$2"' _ "$work/failed-entity" "$FETCH_MOCK_LOG"
# Original positional calls remain valid, now recording canonical fetch_url too.
expect 0 'Unmapped legacy Power invocation remains compatible' bash "$root/tools/fetch-power-catalog.sh" "$work/default-power" "$work/powers.json"
expect 0 'Unmapped catalogs explicitly record canonical transport' jq -e 'all(.repositories[]; .fetch_url==.url)' "$work/default-power/manifest.json"
: > "$FETCH_MOCK_LOG"
export FETCH_MOCK_REWRITE=1
expect 1 'Real Git insteadOf rewriting is rejected before a mapped fetch' bash "$root/tools/fetch-power-catalog.sh" "$work/rewritten" "$work/powers.json" --sources "$work/power-sources.json"
unset FETCH_MOCK_REWRITE
cp "$work/output" "$work/rewrite-diagnostic"
# shellcheck disable=SC2016
expect 0 'Rejected rewriting makes no fetch, publishes no output and reveals no rewritten credentials' bash -c '[[ ! -s $1 && ! -e $2 ]] && ! grep -Fq rewrite-password "$3"' _ "$FETCH_MOCK_LOG" "$work/rewritten" "$work/rewrite-diagnostic"
: > "$FETCH_MOCK_LOG"
export FETCH_MOCK_TIMEOUT=1
expect 1 'Mapped fetch timeout terminates the request and fails publication' bash "$root/tools/fetch-power-catalog.sh" "$work/timed-out" "$work/powers.json" --sources "$work/power-sources.json"
unset FETCH_MOCK_TIMEOUT
# shellcheck disable=SC2016
expect 0 'Timed-out mirror has one request, no retry and no catalog' bash -c '[[ ! -e $1 ]] && jq -e -s '\''length==1'\'' "$2"' _ "$work/timed-out" "$FETCH_MOCK_LOG"
printf 'Passed %s fetch transport regression checks.\n' "$passed"
