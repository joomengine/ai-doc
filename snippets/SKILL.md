---
name: snippets
description: "Create, extend, maintain, migrate and validate JCB Snippet repositories, reusable view source and Snippet Type classifications. Use for snippet-index.json, snippet-type.json, item.json, library references, copy-to-view behaviour and snippet integration failures. Do not use as the format for Super Powers, PHP Custom Code records or complete Joomla extensions."
---

# Work with JCB Snippets

Use this entrypoint within the complete `joomengine-jcb` checkout; retain its shared parent resources. Follow [skill loading](../standards/skill-loading.md) and [AGENTS.md](../AGENTS.md). Read [scope and applicability](README.md), then load the task's contract and workflow.

Record the repository and branch, intended pattern and consuming view, existing or new identity decision, supported JCB/Joomla/PHP and UI-library versions, attribution, and required type/library sources. Inspect [specification.md](specification.md) and the affected [fields](fields.md); verify implementation assumptions against [sources.md](sources.md).

| Task | Load and follow |
| --- | --- |
| Start a repository or add a snippet/classification | [Creation workflow](workflows/create.md) |
| Correct source, maintain an override or migrate old flat files | [Maintenance workflow](workflows/maintain.md) |
| Understand complete source, classification and dependency records | [Examples](examples/README.md) and [field reference](fields.md) |
| Import, copy into a real consumer and test behaviour | [Consumer integration](workflows/integrate.md) |

Preserve these boundaries:

- Search current `joomengine/snippets` first. Check both snippet and classification identities across core, additional catalogues and local unpublished additions. Retain a same-item GUID; generate a distinct new UUIDv4 with `tools/new-entity-guid.sh snippets`.
- Keep raw source in the `snippet` string of `src/<guid>/item.json`. Maintain `snippet-index.json` and, when applicable, `snippet-type.json` plus `src/snippet_type/<guid>/item.json`; this format has no Power body/generated-PHP split.
- Keep `type` and `library` as GUID references with matching dependency rows. Resolve classifications and verify library packages/assets separately; a static pass does not establish asset availability or compatibility.
- Treat selection as source discovery/copying. A refreshed catalogue does not rewrite previously copied view code. Preserve attribution and inspect framework versions, dynamic output escaping and accessibility for the actual consumer.

Run commands from the checkout root using [tools/README.md](../tools/README.md). Fetch the `snippets` catalogue and validate with `tools/validate-snippet-repository.sh`; pass a repeated `--new-guid` for every new snippet or classification. Omit it for same-item maintenance. Resolve reported type failures and retain the explicit library-verification gap. Load another model's skill only when its dependency or consumer is involved.

For executable changes, follow [Playground setup](../testing/playground/README.md) and [consumer integration](workflows/integrate.md): inspect persisted records, copy into an attached view, save/reopen the consumer, compile, inspect generated source/assets, install and exercise the rendered page. Apply durable corrections to the snippet, consumer blueprint or compiler source and regenerate.

Finish with a reviewable source/index/type diff, GUID and source-precedence decisions, attribution/library requirements, exact checks and observed consumer results, and remaining limits. Keep prior [verification](verification.md) separate from this candidate's evidence. Prepare reproducible JCB defects for [human issue submission](../testing/reporting-issues.md).
