# Snippets verification record

**Inspection date:** 2026-10-31. This record distinguishes source review and static repository acceptance from actual JCB/view/browser integration.

## Source and catalogue evidence

The module inspected JCB `6.x@408703a857ad937479b1e28de7f693af178dcc83` and the official core Snippets repository at `master@a7f536be6ea7a8af5bdf86d81c9f7f547b862365`. The core contains 353 snippets and 40 snippet types at this revision; there are no overlapping identities between the two indexes, and every core snippet's type reference resolves to a core type. Library identities are external to this repository and remain a separate dependency boundary. Exact source paths and historical-format evidence are recorded in [sources.md](sources.md).

Independent content review checked the fields/encoding, index-to-item loader, generated dependency edges, controller task names, creation/maintenance workflows and consumer lifecycle against the implementation. It confirmed and clarified three consequential behaviours: explicit registration of the official plural `snippets` repository; Reset does not traverse outgoing category/library dependencies; and the view selector is a copy aid rather than a live binding that updates existing view source.

## Complete example and fresh-agent exercise

The [maintained example](examples/README.md) contains a snippet and its local classification, both using reserved fixture identities. Static validation and explicit new-GUID checks passed against a fresh core catalogue. Its library reference is deliberately reported as **UNVERIFIED** by the static tools; a library GUID is not proof of installed or loaded assets.

An independent agent used the documented creation path to build a separate scratch Snippet repository, generated fresh snippet and type UUIDv4 values checked against core and additional local records, and authored the complete indexes, payloads, documentation and licensing. Its static validation passed with both identities declared new.

The agent also prepared an intentional same-item override of an existing core snippet. The resolution record retained the selected local definition and shadowed core occurrence for a proposed configured order; it was not an observed lookup in an installed JCB instance. Maintenance validation accepted the preserved GUID; `--new-guid` rejected the same identity as a collision. No official core Snippet source was changed.

## Repeatable checks

The final local run passed 34 existing Power regression checks plus 41 Field Type/Snippet checks (**75 total**), documentation/registry checks and ShellCheck. The combined checks passed with both jq 1.7 and 1.8.1 after correcting a Snippet filter binding exposed by CI. The independent review's 22-case negative matrix also passed after its two findings were corrected. All 393 current core snippet/type records passed the static authoring profile, with the two external library GUIDs explicitly reported as unverified. The PHP-enabled combined run used PHP 8.3.6; no snippet runtime is inferred from that environment.

From the documentation repository root:

```bash
bash tools/check.sh
shellcheck -x -P tools tools/*.sh tools/lib/*.sh tests/*.sh
```

The [entity regression suite](../tests/run-entity-tests.sh) checks complete and empty repositories, snippet/type identity separation, core collisions, required core indexes, catalogue integrity/freshness, ordered overrides, unresolved or wrong-kind type references, dependency metadata consistency, canonical paths and JSON shape. It never executes snippet content. The combined check also retains the existing Super Power regression suite. [PR #2 checks](https://github.com/joomengine/skills/pull/2/checks) identifies the result for the exact published commit.

Static checks establish only the [documented tooling profile](../tools/README.md). Duplicate JSON keys, actual library/package availability, complete import graph behaviour, consumer code adaptation and runtime effects require the stated additional review/integration evidence.

## Playground available; Snippet integration not executed

The shared browser-based Playground is now an available integration route; see its [setup](../testing/playground/README.md), [configuration](../testing/playground/configuration.md) and [environment verification record](../testing/playground/verification.md) for the actual environment and observed operations. A shared Power import establishes only that recorded path. It does not establish Snippet acquisition, dependency resolution, copying, compilation or rendering.

**No live Snippet fixture import or consumer compilation has been executed.** The following module-specific stages remain **not run**:

| Stage | Evidence still required |
| --- | --- |
| Snippet repository resolution | Enabled Snippet target, intended read branch and effective source/order for a selected GUID |
| Init, Pull and Reset | Persisted snippet values before/after each applicable operation; stable identity; separate type/library resolution and update results |
| Real consumer and copy boundary | Source copied/adapted into a saved Site View or Custom Admin View; catalog refresh leaves that copy unchanged; deliberate consumer update persists |
| Compilation and installation | Generated view contains the intended source, assets and resolved context; compiled component installs into the declared target |
| Browser, accessibility and security | Actual route renders; compatible assets load; relevant keyboard, focus, dynamic escaping and permission/form cases pass |
| Authoritative fix round trip | Any diagnosis made in JoomEngine Code returns to snippet/blueprint/compiler source and survives regeneration and retesting |

The [consumer integration workflow](workflows/integrate.md) is the default authorized testing path for these stages. Record actual results and blockers here using the shared evidence format when it is executed. Source review and the static/fresh-agent exercises above remain valid at their stated scope; they are not substitutes for these checks.

The current core's Bootstrap v4/UIkit v2 classifications are historical specimen facts, not proof of compatibility with a new Joomla template. JSON validity and an existing library GUID cannot certify a working frontend.
