# Define concrete Fields and application relationships

A package [`field`](../reference/field.md) is a concrete reusable form/storage definition. Its `fieldtype` GUID points to the separate [Field Type catalogue](../../field-types/README.md). The catalogue describes available properties and suggestions; the Field owns its chosen XML and storage settings. A Field becomes part of an Admin View through `admin_fields`, or part of component/module/plugin options through the corresponding configuration collection.

## Keep four boundaries explicit

| Boundary | What to author and verify |
| --- | --- |
| Package graph | Field GUID, Field Type GUID and detected dependencies; these identify authoring records. |
| Form | XML `name`, runtime `type`, label/description, attributes/options, filtering, required/validation and custom code where supported. |
| Storage | Datatype, `datalenght`/`datalenght_other`, `datadefault`/`datadefault_other`, `null_switch`, indexes and store/model transforms. Preserve the historical field names. |
| Consumer attachment | Tab/list/title/alias/search/filter/permissions and database inclusion in `admin_fields`, or option grouping/override in another owner. |

The compiler [Field/Data](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Data.php) joins the current Field Type properties to the saved Field and decodes its database XML/model values. Package serialization reverses database storage transforms: use the [reference](../reference/field.md) and package contract, not database-encoded strings copied by inspection. In particular, database JSON storage of XML does not mean adding another JSON-string layer to an already decoded repository value.

Read [Joomla source research](../../field-types/joomla-research.md) before claiming an XML attribute/default is supported. A catalogue example is not necessarily the Joomla core default or this Field's chosen value. The runtime `type` and custom field implementation must actually exist for the target Joomla version.

## Storage choices change behaviour

The inspected Field form offers indexes `0` none, `1` unique key, `2` ordinary key; nullability is the literal `NULL` or `NOT NULL`. Use `datalenght=Other` with `datalenght_other` for an allowed custom length, and `datadefault=Other` with its companion for a custom default. Empty, zero, SQL NULL and a literal empty string require deliberate design; do not normalize them together.

`store` exposes `0` default, `1` JSON, `2` Base64, `3` basic encryption using a local database key, `5` medium encryption using a local file key, and `6` expert custom handling. The compiler also contains a legacy `store=4` path; its existence is not a reason to select an unoffered mode for a new Field. Resolve older specimens against source instead of silently changing their values.

Expert mode uses `on_get_model_field`/`on_save_model_field` and optional initiator hooks; the inspected compiler only activates the custom path when both model handlers contain code. Choose a reversible transformation and document expected input/output types, failure behaviour, key/configuration dependencies and migration effects. Base64 is encoding, not encryption. Searching/sorting/filtering a transformed column may not have the meaning it had for plaintext/scalar data. Test saved raw values, decoded values, empty/zero/null, multiple rows and failed decoding.

CSS/JavaScript settings on a Field have their own singular/plural view enable flags. A reusable Field can therefore affect several consumers. Preserve existing identity for an intentional shared update and enumerate affected consumers; create a distinct checked Field identity when it is an independently adapted definition.

## Choose the relationship mechanism

| Need | Appropriate mechanism and boundary |
| --- | --- |
| Reference another JCB authoring record | A declared GUID link/subform field plus package dependency; not automatically an application database relation. |
| Select one generated application record with create/edit/select actions | A supported ModalSelect Field; configure actual target table/title/key and selection/edit/new routes. Verify stored key type and ACL. |
| Query a straightforward option list | A Joomla SQL Field with correct query, key/value mapping and target context; a query-backed control does not create its target table. |
| Reusable/context-sensitive selector logic | A Custom Field extending the appropriate core type, with generated class body, table/component/view/key/value context and dependencies as required by the actual template. |
| Store repeated embedded rows | Subform XML referring to child Field GUIDs; deliberate structured storage, usually requiring JSON-compatible model handling. Does not create a normalized join table. |
| Store multiple selected values | A supported multiple control plus chosen storage and query strategy. `multiple` is not a database cardinality/migration definition. |
| Model a relationship with its own attributes/lifecycle | A separate Admin View/table with appropriate reference Fields, uniqueness/query/permission design and owner/child presentation. |
| Use users/categories/tags/access or other Joomla-managed data | Prefer the applicable Joomla core Field and service; do not replace a Joomla-managed relationship with a similarly named local table without a reason. |
| Read/join records for presentation | [Dynamic Get](presentation-and-queries.md), separate from the form's write/storage path. |
| Compose list columns | [Admin Field Relations](admin-views.md#relations-are-list-composition), separate from foreign-key or read-query design. |

Before writing XML, decide target ownership, cardinality, key type, editing/read needs, delete/update policy and permissions. A package's GUID can be a record identity in JCB while an application row uses a numeric ID or another key; never substitute them merely because both identify something.

For ModalSelect, inspect `sql_title_table`, `sql_title_column`, `sql_title_key`, `urlSelect`, `urlNew`, `urlEdit` and the enabled actions against the real component routes. For Custom Fields, use the actual compiler's body/context contract and proper concrete XML encoding. A raw PHP body in catalogue metadata and the encoded value in a saved Field are separate stages. See [custom Field Type example](../../field-types/examples/custom-repository/README.md) and [Field/ModalSelect](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/ModalSelect.php), [Field/Attributes](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php).

## Subform Fields and validation

The package resolver scans a Field XML's `fields="..."` references and `validate="..."` rule separately from ordinary table links. Ensure every nested Field exists, has its own intended type/attributes, and is not accidentally attached as an extra top-level database column. Check nested names, repeatability, required fields, save/reopen shape and how the application queries/validates that structure. Do not presume arbitrary alternate quoting or dynamically assembled XML is recognized by every scanner; use the exact supported representation and inspect generated dependencies.

[`validation_rule`](../reference/validation_rule.md) uses its **name** as repository identity. Use a native Joomla rule where it provides the required behaviour; otherwise provide the custom rule's complete PHP under a deliberate unique natural key. Its `inherit` selector is an authoring aid that fetches existing rule code into the PHP editor, not a portable GUID dependency or proof of runtime class inheritance. Inspect and save the resulting PHP; do not rely on another installation having the same local numeric selector ID. See the [editor implementation](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/media/js/admin/validation_rule.js).

The compiler extracts the `validate` name, normalizes it, checks the target's core rule list, then looks up custom PHP by name. A core rule is not a missing package record. Conversely, a missing custom rule can reach a source path that removes its custom link without a completed diagnostic; explicitly verify the generated class and actual validation rather than relying on compiler silence. [Field/Rule::set](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Rule.php), [Joomla6 core rule source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/JoomlaSix/CoreRule.php).

## Author, integrate and debug

1. Research the real Joomla Field and choose/reuse the external catalogue identity. Declare the required runtime version and assets/context.
2. Allocate/preserve the Field identity and write concrete XML plus explicit storage/model settings. Check XML syntax and source references; optional code needs its enabling settings.
3. Attach the Field to the actual owning view/configuration and resolve every nested Field/rule/code dependency. Inspect the package reference for serialization, not the form's hidden/UI values.
4. Import/reopen the Field and owner. Verify actual XML/storage values, catalogue resolution and existing consumer overrides.
5. Compile and inspect form XML, custom classes/rules, model get/save logic and install/upgrade SQL. Install and test rendering, accessibility, invalid/valid input, save/reopen and raw stored values.
6. For a change to an existing Field, test an unchanged existing consumer as well as a new one. Record and execute a migration when datatype, transform, default, key or cardinality changes; refreshing a Field record does not migrate installed data.

For a wrong control inspect the actual `type`, catalogue properties and generated class registration. For a missing attribute inspect the current Field Type property list and compiler extra-attribute path. For dropped/invalid values inspect XML filter/validation, attachment database inclusion, null/default and the model transform before changing the catalogue. For a relationship mismatch inspect application keys and routes separately from the package GUID graph.
