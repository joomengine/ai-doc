# Snippet examples

Examples demonstrate the [current format](../specification.md); their identities are not new-production templates. Follow the [creation workflow](../workflows/create.md) to allocate fresh IDs and build a coherent repository.

## Complete local fixture

[Minimal repository](minimal-repository/README.md) contains one original noninteractive information panel, a local Snippet Type, both indexes, item documentation, AGENTS pointer and CC0 license. Its source is a JSON string. Its type relationship resolves locally; its Bootstrap v4 library GUID is intentionally external and must be verified in the consumer. This is a realistic dependency boundary, not a self-contained component.

The source uses a visible heading with a matching section label, tabs for markup indentation, and no scripts. It includes exact adaptation instructions for unique IDs, translation and dynamic output. Bootstrap's [versioned card documentation](https://getbootstrap.com/docs/4.0/components/card/) was inspected on 2026-10-31 to verify the library's card/body/title/text class vocabulary. The fixture is original markup, not a relicensed upstream snippet. It is an old-major compatibility example because that is the inspected external library identity; it is not a recommendation to add Bootstrap v4 to every Joomla project.

Fixture-only identities:

| Entity | GUID |
| --- | --- |
| Snippet | `6b3e057c-1587-4969-b032-7631b21e0e0e` |
| Snippet Type | `d08dfbab-4e5d-4ecb-a2b6-084102be3446` |

The [fully executable bootstrap](../workflows/create.md#4-fully-executable-fixture-based-bootstrap) generates different identities, rewrites the records/indexes/dependency row, and validates the result against a current core catalog. It is a local authoring exercise, not permission to publish duplicate production patterns.

## Complete pinned core examples

| Example | Verified convention | Limits |
| --- | --- | --- |
| [Alerts - Success](https://github.com/joomengine/snippets/tree/a7f536be6ea7a8af5bdf86d81c9f7f547b862365/src/eac77139-a69b-4eef-9276-254194d2bed5) | Full item/README, raw multiline HTML, named category GUID, external Bootstrap v4 library and two outgoing dependency rows | Existing source/attribution/license remain its own; no claim of target-template compatibility. |
| [Alerts - Dismissible](https://github.com/joomengine/snippets/tree/a7f536be6ea7a8af5bdf86d81c9f7f547b862365/src/e0f1a436-8527-462b-ba27-cbe60504b8f6) | Markup with a button and `data-dismiss`, demonstrating that interaction needs the correct framework plugin and version | Do not copy old data attributes into a different framework version without migration/testing. |
| [Alerts category](https://github.com/joomengine/snippets/blob/a7f536be6ea7a8af5bdf86d81c9f7f547b862365/src/snippet_type/118327e9-ee52-493b-be69-9789cfd29ef6/item.json) | Complete three-field type record, with empty optional description | The GUID identifies the existing category; reuse as a dependency when appropriate, never assign it to a new unrelated category. |
| [Core indexes](https://github.com/joomengine/snippets/tree/a7f536be6ea7a8af5bdf86d81c9f7f547b862365) | Distinct snippet and type locators and multiple source frameworks | Current-catalog checks must fetch fresh indexes; this pinned snapshot is evidence, not the allocation source forever. |

Before reusing any core source, inspect its `usage`, source reference, contributor notices and repository license. Some examples are historical instructional fragments. Complete packaging does not prove that the source is a complete secure application flow or works without adaptation.

## Invalid cases and expected response

| Input error | Required outcome |
| --- | --- |
| A new item reuses a core GUID | New-item collision gate fails; generate a fresh identity. Same-item maintenance uses the retained-identity path instead. |
| `type` is `"Alerts"` or an installation's numeric ID | Reject for current indexed authoring; resolve a real type GUID. |
| `snippet` is base64 copied from SQL | Restore decoded source; JSON validity alone does not detect intended encoding. |
| Type/library scalar differs from its dependency row | Reject inconsistency and repair both from the intended relationship. |
| Correct `settings` but wrong index `path` | Repair both; importer constructs `path + /item.json`. |
| Missing external library asset | Report consumer integration unavailable/failed; do not call a snippet-catalog pass runtime success. |
| Legacy flat JSON renamed to `item.json` | Use the explicit migration workflow and resolve identities/references. |
| Safe-looking JSON with executable preview markup | Treat as source under review; JSON parsing is not sanitization. |
