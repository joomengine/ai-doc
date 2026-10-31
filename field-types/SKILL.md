---
name: field-types
description: "Create, maintain, compare, override and validate JCB Field Type catalogues and their property metadata. Use for item.json, Joomla XML attributes, examples versus defaults, database suggestions, custom field metadata and Field Type import or consumer failures. Do not treat this as the concrete Field, package blueprint or standalone Joomla FormField implementation contract."
---

# Work with JCB Field Types

Use this entrypoint within the complete `joomengine-jcb` checkout; retain its shared parent resources. Follow [skill loading](../standards/skill-loading.md) and [AGENTS.md](../AGENTS.md). Read [scope and applicability](README.md), then load only the references needed for the task.

Record the target repository and branch, existing or proposed Field Type identity, intended Joomla XML `type`, supported JCB/Joomla/PHP versions, and affected concrete Fields. Inspect [specification.md](specification.md) before changing the interchange format; use [sources.md](sources.md) to recheck version-dependent behaviour.

| Task | Load and follow |
| --- | --- |
| Discover a maintained core mirror or recover public source access | [Shared repository network](../standards/repository-network.md) |
| Start an empty catalogue | [Create a repository](workflows/create-repository.md) |
| Add a genuinely distinct Field Type | [Create a Field Type](workflows/create-field-type.md) |
| Extend a definition, maintain an override or diagnose a failure | [Maintain and debug](workflows/maintain-and-debug.md) |
| Change properties, flags or database suggestions | [Field reference](fields-reference.md) and [Joomla source research](joomla-research.md) |
| Implement custom-field metadata | Relevant custom-field sections of [specification.md](specification.md) and [complete examples](examples/README.md) |
| Verify import, compiled forms and storage behaviour | [Validation and integration](workflows/validate-and-integrate.md) |

Preserve these boundaries:

- Consult current `joomengine/joomla-fieldtypes` plus authorized additional catalogues and local unpublished records. Retain the GUID for the same item or intentional override; allocate a distinct new UUIDv4 with `tools/new-entity-guid.sh field-types`.
- Edit `src/<guid>/item.json` and root `index.json`. Preserve `datalenght`/`datalenght_other` spellings and native nested `properties`; do not double-encode the property collection as a JSON string.
- Distinguish property examples, JCB database suggestions and Joomla's omitted-value defaults. Research the runtime class, ancestors and layouts; a metadata property is not proof that Joomla supports it.
- Treat a Field Type as metadata. It does not install a missing PHP field class or migrate existing concrete Fields and their stored data. Preserve ordered override provenance and inspect actual consumers.

Run commands from the checkout root using [tools/README.md](../tools/README.md). Fetch the `field-types` catalogue and validate the candidate with `tools/validate-field-type-repository.sh`. Pass a repeated `--new-guid` for each genuinely new record; omit it for same-item maintenance. Load another model's skill only for a dependency or consumer in scope.

For executable changes, use [Playground setup](../testing/playground/README.md) and this module's integration workflow. Inspect the persisted definition, new and existing concrete Fields, explicit and omitted values, generated XML/PHP/SQL, installation, form validation and save/reload behaviour. Fix authoritative metadata, blueprint or compiler source before regenerating.

Finish with a reviewable item/index diff, identity and precedence decisions, property/default evidence and target versions, actual validation results, and unrun or blocked stages. Keep historical [verification](verification.md) separate from this candidate's evidence. Prepare reproducible JCB defects for [human issue submission](../testing/reporting-issues.md).
