#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
passed=0
expect_status() {
	local expected=$1 label=$2 status=0; shift 2
	"$@" > "$work/output" 2>&1 || status=$?
	if [[ $status != "$expected" ]]; then
		printf 'FAIL: %s (expected %s; got %s)\n' "$label" "$expected" "$status" >&2
		cat "$work/output" >&2; exit 1
	fi
	passed=$((passed + 1)); printf 'PASS: %s\n' "$label"
}
edit_json() {
	local file=$1 filter=$2
	jq "$filter" "$file" > "$work/edited.json"
	mv "$work/edited.json" "$file"
}
# Synthetic catalogs isolate tests from networks and changing upstream definitions.
# The "live" flag below tests the creation gate; this is never a production catalog.
mkdir "$work/catalog" "$work/catalog/indexes"
: > "$work/repositories"
index=0
for repository in super-powers search psr phpseclib openai gitea minify; do
	printf '{}\n' > "$work/catalog/indexes/$index.json"
	checksum=$(sha256sum "$work/catalog/indexes/$index.json"); checksum=${checksum%% *}
	jq -nc --arg id "joomengine/$repository" --arg file "indexes/$index.json" --arg sha "$checksum" '{id:$id,url:("https://github.com/"+$id+".git"),branch:"master",index:"super-powers.json",commit:"1111111111111111111111111111111111111111",index_file:$file,sha256:$sha}' >> "$work/repositories"
	index=$((index + 1))
done
jq -s --arg date "$(date -u +%FT%TZ)" '{version:1,mode:"live",created_at:$date,repositories:.}' "$work/repositories" > "$work/catalog/manifest.json"
cp -R "$root/super-powers/examples/minimal-repository" "$work/repository"
guid=$(jq -r 'keys[0]' "$work/repository/super-powers.json")
settings="$work/repository/src/$guid/settings.json"
body="$work/repository/src/$guid/code.power"
code="$work/repository/src/$guid/code.php"
expect_status 0 'complete documented example validates' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
expect_status 0 'fresh complete catalog generates UUID' bash "$root/tools/new-power-guid.sh" "$work/catalog" "$work/repository"
grep -Eq '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$' "$work/output"
cp "$settings" "$work/settings.original"
cp "$body" "$work/body.original"
cp "$code" "$work/code.original"
cp "$work/repository/super-powers.json" "$work/index.original"
cp "$work/catalog/manifest.json" "$work/manifest.original"
: > "$body"
jq -r '.[] | "<?php\nnamespace "+.namespace+";\n"+.type+" "+.name+"\n{\n}\n"' "$work/index.original" > "$code"
expect_status 0 'empty body is valid' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/body.original" "$body"
cp "$work/code.original" "$code"
sed 's/function contains/function [[[MethodName]]]/' "$work/body.original" > "$body"
expect_status 0 'raw placeholder syntax is deferred until compiler expansion' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
grep -Fq '1 bodies require compiler comparison' "$work/output"
cp "$work/body.original" "$body"
edit_json "$settings" '.extends="-1" | .extends_custom="ExternalBase"'
expect_status 0 'custom inheritance sentinel is valid' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
edit_json "$settings" 'del(.extends_custom)'
expect_status 1 'custom inheritance requires custom name' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/settings.original" "$settings"
edit_json "$settings" '.head=42'
expect_status 1 'header must retain text representation' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/settings.original" "$settings"
edit_json "$settings" '.composer={composer0:{access_point:"vendor/autoload.php",namespace:{namespace0:{use:"Vendor\\Example"}}}}'
expect_status 0 'nested Composer rows are accepted' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
edit_json "$settings" '.composer.composer0.namespace.namespace0.use=4'
expect_status 1 'malformed nested Composer namespace is rejected' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/settings.original" "$settings"
edit_json "$settings" '.namespace="[[[NamespacePrefix]]]\\Joomla\\OtherName"'
expect_status 1 'namespace suffix must match class name' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/settings.original" "$settings"
sed 's/final class IntegerInterval/final class WrongName/' "$work/code.original" > "$code"
if command -v php >/dev/null 2>&1; then expect_status 1 'generated class declaration must match metadata' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"; fi
cp "$work/code.original" "$code"
for filter in '.namespace="IntegerInterval"' '.namespace="[[[NamespacePrefix]]]\\Bad-Name\\IntegerInterval"' '.power_version=42' 'del(.power_version)' '.licensing_template=""' '.use_selection={row:{use:"00000000-0000-4000-8000-000000000001",as:"bad alias"}}' '.composer=[{access_point:"../escape.php",namespace:[{use:"Vendor\\Example"}]}]'; do
	edit_json "$settings" "$filter"
	expect_status 1 "invalid authoring metadata: $filter" bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
	cp "$work/settings.original" "$settings"
done
if command -v php >/dev/null 2>&1; then
	cp "$work/code.original" "$body"
	expect_status 1 'complete PHP file is not a valid Power body' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
	: > "$body"
	expect_status 1 'empty source rejects stale generated methods' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
	cp "$work/body.original" "$body"
	# A matching declaration in a comment must not conceal the actual wrong class.
	{ printf '<?php\n/*\nnamespace VDM\\Joomla\\AiDocExample;\nfinal class IntegerInterval {}\n*/\n'; sed '1d;s/final class IntegerInterval/final class WrongName/;s/namespace VDM\\Joomla\\AiDocExample;/namespace WrongNamespace;/' "$work/code.original"; } > "$code"
	expect_status 1 'comment-only namespace/declaration cannot spoof generated metadata' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
	cp "$work/code.original" "$code"
fi
printf '{}\n' >> "$work/repository/super-powers.json"
expect_status 1 'index must contain a single JSON document' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/index.original" "$work/repository/super-powers.json"
printf '{}\n' >> "$settings"
expect_status 1 'settings must contain a single JSON document' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/settings.original" "$settings"
edit_json "$settings" '.extends="00000000-0000-4000-8000-000000000001"'
expect_status 2 'unresolved GUID is distinguished from malformed settings' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/settings.original" "$settings"
printf '\n\tpublic function definitelyMissing(): void {}\n' >> "$body"
if command -v php >/dev/null 2>&1; then expect_status 1 'stale generated representation is detected' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"; fi
cp "$work/body.original" "$body"
edit_json "$settings" '.guid="00000000-0000-4000-8000-000000000002"'
expect_status 1 'settings/index GUID mismatch is rejected' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/settings.original" "$settings"
edit_json "$work/repository/super-powers.json" 'to_entries|map(.value.settings="../../outside.json")|from_entries'
expect_status 1 'path traversal is rejected before file access' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/index.original" "$work/repository/super-powers.json"
edit_json "$work/repository/super-powers.json" 'to_entries|map(.value.spk="Super___wrong___Power")|from_entries'
expect_status 1 'wrong index SPK syntax is rejected' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
cp "$work/index.original" "$work/repository/super-powers.json"
rm "$settings"; ln -s "$work/settings.original" "$settings"
expect_status 1 'symlink escaping repository is rejected' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
rm "$settings"; cp "$work/settings.original" "$settings"
edit_json "$work/catalog/manifest.json" '.repositories |= .[0:6]'
expect_status 1 'incomplete official catalog cannot issue UUID' bash "$root/tools/new-power-guid.sh" "$work/catalog"
cp "$work/manifest.original" "$work/catalog/manifest.json"
edit_json "$work/catalog/manifest.json" '.created_at="2000-01-01T00:00:00Z"'
expect_status 1 'stale catalog cannot issue UUID' bash "$root/tools/new-power-guid.sh" "$work/catalog"
cp "$work/manifest.original" "$work/catalog/manifest.json"
printf ' ' >> "$work/catalog/indexes/0.json"
expect_status 1 'modified catalog index fails integrity check' bash "$root/tools/new-power-guid.sh" "$work/catalog"
printf '{}\n' > "$work/catalog/indexes/0.json"
# Same GUID in two catalogs is retained and reported, not silently collapsed.
for index in 0 1; do
	cp "$work/index.original" "$work/catalog/indexes/$index.json"
	checksum=$(sha256sum "$work/catalog/indexes/$index.json"); checksum=${checksum%% *}
	edit_json "$work/catalog/manifest.json" ".repositories[$index].sha256=\"$checksum\""
done
expect_status 0 'ordered shadowed definitions remain valid catalog inputs' bash "$root/tools/validate-power-repository.sh" "$work/repository" "$work/catalog"
grep -Fq '1 catalog GUIDs have ordered shadowed definitions' "$work/output"
if command -v php >/dev/null 2>&1; then
	expect_status 0 'documented example runs in PHP' php -n "$root/super-powers/examples/minimal-repository/smoke.php"
else
	printf 'SKIP: PHP example execution (php is unavailable).\n'
fi
printf 'Passed %s regression checks.\n' "$passed"
