# Extend, fix, or override a Field Type

## Inputs and baseline

Capture the affected GUID, selected repository/revision, configured catalogue order, target JCB/Joomla/PHP versions, concrete Field GUIDs using it, saved XML, and the expected versus observed behaviour. For a rendering or save defect, capture the compiled form XML and actual runtime field class as well. A repository definition, JCB's imported row, a saved Field, compiled extension files, and installed runtime are separate states.

Reproduce with the smallest useful consumer before changing metadata. Research the actual Joomla class/ancestors/layout and the JCB compilation path. A missing attribute in the catalogue, a compiler omission, and a runtime PHP defect require different changes.

## Decide where the fix belongs

| Symptom | Evidence to inspect | Likely boundary |
| --- | --- | --- |
| Definition missing from initialization | Index, path, branch, repository configuration/order, access | Catalogue/configuration |
| Wrong same-GUID definition imported | All occurrences and effective repository precedence | Intended overlay versus wrong selection |
| UI shows old property description/options | Imported Field Type row, open edit form, AJAX result | Source refresh and UI reload |
| Changed default not copied to a saved Field | Concrete Field database settings and XML, type-selection action | Explicit Field update or migration; not automatic catalogue propagation |
| Attribute disappears after compilation | Current property collection, saved Field XML, compiler extra-attribute rules | Metadata/compiler interaction |
| Default changes despite unchanged saved XML | `mandatory`/`example`, type resolution, omission handling | Compatibility-sensitive metadata |
| Generated XML correct but control behaves incorrectly | Joomla field class, ancestors, layout/assets, filters/validation | Joomla/custom runtime implementation |
| Custom field class cannot be loaded | Actual custom PHP delivery, namespace/registration, compiled files | Implementation/deployment, not catalogue metadata alone |
| Save truncates or corrupts values | Concrete Field SQL/storage choices, generated schema, runtime filtering | Concrete Field/schema migration |

Do not clear caches as a substitute for locating the stale layer. First inspect the row, XML, and file the failing operation actually uses.

## Identity and override rules

Keep the GUID for a correction, extension, port, fork, or deliberate overlay of the same definition. Retain the upstream source/revision and explain the deviation. Document the desired selection order and inspect shadowed entries; same GUIDs in multiple catalogues are meaningful when they intentionally represent the same item.

Generate a fresh checked GUID only for a distinct new definition. Changing the name or GUID to evade an override conflict can disconnect existing Fields and leave the original defect unresolved. The mandatory current official-catalogue check applies to every newly allocated GUID, including in a private fork.

The inspected remote lookup selects the first indexed match; a malformed selected item is not guaranteed to fall back to a later valid definition. Repair the selected record or configuration instead of assuming precedence will recover automatically. Verify actual order against [the specification](../specification.md), since UI order, configured defaults, and lookup order need not be inferred from a directory listing.

## Compatibility analysis before editing

Inventory existing concrete Fields using the GUID and their saved values. Include representative consumers with an omitted value, an explicit value different from the example, an empty/zero value, and any custom implementation.

| Proposed change | Required compatibility check |
| --- | --- |
| Add optional property | Confirm omission preserves old behaviour and explicit values compile/run |
| Add or tighten `mandatory` | Check omitted/empty existing values and compiler fallback to `example` |
| Change `example` | Check new-field authoring and missing mandatory values; do not describe it as documentation-only |
| Rename/remove property | Check saved XML, generated attributes, extra-attribute exceptions, and explicit migration of old values |
| Change `translatable` | Check emitted language keys/files and runtime labels versus raw values |
| Change `adjustable` | Inspect actual enforcement; do not claim an immutability guarantee from metadata alone |
| Change `type` example or catalogue/custom name | Check class/type resolution for every known consumer; same GUID does not make it compatible |
| Change database suggestions | Compare new Fields and existing Fields with deliberate overrides; plan schema/data migration separately if required |
| Change storage encoding/filter/default/null/index | Test save/load, empty/zero/null values, SQL compatibility, and upgrade data preservation |

JCB's inspected compiler reads the concrete Field's own values and joins the current Field Type name/properties. Therefore a catalogue property removal or mandatory/example change can affect the **next compilation of an existing Field even without resaving its XML**. In contrast, the Field Type's database suggestions do not dynamically replace every existing Field's database settings. Both cases need testing; neither “all changes propagate” nor “existing Fields are unaffected” is an accurate general rule.

## Change and verify

1. Edit the authoritative `src/<guid>/item.json`. Preserve native property objects/arrays, field-specific scalar/empty forms, historical key spellings, and untouched metadata. Do not JSON-encode the property collection into a string.
2. Add/update the researched property description and example with explicit target support. For runtime defaults, cite the actual consuming implementation rather than repeating an old catalogue claim.
3. Update index metadata when name/short description/path changes, plus item and root documentation. Preserve licences and upstream provenance for forked material.
4. For a breaking property/type/storage change, write a concrete migration: affected GUIDs/Fields, old-to-new value mapping, import order, per-Field updates, recompilation, extension upgrade/schema steps, and rollback. Do not silently rewrite existing Field data merely by refreshing the catalogue.
5. Validate the whole repository with the current ordered catalogue. Use `--new-guid` only for genuinely new identities. Inspect intentional overrides and unresolved sources separately from accidental corruption.
6. Refresh only the intended Field Type in a disposable/backed-up JCB instance, then compare its imported values. Reload the Field editing form and inspect its AJAX state. Test both a new concrete Field and preserved existing Fields using [the integration procedure](validate-and-integrate.md).
7. Compile, inspect emitted XML/language/schema/custom PHP where applicable, then run the control and save/reload its values. Repeat the affected cases across the declared target versions.
8. Push a focused commit and report the defect, selected definition/revision, compatibility/migration consequences, tests actually run, and remaining limits. Do not present a metadata lint as a successful Joomla runtime test.

## Recovery and cache boundaries

- **Remote changes not imported:** distinguish initialize from reset/refresh; initialization may leave an existing local row untouched. Inspect the imported row before clearing anything.
- **Open edit form stale:** reload it after refresh and inspect the returned property data. Preserve unsaved work first. Re-selecting a Field Type can copy database suggestions, so do not use that action blindly on a Field with intentional overrides.
- **Compiled or installed output stale:** start a fresh compile and verify its files, then install the intended build in the authorized test site. Repository refresh alone does not rewrite installed extensions.
- **Process/autoload/asset cache suspected:** verify file/version identity first, then use the target environment's documented cache refresh/restart when relevant. Do not prescribe a universal cache deletion command or direct SQL update as normal workflow.
- **Incorrect same-GUID override:** restore ordering/source and refresh the intended definition, then recompile affected consumers. Record the selected provenance in the result.
- **Failed migration or data loss risk:** restore the test snapshot or revert the authored change and restore affected Field/XML/schema state. Reverting catalogue metadata alone does not undo saved data/schema changes.

The [source map](../sources.md) identifies the controller/import, UI helper/JavaScript, and compiler evidence for these behaviours. Reinspect those sources for another JCB target.
