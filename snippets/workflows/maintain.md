# Maintain, debug and migrate snippets

## Before editing

Identify the exact repository/branch/commit, snippet GUID, type/library references, consuming Joomla/template/library versions and the reported result. Read the authoritative item and both indexes. Determine whether the defect belongs to catalog source, JCB editor selection, imported local state, copied consumer markup, library assets or runtime data. A correction in the wrong layer may leave the reported failure unchanged.

Search official core and configured additional repositories for the identity and related patterns. Preserve existing GUID and attribution. A same-name item is not necessarily the same item; a same-GUID override may shadow core. Capture both definitions and actual configured order.

## Editing an existing item

1. Preserve the GUID and canonical paths. Edit decoded `snippet`, usage and relevant metadata in `item.json`; regenerate JSON using jq or another safe serializer.
2. For a source fix, review dynamic-data escaping, library/version assumptions, user-facing text, DOM IDs, semantics, keyboard/focus behaviour and event handlers. Do not introduce a second framework or duplicate dependency to avoid understanding the configured library.
3. For a changed type/library, update scalar links and corresponding `@dependencies` together. Reuse existing identities where their meaning fits. Inspect downstream category/library consumers before renaming or materially changing a shared type.
4. Update index `name`/`desc` and README where affected. Do not change contributor fields to falsely claim upstream authorship or erase it.
5. Run `validate-snippet-repository.sh REPO_DIR CATALOG_DIR` using the actual paths prepared in the creation workflow. Use `--new-guid` only for genuinely new records; ordinary validation permits retained identities.
6. Test [import/reset and the consumer](integrate.md). If users already copied the old markup, provide a concrete old-to-new adaptation note; the catalog update will not migrate those views automatically.
7. Push the requested branch/PR with evidence and remaining limitations. Keep unrelated source formatting or mass rewrites out of a focused repair.

## Debugging map

| Symptom | Evidence to inspect | Correct response |
| --- | --- | --- |
| Repository not listed | JCB repository target/host/owner/name/read branch, credentials and permissions | Configure the actual Snippet target. Do not assume old singular `snippet` defaults point at the official plural `joomengine/snippets`. |
| Item absent from remote selection | `snippet-index.json`, identity/path casing, selected branch, fetch errors | Repair locator/index or source access; an unindexed directory is not discoverable. |
| Item fetch fails despite `settings` looking correct | Actual `path + /item.json` retrieval, item GUID | Correct both locator fields and file location. |
| Init leaves old local content | Existing local GUID and non-forced init outcome | Preserve intended local changes, then use the tested update/reset path; a successful init does not mean refresh. |
| Item missing after choosing a library | Snippet library GUID, consumer libraries, local published state, available joined type/library records | Verify actual references and publication state. Current selected-library filtering requires published=1; other paths accept >=1. |
| Edit button absent for a selected snippet | Current SnippetsField GUID option versus numeric-only edit-helper logic | Record a JCB UI defect; do not corrupt the repository by replacing GUIDs with numeric IDs. |
| Markup appears in preview but not generated output | Consumer's saved `default`/template/layout code | Copy/adapt the source into the actual code editor; selector state is temporary. |
| Reset changes catalog but not an existing view | View's copied source and migration note | Update the consumer's own markup deliberately. |
| Plain/unstyled markup or inactive widget | Actual target CSS/JS assets, versions, initialization and browser errors | Configure compatible consumer libraries/assets. Snippet classification is not automatic installation. |
| Duplicate IDs, wrong click target or keyboard failure | Repeated markup IDs, event bindings, accessible names and focus behaviour | Make instance identifiers unique and test the interaction in the real page. |
| Source displays as base64/entity text | Repository string versus local storage and preview | Restore raw text in item.json; do not copy database encoding into the repository. |
| Preview executes unexpected markup | Source and rich metadata trust review | Stop rendering that content, inspect it as text, repair the unsafe code/preview issue and document the affected boundary. |

For missing library/type dependencies, distinguish inaccessible source from invalid identity. Preserve the unresolved GUID and provenance in diagnostics; do not guess another record by display name.

## Deletion, deprecation and compatibility

Before removing a catalog entry, inspect references and documented consumers. Removing an index entry hides it from new discovery but does not delete an already imported local JCB record or copied markup. Removing a type can leave snippet links unresolved. Prefer a documented deprecation/migration path where users still rely on the pattern. Do not recycle retired GUIDs.

Changing a snippet's framework major version can break classes, data attributes, plugin APIs and assets despite retaining similar visual intent. Decide whether it remains a compatible evolution of the same item or is a genuinely distinct variant with a fresh identity. Preserve a clear migration note and avoid claiming broad compatibility without testing it.

## Migrate legacy flat archives

The historical format is described in [the specification](../specification.md#legacy-flat-exports-are-a-different-contract). Current tools validate the indexed format and are not a silent legacy converter.

1. Keep the original archive and provenance. Inspect each flat JSON file as data; do not execute embedded source.
2. Inventory its name, raw snippet, type/library display names, URL, attribution and old created/modified metadata.
3. Compare against current core by source/provenance and intended semantics, not filename alone. If it is a known current item, retain that current identity for its same-item maintenance path. If it is genuinely new, allocate a fresh core-checked UUIDv4.
4. Resolve type and library names to actual target GUIDs. Duplicate names, missing versions or ambiguous lineage require source investigation before assigning a link.
5. Build current `item.json`, both indexes as needed, coherent dependency rows and documentation. Move historic timestamps/provenance into the README or migration record rather than importing unsupported columns.
6. Validate and test in the declared JCB version and consumer. Report any unresolved mapping and do not claim automated universal migration.

The output is a reviewable current repository plus migration notes; no old filename is used as a new stable GUID.
