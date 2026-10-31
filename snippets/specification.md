# Snippet repository contract

**Authority:** verified implementation at the revisions recorded in [sources](sources.md), with additional authoring rules explicitly marked **Policy**. Field-level details are in [fields.md](fields.md).

## Current layout and source of truth

| Artifact | Role |
| --- | --- |
| `snippet-index.json` | JSON object keyed by snippet GUID; catalog display and locator data |
| `src/<guid>/item.json` | Authoritative snippet content and metadata |
| `src/<guid>/README.md` | Generated or maintained human/agent description; not the imported source |
| `snippet-type.json` | JSON object keyed by snippet-type GUID |
| `src/snippet_type/<guid>/item.json` | Authoritative category record: name, description and GUID |
| `README.md` | Repository purpose, runtime expectations, inventory, attribution and instructions |
| `LICENSE` and any retained notices | Repository and per-origin licensing information |

`Snippet/Remote/Config` selects `snippet-index.json`; base remote configuration supplies `src`, `item.json` and identity field `guid`. `SnippetType/Remote/Config` changes the source path to `src/snippet_type` and index to `snippet-type.json`, and disables automatic per-type and root README generation. Providing a helpful type README is permissible documentation, but it is not required by that exporter.

**Policy:** new repositories include both index files, even when the type index is `{}` because all types are reused externally. Use canonical paths above, UTF-8 JSON, `/` path separators and exact case. Empty indexes are objects (`{}`), not arrays (`[]`). Do not create empty snippet source as a publishable example: the current form requires source. Preserve meaningful existing line endings rather than normalizing the whole catalog in an unrelated patch.

A complete snippet index entry has `name`, `desc`, `path`, `settings` and `guid`. `desc` derives from `short_description` when present or otherwise `description`; ordinary snippet items use `description`. The type index has `name`, `path`, `settings` and `guid`. Index keys, embedded GUIDs, item GUIDs and directory identities must agree. Index display names do not establish identity and need not be globally unique.

The actual generic remote loader takes the matched index entry's **`path`** and appends its configured **`item.json`** filename. `settings` remains exported locator metadata, but changing only `settings` does not redirect that loader. Keep both coherent. No source body lives in the index. No generated PHP file is required.

## Identity and mandatory core check

**Policy:** preserve the GUID when improving the same snippet or type. For a genuinely new snippet or classification record, generate UUIDv4 using a cryptographically secure system facility, and check:

1. The current official core indexes from [the registry](../registries/snippet-repositories.json).
2. Every authorized additional catalog relevant to the task.
3. Existing items and pending additions in the target repository.

Check both snippet and type identities during allocation. Never use an example UUID, a manually invented identifier, a numeric database ID, or a hash of the snippet name. Identity is stable when a name, description, source or documentation changes. A same-item fork intentionally retains identity; a distinct new item must not reuse a core identity. Keep the provenance and intended override explicit in the PR.

The registry is a mandatory discovery/collision baseline, not a guarantee that every private or unregistered snippet worldwide was checked. Record checked commits and unresolved sources. Refresh before allocation and again before publication if upstream changed. A failed core fetch is a failed identity gate, not an empty catalog.

## Data, encoding and derived fields

An item contains the thirteen ordinary snippet fields described in the reference plus optional/generated `@dependencies`. All ordinary fields in the current core corpus are JSON strings, including the two GUID links. `snippet` contains decoded source. JSON escaping of quotes/newlines is necessary; wrapping that source in base64 or HTML-entity-encoding the whole block is incorrect.

The database stores `snippet` as base64; JCB's load/upsert and editor model paths perform the transformation. Repository authors write the decoded text. Other listed snippet fields have no base64 storage transform. `@dependencies` is transport metadata, not a database column.

The remote map derives from table metadata and excludes `access`. Database/UI values such as numeric `id`, assets, permissions, publishing state, checkout, created/modified dates, ordering, hits and record version are not the current portable snippet payload. Do not dump a database row or add Power-specific settings. Preserve unknown existing data until its target-version meaning is inspected; the new-authoring profile may reject it without proving that every historic export was invalid.

The current base mapper can produce null for missing fields, and SQL columns are nullable. That tolerance is not a useful authoring default. **Policy:** author complete string-valued records, with explicit `""` for optional text and nonempty required content/references. Do not assume omitting a field clears an existing local value. When removing text, serialize the intended empty value and test the imported record.

## Relationships and acquisition

A snippet's `type` points to `snippet_type.guid`; `library` points to `library.guid`. The former is a category such as Alerts or Cards, not MIME type or PHP class type. The latter classifies the intended UI library and connects to the package library definition.

For these two links the current exporter produces:

```json
{
  "@dependencies": [
    {
      "key": "guid",
      "value": "118327e9-ee52-493b-be69-9789cfd29ef6",
      "entity": "snippet_type",
      "table": "#__componentbuilder_snippet_type",
      "direction": "out"
    },
    {
      "key": "guid",
      "value": "6f6650a5-ebff-4783-8508-f0285c0e98a6",
      "entity": "library",
      "table": "#__componentbuilder_library",
      "direction": "out"
    }
  ]
}
```

These are existing reference identities, not new-item IDs. The dependency resolver derives edges from table link metadata. The loader's dependency trait registers nonempty `key`, `value` and `entity` with the shared tracker; it does not validate all graph semantics for the repository author. Keep both edges synchronized with the current `type`/`library` fields. Reordering equivalent dependency entries is not a substantive identity change. Do not remove an unresolved dependency to make a check pass.

Type definitions can be local or in another configured snippet repository. Library definitions use the separate package contract, ordinarily `index/library.json` and `src/library/<guid>/item.json`; they may also have configuration and file/folder/URL child records. They are **not** automatically found in `snippet-type.json`, and a library's CSS/JavaScript is not carried inside its GUID. The current core snippet repository contains no library catalog: its two referenced library identities are present in the inspected JCB installation seed data. A different target must verify its actual library records and asset configuration.

Configured repository precedence determines which existing identity is selected. Keep repository, configured read branch, commit, entity, GUID and path for each result and note shadowed alternatives. Explicit repository selection and already-present local records also affect acquisition; do not claim an unconditional global lookup order independent of the chosen operation.

## Init, Pull, Reset and Push lifecycle

The current Snippets controller exposes separate acquisition/update/publication operations through the shared package builder. They require the appropriate JCB permissions and session token.

- **Init:** selects remote definitions to acquire. Base `init(..., force=false)` preserves an already-present local identity and reports it as local; missing remote items are reported separately. Ordinary initialization is not a refresh guarantee.
- **Pull:** opens the pull-selection flow; inspect the resulting selection/diff for the configured source and target. Its availability is not proof that every selected dependency or asset was imported successfully.
- **Reset:** fetches the remote item and overwrites the local definition through the current remote path. Preserve a reviewable copy of intentional local edits first. The operation updates the catalog record, not markup already copied into views. Package reset traversal follows incoming direct-child edges; it does not refresh the ordinary outgoing type/library dependencies. Verify changed targets separately.
- **Push:** maps local records and dependency metadata into configured write repositories, updates items/indexes/documentation, and requires a write branch and write permissions. Read and write branches are separate configuration values.

Use the detailed [integration workflow](workflows/integrate.md) to test actual operation results. A source repository commit does not automatically refresh a local JCB record or recompile downstream components.

## Editor and runtime boundary

In Site Views and Custom Admin Views, the snippet selector fetches details and renders a source textarea plus usage metadata. The user/agent copies and adapts that source into the consumer's actual code field. The inspected save models clear the temporary `snippet` selection to `0`. The compiler processes the view's `default` markup and its own `libraries` selection, not a live link to the snippet record. Layout/template/module editors follow corresponding copy-aid patterns.

Therefore maintain a consumer migration note when changing an established pattern: what copied markup must change, which library version is required, whether IDs/classes/options differ, and how to verify the affected views. Do not promise that a catalog Reset updates existing consumers.

Selecting a snippet classified under a library does not itself promise to install or enable the library's CSS/JavaScript. Some compiler content detectors exist for specific features; that is not general dependency inference. Verify target libraries explicitly.

## Legacy flat exports are a different contract

JCB `3.x` at `f8b0a5df5490154e05c70c99b1ebfba5e4591077` provides a historical `shareSnippets()` exporter. It selected display names for `type` and `library`, decoded `snippet`, retained created/modified metadata, and wrote flat JSON files named from `library + " - (" + type + ") " + name` through its filename sanitizer. That selected payload did **not** contain a snippet GUID. This is pinned evidence for recognizing older archives, not a supported alternate layout for the current importer.

Do not rename such a file to `item.json` and call migration complete. Match its provenance/content against current core first; map category and library names to the actual target GUIDs without assuming names are unique; retain a known current identity for the same item, or allocate a fresh checked identity for a genuinely new item; create the indexes and dependency edges; then test import and consumer behaviour. Preserve old source metadata as documented provenance, not unsupported current payload columns. Ambiguous mappings need resolution before publication.
