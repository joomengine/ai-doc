# Validate Field Type source and its real consumer

## Required evidence levels

| Layer | Passing establishes | Passing does not establish |
| --- | --- | --- |
| Catalogue structure | Coherent JSON, identity/index/path/property structure under the validator's documented profile | Joomla attribute support or runtime PHP availability |
| Identity/provenance | New IDs absent from the supplied current comparison set; deliberate overrides visible | Worldwide uniqueness or complete knowledge of private catalogues |
| Joomla source research | The inspected target code consumes a property/default in the described way | That JCB emits the intended XML for a concrete Field |
| JCB import/refresh | The tested instance has the intended metadata row | Existing concrete Fields were migrated or extensions rebuilt |
| JCB compilation | The tested consumer produces expected XML/language/schema/custom output | Correct rendering, filtering, validation, or persisted values |
| Joomla runtime | The tested form renders and saves/loads as expected | Universal compatibility across untested targets |

Report each layer independently. This documentation's integration procedure is not a claim that a live JCB import/compile or Joomla runtime test was executed while writing it.

## Static checks

1. Fetch a complete current catalogue with the official `joomengine/joomla-fieldtypes` and all known project catalogues. Preserve revisions, hashes, order, and any intentional same-GUID shadowing.
2. Run `bash tools/validate-field-type-repository.sh REPO_DIR CATALOG_DIR`, adding `--new-guid UUID` for each distinct new item. Omit that flag for the same definition in a fork/overlay. Follow [Tools](../../tools/README.md) for exact dependencies and diagnostics.
3. Check every affected item and its index/README together. Verify native JSON property structures, unique property names where required by the authoring profile, type/property examples, meaningful false/zero/empty values, and historical key spellings. A JSON string containing a property collection is not equivalent to a native collection on current import.
4. Review the research evidence for every claimed Joomla attribute, default, target version, translation decision, and custom PHP dependency. Static JSON validation cannot provide that evidence.
5. Parse representative concrete XML examples and inspect quoting/escaping. Do not use a Field Type's JSON validity as proof its embedded example XML is valid.
6. Refresh the identity comparison before finalizing long-running new-item work. Record unavailable additional sources rather than calling an incomplete comparison complete.

## Integration acceptance procedure

Use an authorized disposable or backed-up development JCB/Joomla environment. Record exact JCB/Joomla/PHP versions, candidate repository commit, dependency catalogue commits/order, affected Field Type GUIDs, and concrete Field/component GUIDs. Preserve local definitions and unsaved Field edits before reset or type reselection.

### 1. Select and import the intended source

Configure the candidate Field Type repository's host/owner/name and **read branch** in the test instance. Include the official and any project catalogues with the intended effective precedence. Do not change production repository configuration merely to test a branch.

In the inspected JCB `6.x` baseline, the Field Types list's `fieldtypes.initPowers` action requires `fieldtype.init` permission and opens initialization selection for `Joomla.Fieldtype`. For existing items, `fieldtypes.resetPowers` requires `fieldtype.reset`, resolves the selected records to GUIDs, and calls `Package.Builder.Get->reset('fieldtype', $guids)`. Use the authenticated supported UI/API flow, including its request token; do not construct an unauthenticated controller URL.

Initialization is not proof that an existing definition was refreshed: the shared remote getter's ordinary initialization leaves an existing local row as local unless forced. Use the supported reset/refresh action on the intended existing GUID. Inspect messages and verify the actual local record:

- GUID/name and selected source are correct.
- Descriptions, property records and their flags/examples are current.
- `has_defaults` and the associated database suggestions match the candidate.
- The definition is in the local state needed for the editor to use it; the inspected property helper queries published Field Types.
- A deliberate override really selected the candidate, not a shadowed original.

Do not write directly to JCB's tables to bypass a failed import test. Diagnose the index/path/encoding/target-implementation discrepancy.

### 2. Create a new concrete Field through JCB

Create a fresh Field in the test component's supported authoring flow and select the imported Field Type. Confirm that the expected property choices, descriptions, and examples appear. Set a unique field name and useful label, and set the new/changed property explicitly.

Record the resulting Field XML and database settings before saving. Distinguish catalogue suggestions from values deliberately chosen for this Field. Inspect **all** relevant settings, including nullability, instead of assuming the UI copies every returned default: the inspected JavaScript has specific assignments, not a generic copy of the entire database object.

Save and reopen the Field. Confirm that its `fieldtype` references the intended GUID and that saved XML/values survive. Attach it to a real test Admin View/component location that generates a form; an unused Field does not prove compilation includes the control.

### 3. Preserve and test existing Fields

Before refreshing the catalogue, capture at least one existing Field using the GUID with an explicit non-example property value and deliberate database overrides. After refresh:

1. Reopen it without changing its Field Type and compare the displayed properties, saved XML, and database values.
2. Compile the unchanged saved Field and compare output. This catches current-property-list effects independently of resaving the editor form.
3. On a disposable copy, test an omitted changed property, an explicit empty value, `"0"`/false-like values where valid, and a required/invalid value where relevant.
4. If testing type reselection, compare database settings before and after; that action can request catalogue defaults. Do not apply it blindly to production Fields with overrides.

For a property removal/rename, inspect whether the old attribute remains supported through an explicit compiler extra-attribute path or disappears. Do not assume every arbitrary saved XML attribute is preserved. For mandatory/example/type changes, verify the actual emitted value. For storage changes, apply the approved per-Field/schema migration separately and test preserved data.

### 4. Compile and inspect generated artifacts

Start a fresh component compilation and inspect the actual generated paths for the target component, rather than hardcoding paths from another Joomla version. Check:

- The test form contains the intended field name and runtime `type`.
- New/changed XML attributes are emitted with correct escaping, omission behaviour, and values.
- Translation-marked properties produce appropriate language references and strings; raw values remain raw where required.
- The intended database columns/defaults/nullability/indexes come from the concrete Field configuration, with appropriate upgrade SQL where a migration is required.
- A custom field's PHP class, namespace/registration, dependencies, assets, and layout are delivered by the actual implementation path. Metadata alone is insufficient.
- XML parses and generated/custom PHP lints on each affected supported PHP target.

Compare against the pre-change compile for existing consumers. Review unexpected changes even when the compiler reports success.

### 5. Exercise Joomla runtime behaviour

Install the compiled extension in the authorized test site and open the actual form. Verify rendering, label/help translation, relevant assets, enabled/disabled/readonly behaviour where applicable, required/invalid input handling, and save/reload. Verify persisted values for empty, zero, null, scalar/multiple-value, and boundary cases relevant to this Field Type.

Where the field class performs a query or requires component context, exercise the necessary context instead of testing only a standalone HTML mock. If the class/property exists only in some Joomla versions, test those targets and document the unsupported versions explicitly.

### 6. Report and recover

Report the candidate/research revisions, catalogue order/selected source, changed GUIDs, static result, import/refresh result, new and existing Field results, compile artifact comparison, runtime cases, and remaining limitations. If no JCB instance was available, state **“JCB import/compile and Joomla runtime not run”**, with this recipe as the concrete next step.

If refresh or compilation fails, retain the relevant messages and source/record diffs. Restore the development snapshot when necessary. If a change is reverted after it was consumed, refresh the previous metadata and recompile/reinstall affected consumers; restore migrated Field/schema/data state separately. Do not assume reverting Git repairs installed sites.

## Implementation evidence

The named JCB operations above were checked against `6.x` commit `408703a857ad937479b1e28de7f693af178dcc83`:

- [Field Types controller](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/FieldtypesController.php): initialization selection, permissions/token checks, selected-GUID reset.
- [Shared remote getter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Get.php): initialization's existing-local behaviour and read branch.
- [Field property helper](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Helper/ComponentbuilderHelper.php): `getFieldTypeProperties`, existing XML values, examples, publication requirement, and optional database suggestions.
- [Field editor JavaScript](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/media/js/admin/field.js) and [Field edit template](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/tmpl/field/default.php): explicit database assignments and type-change loading with defaults enabled.
- [Compiler Field Data](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Data.php), [TypeName](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/TypeName.php), and [Attributes](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php): concrete Field values joined to current Field Type metadata, type resolution, property filtering, and mandatory/example handling.

The [module source map](../sources.md) records the complete evidence and freshness procedure. Verify the target implementation before applying these named actions to another JCB version. The acceptance matrix and test cases are project guidance; they are not claims of completed runtime tests.
