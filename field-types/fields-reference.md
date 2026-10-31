# Field Type `item.json` field reference

The current portable projection has **14 top-level fields**. They come from JCB's Field Type table map, excluding `catid` and `access`; they are not inferred solely from the 49 core specimens. [F01](sources.md#f01), [F03](sources.md#f03). New definitions should include all 14 with explicit appropriate values. Existing malformed/legacy representations need a named migration, not silent coercion or speculative defaults.

The exact property names `datalenght` and `datalenght_other` are historical spellings in the contract. Do not “correct” them to `datalength`.

## Top-level fields

| Field | Repository shape and domain | Meaning, conditions and empty handling |
| --- | --- | --- |
| `guid` | UUID string | Stable Field Type identity. Same as index key/entry and directory. Preserve for maintenance or intentional same-type overrides; generate a new checked UUIDv4 for a different type. Empty/missing is invalid. |
| `name` | Nonempty string | JCB display/type classification name, e.g. `Text`, `Modal Menu`, `Privacy@`. Spaces and the special `@` marker occur legitimately; this is not a PHP identifier. The compiler normally derives runtime type from the `type` property example. |
| `short_description` | String | Short explanation used for the index's `desc` and UI. `""` is an empty description, not a request to use the full description; see exporter fallback rules in [specification](specification.md#repository-layout-and-import-inputs). |
| `description` | String | Detailed purpose, use conditions and restrictions. May be empty, but new definitions must explain their intended use and version limits. This text is not executable implementation or a substitute for source verification. |
| `properties` | Object/list of row objects | Supported JCB authoring/property metadata. Native nested JSON, not an encoded JSON string. Empty/null properties are not a useful complete definition: the UI helper returns no property definition and the compiler cannot rely on it. See row contract below. |
| `has_defaults` | `0` or `1`, including numeric-string representations | Enables returning the database suggestions when the authoring helper is called with database defaults requested. `0` means suggestions are inactive; it does not mean the concrete Field can never store data. Missing/null is not a reliable configured default. |
| `datatype` | String; domain below | Suggested database column type when defaults apply. `""` means no selected suggestion. It is unrelated to XML `type`. |
| `datalenght` | String; domain below | Suggested SQL length/precision selector, including `Other`. An empty value supplies no explicit selection. It is not the form's `size` or `maxlength`. |
| `datalenght_other` | String | Custom length/precision when `datalenght == "Other"`; otherwise inactive, commonly `""`. Choose syntax valid for the selected SQL type and target database. |
| `datadefault` | String; domain below | Suggested SQL default selector. `""` is the form's “None” selection; it is not the same as the literal string `"0"`, SQL `NULL`, or XML `default`. |
| `datadefault_other` | String | Custom default when `datadefault == "Other"`; otherwise inactive, commonly `""`. Validate the emitted schema under the target SQL mode instead of assuming any string is legal SQL. |
| `indexes` | Numeric string/integer `0`, `1`, `2`; existing inactive specimens also use `""` | Suggested index selection: `0` none, `1` unique key, `2` ordinary key. Concrete Field occurrence roles may additionally influence generated indexes. Empty is not a request for a unique index. |
| `null_switch` | `"NULL"`, `"NOT NULL"`; existing inactive specimens also use `""` | Suggested SQL nullability. The JSON string `"NULL"` is not JSON `null`. Confirm the concrete Field value; the authoring helper returning a suggestion does not prove the UI copied it. |
| `store` | Integer/numeric string; domain below | Suggested value transformation/storage mode for concrete Field values. It does not control how this repository JSON or the Field Type's own `properties` are encoded. |

UI-supported domains at the inspected revision, from [F02](sources.md#f02):

| Field | Values |
| --- | --- |
| `datatype` | `""`, `CHAR`, `VARCHAR`, `TEXT`, `MEDIUMTEXT`, `LONGTEXT`, `BLOB`, `TINYBLOB`, `MEDIUMBLOB`, `LONGBLOB`, `DATETIME`, `DATE`, `TIME`, `INT`, `TINYINT`, `BIGINT`, `FLOAT`, `DECIMAL`, `DOUBLE` |
| `datalenght` | `""`, `"1"`, `"7"`, `"10"`, `"11"`, `"36"`, `"50"`, `"64"`, `"100"`, `"255"`, `"1024"`, `"2048"`, `"Other"` |
| `datadefault` | `""`, `"0"`, `"1"`, `"CURRENT_TIMESTAMP"`, `"DATETIME"`, `"Other"` |
| `store` | `0` default/plain handling; `1` JSON; `2` Base64; `3` basic encryption using local database key; `5` medium encryption using local file key; `6` expert/custom mode |

These are **UI value domains**, not a claim that every cross-product is a sensible schema or that `DATETIME` is an independently valid SQL default expression. The compiler has legacy handling for storage mode `4` (WHMCS), but the current Field Type form does not offer it. Do not silently convert an existing legacy value or recommend it for new definitions without a target-specific compatibility investigation. Expert mode requires concrete Field modelling code; `store: 6` alone supplies none. Encrypted storage needs its actual key/runtime configuration; a Field Type default is not proof that those prerequisites exist.

Database suggestions are conditional authoring metadata. Current UI conditions hide length, index and storage controls for unsupported type combinations. When `has_defaults == 0`, existing records may retain inactive values or empty strings; preserve them unless intentionally changing the definition. For a new active default set, choose a coherent complete combination and verify the resulting concrete Field and schema. A no-default Field Type need not copy arbitrary values from Text just to fill the document.

## `properties` rows

A keyed object is the observed core export form. Row keys such as `properties0` are serialization/UI row identifiers, not GUIDs and not the XML attribute name. Read the row's `name`. Lists can also be consumed after storage normalization. Preserve row order where it affects compiler handling; keys need not be consecutive, and sorting by property name can change semantics such as processing the name before its label.

| Row member | Shape | Exact purpose and absence handling |
| --- | --- | --- |
| `name` | Nonempty string | Property name, such as `type`, `name`, `label`, `maxlength`, `option` or a JCB custom-code selector. Unique per authored definition. It may be a Joomla attribute or JCB-specific input; verify which. |
| `example` | String | Suggested authoring value and, for certain mandatory non-custom properties, compiler fallback. `""` is a legitimate empty example. New records should include it explicitly; the helper defaults missing values to `""`, while other compiler paths use a diagnostic fallback, so omission is not a robust authoring choice. |
| `description` | String | Explanation of accepted values, conditions, target support and effects. Preserve literal text/markup with correct JSON escaping. A claim here must be backed by the relevant Joomla/JCB implementation. |
| `adjustable` | Optional `0`/`1` or numeric string | Describes whether the property is intended to be adjustable. Unchecked core rows commonly omit it. The current generic property helper/compiler path does not enforce this as a write lock; do not promise that setting it to `0` prevents editing or overrides. |
| `mandatory` | Optional `0`/`1` or numeric string | JCB metadata indicating required property presence for its generated definition. Missing flag is treated as false in the inspected attribute builder. A missing/empty mandatory non-custom property can fall back to `example`; this is not the HTML/Joomla validation attribute `required="true"`. |
| `translatable` | Optional `0`/`1` or numeric string | Directs JCB to generate language-key treatment for applicable nonempty concrete values. Omitted means false in the inspected compiler. It is not automatic translation of the Field Type's documentation. |

This is a valid **fragment**, using the existing Text pattern to show omitted unchecked flags and a translated label. For complete importable examples see [examples](examples/README.md).

```json
{
    "properties": {
        "properties0": {
            "name": "type",
            "example": "text",
            "mandatory": "1",
            "description": "The Joomla form field type is text."
        },
        "properties1": {
            "name": "name",
            "example": "mytextvalue",
            "adjustable": "1",
            "mandatory": "1",
            "description": "The unique field name in its form."
        },
        "properties2": {
            "name": "label",
            "example": "Enter some text",
            "adjustable": "1",
            "mandatory": "1",
            "translatable": "1",
            "description": "The descriptive field label."
        }
    }
}
```

**Policy:** do not encode flags as textual `"true"`/`"false"` or use JSON booleans for newly authored rows. Follow the numeric convention. Preserve omission for unchecked flags when maintaining existing rows. Do not fill a missing required example or name with a guessed runtime value; research it.

## Consequential compiler/UI rules

| Property/condition | Verified JCB behaviour | Authoring consequence |
| --- | --- | --- |
| New Field, no prior XML | The helper can seed properties from examples | An example becomes a real saved value in this path; choose safe, meaningful seeds |
| Existing Field XML | The helper normally retains present values and avoids adding absent properties unless forced/overridden | Adding a catalogue row does not guarantee every existing Field gets that attribute |
| Non-custom `type` | Nonempty type-row example takes precedence; concrete XML is a fallback | Changing this example changes actual emitted type selection |
| `Custom`, `CustomUser`, or derived own-custom route | Concrete XML provides the actual type | Do not force the literal `custom` value as the runtime implementation |
| `mandatory == 1` on ordinary fields | Missing/empty value falls back to the example | Changing mandatory/example can alter an existing consumer without editing its XML |
| `translatable == 1` | Existing nonempty value is modelled into language output before mandatory fallback | Do not assume a missing mandatory value's fallback example is translated in the same way; inspect emitted XML and language entries |
| Explicit `default=""` | Attribute builder has a special path preserving explicit empty defaults | Do not erase empty default by treating all empty values as absent |
| Property removed from catalogue | Ordinary emitted attributes are built by iterating the current rows | A saved XML attribute may disappear from new compiled output |
| `adjustable` | Shown in catalogue documentation; not consumed as a generic enforcement flag in the inspected helper/attribute path | Treat it as documented authoring intent, not access control |

Sources: [F07](sources.md#f07), [F08](sources.md#f08). These rules explain why changes must be tested using both a newly created Field and an existing saved Field. Generic extra/special attributes have their own compiler handling, so do not describe the iteration rule as an absolute prohibition on every attribute not in a catalogue.

## Ordinary Joomla attributes versus JCB instructions

The nested property vocabulary is extensible; a list of today's names would not prove all future names valid. For each row, classify it using the [Joomla source-research procedure](joomla-research.md):

- **Joomla/runtime attributes:** inspect the actual field class, inherited `FormField`/input behaviour, layout, filters, rules and form loading. `size`, `maxlength`, `default`, `required` and `filter` control different concerns.
- **JCB special inputs:** metadata such as `type`, `name`, validation-rule selectors, option definitions, subform Fields, custom `extends`, `view`/`views`, table/key/text selectors and `type_php*` may be transformed before output. Read the appropriate compiler builder, not only Joomla's final XML documentation.
- **External implementation attributes:** record the installed provider/class and target versions. A property copied from another extension does not become a Joomla core property.

A Field Type name containing `@` selects an own-custom route in `Compiler\Field\TypeName`; it is not a generic email/address delimiter. `own_custom` is derived state and must not be invented as a fifteenth portable field. Custom PHP examples remain plain strings in the catalogue. Actual `type_php*` values in a concrete Field's XML pass through the custom-code encoding/decoding path. The compiler loads additional numbered PHP fragments through line 30; their execution context depends on the specific custom-field template. See [F09](sources.md#f09) and complete examples before changing these values.

There is no general Field Type namespace-prefix placement field comparable to a Super Power's `namespace`. Placeholder-looking text in a property example is not guaranteed to expand everywhere: actual XML values and custom PHP pass through particular compiler placeholder/custom-code stages. Introduce such tokens only with a documented provider, evaluation stage and tested consumer. Ordinary text must remain literal when no such stage applies.

## Omitted, null, empty and local values

- The inspected core records use native property objects, integer `has_defaults`/`store`, string SQL selectors, and optional numeric-string flags. Those observations do not authorize replacing all values with a single type.
- `null` is not an alternative spelling for `"NULL"`, `0`, `""` or an empty property collection. Do not supply it for required/new-authoring members without target-specific evidence.
- Empty inactive SQL suggestions are valid observed data. Active `Other` selectors require a deliberately chosen corresponding `_other` value and generated-schema verification.
- Omission on an update is not a safe instruction to clear a local field. Write the intended explicit disabled/empty value, then inspect the stored result after reset/import.
- Do not export local `catid`, `access`, numeric `id`, `asset_id`, publication/editor bookkeeping, repository credentials or compiled state as part of the portable item. Current remote projection excludes the local category/access fields and uses the table metadata map. Keep ancillary provenance in separate documentation.
- Field Type records do not have a Super Power version field or SPK. Version applicability belongs in documentation/provenance until an actual JCB contract adds a portable field. Do not append invented `joomla_version`, `namespace`, `code` or dependency schema members to `item.json`.

When a legitimate new target requires fields beyond this baseline, inspect its live serializer/importer first, update the evidence and validator, and describe the compatibility change explicitly. Do not discard unknown fields from supplied files before determining their origin.
