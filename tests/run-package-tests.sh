#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d); trap 'rm -rf -- "$work"' EXIT
passed=0
expect() {
	local expected=$1 label=$2 status=0; shift 2
	"$@" > "$work/output" 2>&1 || status=$?
	if [[ $status != "$expected" ]]; then printf 'FAIL: %s (expected %s; got %s)\n' "$label" "$expected" "$status" >&2; cat "$work/output" >&2; exit 1; fi
	passed=$((passed+1)); printf 'PASS: %s\n' "$label"
}
edit() { jq "$2" "$1" > "$work/edit.json"; mv "$work/edit.json" "$1"; }
reset() { rm -rf "$work/package"; cp -R "$root/packages/examples/minimal-repository" "$work/package"; }
reset
component=$(jq -r 'keys[0]' "$work/package/index/joomla-component.json")
view=$(jq -r 'keys[0]' "$work/package/index/admin-view.json")
field=$(jq -r 'keys[0]' "$work/package/index/field.json")
component_item="$work/package/src/joomla_component/$component/item.json"
field_item="$work/package/src/field/$field/item.json"
child="$work/package/src/admin_view/children/$view/admin-fields.json"
custom="$work/package/src/custom_code/aidocPackageReadme/item.json"
# A synthetic external index tests typed membership only, not a fetched core claim.
mkdir "$work/external"
jq -n '{"201327fe-3067-4316-a155-3fe2a52e05c0":{guid:"201327fe-3067-4316-a155-3fe2a52e05c0"}}' > "$work/external/index.json"
command=(bash "$root/tools/validate-package-repository.sh" "$work/package" --with "$work/external")
expect 0 'complete package graph and typed external dependency pass' "${command[@]}"
expect 2 'missing external Field Type is unresolved, not malformed' bash "$root/tools/validate-package-repository.sh" "$work/package"
edit "$field_item" '.xml={wrong:"object"}'
expect 1 'JSON-stored Field XML must retain scalar text' "${command[@]}"
reset
edit "$child" '.addfields|=tojson'
expect 1 'encoded subform string is rejected' "${command[@]}"
reset
edit "$child" '.addfields={bad:42}'
expect 1 'nonobject subform row is rejected' "${command[@]}"
reset
edit "$component_item" '.unknown_export_field="invented"'
expect 1 'unknown projected field requires source review' "${command[@]}"
reset
edit "$field_item" '.guid="00000000-0000-4000-8000-000000000001"'
expect 1 'item identity must agree with index key' "${command[@]}"
reset
edit "$work/package/index/field.json" 'with_entries(.value.path="../outside")'
expect 1 'traversing index path is rejected' "${command[@]}"
reset
cp "$field_item" "$work/outside.json"; rm "$field_item"; ln -s "$work/outside.json" "$field_item"
expect 1 'escaping item symlink is rejected' "${command[@]}"
reset
printf '{}\n' >> "$field_item"
expect 1 'multiple JSON item roots are rejected' "${command[@]}"
reset
printf '{}\n' >> "$work/package/index/field.json"
expect 1 'multiple JSON index roots are rejected' "${command[@]}"
reset
edit "$custom" '."@dependencies"[0].table="#__componentbuilder_field"'
expect 1 'dependency entity/table mismatch is rejected' "${command[@]}"
reset
edit "$custom" '."@dependencies"[0].direction="sideways"'
expect 1 'unknown dependency direction is rejected' "${command[@]}"
reset
edit "$custom" '."@dependencies"[0].value="[[[missing_placeholder]]]"'
expect 2 'missing natural-key dependency remains unresolved' "${command[@]}"
reset
edit "$custom" '."@dependencies" += [."@dependencies"[0]]'
expect 1 'duplicate dependency descriptors are rejected' "${command[@]}"
reset
edit "$field_item" '.fieldtype="00000000-0000-4000-8000-000000000001"|."@dependencies"=[]'
expect 2 'source Table reference checked even if metadata omitted' "${command[@]}"
reset
asset_child="$work/package/src/joomla_component/children/$component/component-files-folders.json"
edit "$asset_child" '."@dependencies"|=map(if .entity=="file" then .pointer="wrong" else . end)'
expect 1 'asset pointer must match the normalized key spelling' "${command[@]}"
reset
edit "$asset_child" '."@dependencies"|=map(if .entity=="file" then .target="unknown" else . end)'
expect 1 'asset target must be a supported scope' "${command[@]}"
reset
asset=$(jq -r 'to_entries[0].value.path' "$work/package/index/file_folder.json")
rm "$work/package/$asset"
expect 1 'missing raw asset is rejected' "${command[@]}"
reset
mkdir -p "$work/package/src/field/unindexed"; cp "$field_item" "$work/package/src/field/unindexed/item.json"
expect 1 'unindexed root record is rejected' "${command[@]}"
reset
mkdir -p "$work/package/src/admin_view/children/unindexed"; cp "$child" "$work/package/src/admin_view/children/unindexed/admin-fields.json"
expect 1 'unindexed owned child is rejected' "${command[@]}"
reset
cp -R "$work/package" "$work/overlay"
expect 0 'ordered same-item overlays preserve every occurrence' "${command[@]}" --with "$work/overlay" --report "$work/report.json"
expect 0 'report selects first occurrence and retains shadowed source' jq -e 'all(.resolution[]|select(.entity!="fieldtype"); .selected.order==0 and (.shadowed|length)==1 and .shadowed[0].order==2)' "$work/report.json"
# Same GUID, different entity cannot satisfy a fieldtype reference.
mkdir "$work/wrong-domain"; cp "$work/external/index.json" "$work/wrong-domain/super-powers.json"
expect 2 'Power GUID cannot satisfy a Field Type dependency' bash "$root/tools/validate-package-repository.sh" "$work/package" --with "$work/wrong-domain"
reset
edit "$component_item" '{guid}'
expect 1 'identity-only record cannot satisfy modeled-field cardinality' "${command[@]}"
reset
edit "$child" '.addfields|=with_entries(.value.order_list={bad:"shape"})'
expect 1 'nested scalar form field cannot contain an object' "${command[@]}"
reset
asset=$(jq -r 'to_entries[]|select(.key|endswith(".txt"))|.value.path' "$work/package/index/file_folder.json")
: > "$work/package/$asset"
expect 1 'empty raw asset is rejected by JCB reader compatibility check' "${command[@]}"
printf '0' > "$work/package/$asset"
expect 1 'literal zero raw asset is PHP-empty and rejected' "${command[@]}"
reset
# Generator rejects executable expressions and never includes inspected PHP.
if command -v php >/dev/null 2>&1 && php -r 'exit(extension_loaded("tokenizer") && extension_loaded("simplexml") ? 0 : 1);'; then
	source_dir="$work/source"; base="$source_dir/libraries/vendor_jcb/VDM.Joomla/src"
	mkdir -p "$base/Componentbuilder/Package/Example/Remote" "$base/Abstraction/Remote" "$source_dir/admin/forms"
	cat > "$base/Componentbuilder/Table.php" <<'PHP'
<?php
file_put_contents(__DIR__ . '/EXECUTED', 'must not run');
class Table { protected array $tables = ['example'=>['guid'=>['name'=>'guid','type'=>'text','store'=>null,'db'=>['type'=>'VARCHAR(36)','default'=>''],'link'=>null]]]; }
PHP
	cat > "$base/Abstraction/Remote/Config.php" <<'PHP'
<?php
class Config { protected array $map=[]; protected array $ignore=['access']; protected array $children=[]; protected string $guid_field='guid'; protected string $settings_name='item.json'; }
PHP
	cat > "$base/Componentbuilder/Package/Example/Remote/Config.php" <<'PHP'
<?php
class Config { protected string $table='example'; protected string $index_path='index/example.json'; protected string $src_path='src/example'; }
PHP
	printf '%s\n' '<form><fieldset><field name="guid" type="text" required="true" default=""/></fieldset></form>' > "$source_dir/admin/forms/example.xml"
	git -C "$source_dir" init -q
	git -C "$source_dir" add .
	git -C "$source_dir" -c user.name=Fixture -c user.email=fixture@example.invalid commit -qm Fixture
	expect 0 'safe literal metadata generator accepts pinned miniature source' bash "$root/tools/generate-package-contracts.sh" "$source_dir" "$work/generated"
	expect 0 'metadata generation never executes inspected PHP' test ! -e "$base/Componentbuilder/EXECUTED"
	expect 0 'generated contract preserves database and form metadata' jq -e '.fields.guid.table_metadata.db.type=="VARCHAR(36)" and .fields.guid.form[0].attributes.required=="true"' "$work/generated/reference/example.json"
	sed -i "s/\x27guid\x27;/strtoupper(\x27guid\x27);/" "$base/Abstraction/Remote/Config.php"
	git -C "$source_dir" add .; git -C "$source_dir" -c user.name=Fixture -c user.email=fixture@example.invalid commit -qm Unsupported
	expect 1 'metadata generator rejects nonliteral expressions' bash "$root/tools/generate-package-contracts.sh" "$source_dir" "$work/rejected"
	expect 0 'failed generation publishes no partial output' test ! -e "$work/rejected"
else
	printf 'SKIP: package generator regressions require PHP tokenizer and SimpleXML.\n'
fi
printf 'Passed %s total package regression checks.\n' "$passed"
