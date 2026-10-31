# Package repository specification

**Scope:** the indexed blueprint/entity graph handled by JCB's Package services. **Implementation baseline:** JCB `6.x@408703a857ad937479b1e28de7f693af178dcc83`, inspected 2026-10-31; its manifest identifies `6.2.1-alpha1`. This is source evidence, not a claim that every path has run on that version or that an installed `6.2.0` package is identical. [Sources](sources.md) give immutable references and the limits of each claim. Requirements marked **Policy** are this repository's authoring standard.

## What a Package contains

A Package repository is a shared pool of JCB definitions, owned relationship records, indexes, descriptions and transported assets. A component, module or plugin is a root into that pool. Its usable blueprint includes the required reachable records and external definitions, not merely its root `item.json`.

| Representation | Purpose | Boundary |
| --- | --- | --- |
| Standalone entity payload | An extension, view, Field, query, library, code definition or other supported record | A projection of mapped JCB fields, not a raw database dump |
| Child payload | Parent-specific associations/configuration, such as selected Admin Views or Fields | Identified by its parent key; not a new independent entity GUID |
| `@dependencies` | Typed transport requests needed by the payload | Not an ordinary database column or a substitute for the underlying references |
| Entity index | Maps portable identities to payload locations and summaries | Not the payload itself |
| File/folder content | Images, compiler/custom files and zipped directories | Filesystem transport, not entity-table persistence |
| Generated extension | Compiled PHP/XML/SQL/assets and installable package | A downstream product, not the source Package repository |

The model inventory covers **40 database-backed entities plus file/folder transport**. There are 42 remote configurations because File and Folder have separate handlers for the same `file_system` contract. [Model contracts](model-contracts.json) and the [field reference](reference/README.md) supply each configuration's exact paths, projection, identity and fields. Do not treat all JCB tables as Package entities: a compiler feature or local table without a Package configuration does not acquire a portable format by inference. [P01](sources.md#p01), [P02](sources.md#p02).

This general ecosystem contract is separate from the supplied *JCB Blueprint Authoring MCP* project's delivery policy. That project chooses Joomla 6, blueprint branch `master` and repository authoring as its product boundary. Those choices do not remove JCB's configurable branches, the ecosystem's other Joomla targets, or this documentation's downstream integration checks. An MCP API is also not required to author or consume the repository format. [P13](sources.md#p13).

## Typed identities and supported families

Use `(entity, identifying field, value)` as the identity. A local numeric `id`, an index entry labelled `guid`, a human-readable title and a portable key are different concepts.

| Family | Entities | Portable identity |
| --- | --- | --- |
| Extension roots | `joomla_component`, `joomla_module`, `joomla_plugin` | Their own `guid` |
| View/query/reuse roots | `admin_view`, `custom_admin_view`, `site_view`, `dynamic_get`, `field`, `template`, `layout`, `library` | Their own `guid`; Template/Layout aliases are lookup helpers, not replacement identities |
| Class/plugin support | `class_extends`, `class_method`, `class_property`, `joomla_plugin_group` | Their own `guid` |
| Named definitions | `custom_code`, `placeholder`, `validation_rule` | Respectively `function_name`, `target`, `name`; see Custom Code exception below |
| Component-owned records | `component_admin_views`, `component_custom_admin_views`, `component_site_views`, `component_router`, `component_config`, `component_placeholders`, `component_updates`, `component_files_folders`, `component_custom_admin_menus`, `component_dashboard`, `component_modules`, `component_plugins` | `joomla_component`, containing the owning component's GUID |
| Admin View-owned records | `admin_fields`, `admin_fields_conditions`, `admin_fields_relations`, `admin_custom_tabs` | `admin_view`, containing the owning view's GUID |
| Module/plugin-owned records | `joomla_module_updates`, `joomla_module_files_folders_urls`; `joomla_plugin_updates`, `joomla_plugin_files_folders_urls` | `joomla_module` or `joomla_plugin`, containing that owner's GUID |
| Library-owned records | `library_config`, `library_files_folders_urls` | `library`, containing the owning library's GUID |
| Assets | `file`, `folder`, using `file_system` transport | Deterministic path-derived `key`, normally a UUIDv5-form key with extension |

**Policy:** preserve existing identities for maintenance and intentional same-item overrides. Generate a securely generated, collision-checked UUIDv4 only for a genuinely new GUID-based root. Reuse the owner's key for its child records. Choose and check natural keys within their entity domain; do not fabricate a UUID for a Placeholder or Custom Code name. Check asset identities using the normalizer's actual algorithm. Retain provenance and resolution order for intentional duplicates across repositories.

Renaming a natural key is an identity migration. Update the index, path, payload, descriptors and all consuming references together; importing the new name is not a rename/delete instruction for the old local record. The literal Placeholder target, including `[[[` and `]]]`, is its key. A component-specific placeholder row and a standalone Placeholder entity are different records.

**Custom Code exception:** the configured lookup/storage key is `function_name`. For `target == 1` automation records, the specialized exporter derives the index entry's `guid` and payload directory from `path` with `/` replaced by `#` when nonempty. The generic save/index-bucket and import paths still use the configured key. Consequently, the simple invariant “outer index key = entry GUID = function name” does not describe that route, and its complete round trip is not established here. Use the manual named-code profile for a simple new fixture; inspect and test automation records explicitly instead of normalizing them into that profile. [P03](sources.md#p03).

## Layout and locator rules

| Kind | Index | Payload |
| --- | --- | --- |
| Standalone | Exact configured `index/<name>.json` | `src/<entity>/<key>/item.json` |
| Child | Its own configured entity index | `src/<parent>/children/<parent-key>/<child-settings>.json` |
| File/folder | Shared `index/file_folder.json` | Raw bytes at `src/file_folder/<asset-key>` |

Use the configuration, not a blanket punctuation conversion: most index names use hyphens, while `index/validation_rule.json` and `index/file_folder.json` preserve underscores. Child settings names are exact filenames such as `component-admin-views.json` and `admin-fields.json`. All paths are repository-relative. Ordinary indexes are JSON objects keyed by the configured identifying value. Empty catalogues are `{}`.

The generic index entry contains `name`, `path`, `settings` and `guid`; some models add `desc`, and Template/Layout add `alias`. `guid` is a historical member name and can contain a natural key or parent key. The index's title comes from the model's title field. The generic description mapping is `short_description ?? description ?? null`, with **no trimming**; do not apply the separate Field Type exporter's trim behavior here. The listing UI adds `local` at runtime; it is not a required portable member. [P02](sources.md#p02), [P03](sources.md#p03).

For ordinary entity reads, `Remote\Grep::getRemote()` fetches **`entry.path + '/' + configured settings_name`**. It does not use `entry.settings` as a fetch override. Keep both locators consistent. The fetched object must contain the configured identity member, but this path does not establish equality between that member and the requested index key. **Policy:** validate that equality for the normal profile before import; handle the documented Custom Code exception explicitly rather than relying on the reader to reject a mismatch.

The asset reader differs: it fetches the index's `path` directly. Assets have no `item.json` and no `settings` member in their configured index map. Neither this format nor its natural-key definitions use a Super Power `settings.json`/`code.power` pair or SPK identity.

README generation is conditional. Several root models have an entity README and per-item README, while child/class/support configurations deliberately disable one or both. Do not require an item README for a type whose configuration sets `item_readme_name` to the empty string. Repository-level purpose, target versions, source provenance, licensing and operating instructions remain required authoring documentation.

**Policy:** use UTF-8 JSON and exact case; reject traversal, absolute repository paths and unsafe natural-key path values. Do not rename legitimate keys merely to simplify URL encoding. Do not treat JCB's path construction as a general validation or containment guarantee.

## Field projection, encoding and empty values

The table map explains field storage and relationships. A remote configuration selects the entity, ignored fields and any specialized mapping. `Base::mapItem()` copies the selected properties, normally supplying `null` where the property is absent. The Package exporter operates on model-loaded values, not raw stored bytes. The [field reference](reference/README.md) is the per-entity authority; SQL column defaults and UI form defaults must remain distinct from repository values. [P01](sources.md#p01), [P04](sources.md#p04).

| Storage metadata / layer | Portable value | Persistence behavior |
| --- | --- | --- |
| `store: base64` | Decoded text/code string | Upsert encodes it; Load decodes it |
| `store: json` with structured data | Native object/list appropriate to that field | Upsert uses `json_encode(..., JSON_FORCE_OBJECT)`; Load decodes once |
| `store: json` with scalar data | The intended scalar, e.g. a Field's XML string | JSON is its database storage wrapper; it does not make XML a subform object |
| Ordinary selector/reference | The documented scalar, sentinel or collection | No blanket coercion into booleans, GUIDs or strings |
| `@dependencies` | Native array of descriptors | Used by transport tracking; omitted by table-aware persistence |
| File/folder payload | Raw file/ZIP bytes | Stored through filesystem handlers, not JSON/Base64 model fields |

Do not base64-encode all repository code or JSON-encode a subform into a second string. Equally, do not require every JSON-stored field to be an object: `field.xml` is a deliberate XML string. Code carried *inside* concrete Field XML can have a further field-specific encoding boundary; refer to the Field guide and [Field Types contract](../field-types/specification.md#serialization-and-encoding-layers). A database's encoded form and a repository's portable form are not interchangeable.

The generic model applies these transforms to the fields it is modeling; it does not recursively decode every nested member of a JSON object. Inspect the consumer for nested code/XML conventions rather than applying a second blanket transform from a row's appearance.

The generic Load/Upsert models implement `base64` and `json` transforms. They are not evidence that every named encryption mode in the table map is decrypted/re-encrypted for Package transport. Preserve unknown or specialized values and inspect their actual handling rather than exposing or inventing decoded credentials.

Persistence iterates mapped table fields with `isset`. **Omitted members and explicit JSON `null` are skipped**, so they do not reliably clear an existing stored value. Explicit empty strings, zero and appropriate empty collections are different inputs; the generic model permits empties by default, but field-specific meaning still controls their use. Database defaults may apply to omitted new-record columns; they do not make a sparse payload a verified complete blueprint. Unknown payload fields are not a supported extension schema simply because the table-aware model ignores them. A persistable item must yield more than its identifying field.

Some specialized projections change meaning before export:

- The component configuration excludes installation-specific access/export/server/translation-service properties. Module/plugin/view/Field ignore lists differ. Do not reuse one list for all entities.
- Dynamic Get's specialized mapper clears fields inapplicable to `main_source`. Its `source === 1` branch is type-sensitive, while its reset-map lookup uses numeric array keys. Preserve source types and compare the exported projection; the input object is not always copied verbatim.
- Custom Code's automation route changes displayed name, description and path identity as described above. Template/Layout's specialized writer adds aliases to the index.

For a changed sentinel, selector or code-bearing value, inspect the new and existing local record after import, then inspect its actual generated consumer. A shape check cannot establish the resulting SQL, XML, PHP or runtime behavior.

## Source selection, branches and precedence

Package repositories use target **4 (JCB Packages)** in repository configuration. Provider type selects Gitea or GitHub; GitHub uses its API base. The inspected Package configuration starts with the configured core organisation's `packages` repository, `master`; its default organisation is the legacy network name `joomla`. It then prepends published registered target-4 sources. These defaults do not mean a literal GitHub URL is always appended or that every installation has identical sources. [P05](sources.md#p05).

`RepoHelper::get(4)` queries `published >= 1` with `ordering DESC`; successive prepends produce smaller ordering values first for distinct entries. Owner/repository map keys can collapse duplicate connections and do not distinguish hosts. Avoid tied ordering and duplicate connection ambiguities. Record the effective `(host, owner, repository, read branch, resolved revision)` list.

Global lookup selects the first index containing the requested identity in that entity's index. Later duplicates are shadowed; a selected entry with a broken payload does not trigger a retry against a later duplicate. An explicitly selected repository constrains the lookup to that repository. This is not “newest version wins.”

Read branch and write branch are separate. Read-side validation treats empty or literal `default` as the Git host's default branch; use an explicit existing branch for reproducible tests. The Package writer requires a nonempty write branch other than `default`. A project can choose `master` as its authoring policy while still using review branches in a test configuration. Never claim that importing one upstream branch exercised another candidate branch.

Repository objects cache indexes per entity; request trackers and loaded local records have their own lifetimes. Changing a Git branch, payload or order does not replace local JCB records. Use a fresh operation after configuration changes, perform the correct refresh, reopen the local records and compile the intended consumers.

## Dependency descriptors and discovery

An ordinary descriptor has this shape; `parent-key` here is illustrative text, not an importable GUID:

```json
{
    "key": "admin_view",
    "value": "parent-key",
    "entity": "admin_fields",
    "table": "#__componentbuilder_admin_fields",
    "direction": "in"
}
```

| Member | Meaning |
| --- | --- |
| `entity` | Canonical target entity whose handler is needed |
| `key` | That entity's identifying/relation field, not necessarily `guid` |
| `value` | Requested value for that key |
| `table` | Target table name, ordinarily `#__componentbuilder_<entity>`; assets use `file_system` |
| `direction` | `out` for referenced shared definitions; `in` for owned incoming child records |

The importer queues descriptors that have nonempty `key`, `value` and `entity`. It is not a full graph validator. Builder dispatch then uses the entity handler's configured identity and extracts descriptor values; an invented key does not redefine that handler's identity. **Policy:** validate entity/key/table/direction together, agreement with the payload's actual links, and resolution to the intended local or external source. An index entry without its payload, or a declared dependency without its target, leaves the graph incomplete. [P06](sources.md#p06).

The exporter derives requests from specific sources:

1. **Mapped links:** well-formed Table links of type `1` with target key `guid`, including supported nested subform paths. Type `2` links are not generic JCB entity dependencies.
2. **Owned children:** incoming table links filtered by the parent's configuration `children` list, then checked for an existing local record. This is not every table that happens to reference the parent. `component_mysql_tweaks`, for example, has no Package remote configuration in this baseline; the component's `custom_code` child entry is commented out.
3. **Recognized text:** Custom Code `[CUSTOMCODE=...]` references; literal Template `loadTemplate(...)` and recognized Layout render forms resolved through local alias maps; standalone Placeholders already present in the local Placeholder table. Numeric Custom Code references require local ID-to-name resolution. General runtime-computed aliases are not discovered.
4. **Special Field XML:** the specific Subform Field Type GUID `7139f2c8-a70a-46a6-bbe3-4eefe54ca515` plus a double-quoted `fields="..."` list; double-quoted `validate="..."` for custom validation rules. This is literal extraction, not a general XML/AST dependency analysis.
5. **Configured assets:** file/folder field maps and supported nested rows, normalized against actual local resources.

Text scanning is limited to fields selected by `Power\Table::search()`. Placeholder scanning is disabled for `placeholder` and `component_placeholders` themselves. Template/Layout alias-map creation can assign a missing local GUID; export discovery is not guaranteed read-only. The resolver deduplicates ordinary descriptors by entity/key/value and applies value tests; a non-GUID natural string of three or fewer trimmed characters is not accepted by its generic `validValue()` path, even though other paths may store that key. Do not silently shorten an identity or assume every stored reference is discovered.

Generic GUID links are validated as GUIDs, not automatically converted from legacy numeric database IDs. The explicit numeric conversions in Subform XML and Custom Code scanning are specific exceptions. Resolve older representations against their actual source installation before migration; never assume the same numeric ID identifies the same record elsewhere.

**Power boundary:** the generic Package resolver does not enumerate every Super/Joomla Power token into `@dependencies`. Its recognized Joomla LayoutHelper token form is a *Layout alias* scan, not a general Power scanner. Compiler Power acquisition and the separate [Super Powers](../super-powers/README.md) / Joomla Power mechanisms remain relevant. Field Types and Snippets likewise retain their own repository formats. Ensure these external requirements are available and correctly selected; do not copy them into invented `src/fieldtype` or Package Power payloads.

## Import, Pull, Reset and persistence

The UI controller family uses `initPowers`, `pullPowers`, `resetPowers` and `pushPowers` even for entities that are not PHP Powers. Names do not merge their file formats. Component initialization opens `initialization_selection&power=Component`; other roots use their registered area identifiers. Follow the [workflows](workflows/README.md) and [shared Playground configuration](../testing/playground/configuration.md), using the authenticated UI and its permission/token checks. [P07](sources.md#p07).

| Operation | Source/selection | Existing local data | Dependency scope |
| --- | --- | --- | --- |
| Init | Explicit repository, selected remote items; local list rows are not required | Existing identity is retained and categorized `local` | Only fetched payloads expose their remote descriptors; queued handlers receive the same repository and `force=false` |
| Pull | Explicit repository, selected remote items | `force=true` requests replacement/update of selected fields, subject to persistence semantics | Same explicit repository and force setting propagate through queued supported dependencies and assets |
| Reset | Selected local rows converted to their configured identity values | Fetch/update from globally ordered sources | Recurses only through queued `direction: in` records; separately invokes asset reset |
| Builder `get` | Programmatic lookup, optionally resolving helper aliases first | Ordinary local-first acquisition | Global-source acquisition, without explicit repository or force arguments |

In the inspected **Reset** implementation, outgoing requests are filtered out of the drained queue; there is no call that initializes them as part of that traversal. This differs from an architecture summary that describes outgoing ordinary acquisition. Ensure required outgoing definitions already exist or initialize them separately. Do not claim Reset refreshes or completes the entire shared graph. Asset Reset has an additional source limitation below.

The Package container dispatches only services it has registered. Unsupported/unregistered entity services can be skipped without a `not_found` result. In particular, the separate Field Type remote service is not registered in the Package container merely because a Field descriptor references it. Initialize/verify required Field Types through their own module. A complete catalogue validator must distinguish “external and resolved,” “missing,” and “no handler in this operation”; a silent service skip is not success.

Ordinary remote initialization marks an attempt before checking local existence/fetching, then invokes table-aware insert/update by the configured key. It adds an `added` result without checking the setter's Boolean return. Item/reset paths check that return separately. Reopen persisted records and inspect a distinctive expected change and relationship values; a toast or `added` category alone is not proof of storage or graph completion.

Request guards prevent repeated work for entity/key/value identities. Dependency queues are removed before recursive processing. This bounds repeated attempts for a finite graph, but it does not prove that cycles are semantically valid, all attempts succeeded or every relationship was resolved. Failed attempts can remain guarded for that request. Result buckets merge by value rather than preserving a full typed provenance graph, so the displayed summary alone can collapse same-valued keys across entity domains. Retain a typed verification ledger for complete-package acceptance.

## Export and Push behavior

Push begins with selected local identities, loads model-decoded values, projects the entity, derives its descriptors and writes through the configured writer. The builder drains newly discovered entity requests, then files/folders. It is a graph operation, not a promise to publish only the selected root. [P08](sources.md#p08).

**Consequential scope:** the generic Package writer's `targetRepo()` returns `true`. It attempts **every** configured package repository with a usable nonempty/non-`default` write branch. There is no per-item Super Power `approved_paths` gate in this generic path. Before an authorized Push, inspect all eligible destinations and restrict them to the intended publication scope through repository configuration. A read-only catalogue registration does not need a write branch.

Existing writes use repository blob metadata and comparison of mapped fields/dependencies; dependency comparison ignores descriptor order but preserves multiplicity. Missing remote SHA and unchanged content both follow a “no change/already in sync” warning path, so that message does not prove a successful byte comparison in every case. The item method can return false for a legitimate unchanged item; overall success/failure labels must be read with the messages and actual outputs.

Payload, item README, index, aggregate README, dependency items and assets are separate repository operations. There is no all-or-nothing transaction or automatic rollback across those writes or multiple repositories. One destination may succeed while another fails. The writer's index bucket is populated on creation; the existing-item update branch does not itself queue fresh descriptive index metadata. Verify index `name`/`desc`/alias/path consistency after updates instead of assuming every successful payload change refreshed it.

Index merge reloads the current entity index and preserves unrelated entries. This is not a deletion/synchronization protocol: removing an item from one local selection does not delete published content or imported records. Record deletion and natural-key migrations explicitly.

Repository placeholder configuration is distinct from compiler placeholders. Generic Package JSON creation/update serializes its mapped item directly; the existence of a base `updatePlaceholders()` helper does not establish universal replacement in every Package field. Preserve portable tokens until their actual consumer stage is known and tested.

## Files and folders

Files and folders share `index/file_folder.json` but have separate `file` and `folder` dependency queues. A portable asset descriptor contains `key`, `pointer`, `value`, `entity`, `table: "file_system"` and `target`; the current exporter does **not** add `direction`. Its local tracker additionally holds an absolute `full` path for export; that local path is not portable descriptor data. [P09](sources.md#p09).

| Member | Example role |
| --- | --- |
| `key` | Normalizer-generated identifier, usually UUIDv5-form plus `.png`, `.txt` or `.zip` |
| `pointer` | The key with every `.` replaced by `--`, used for tracker addressing |
| `value` | Normalized relative destination within the named target |
| `entity` | `file` or `folder` |
| `target` | `custom`, `compiler`, `image`, `images` or `full`, according to the field's configured mapping |

`Normalize::path()` requires an existing local file/directory, resolves its path and derives a deterministic key from the normalized relative path. The key algorithm lowercases a character-substituted path and uses the URL UUID namespace; file extensions are appended in lowercase, directories use `.zip`. This is **path identity, not content hashing**, and it is not a randomly generated UUIDv4. Target/type are not independently included in that key input. Check collisions across target scopes and case variants; changing content alone normally retains identity.

Targets reconstruct different destinations: `custom` and `compiler` refer to JCB's corresponding directories, `image` to site `/images`, `images` to site root with an `images/...` value, and `full` has constant/root handling. Do not confuse an asset's destination with a repository path. The normalizer performs path/string transformations; its name does not establish traversal rejection or universal filesystem containment. Authoring validation must check allowed targets and safe paths, and archive inspection must check the actual ZIP structure.

An exported file is its raw bytes. A folder becomes a ZIP whose contents are restored to the intended directory. The index contains `name` (destination value), `path` (repository payload), and `guid` (asset key). Neither an empty `settings_name` nor a ZIP payload should be replaced with an `item.json` default by a generator.

Init retains an existing local file/directory unless forced. Pull's force setting reaches queued assets. Storage failure is reported separately from entity persistence. File storage may delete an existing file before writing; folder storage deletes the existing directory before writing/unzipping its restore archive. A failure after removal is not rolled back. Preserve the affected local content before replacement and inspect restored files afterward. The handlers use PHP `empty()` checks for content: an empty file, and the literal content `"0"`, do not pass as ordinary successful asset payloads in these paths.

**Asset Reset limitation in the inspected source:** `GetContent::reset()` reduces the descriptor to its key and calls `item()`. That method expects `value` and `target` on the fetched object to reconstruct its destination. `GrepContent` normally returns the stock index entry (`name`, `path`, `guid`) plus content, without those destination members. Unlike Init/Pull, this route does not retain the descriptor's destination. Do not claim stock exported assets reset successfully from this source inspection. Exercise the target version with a preserved test asset; use a properly scoped descriptor-aware refresh path when appropriate, and report any reproduced issue through the [human reporting procedure](../testing/reporting-issues.md).

## Acceptance and recovery

**Policy:** complete authoring means the declared blueprint is useful to its intended consumer, not that every table has a nonempty fixture. Validate the relevant whole graph, native encoding, exact locators, identity migrations, ordered external resolution, asset payloads and meaningful model conditions. Then use the Package [integration workflow](workflows/validate-and-integrate.md) in the default [Playground environment](../testing/playground/README.md) for authorized implementation work.

Import a new root and inspect its owned and shared records. Separately test a distinctive existing-record update. Compile the actual linked component/module/plugin, inspect generated PHP/XML/SQL/assets with Code, install it where appropriate and exercise the affected runtime path. Database-held metadata, repository files and generated/installed output are different layers; return lasting fixes to the authoritative definition or compiler and regenerate.

When a lookup or traversal fails, record the typed identity, selected/shadowed sources, branch/revision, operation and persisted state. Check the selected index/payload, handler registration, external catalogues, literal discovery syntax and target capabilities before changing identifiers. A successful retry requires a fresh operation after correcting the cause, not treating the earlier attempt marker as a completion record. Preserve partial-write evidence and recover deliberately; do not republish to every writable repository merely to repair one destination.

No source observation above certifies every Package specimen, automatic dependency closure, an atomic update, or runtime compatibility. Keep performed, failed, blocked and not-run stages distinct in the change's verification record.
