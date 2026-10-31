# Create a repository, snippet or type

## Inputs and prerequisites

Record the intended repository/branch, purpose, supported JCB/Joomla/PHP and UI-library versions, license and source attribution. Identify whether this is a new item, maintenance of an existing core item, or an intentional override. Inspect [the contract](../specification.md), [fields](../fields.md), current official core and authorized additional catalogs. Do not start by copying a core record and merely changing its name.

Use Bash, jq, Git and the hashing/path utilities listed in [tools](../../tools/README.md). Catalog fetching reads data; it must not execute repository code. Current-catalog and UUID tools are **domain-specific**: use `snippets`, not the Power GUID tool.

## 1. Empty repository setup

For a real task use the authorized target checkout and a focused new branch. For a disposable bootstrap exercise, the following runs from the root of `skills` and creates an isolated repository:

```sh
docs_dir=$(pwd -P)
work_dir=$(mktemp -d)
repo_dir="$work_dir/snippet-repository"
catalog_dir="$work_dir/snippet-catalog"
mkdir -p "$repo_dir/src/snippet_type"
git -C "$repo_dir" init -b main
printf '{}\n' > "$repo_dir/snippet-index.json"
printf '{}\n' > "$repo_dir/snippet-type.json"
bash "$docs_dir/tools/fetch-entity-catalog.sh" snippets "$catalog_dir"
```

`main` is the exercise branch, not a required JCB repository branch. Configure the actual read/write branches explicitly. The official core currently uses `master`. Additional authorized repositories belong in a task-specific copy of the registry; retain the official core and its mandatory collision-check flag. Use the fetch tool's registry argument and keep all resulting provenance, not just a flat GUID list.

Add a README identifying this as a Snippet repository, its library/runtime requirements, license and import procedure. Add a local `AGENTS.md` pointer to this module; `skills/AGENTS.md` does not automatically govern another checkout. Existing licenses and attribution must be preserved; new original code needs the project owner's chosen license. Empty indexes are an initial state, not a useful finished deliverable.

## 2. Reuse and allocate identities

Search core for the desired pattern and type, and inspect candidate source/usage before writing. Reuse a suitable type GUID and library GUID; neither becomes a new record merely because another snippet refers to it. Verify the library's package/source and runtime setup independently.

For a genuinely new item, use:

```sh
snippet_guid=$(bash "$docs_dir/tools/new-entity-guid.sh" snippets "$catalog_dir" "$repo_dir")
```

For a genuinely new category, run the same command and write its record/index before allocating another identity, so subsequent checks include the pending addition. Re-run allocation if another identity was committed upstream in the meantime. The tool refuses a missing mandatory core or stale/incomplete catalog. Do not bypass that refusal with a hard-coded UUID. Same-item improvements or intended overrides retain their existing GUID and do not use the new-item allocation path.

## 3. Write a complete definition

A new snippet requires all ordinary fields in [the field reference](../fields.md), plus coherent type/library dependency rows. Write the raw source as a UTF-8 text file while editing, then encode it with `jq --rawfile` into `snippet`; do not hand-escape quotes or base64-encode it. The authoritative final source is the string in `item.json`, not the temporary file.

For a new type, write `name`, `description` and its fresh GUID under `src/snippet_type/<guid>/item.json`, then its type index entry. If no new type is needed, leave the local type index empty and resolve the referenced type through the catalog.

Create `src/<snippet-guid>/item.json`, its per-item README and the matching snippet index entry. Derive `name`/`desc` from the actual item and all paths from the same GUID. Update root navigation. Document the expected consumer code field, library/version/assets, required data/context, translation, output escaping, keyboard/focus behaviour where interactive, and all adaptation needed. Keep each snippet focused enough that a beginner can understand what to copy and what to change.

## 4. Fully executable fixture-based bootstrap

This optional exercise creates new **local demonstration identities** from the complete documentation fixture. It is useful for proving that the format can be constructed from an empty repository; it does not authorize publishing another production copy of the fixture. Run after step 1, before adding any records:

```sh
fixture_dir="$docs_dir/snippets/examples/minimal-repository"
fixture_type=$(jq -er 'keys[0]' "$fixture_dir/snippet-type.json")
fixture_snippet=$(jq -er 'keys[0]' "$fixture_dir/snippet-index.json")
type_guid=$(bash "$docs_dir/tools/new-entity-guid.sh" snippets "$catalog_dir" "$repo_dir")
mkdir -p "$repo_dir/src/snippet_type/$type_guid"
jq --arg guid "$type_guid" '.guid=$guid' \
  "$fixture_dir/src/snippet_type/$fixture_type/item.json" \
  > "$repo_dir/src/snippet_type/$type_guid/item.json"
jq '{(.guid):{name:.name,path:("src/snippet_type/"+.guid),settings:("src/snippet_type/"+.guid+"/item.json"),guid:.guid}}' \
  "$repo_dir/src/snippet_type/$type_guid/item.json" > "$repo_dir/snippet-type.json"
snippet_guid=$(bash "$docs_dir/tools/new-entity-guid.sh" snippets "$catalog_dir" "$repo_dir")
mkdir -p "$repo_dir/src/$snippet_guid"
jq --arg guid "$snippet_guid" --arg type "$type_guid" \
  '.guid=$guid | .type=$type | ."@dependencies" |= map(if .entity=="snippet_type" then .value=$type else . end)' \
  "$fixture_dir/src/$fixture_snippet/item.json" > "$repo_dir/src/$snippet_guid/item.json"
jq '{(.guid):{name:.name,desc:.description,path:("src/"+.guid),settings:("src/"+.guid+"/item.json"),guid:.guid}}' \
  "$repo_dir/src/$snippet_guid/item.json" > "$repo_dir/snippet-index.json"
cp "$fixture_dir/LICENSE" "$repo_dir/LICENSE"
cp "$fixture_dir/AGENTS.md" "$repo_dir/AGENTS.md"
printf '# Local Snippet bootstrap exercise\n\nDemonstration only; do not publish these as new production patterns.\n\nSnippet: [%s](src/%s/item.json). Type: [%s](src/snippet_type/%s/item.json).\n\nExternal library: Bootstrap v4, GUID 6f6650a5-ebff-4783-8508-f0285c0e98a6. Verify its record and CSS in the consumer separately.\n\nOriginal demonstration source is CC0; see LICENSE.\n' \
  "$snippet_guid" "$snippet_guid" "$type_guid" "$type_guid" > "$repo_dir/README.md"
printf '# Service hours panel\n\nLocal demonstration identity: `%s`.\n\nSee [item.json](item.json) for raw source, dependencies and complete usage. This catalog item is a copy aid, not a live view binding.\n' \
  "$snippet_guid" > "$repo_dir/src/$snippet_guid/README.md"
bash "$docs_dir/tools/validate-snippet-repository.sh" "$repo_dir" "$catalog_dir" \
  --new-guid "$snippet_guid" --new-guid "$type_guid"
```

The license copying above is specific to this original CC0 fixture. It is not a rule for copying upstream material. The external Bootstrap library remains external; a structural pass is not a browser or installation pass.

## 5. Validate and make reviewable

For normal creation, run the validator with `--new-guid` for every newly allocated snippet/type. For a same-item update or intentional override, omit that flag for existing identities and disclose the source/precedence. Default validation cannot decide intent from a duplicate GUID alone.

Inspect the JSON diff, check all paths and documentation links, and review source rather than render unknown remote markup. Complete [the integration workflow](integrate.md) before claiming that the snippet works in a component. Preserve catalog hashes/commits and record any unavailable library or integration evidence.

Commit coherent changes, push the authorized branch and open/update its PR. Describe what the snippet provides, where it is used, identity/reuse decisions, dependencies, compatibility and checks. Leave merge to the user unless it was separately authorized.

## Failure recovery

- Missing/failed core: repair access/ref and fetch again; do not allocate against an empty substitute.
- Duplicate new GUID: discard the candidate before publication and regenerate coherently in every file; do not alter an existing core item to accommodate it.
- Unresolved type: locate the actual authorized type or create a legitimately new category; do not put a display name into the GUID field.
- Unavailable library: resolve package/runtime setup before claiming usability. A successful snippet/type check cannot fix it.
- Invalid JSON/raw source: correct escaping with jq, then inspect the decoded source and rerun checks.
- Incomplete JCB environment: deliver a reviewable repository and exact pending integration checks; do not mark them passed.
