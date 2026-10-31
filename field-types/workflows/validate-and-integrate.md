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

Report each layer independently. **JoomEngine Playground is the default browser integration path**; start with the [shared testing guide](../../testing/playground/README.md). Its [verification record](../../testing/playground/verification.md) documents the browser observations already made. Those observations do not establish that a Field Type fixture was imported, compiled, or exercised. This module's actual stage results remain in [Field Type verification](../verification.md).

## Static checks

1. Fetch a complete current catalogue with the official `joomengine/joomla-fieldtypes` and all known project catalogues. Preserve revisions, hashes, order, and any intentional same-GUID shadowing.
2. Run `bash tools/validate-field-type-repository.sh REPO_DIR CATALOG_DIR`, adding `--new-guid UUID` for each distinct new item. Omit that flag for the same definition in a fork/overlay. Follow [Tools](../../tools/README.md) for exact dependencies and diagnostics.
3. Check every affected item and its index/README together. Verify native JSON property structures, unique property names where required by the authoring profile, type/property examples, meaningful false/zero/empty values, and historical key spellings. A JSON string containing a property collection is not equivalent to a native collection on current import.
4. Review the research evidence for every claimed Joomla attribute, default, target version, translation decision, and custom PHP dependency. Static JSON validation cannot provide that evidence.
5. Parse representative concrete XML examples and inspect quoting/escaping. Do not use a Field Type's JSON validity as proof its embedded example XML is valid.
6. Refresh the identity comparison before finalizing long-running new-item work. Record unavailable additional sources rather than calling an incomplete comparison complete.

## Integration acceptance procedure

Use a disposable Playground JCB site following the shared [setup](../../testing/playground/README.md) and [repository/runtime configuration](../../testing/playground/configuration.md). Reuse an authorized test session where appropriate and preserve its intentional local work. Another supported development environment can supplement a target or operation unavailable in Playground; record which environment supplies each result.

Record exact JCB/Joomla/PHP versions, candidate repository commit, dependency catalogue commits/order, affected Field Type GUIDs, and concrete Field/component GUIDs. Preserve local definitions and unsaved Field edits before reset or type reselection. Keep exported test evidence and any required snapshot using the shared guide's persistence procedure; a browser session by itself is not durable evidence.

Before starting, declare the relevant Joomla/PHP matrix. Test the project's supported target versions affected by the change, including a minimum version where the proposed field/property or custom PHP syntax matters. One successful Playground runtime does not establish the whole matrix. When a needed target cannot be selected or a required operation is blocked, record that specific gap and use the shared fallback guidance; do not label all browser integration unavailable without checking the default route.

### 1. Select and import the intended source

Configure the candidate repository for the **Field Types** content target (`3` in the inspected repository form), with its actual host/owner/name and **read branch**, following the shared configuration guide. Its locator is `index.json`, not a Power or Snippet index. Include the official `joomengine/joomla-fieldtypes` and project catalogues with the intended effective precedence. Do not change production repository configuration merely to test a branch.

Choose the operation for the question being tested. The following scopes are verified in the inspected JCB `6.x` baseline; check the running version before assuming identical UI behaviour:

| Operation | Entry and permission | Source/update scope |
| --- | --- | --- |
| Init | `fieldtypes.initPowers`, `fieldtype.init`; opens initialization selection for `Joomla.Fieldtype` | The selected repository is passed to initialization with its default `force=false`; an existing local identity can remain local without being refreshed. |
| Pull | `fieldtypes.pullPowers`, `fieldtype.pull`; opens pull selection for `Joomla.Fieldtype` | The selected repository is passed to `Package.Builder.Get->init('fieldtype', ..., $repo_path, true)`, requesting an update even when the identity exists. This tests the explicitly selected repository, not the global precedence winner. |
| Reset | `fieldtypes.resetPowers`, `fieldtype.reset` | Selected local record IDs are resolved to GUIDs and passed to `Package.Builder.Get->reset('fieldtype', $guids)`. No repository is selected by this call; remote lookup uses the configured effective order/read branches. |

Use the authenticated supported UI/API flow, including its request token; do not construct an unauthenticated controller URL. The selection screen and a success notification are not proof of the final values. Read the result categories and inspect the local record.

For a new candidate, allocate a fresh identity checked against current official and project catalogues, then use Init and confirm that the item was added. Do not republish a documentation fixture's reserved identity as a new production definition. For an improvement/intentional override of an existing core item, preserve its GUID, capture the prior local values, and test a controlled update. Pull can isolate the candidate repository; a separate Reset test is needed to demonstrate the intended ordered override. Confirm that no second identity was created to avoid a collision and that the selected source is the candidate rather than a shadowed original.

Inspect messages and verify the actual local record:

- GUID/name and selected source are correct.
- Descriptions, property names, native row structure, examples, and `mandatory`/`adjustable`/`translatable` metadata are current, including intentionally omitted unchecked flags.
- `has_defaults` and the associated database suggestions match the candidate.
- The definition is in the local state needed for the editor to use it; the inspected property helper queries published Field Types.
- A deliberate override really selected the candidate, not a shadowed original.

Do not write directly to JCB's tables to bypass a failed import test. Diagnose the index/path/encoding/target-implementation discrepancy.

### 2. Create a new concrete Field through JCB

Create a fresh Field in the test component's supported authoring flow and select the imported Field Type. Confirm that the expected property choices, descriptions, and examples appear. Set a unique field name and useful label, and set the new/changed property explicitly.

Record the resulting Field XML and database settings before saving. Distinguish catalogue suggestions from values deliberately chosen for this Field. Inspect **all** relevant settings, including datatype, `datalenght`/custom length, default/custom default, nullability, indexes, and storage method, instead of assuming the UI copies every returned default: the inspected JavaScript has specific assignments, not a generic copy of the entire database object. Verify the concrete Field's `fieldtype` GUID and its actual association with the test Admin View/component; a matching display name alone is insufficient.

Save and reopen the Field. Confirm that its `fieldtype` references the intended GUID and that saved XML/values survive. Attach it to a real test Admin View/component location that generates a form; an unused Field does not prove compilation includes the control.

### 3. Preserve and test existing Fields

Before refreshing the catalogue, capture at least one existing Field using the GUID with an explicit non-example property value and deliberate database overrides. After refresh:

1. Reopen it without changing its Field Type and compare the displayed properties, saved XML, and database values.
2. Compile the unchanged saved Field and compare output. This catches current-property-list effects independently of resaving the editor form.
3. On a disposable copy, test an omitted changed property, an explicit empty value, `"0"`/false-like values where valid, and a required/invalid value where relevant.
4. If testing type reselection, compare database settings before and after; that action can request catalogue defaults. Do not apply it blindly to production Fields with overrides.

For a property removal/rename, inspect whether the old attribute remains supported through an explicit compiler extra-attribute path or disappears. Do not assume every arbitrary saved XML attribute is preserved. For mandatory/example/type changes, verify the actual emitted value. For storage changes, apply the approved per-Field/schema migration separately and test preserved data.

### 4. Compile and inspect generated artifacts

Compile the component that actually includes the saved test Field through its view/field associations. Start a fresh compilation and inspect the actual generated paths for that target, rather than hardcoding paths from another Joomla version. In Playground, use the generated-file inspection/export route documented by the shared guide; do not infer artifact contents from a successful compile notification. Check:

- The test form contains the intended field name and runtime `type`.
- New/changed XML attributes are emitted with correct escaping, omission behaviour, and values.
- Translation-marked properties produce appropriate language references and strings; raw values remain raw where required.
- The generated installation/update SQL and intended column type, length, default, nullability, and indexes agree with the **concrete Field** configuration. A catalogue's database suggestions neither create a missing custom column nor migrate existing data automatically. Inspect the approved schema change and upgrade SQL separately where a migration is required.
- A custom field's PHP class, namespace/registration, dependencies, assets, and layout are delivered by the actual implementation path. For a name using JCB's `@` own-custom route, verify the concrete custom body in the emitted class and that Joomla resolves that class for the generated XML `type`; importing its property metadata alone does not create this runtime proof. Follow the [custom examples](../examples/README.md) for the exact code context.
- XML parses and generated/custom PHP lints on each affected supported PHP target.

Compare against the pre-change compile for existing consumers. Review unexpected changes even when the compiler reports success.

### 5. Exercise Joomla runtime behaviour

Install the compiled extension in the Playground test site through the supported install flow and open the actual generated form. Record installation separately from compilation. Verify rendering, label/help translation, relevant assets, enabled/disabled/readonly behaviour where applicable, required/invalid input handling, and save/reload. Submit a valid case and a relevant invalid/required case, verify the response, and reopen the saved record. Verify persisted values for empty, zero, null, scalar/multiple-value, and boundary cases relevant to this Field Type; inspect the actual table/storage representation where the supported test environment exposes it. A rendered control alone does not establish server validation or storage correctness.

Where the field class performs a query or requires component context, exercise the necessary context instead of testing only a standalone HTML mock. If the class/property exists only in some Joomla versions, test those targets and document the unsupported versions explicitly.

### 6. Report and recover

Report the candidate/research revisions, Playground/runtime configuration, catalogue order/selected source, changed GUIDs, static result, operation actually used (Init, Pull, or Reset), new and existing Field results, compile artifact comparison, installation, runtime submission/storage cases, matrix coverage, and remaining limitations. For an unexecuted stage, state **“Field Type [stage] not run”** and its reason; an available shared browser path is not evidence that this entity-specific stage ran. Use the [shared evidence record](../../testing/playground/verification.md) for previously observed setup behaviour and this module's [verification record](../verification.md) for Field Type results.

If refresh or compilation fails, retain the relevant messages and source/record diffs. Restore the development snapshot when necessary. If a change is reverted after it was consumed, refresh the previous metadata and recompile/reinstall affected consumers; restore migrated Field/schema/data state separately. Do not assume reverting Git repairs installed sites.

## Implementation evidence

The named JCB operations above were checked against `6.x` commit `408703a857ad937479b1e28de7f693af178dcc83`:

- [Field Types controller](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/FieldtypesController.php): Init/Pull selection, permissions/token checks, and selected-GUID Reset; [repository form](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/repository.xml): Field Types target `3`.
- [AJAX model](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Model/AjaxModel.php#L6764): `initSelectedPackages` passes the selected repository without force; `pullSelectedPackages` passes it with `force=true`. [Package builder getter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Builder/Get.php#L296): Reset invokes the remote handler without a repository selector.
- [Shared remote getter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Get.php): initialization's existing-local behaviour and read branch.
- [Field property helper](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Helper/ComponentbuilderHelper.php): `getFieldTypeProperties`, existing XML values, examples, publication requirement, and optional database suggestions.
- [Field editor JavaScript](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/media/js/admin/field.js) and [Field edit template](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/tmpl/field/default.php): explicit database assignments and type-change loading with defaults enabled.
- [Compiler Field Data](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Data.php), [TypeName](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/TypeName.php), and [Attributes](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php): concrete Field values joined to current Field Type metadata, type resolution, property filtering, and mandatory/example handling.

The [module source map](../sources.md) records the complete evidence and freshness procedure. Verify the target implementation before applying these named actions to another JCB version. The acceptance matrix and test cases are project guidance; they are not claims of completed runtime tests.
