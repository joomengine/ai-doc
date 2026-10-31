# `settings.json` field reference

This is the repository representation of a PHP Super Power, not a database dump. Read [the file and namespace contract](specification.md) first. Preserve existing values unless the change requires modifying them; omission, `null`, `""`, `[]`, `{}`, `0` and `-1` are not a universal set of equivalents.

## Authority and applicability

**Implementation:** verified against JCB `6.x` commit `408703a857ad937479b1e28de7f693af178dcc83` on 2026-10-31. Field domains come from [admin/forms/power.xml](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/power.xml); persistence metadata from [Table.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php#L3963); consumption from [Compiler/Power.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php); export forms from [Power/Remote/Set.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Set.php) and [Compiler/Power/Infusion.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Infusion.php#L113).

**Policy:** create complete definitions using the fields below. Do not derive the schema solely from one example, and do not reject valid historical exports just because they omit inactive custom fields. A validation tool must distinguish the shape accepted for existing exports from the stricter conventions used to author new records. Unknown fields require investigation of the target implementation, not silent deletion.

## Identity and description

| Field | Repository value | Required meaning and empty handling |
| --- | --- | --- |
| `guid` | UUID string | Stable Power identity. Required for new definitions; same as index key and directory. New identities use generated UUIDv4. Never change it for an ordinary update. |
| `name` | Nonempty string | Declaration name, normally a valid PHP class/interface/trait identifier. Compiler expands placeholders/custom code then applies its name sanitizer; final namespace filename must match. New reusable names should be explicit rather than dependent on undocumented custom code. |
| `system_name` | String | JCB administration/display/search label. It is not the PHP fully qualified class name and is not used in place of the GUID. Use a meaningful repository-qualified label; preserve established naming. |
| `type` | `class`, `abstract class`, `final class`, `interface`, `trait` | Exact declaration text before the name. No empty value for an authored Power. `enum` and PHP 8.2 `readonly class` are not options in the inspected form; do not invent support. |
| `namespace` | Nonempty string | Portable placement template **including** the final declaration name. At least two backslash-separated parts, final dotted filename equal to resolved `name`; see [namespace algorithm](specification.md#namespace-templates-and-physical-placement). |
| `power_version` | Nonempty string, e.g. `1.0.0` | Per-Power version metadata. Form default is `1.0.0`; no dependency version-range resolution is implemented by this field. Choose version increments under the repository's release policy. |
| `description` | String, possibly empty | Class documentation. Compiler can wrap plain text as a PHP docblock, or preserve a supplied comment. Keep description and `@since` information consistent with behaviour; avoid accidental `*/` terminating a comment. |

The repository's supported Joomla/PHP/JCB versions must be documented separately: `power_version` is not a PHP version, Joomla version, repository release tag or Composer constraint.

## Inheritance and interface contracts

| Field | Active when | Repository shape and meaning |
| --- | --- | --- |
| `extends` | `type` is not `interface` | Existing Power GUID, custom sentinel `-1`/`"-1"`, or `""` for no parent. The compiler treats the sentinel loosely, so both exported forms occur. New normal class definitions without a parent use `""`. |
| `extends_custom` | `extends == -1` | Nonempty declaration name/expression supplied by the header or another documented external source, e.g. `JoomlaHttp`. No GUID lookup occurs for this value. Inactive exports may omit it or contain `""`. |
| `extendsinterfaces` | `type == "interface"` | Array of interface GUIDs and/or a single custom sentinel. Empty historical exports commonly use `null`. The compiler reads this field instead of `extends` for interfaces. |
| `extendsinterfaces_custom` | Interface has sentinel in `extendsinterfaces` | Nonempty custom parent-interface declaration text. Inactive exports may omit it or use `""`. |
| `implements` | A PHP class implements interfaces | Array of interface GUIDs and/or a single custom sentinel. Historical empty exports use `null`; the direct remote exporter can preserve an existing empty form. |
| `implements_custom` | Sentinel is present in `implements` | Nonempty custom interface declaration text, with imports supplied separately. Inactive exports may omit it or use `""`. |

**Policy:** use Power GUID selectors when the dependency is a Power. Use custom selectors for genuine external classes/interfaces such as Joomla classes; ensure their symbols are imported or fully qualified and their runtime availability is established. Never put a class name into a GUID selector or a GUID into a custom name. Prefer a single sentinel per list; the compiler processes the associated custom text once.

For interfaces, keep `extends`/`extends_custom` empty and use `extendsinterfaces`; for ordinary classes, keep `extendsinterfaces` empty. For traits, use no class inheritance or `implements` metadata. The generic compiler inheritance branch does not validate every legal PHP type combination; schema acceptance cannot make `trait X extends Y` valid PHP. Do not extend a `final class`, and do not implement a class as an interface.

**Alias caveat:** the compiler resolves GUID-based inheritance/implements declaration names independently from ordinary `use_selection` aliases. For a class extending another Power with the same short name, the inspected compiler creates an `Extending<Name>` alias. An arbitrary alias in `use_selection` is not a promise that the inheritance or implements clause will use it. Inspect the generated declaration/imports and compile the consumer, especially when changing aliases or combining same-named dependencies. Sources: [setExtendClass](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L833), [setExtendInterface](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L889), [setImplements](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L757).

## Loading and imports

| Field | Empty form | Populated shape | Effect |
| --- | --- | --- | --- |
| `use_selection` | Usually `null` | List or keyed object of rows containing `use` GUID and `as` string | Loads each dependency and generates a namespace import |
| `load_selection` | Usually `null` | List or keyed object of rows containing `load` GUID | Loads dependencies without adding a namespace import to this Power |

Keyed subform objects are normal JCB exports. Their row keys, such as `use_selection0`, are row identifiers, **not** dependency GUIDs. Read the `use`/`load` member. Do not confuse a keyed object with an invalid array and flatten it destructively.

This illustrative pair of imports references existing `super-powers` utilities; it demonstrates the row shape without creating new identities:

```json
{
    "use_selection": {
        "use_selection0": {
            "use": "0a59c65c-9daf-4bc9-baf4-e063ff9e6a8a",
            "as": "default"
        },
        "use_selection1": {
            "use": "1f28cb53-60d9-4db1-b517-3c7dc6b429ef",
            "as": "StringUtility"
        }
    },
    "load_selection": null
}
```

This is an illustrative selector fragment, not a complete Power definition. Resolve both referenced GUIDs against the current catalogue before adopting them. `as: "default"` requests no alias; an empty/missing alias is treated as default by the inspected compiler. An explicit alias must be a valid PHP identifier, unique among imported symbols and consistent with the class body. New definitions use `"default"` explicitly when no alias is intended. Import declarations with invalid names are authoring errors even if the compiler's string handling is permissive.

A `load_selection` row has the form `{"load":"<resolved dependency GUID>"}`; populate it using an actual indexed dependency. It is appropriate for dependencies needed by runtime discovery or factories that cannot be found by ordinary imports. It does not register those services. Sources: [setUseSelection](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L621), [setLoadSelection](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L651).

## Header and licensing

| Field | Values | Exact relationship |
| --- | --- | --- |
| `add_head` | `0`/`1` (numeric strings can arise from database exports) | `1` enables the source `head`; `0` disables that source text. Generated imports from dependency/composer metadata still occur with `0`. |
| `head` | Plain text JSON string, normally `""` when unused | Inserted after the namespace and before the class docblock/declaration. Place external imports here. It is not the class body and must not contain another `<?php` opening tag. |
| `add_licensing_template` | `1` or `2` | `1` means global licensing; `2` means override using a nonempty `licensing_template`. This is not a boolean. |
| `licensing_template` | Plain text JSON string | Custom file licence/header comment when the override is enabled and nonempty. Preserve original attribution and licence terms. Inactive values may be empty or present but unused. |

The compiler processes active header and licence text through its custom-code/placeholder pipeline. A populated `head` with `add_head: 0` is inactive; do not assume its imports exist. Conversely, `add_head: 0` does not suppress imports generated from `use_selection`, inheritance or Composer metadata. If the custom licensing condition is not met, the compiler resets to global mode. Do not rely on that fallback to repair an authored override with missing legal text.

An existing Joomla adapter demonstrates custom inheritance correctly: [`Openai Http settings`](https://github.com/joomengine/openai/blob/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/src/4c58b254-aea5-40aa-b54d-9586a1690451/settings.json) enables a header containing `use Joomla\CMS\Http\Http as JoomlaHttp;` and selects `extends: "-1"`, `extends_custom: "JoomlaHttp"`. Reusing Joomla's HTTP implementation requires this linkage and supported Joomla APIs, not a copied resolved Power namespace.

Sources: [Selection::codeEnabled](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Selection.php#L213), [setHeader and setLicensingTemplate](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L1052).

## Composer linkage

`composer` is **not** `composer.json`, a package requirement list, or an instruction to download a dependency. It connects external PHP namespace imports to an autoloader access point.

| Member | Meaning |
| --- | --- |
| `composer` | List or keyed object of Composer linkage rows; historical empty exports include `""`, while the direct exporter normalizes an empty value to `[]` |
| Row `access_point` | Autoloader file path relative to `JPATH_LIBRARIES` in the ordinary generated component autoloader |
| Row `namespace` | List or keyed object of import rows |
| Namespace row `use` | External fully qualified namespace/class import text, optionally ` as Alias` |

The existing phpseclib [`KeyLoader`](https://github.com/joomengine/phpseclib/blob/77dce1558dbb8b003629d06b7ebb0950f386e2e0/src/6da44dff-a221-4f22-b9d9-b2fc2a724b4b/settings.json) uses this complete linkage value:

```json
{
    "composer": {
        "composer0": {
            "access_point": "phpseclib3/vendor/autoload.php",
            "namespace": {
                "namespace0": {
                    "use": "phpseclib3\\Crypt\\PublicKeyLoader"
                }
            }
        }
    }
}
```

It extends the custom name `PublicKeyLoader` and has an empty body. Its inherited functionality is the implementation; an empty body is not an unfinished class. The consumer must still supply `libraries/phpseclib3/vendor/autoload.php` and the compatible dependency. The compiler adds a guarded `require_once` for the path; if the file is missing it does not install it. A file-existence guard also does not make a dependent class usable without that package.

**Policy:** record dependency package/version, provenance/licence, installation/package inclusion and the supported runtime. Use relative paths with no traversal or embedded PHP. Do not copy private tokens or local filesystem paths into `access_point`. The XML UI allows one top-level Composer row and up to 30 namespace rows in the inspected form; the compiler loops over rows. For new authored definitions stay within the supported UI shape unless a tested target-specific requirement justifies otherwise. Sources: [setComposer](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L681), [Autoloader::getComposer](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Autoloader.php#L335).

## Legacy, local and derived fields

| Field | Treatment |
| --- | --- |
| `method_selection`, `property_selection` | Legacy metadata present in JCB's table/form and some exports. Current `Compiler/Power/Selection::relationshipFields()` explicitly excludes them, and the inspected compiler does not consume them to construct class members. Preserve existing values; write actual required members in `code.power`. Do not document these as a working method/property import mechanism. |
| `main_class_code` | Internal merged/import/database field. It must live in `code.power`, not be duplicated in authored `settings.json`. The remote exporter explicitly removes it from settings. |
| `extends_name`, `implement_names`, `_namespace`, `class_name`, `file_name`, `path` | Compiler/export working data or index-derived information. Do not add them to authored settings. |
| `approved`, `approved_paths`, `access` | Local JCB export/permission configuration. Current Power remote config excludes these from exported settings. `approved` and paths control where JCB may export a local Power; they do not establish a repository's external dependency list. |
| `id`, `asset_id`, `created_by`, `modified_by`, `checked_out`, `rules` and similar local record/UI data | Not the portable Power identity/contract. Do not copy database rows or a form payload wholesale into settings. |

The compiler's export linker contains a fixed portable field list. The current direct remote exporter derives its map from table metadata, excludes the three fields above, and strips body/working names, which explains why legacy selection fields may appear in some exported settings but not others. Preserve meaningful unknown data until its origin is understood; a schema designed for new authoring must not silently remove it from an existing repository. Sources: [Remote/Config ignore list](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Config.php#L81), [Remote/Config map builder](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Config.php#L457), [Selection::relationshipFields](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Selection.php#L77).

## Safe handling of empty and missing fields

1. For an existing Power, retain its inactive fields and established serialization form unless there is a concrete reason to normalize them. Review the whole semantic result, not merely a JSON-schema pass.
2. For a new definition, include identity, type, namespace, version, description, explicit header/licence switches and their text, empty or populated inheritance fields, and explicit use/load/composer selections. Use a complete verified example as a starting shape, then generate a new GUID and choose dependencies deliberately.
3. Custom fields are required **when selected**. A missing active `extends_custom`, missing `use`/`load` in a populated row, or missing Composer access/import members is an error, not an empty dependency.
4. Empty source `code.power` remains valid. Absence of the body file is an error. `null` is not body content.
5. Do not encode selector arrays as JSON text inside JSON. The storage layer encodes them after import. Do not base64-encode header or licence strings.
6. Do not assume omission clears a local JCB field. Import/update paths and model defaults differ; when removing a relationship or disabling code, write its explicit empty/disabled representation and verify the resulting imported record.
7. Run field checks together with dependency resolution, namespace rendering and PHP syntax. For example, a valid `extends` GUID can still point to an interface, and an otherwise valid import can conflict with the declaring class name.

## Field review checklist for a change

- Which value is source, which is local configuration, and which is derived output?
- Does a flag or declaration type make this value active or inactive?
- Does every GUID reference resolve at the intended ordered repository revision?
- Are custom names imported and installed, with legal PHP inheritance/type relationships?
- Does the namespace template render to the intended class and physical location for the supported target?
- Are PHP signature/alias/service compatibility and licence obligations preserved?
- Do the settings and body import correctly, and do regenerated PHP and documentation describe the same result?

For full repository operations and their validation steps, return to [the module entry point](README.md).
