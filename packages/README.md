# Package blueprints for components, modules and plugins

Start with [SKILL.md](SKILL.md). A JCB package repository is a portable pool of authored records, child settings, raw assets and locator indexes. A component, Joomla module or plugin is a root into that graph; compilation turns the resolved authoring data into installable Joomla extensions. A repository package is not itself an extension ZIP, and a Joomla package installer is another representation again.

This module covers all **41 logical package contracts** found in **42 Remote Config classes** at JCB `6.x@408703a857ad937479b1e28de7f693af178dcc83`: 40 database entities and the virtual `file_system` contract used by File and Folder. [Model routing](models/README.md) maps every contract and the associated nested settings. The [inventory](model-contracts.json) and individual field references make exact data discoverable without loading every model. The supported interchange baseline is this inspected JCB revision; verify differences before applying it to another release. The live installed Playground version and actual test outcomes are recorded separately in [verification](verification.md).

## Choose the work

| Intended change | Read next |
| --- | --- |
| Start a package repository, choose identity and build a coherent graph | [Create repository](workflows/create-repository.md), [serialization contract](specification.md) |
| Build through JCB's GUI and export to an authorized branch | [Author in Playground](workflows/author-in-playground.md) |
| Extend existing records, rename or replace relationships | [Maintain](workflows/maintain.md) |
| Diagnose failed acquisition, missing dependencies or generated behaviour | [Debug](workflows/debug.md) |
| Move a blueprint to another Joomla/PHP target | [Migrate target](workflows/migrate-target.md) |
| Validate import/update, compilation, installation and behaviour | [Package acceptance](workflows/validate-and-integrate.md) |
| Configure a component, its views, dashboard, router, schema or version updates | [Component](models/component.md) |
| Build admin CRUD, linked Fields, conditions, relations and tabs | [Admin Views](models/admin-views.md), [Fields and relationships](models/fields-and-relationships.md) |
| Build site/custom admin views, queries, templates and layouts | [Presentation and queries](models/presentation-and-queries.md) |
| Build Joomla modules/plugins, inheritance and shared class records | [Extensions](models/extensions.md) |
| Add libraries, URLs and raw files/folders | [Libraries and assets](models/libraries-and-assets.md) |
| Maintain Custom Code, helpers, placeholders and Power references | [Code and placeholders](models/code-and-placeholders.md) |
| Understand the supplied catalogues and a complete small blueprint | [Repositories](repositories.md), [examples](examples/README.md) |
| Inspect exact fields, nested form options or source provenance | [Contract inventory](model-contracts.json), [sources](sources.md) |

The prose guides explain choices and consuming behaviour. The per-entity `.json` references preserve source metadata and XML form definitions, while `.md` references provide a field index. For example, from the skills checkout root:

```bash
jq '.entities[] | {entity, identity_kind, key, index, guide}' packages/model-contracts.json
jq '.fields.xml' packages/reference/field.json
jq '.fields.addfields' packages/reference/admin_fields.json
```

Read the referenced implementation when a value is conditional or transformed. Database defaults are not a universal recipe for hand-authored JSON; a field's export/import transformation and form/compiler usage matter. The [specification](specification.md) defines authority and known discrepancies.

## Invariants to carry into every task

- Preserve an existing record's identity. For a new independent graph, remap its owned standalone GUIDs and every affected reference together. Do not allocate fresh GUIDs for parent-keyed child settings, natural-key records or deterministic asset pointers by applying another model's rule.
- Keep index locators, root/child payloads, dependency descriptors and raw assets coherent. Preserve source and precedence for overlapping records across repositories; the three supplied catalogues are not disjoint identity sets.
- Keep Field Types, Super Powers and Joomla Powers in their own domains. Concrete Fields reference Field Types. Compiler tokens and copied snippets require their own dependency/consumer checks; a package `@dependencies` list is not proof of complete runtime closure.
- Distinguish Init, explicitly selected Pull, ordered-source Reset and remote-writing Push. Before Push, audit every eligible writable package connection, its token and write branch; inspect the resulting remote diff and read it back. A successful toolbar action does not establish correct source selection or complete persistence.
- Use [Playground](../testing/playground/SKILL.md) by default for authorized integration and GUI authoring, selecting the intended [environment](../testing/playground/configuration.md). Test the changed root and its actual component/module/plugin outputs. Carry diagnostic output edits back into authoritative source and regenerate.
- Preserve source licensing and attribution. Treat source-inspected behaviour, observed specimens, project authoring policy and actual execution as distinct evidence.

## Coverage and boundaries

The source map distinguishes package entities, direct-child records, nested subforms and compiler-only concepts. The module does not invent interchange contracts for excluded/local-only tables. It does not replace the [Field Type](../field-types/SKILL.md), [Super Power](../super-powers/SKILL.md) or [Snippet](../snippets/SKILL.md) contracts. The supplied MCP architecture proposal helps explain the graph, but its product-specific Joomla/branch/output restrictions do not govern every JCB repository.

Use [verification](verification.md) for the current results and gaps. Static profiles check their stated structural subset; they do not establish complete dependency closure, execute exported code, emulate JCB or certify every field combination. Import, export/read-back, compile, install and runtime remain separate acceptance stages.
