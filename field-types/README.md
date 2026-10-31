# Field Types operational module

This module explains how to create, maintain, extend, compare, import and debug **JCB Field Type repositories**. The core authority is [`joomengine/joomla-fieldtypes`](https://github.com/joomengine/joomla-fieldtypes). Every additional Field Type repository must consult that core catalogue for existing identities and capabilities. A fork can intentionally preserve an existing GUID to override that same Field Type; a genuinely different Field Type must receive a new, collision-checked UUIDv4.

A Field Type is a **metadata definition** used to author and compile concrete JCB Fields. It describes XML properties, examples and authoring flags, and may suggest database settings. It is not the concrete Field, a Joomla `FormField` PHP implementation, or a Super Power. Adding metadata for a new `type` does not implement or install the corresponding Joomla field class.

## Start with the task

| Task | Required reading |
| --- | --- |
| Understand file ownership, GUIDs, ordered overrides and lifecycle | [Specification](specification.md) |
| Change an item or property without confusing examples and defaults | [Field reference](fields-reference.md) |
| Establish which attributes Joomla really supports | [Joomla source research](joomla-research.md) |
| Create a repository, add a type, maintain a fork or verify an import | [Workflows](workflows/README.md) |
| Inspect complete specimens and custom-field variants | [Examples](examples/README.md) |
| Reproduce or refresh the evidence | [Sources and known limits](sources.md) |

Read only the task-relevant route after these invariants. Use [the module-authoring standard](../standards/module-authoring.md) when extending these instructions rather than introducing a parallel documentation convention.

## Operating invariants

1. **Start from the core catalogue.** Reuse its Field Type identity for the same concept. Preserve core GUIDs in an intentional override; generate and check new UUIDv4 identities for genuinely new concepts against core and every registered/task-specific catalogue.
2. **Resolve against the effective ordered repository list.** The first indexed match wins. An earlier authorized override shadows the later core definition. Report the selected and shadowed sources with branch and revision. Duplicate identities across repositories are not automatically mistakes.
3. **Edit the imported `item.json`.** Root `index.json` locates items; README files explain them. There is no `code.power`/`settings.json` split or generated `code.php` requirement in this format.
4. **Keep property examples, JCB database suggestions and Joomla runtime defaults separate.** Existing concrete Fields retain their own database settings and XML, while the current Field Type's property definitions can change what the compiler emits.
5. **Research Joomla implementation first.** Check the target field class, ancestors, layouts, forms/filter/validation behaviour and installed dependencies before documenting a property as supported. Metadata text and an old example are insufficient evidence.
6. **Treat import/update as a separate step.** A Git commit or changed repository order does not automatically replace an existing JCB database record. Refresh the intended Field Type, then inspect and compile representative consumers.
7. **Preserve the exact serialization contract.** Keep `datalenght`/`datalenght_other` spellings; `properties` is native nested JSON, not a JSON string. Preserve field-specific empty forms and omitted unchecked flags.

## Applicability and proof

The JCB repository contract was inspected on `6.x` at `408703a857ad937479b1e28de7f693af178dcc83`; the core catalogue on `master` at `3be64d59378b5650825b97b44dbd58f2cdb82fcb` contains 49 entries. These are recorded source baselines, not minimum supported version numbers or an assertion that all 49 definitions are correct for every Joomla target. See [sources](sources.md) for inspection dates, source paths and Joomla research scope.

This module documents metadata authoring and static checks, plus an integration procedure. A successful repository validation does not prove import success, SQL compatibility, a generated custom field's PHP validity, or runtime form behaviour. The PR and workflow result must say which of those checks were actually executed.
