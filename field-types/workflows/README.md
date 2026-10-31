# Field Type workflows

These procedures maintain **JCB Field Type metadata repositories**. A Field Type describes the properties JCB offers when authoring a concrete Field and, optionally, initial database settings. It is not the concrete Field record, a Joomla PHP field implementation, a Super Power, or a component package.

| Task | Procedure |
| --- | --- |
| Start a new or forked catalogue | [Create a repository](create-repository.md) |
| Add a distinct Field Type or a newly supported Joomla field | [Create a Field Type](create-field-type.md) |
| Extend, correct, override, or debug an existing definition | [Maintain and debug](maintain-and-debug.md) |
| Prove metadata, import, compilation, and runtime behaviour | [Validate and integrate](validate-and-integrate.md) |

Read the [specification](../specification.md), [field reference](../fields-reference.md), and [Joomla research procedure](../joomla-research.md) for the relevant contract. Use the [source map](../sources.md) to recheck version-sensitive behaviour.

## Common requirements

1. Establish the destination repository/branch, supported JCB/Joomla/PHP versions, requested behaviour, and known consumers. Do not silently make every Field Type Joomla 6-only because a separate package project targets Joomla 6.
2. Inspect the current official `joomengine/joomla-fieldtypes` catalogue and every additional repository configured or known for this project. Multiple catalogues and intentional overrides are supported; the official catalogue is not the only possible source.
3. **Every newly allocated Field Type GUID must be checked against the current official `joomengine/joomla-fieldtypes` index, plus the additional project catalogues and local work in progress.** This requirement applies to every repository, including a new private or specialist catalogue. Never publish a new identity checked only against its destination repository.
4. Preserve a GUID when improving, porting, or intentionally overriding the same existing definition. A fork keeps the identities of its existing items. A genuinely distinct new definition receives a cryptographic UUIDv4; a copied fixture GUID is never a new identity.
5. Preserve repository order and provenance. Distinguish an intentional same-GUID override from a new-item collision. Record which source is selected and which definitions it shadows; do not flatten the catalogues into a last-write-wins dictionary.
6. Research Joomla's actual field class, ancestors, layout, and supporting code before claiming an XML property or default is supported. The catalogue's `example` value is not automatically Joomla's default.
7. Keep authoritative `item.json`, `index.json`, and documentation consistent. Do not add `code.power` or `settings.json` merely because the Super Powers module uses them.
8. Validate both a new concrete Field and an existing consumer when changing a shared definition. Catalogue changes can affect subsequent compilation even when an existing Field's saved XML has not been edited.
9. Publish a meaningful branch/PR early when requested, then push coherent updates. Stay within the task's authorization; passing checks alone does not authorize merging or publishing elsewhere.

## Tool interfaces

Run these from an `skills` checkout with the dependencies documented in [Tools](../../tools/README.md). Uppercase path names below describe arguments chosen for the current task, not literal paths to commit.

| Operation | Command |
| --- | --- |
| Fetch an ordered Field Type catalogue | `bash tools/fetch-entity-catalog.sh field-types NEW_DIR [REGISTRY_JSON]` |
| Allocate a new Field Type identity | `bash tools/new-entity-guid.sh field-types CATALOG_DIR [LOCAL_REPO ...]` |
| Validate one Field Type repository | `bash tools/validate-field-type-repository.sh REPO_DIR CATALOG_DIR [--new-guid UUID ...]` |
| Check this documentation and its tooling | `bash tools/check.sh` |

The identity allocator requires a complete recent live catalogue containing the official Field Type repository. Include additional current working repositories when allocating IDs. These checks concern Field Type identities; do not substitute the seven Super Power indexes, which use a different entity contract.

Pass `--new-guid` once for each distinct newly authored identity during validation. This checks that it exists locally and does not already occur in the supplied live catalogue. Omit that flag for an existing definition retained in a fork or intentional override; otherwise a deliberate same-identity relationship would be misclassified as a new-item collision.

Use authorized host tools/checkouts for additional repositories outside a fetcher's supported host profile; retain their revision and resolution order. Never exclude a known catalogue to obtain a clean result. Static checks cannot prove a PHP class exists in Joomla or that a real JCB instance imports and compiles the definition.
