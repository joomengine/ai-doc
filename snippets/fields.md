# Snippet and type field reference

This reference describes the current repository records, not the database or REST form payload. Its authority is the pinned [table metadata, forms, SQL and remote configuration](sources.md). **New-authoring policy** uses complete, explicitly typed values. Existing nulls or absent fields need investigation; SQL nullability does not guarantee a useful editor record.

## Snippet item fields

| Field | Current repository shape | Meaning, constraints and empty handling |
| --- | --- | --- |
| `guid` | UUID string | Stable snippet identity. Must agree with index key/value and directory. Preserve for an update; securely generate and check core/current catalogs for a new item. Not a display name or local ID. |
| `name` | String | Human/agent title; required in the form, maximum 150 characters there; SQL permits 255. New authoring follows the form's 150-character boundary. Names need not be globally unique. |
| `url` | String | Source/reference documentation URL, not a script-import instruction or asset installation URL. Form requires HTTP/HTTPS and maximum 150 characters; SQL permits 255. New records use a real applicable documentation URL. Do not embed credentials. |
| `type` | UUID string | Required reference to a Snippet Type (`snippet_type.guid`). Do not use `"HTML"`, `"class"`, a category display name, or numeric local ID. |
| `heading` | String | Short explanatory heading/class-style label shown with the snippet, not the snippet's stable identity. Form requires it, allows HTML filtering and maximum 150 characters; SQL permits 255. Prefer plain descriptive text unless markup is deliberate. |
| `library` | UUID string | Required reference to `library.guid`, identifying the expected UI library. Does not itself prove assets are present/loaded. Document exact framework version and runtime setup in usage/README. |
| `snippet` | String | Actual raw source, normally HTML-based; required textarea with raw filter. JSON escapes quotes and line endings. Do not base64-encode or substitute an external file path. The SQL TEXT column imposes storage limits after the database base64 transform; verify large content in the target rather than assuming the JSON size alone is sufficient. |
| `usage` | String | Integration instructions: where to copy, prerequisite library/assets/data, required adaptation, IDs/behaviour and limitations. Optional in form; `""` is representable, but new production examples should give actionable guidance. Form uses string filtering. |
| `description` | String | Description and purpose; optional in form, HTML filtering supported. May be empty. Supplies the normal index `desc`; update that derived value with it. Rich text is part of the preview trust boundary. |
| `contributor_name` | String | Attribution, not an authenticated identity or permission grant. Optional; retain truthful existing value. Empty is preferable to invented authorship. |
| `contributor_company` | String | Optional organization attribution; do not infer it from a URL or overwrite upstream attribution. |
| `contributor_email` | String | Optional contributor contact. Current form is readonly text/string filtering, not a validated authenticated email identity. Preserve authorized public attribution; do not add a private contact from unrelated context. |
| `contributor_website` | String | Optional contributor URL/reference, stored as text. Review link safety and truthfulness; it does not convey licensing or trust. |
| `@dependencies` | Array of dependency objects | Generated transport graph metadata. For a normal new snippet include the outgoing type and library edges matching the scalar fields. Not a column or content to display. See below. |

The four contributor controls have `maxlength=50` in the inspected form, while SQL permits 255; existing core values can reflect older form settings. New authoring should fit the target form if round-trip editing is required. Existing attribution must not be truncated silently. Preserve it and document/test any target form limitation.

There is no serialized `power_version`, `namespace`, `extends`, `use_selection`, `code.power` or `code.php` contract here. A snippet can contain PHP or JCB placeholders in its raw source, but those are interpreted by the eventual consumer's code pipeline; their presence does not turn it into a Power. Document the evaluation context, available variables, escaping and required target configuration instead of assuming Power namespace substitutions apply.

## Snippet Type record

| Field | Shape | Meaning |
| --- | --- | --- |
| `guid` | UUID string | Stable category identity; preserved for a same-category update and collision-checked for a new category. |
| `name` | Nonempty string | Human category title, e.g. Alerts. It classifies snippets; it is not a programming language selector. The inspected form uses maximum 150 characters; SQL permits 255. |
| `description` | String | Optional short explanation of the classification; SQL VARCHAR(255), current text control with a 150-character limit. New records use `""` when no additional explanation is needed. |

Core type items currently have these three fields only. The type remote configuration disables generated README files. Reuse an existing suitable category GUID rather than create a synonymous category. Do not change a category's meaning radically under an identity already used by many snippets.

## Index fields

Both indexes are JSON objects keyed by identity. For snippets the entry contains:

| Field | Rule |
| --- | --- |
| `guid` | Equals the object key and item GUID. |
| `name` | Matches the authoritative item title. |
| `desc` | Matches the snippet's description in this profile; base mapper prefers `short_description` if a different entity supplies one. Not a separate editable explanation. |
| `path` | `src/<snippet-guid>`; actual loader appends `/item.json`. |
| `settings` | `src/<snippet-guid>/item.json`; exported locator metadata must remain coherent with `path`. |

Snippet-type entries omit `desc`, use `src/snippet_type/<type-guid>` for `path`, and append `/item.json` for `settings`. Neither index uses a Super Power `spk`, `power`, `code`, class type, or namespace field. JSON member order is not semantic; stable ordering reduces review noise. Do not publish duplicate JSON keys.

## Dependency row fields

| Field | Ordinary snippet value | Meaning |
| --- | --- | --- |
| `key` | `"guid"` | Referenced entity's identity column. |
| `value` | Referenced UUID | Same as the snippet's `type` or `library` value. |
| `entity` | `"snippet_type"` or `"library"` | Handler/entity name, not repository or display title. |
| `table` | `"#__componentbuilder_snippet_type"` or `"#__componentbuilder_library"` | Matching JCB table name with its placeholder prefix. Do not substitute an installation's private SQL prefix. |
| `direction` | `"out"` | The snippet requires this referenced record. Do not reverse it to `in`. |

The generic graph supports other entities and asset descriptors, but that does not authorize adding arbitrary rows to a snippet. Derive metadata from real references and target-version rules. The inspected dependency trait tolerates missing/malformed rows by skipping some of them; an authoring validator must reject inconsistent required relationships instead of copying that tolerance.

## Absent, empty and local-only values

- For new valid snippets, `name`, `url`, `heading`, `snippet`, `type`, `library` and `guid` are nonempty strings. Required links must resolve at the appropriate verification layer.
- Optional metadata uses explicit empty strings, not invented prose or contacts. A blank usage field is structurally representable but does not meet this module's standard for a useful newly authored example.
- Missing `@dependencies` is not proof that there are no dependencies: the `type` and `library` links still exist. New records include their coherent graph metadata. Review old omission against its exporter version.
- `access`, `published`, `id`, asset/checkout/audit fields and local record `version` are not the current portable payload. Publication permissions are controlled by the JCB installation/repository setup, not by adding a permission field to JSON.
- The generic map can serialize nulls for missing values. Do not replace all absent/null/empty states indiscriminately; make the intended update explicit and verify a reset/import round trip, especially when clearing content.
