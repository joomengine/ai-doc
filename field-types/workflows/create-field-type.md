# Create a Field Type definition

## Decide whether this is a new identity

Search the official catalogue and all project catalogues by GUID, catalogue name, and actual Joomla XML `type`. Inspect source records, not only index descriptions.

| Requested work | Identity decision |
| --- | --- |
| Correct or extend an existing definition | Keep its GUID |
| Fork or intentionally override that same definition | Keep its GUID; document selected source and shadowed originals |
| Represent a genuinely distinct new definition | Generate a new cryptographic UUIDv4 and check all required catalogues |
| Copy a documentation fixture as a starting structure | Generate/check a fresh identity before any production publication |

A different repository, clearer description, new property, or corrected default does not by itself create a new entity. Conversely, preserving a GUID does not make an incompatible replacement safe; review its consumers.

## Research the Joomla capability

Follow [Joomla field research](../joomla-research.md) and record a property evidence table before writing metadata. For each proposed property record the consumer symbol/layout, supported value domain, behaviour when omitted or empty, target-version applicability, translation handling, and whether it is a Joomla attribute or JCB-specific authoring instruction.

For a newly added Joomla core field, verify its introduction on every claimed target and inspect its ancestors and layout. A leaf PHP class may contain little code while its parent and layout consume most attributes. Investigate factory/registration paths, relevant assets, filters and validation rules when they affect use. Public class properties are not automatically XML attributes, and a documentation example is not automatically an omitted-value default.

Keep three defaults separate: Joomla's runtime behaviour when XML omits an attribute; JCB's catalogue `example` used while authoring/compiling; and database defaults offered to concrete Fields. They can differ and must be described separately.

If Joomla already provides the runtime class, reference that capability. If a custom PHP class is needed, explicitly identify its implementation and delivery path; do not claim the metadata record implements it. Follow the [custom-field rules](../specification.md) rather than placing arbitrary PHP in a new undeclared JSON key.

## Allocate a distinct new GUID

1. Fetch a recent complete catalogue with `fetch-entity-catalog.sh field-types`, including **`joomengine/joomla-fieldtypes` in every project**, plus all configured/known additional Field Type repositories. Preserve source revisions and order.
2. Call `new-entity-guid.sh field-types` with that catalogue and the destination/local repositories containing uncommitted or parallel new definitions. Do not invent an identifier or copy a catalogue/example GUID.
3. Reserve the generated identity in this task's item and index immediately. Coordinate parallel additions and validate the combined index before commit. The tool generates an ID; it does not reserve it in a global service.
4. Recheck newly allocated identities against fresh indexes before finalizing a long-running change. The collision check is scoped to the known current catalogues; UUIDv4 plus that check does not claim mathematical proof of worldwide uniqueness.

Skip allocation for an existing-item improvement or intentional same-item override. Preserve its provenance and GUID instead.

## Author the complete item

1. Create `src/<guid>/item.json` using a complete compatible [example](../examples/README.md) and the [field reference](../fields-reference.md). Preserve exported names, including historical spellings such as `datalenght`; correcting spelling would change the contract.
2. Set the identity, descriptive name, descriptions, property collection, and explicit database-default policy. Do not copy local database row IDs, categories, access settings, or unrelated runtime environment values into the exported definition.
3. Provide one coherent property record per property name, with the actual `name`, representative `example`, meaningful description, and supported `mandatory`, `adjustable`, and `translatable` metadata as applicable. Preserve the documented collection shape and scalar representations. Do not interpret `adjustable` as an enforced runtime lock without checking the targeted code.
4. Define the actual XML `type` accurately. For ordinary Field Types, JCB's compiler can take it from the catalogue's `type` property's `example`; the catalogue label alone is not sufficient. Follow the distinct custom/own-custom behaviour for those definitions.
5. Use `mandatory` only where justified by the JCB/Joomla contract. A mandatory property with a misleading example can inject that value when a concrete Field omits it. Set translation metadata according to how JCB and Joomla consume the value, not whether the English example looks human-readable.
6. If `has_defaults` enables database suggestions, set a coherent storage combination. Check SQL type, length/precision, default/null policy, index choice, and storage encoding against the intended field value. A multi-value field and a scalar field need different consideration. Catalogue defaults are starting values, not an automatic database migration.
7. Add/update the GUID-keyed root `index.json` entry, matching `guid`, `name`, `desc`, `path`, and `settings`. `settings` points to `src/<guid>/item.json`; it is not a `settings.json` file.
8. Add the item's README and root README entry. Include a useful concrete XML example, supported versions, source provenance, and custom class/asset dependencies if any. Check XML quoting/escaping rather than embedding unescaped JSON strings into XML.

## Validate and deliver

Run the Field Type repository validator against the complete destination and current catalogue, passing `--new-guid` for each newly allocated identity. Omit that flag for same-item updates/overrides. Inspect the entire item/index diff, verify any intended same-GUID override explicitly, and follow [Validate and integrate](validate-and-integrate.md).

Test a new concrete Field selected through JCB, the emitted XML, and the Joomla runtime control. For an extension of an existing definition also test a saved Field with an explicit custom value and one omitting the changed property. Exercise save/reload and validation, not only rendering. A new metadata entry whose runtime class cannot be loaded is not complete.

The PR must identify the GUID decision, researched Joomla/JCB revisions, property changes, default/compatibility implications, source/derived artifacts, exact checks run, and remaining limits. If the requested feature cannot be expressed by this catalogue alone, explain the specific PHP/compiler/runtime change needed rather than inventing a metadata field.
