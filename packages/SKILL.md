---
name: packages
description: "Create, extend, maintain and debug Joomla Component Builder package or blueprint repositories for components, modules and plugins. Use for JCB package JSON/index graphs, admin/site/custom views, concrete Fields, dynamic queries, layouts, templates, libraries, custom code, placeholders, raw assets and child configuration records; also use for Playground authoring, repository Push/export and compiled-consumer verification."
---

# Build JCB package blueprints

Read [scope and baseline](README.md) and the shared [operating contract](../AGENTS.md). Obtain the requested extension behaviour, Joomla/JCB/PHP targets, source/read branch, authorized write destinations, existing identities and dependency catalogues. Preserve established source and local edits. Inspect uncertain target-specific behaviour before authoring.

| Task | Load and execute |
| --- | --- |
| Select the correct entity or nested setting | [Model router](models/README.md) and the matching field file in [contract inventory](model-contracts.json) |
| Understand portable records, indexes and identities | [Serialization and graph contract](specification.md) |
| Start an empty repository or author a coherent graph | [Repository creation](workflows/create-repository.md) and [complete examples](examples/README.md) |
| Build through the JCB GUI and export | [Author in Playground](workflows/author-in-playground.md) |
| Extend, repair or migrate existing source | [Workflow router](workflows/README.md) |
| Import, refresh, compile and test the result | [Package acceptance](workflows/validate-and-integrate.md) |
| Resolve corpus differences or source uncertainty | [Repositories](repositories.md) and [pinned sources](sources.md) |

Load only the matching model guide and field reference. Read the [Field Types skill](../field-types/SKILL.md) when changing a catalogue definition; a concrete package Field is a different record. Read [Super Powers](../super-powers/SKILL.md) when maintaining a referenced reusable class and [Snippets](../snippets/SKILL.md) when changing copied-source patterns.

Preserve these non-obvious constraints: the repository is a shared graph, not one component JSON; child records use parent keys; natural-key records and file/folder pointers do not follow the standalone UUID rule; database storage encoding is not the exported encoding; missing/null values need field-specific treatment. Declared dependencies alone do not establish complete Field Type, Power, asset or runtime availability.

Before Push, inspect every eligible writable package repository in the disposable JCB instance. A selected root does not restrict the exporter to one destination. Follow the documented write-branch/token and read-back procedure; report publication as unrun if no authorized destination/credential exists.

Validate the entire affected repository and dependency closure, then use Playground for the actual root and linked consumers. Inspect persisted records and generated files, install the produced extension and exercise the requested behaviour. Correct the authoritative blueprint/source and regenerate after diagnostic edits. Return the changed identities, selected/shadowed provenance, actual checks, observed results and remaining gaps using [verification](verification.md); never equate a successful import or ZIP with runtime completion.
