# Field Type repository specification

**Scope:** the `fieldtype` repository contract consumed by JCB's `Joomla.Fieldtype` services. **Evidence:** JCB `6.x@408703a857ad937479b1e28de7f693af178dcc83` and core catalogue `master@3be64d59378b5650825b97b44dbd58f2cdb82fcb`, inspected 2026-10-31. [Sources](sources.md) distinguish implementation, specimens and remaining verification limits. Project requirements below are explicitly marked **Policy**.

## Entities and authority boundaries

| Entity | Identity and source | Meaning |
| --- | --- | --- |
| Field Type | `guid` in an indexed `src/<guid>/item.json` | JCB authoring metadata for a kind of field |
| Concrete JCB Field | Its own Field GUID, with `fieldtype` referencing the Field Type GUID | A reusable field instance with saved XML, database choices and code-bearing values |
| Field occurrence | View/component associations to a Field | Context such as title, search, sort, tab and placement |
| Joomla form field class | PHP class resolved by Joomla for emitted XML `type` | Actual form loading/rendering and type-specific behaviour |
| Custom field output | Generated PHP/template output from an appropriate concrete Field | The implementation of a custom field; not created solely by adding an arbitrary metadata name |

A shared Field Type is foundational metadata, but it does not impose identical SQL choices on every concrete Field. Changing a type may affect many consumers; review both new-field authoring and existing-field compilation. JCB's [architecture field trace](https://github.com/joomengine/architecture/blob/7ac0ba83361e4b1d5181d2a441989ab17d50d63f/DOCS/examples/field-trace.md) demonstrates the difference between a Field Type GUID, a Field GUID and its contextual projections.

## Repository layout and import inputs

| Path | Role |
| --- | --- |
| `index.json` | Root JSON object keyed by Field Type GUID |
| `src/<guid>/item.json` | Authoritative portable Field Type record |
| `src/<guid>/README.md` | Derived description and property reference |
| `README.md` | Repository role, catalogue, runtime scope and import/override instructions |
| Licence file | Preserved original licence and contribution licensing |

**Policy:** create this complete layout. Use UTF-8, repository-relative paths with `/`, exact case and no traversal. An empty index is `{}`; an empty or missing `item.json` is invalid. The Field Type reader has no use for a Super Power `code.power`, `settings.json`, SPK or namespace placement template. Extra task-specific research files may exist, but do not masquerade as imported fields.

**Implementation:** Fieldtype remote config inherits `index.json`, `src`, `item.json` and GUID identity from the base configuration. It excludes local `catid` and `access` from the exported table projection. The reader locates `entry.path` and fetches **`entry.path + '/item.json'`**; it does not use `entry.settings` as an independent fetch override. Authors must keep both locators consistent. Item and main READMEs are generated separately. See [F03](sources.md#f03).

The complete real Text index entry is:

```json
{
    "201327fe-3067-4316-a155-3fe2a52e05c0": {
        "name": "Text",
        "path": "src/201327fe-3067-4316-a155-3fe2a52e05c0",
        "settings": "src/201327fe-3067-4316-a155-3fe2a52e05c0/item.json",
        "guid": "201327fe-3067-4316-a155-3fe2a52e05c0",
        "desc": "Single-line text input field."
    }
}
```

This is the **existing Text identity**, not an example UUID for a new unrelated type. The index key, entry GUID, directory GUID and `item.guid` must agree. `name` matches the item name. `desc` comes from trimmed `short_description` when that member is present; the exporter falls back to `description` only when the short member is absent/null, not when it is an empty string. The exporter can emit `null` when the chosen description is empty. Paths are full repository-relative paths, not relative to the item directory. [F03](sources.md#f03), [F10](sources.md#f10).

## Identity policy and core catalogue

**Policy:** [`joomengine/joomla-fieldtypes`](https://github.com/joomengine/joomla-fieldtypes) is the mandatory core identity and reuse baseline for **every** other Field Type repository. Before adding a type:

1. Fetch/read the core index at a recorded current revision.
2. Search core and the effective registered/task-specific repositories for the same capability, name and intended Joomla type.
3. If maintaining or intentionally overriding that same Field Type, keep its GUID and describe the override and expected precedence.
4. If introducing a different Field Type, generate UUIDv4 with a secure system facility and check it against core, all registered indexes and the target repository before use.

A collision check must distinguish **intentional same-identity overrides** from accidental reuse for unrelated definitions. Do not replace a core GUID to hide an intentional override, and do not assign a core GUID to a different type merely to bypass validation. Keep provenance for each catalogue entry rather than flattening duplicate GUIDs into a map that silently loses a source. The GUID is the identity; a display name, `type` example, repository name or local database ID is not interchangeable with it.

The current core count is a snapshot, not a fixed list to embed in new generators. A UUID uniqueness result applies only to the indexes/revisions actually checked. Repository identity and Field Type identity also differ: repository GUIDs configure JCB's source connections; item GUIDs identify types.

## Ordered repositories and intentional overrides

**Implementation:** Field Type lookup uses an effective ordered list. Within the remote search, `existsRemotely()` loads each repository index in order and returns the first repository containing the requested GUID. `searchRemote()` then reads that repository's item. Later entries with the same GUID are shadowed. This is intended override behaviour, not “pick whichever hash is newest.” [F04](sources.md#f04).

| Effective order | Contents | Resolution |
| --- | --- | --- |
| 1. Project fork | Text GUID with reviewed project-specific metadata | Selected Text definition |
| 2. Core repository | Same Text GUID with core metadata | Shadowed for Text; still supplies other missing identities |
| 3. Additional catalogue | New unrelated GUIDs | Supplies identities absent from earlier repositories |

This table illustrates configured order; it does not prescribe placing every specialist source after core. Put an intentional override **before** the definition it overrides and verify the resulting effective list. A selected item with invalid/unreadable payload does not cause `searchRemote()` to continue to the next repository with that GUID. Fix the selected source or its configuration; do not assume silent fallback to core.

**How the inspected JCB builds its order:**

- `RepoHelper::get(3)` reads published repository records (`published >= 1`) for target `3`, ordering them by numeric `ordering DESC`.
- `Fieldtype\Config::getApprovedjoomlapaths()` prepends each returned record to the approved map. For distinct repository keys this produces an effective ascending ordering: smaller ordering values come first.
- Configured entries precede the optional username-specific `joomla-fieldtypes` fallback and configured core-organisation fallback. Those legacy initial entries use `read_branch: master` and pass through the network-target resolution path; do not infer that the GitHub core URL is automatically appended literally.
- Entries are keyed by organisation/repository during this construction, so duplicate connection records for the same owner/repository do not create two independent precedence slots. The map key does not include host. Do not rely on ambiguous duplicate connections or tied ordering values; inspect the effective configuration.
- A lookup explicitly restricted to one repository uses that source rather than comparing the whole ordered catalogue. Record whether an initialization/import operation selects a repository explicitly.

Changing the order affects subsequent resolution. It does not rewrite already imported records. Read/write branches and host/credentials belong to repository configuration, not to the Field Type item. **Policy:** record the effective ordered `(host, repository, read branch, revision)` list, selected GUID/path and shadowed alternatives for override work. Preserve the core role even when a fork is selected first.

## Import, local state and refresh

1. Remote lookup reads the index and selected `item.json` as decoded JSON.
2. `Remote.Get::init()` normally checks the local JCB database first. An existing item is categorized as local and not fetched unless forced.
3. The Data item service inserts or updates by GUID. Its model converts nested `properties` to database JSON storage.
4. The Field Types Reset controller resolves selected local IDs to GUIDs and delegates to `Package.Builder.Get::reset('fieldtype', ...)`, which invokes the Field Type remote handler. This refreshes the selected local definition from repository lookup; it is not a Git action.
5. Compilation reads the local Field and its joined local Field Type, not GitHub on every attribute access.

The remote index is cached on the repository object for the service lifetime; selected public APIs support reload. Package tracking prevents repeating the same GUID import within a request. The compiler also caches loaded Fields. After changing an index, payload or precedence, use a fresh request and the documented refresh/reset operation, then inspect the saved record before a fresh compilation. Do not claim that clearing browser cache refreshes database definitions. [F05](sources.md#f05), [F08](sources.md#f08).

**Policy:** before refreshing an intentional override, preserve the prior local item/export and the selected source revisions. Refresh only the task's intended Field Types. Check actual persisted values and generated output; a success category or toast alone is insufficient proof that every value was written as intended. Ordinary initialization is not a substitute for a forced update of an existing GUID.

## Serialization and encoding layers

| Layer | Correct representation |
| --- | --- |
| Repository `item.json` | JSON object with the 14 portable fields described in [fields-reference.md](fields-reference.md) |
| `properties` | Native JSON object of row objects, or list of row objects; preserve meaningful order |
| Property `example`/`description` | Ordinary JSON strings with JSON escaping for quotes, backslashes and newlines |
| JCB database `fieldtype.properties` | JSON text produced by the storage model |
| Concrete Field XML | Separate authored field configuration, with its own XML escaping and special custom-code encoding |
| Emitted XML/PHP | Compiler output that must be inspected and validated for the target Joomla/PHP versions |

**Do not double-encode `properties`.** Current `Model\Upsert` applies `json_encode(..., JSON_FORCE_OBJECT)` to this field. A repository string containing serialized JSON would be encoded as a JSON string; the compiler decodes once and expects an array, so it would not recover the intended property rows. If an older export or supplied file has a string, identify that legacy representation, decode it once as a deliberate migration, validate the resulting rows and write native nested JSON. Do not call it the current contract or silently decode arbitrary values repeatedly. [F06](sources.md#f06).

Property examples may contain code or markup, but they are not globally base64 encoded. Custom concrete Field XML can carry `type_php*` content that the compiler reads through `Base64Helper::open`; that is a separate boundary. JSON escaping does not make a value safe as an XML attribute or as PHP. The current UI helper's `buildXmlAttributeLine()` concatenates values; do not assume it validates/escapes arbitrary example strings. Test quotes, ampersands, multiline code and special attributes through the actual authoring/compile path. [F07](sources.md#f07), [F09](sources.md#f09).

## Meaning of defaults and existing consumers

| Value | What it controls | What it does not establish |
| --- | --- | --- |
| Field Type `has_defaults` and SQL/storage fields | Suggested database choices returned by the Field authoring helper when requested | An automatic SQL override of every existing Field |
| Property `example` | JCB authoring seed; also compiler fallback in specific mandatory-property cases | Joomla's actual runtime default when XML omits the attribute |
| Concrete Field `xml` | The saved attributes for that Field | A guarantee that every saved attribute is emitted after metadata changes |
| Concrete Field database members | Storage selected for that Field | Form input `size`, `maxlength` or HTML default |
| Joomla field class/ancestors/layout | Actual interpretation of emitted XML and runtime defaults | JCB's recommended database model |

`Compiler\Field\Data::getQuery()` selects the concrete Field's `a.*` and joins only Field Type `name`/`properties` as type information. Therefore changes to the type's SQL suggestions do not dynamically replace existing Field SQL choices. The UI helper returns defaults only when `dbDefaults` is requested and `has_defaults == 1`; its client handling must also be checked rather than assuming every returned member is applied. [F07](sources.md#f07), [F08](sources.md#f08).

The compiler iterates the current property rows. Removing a row can stop an ordinary saved XML attribute from being emitted. For a missing/empty mandatory property on a non-custom field, it can use the row's `example`. Changing a type example, mandatory flag, translation flag or type row can therefore alter existing generated output even when that Field's saved XML is unchanged. Not all attributes are generic: the compiler handles names, types, validation, custom-code properties, repeatable fields and others specially. Do not equate a property table with a passive UI help table.

## Runtime and custom-field boundary

For a normal Field Type, the compiler prefers the `type` property's nonempty example for the emitted type; concrete XML is a fallback. `Custom`/`CustomUser` use the concrete XML's type. A type name containing `@` marks the `own_custom` route, records the original name and enters custom handling. `own_custom` is derived compiler state, not an extra portable JSON field. [F08](sources.md#f08).

Custom routes can use special properties such as `extends`, `type_php*` and `prime_php` to generate PHP. Their code context depends on the selected generator/template; a standard custom method body and an own-custom class body are not interchangeable. Follow the complete [examples](examples/README.md) and source-specific guidance in [Joomla research](joomla-research.md). For core types, reuse Joomla's supplied implementation. For genuinely new runtime behaviour, supply and test the required implementation separately; a metadata catalogue is not a package installer.

## Compatibility and acceptance

Preserve existing GUIDs and deliberate overrides. Treat renaming `name`, changing the `type` example, adding/removing mandatory properties, changing translations or replacing custom-code examples as consumer-affecting changes. Review targeted concrete Fields and generated forms/SQL/PHP before declaring compatibility. A removed catalogue entry does not delete local imported records or update referencing Fields; retain a migration path rather than silently deleting an identity.

Static acceptance covers valid JSON, complete identity/path agreement, field/row shapes, core catalogue checks, declared overrides, provenance and documentation. Integration acceptance additionally requires refresh/import, persisted-value inspection, compilation and runtime form checks on stated versions. Record exact checks and unavailable stages; neither PHP lint nor a JSON validator proves Joomla field behaviour.
