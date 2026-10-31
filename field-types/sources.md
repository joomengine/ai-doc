# Field Type evidence and maintenance map

Inspected **2026-10-31**. These references establish the documented repository/authoring/compiler behaviour. They are not a claim that every Field Type has been imported, compiled or exercised in a live Joomla site.

## Baselines

| Source | Branch/reference inspected | Exact revision | Role |
| --- | --- | --- | --- |
| `vdm-io/Joomla-Component-Builder` | `6.x`, fetched again for this module | `408703a857ad937479b1e28de7f693af178dcc83` | Current inspected serializer, import, metadata, UI and compiler contract |
| `joomengine/joomla-fieldtypes` | `master` | `3be64d59378b5650825b97b44dbd58f2cdb82fcb` | Mandatory core identity/reuse baseline and 49 exported specimens |
| `joomengine/architecture` | `main` snapshot already pinned by this documentation repository | `7ac0ba83361e4b1d5181d2a441989ab17d50d63f` | Architectural explanation and worked Field trace |

Joomla runtime implementation evidence is recorded separately in [joomla-research.md](joomla-research.md), including the exact Joomla revision and inspected classes/ancestors/layouts. A JCB branch baseline does not itself establish the Joomla runtime versions supported by a particular Field Type.

## F01

**Portable record semantics and database storage metadata.** [Componentbuilder/Table.php, `fieldtype` entry](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php#L11267) defines all Field Type fields, storage modes and nested property rows. There are 16 mapped fields including `catid` and `access`; the remote config excludes those two, leaving the 14 documented portable fields. `properties` has JSON storage. Field references use the separate Field table's `fieldtype` GUID link; the Field Type GUID is not the concrete Field GUID.

## F02

**Form domains and conditions.** [admin/forms/fieldtype.xml](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/fieldtype.xml) defines SQL/storage selectors, the six property-row members, checkbox values, defaults and the exact `datalenght` spelling. [FieldtypeModel.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Model/FieldtypeModel.php#L742) contains form conditions for the active database-default controls. These establish JCB UI choices, not universal validity of all resulting SQL combinations or Joomla runtime property semantics.

## F03

**File layout, import locator and export projection.**

- [Abstraction/Remote/Config.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Config.php) supplies `index.json`, `src`, `item.json`, `guid`, README names and `getMap()`.
- [Fieldtype/Remote/Config.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Fieldtype/Remote/Config.php) sets entity `fieldtype`, excludes `catid`/`access`, and defines index members.
- [Componentbuilder/Remote/Grep.php, `getRemote()`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Remote/Grep.php#L67) fetches `entry.path + settings_name`, checks the item's identity member and records source SHAs when used on the write-branch path.
- [Fieldtype/Remote/Set.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Fieldtype/Remote/Set.php) writes pretty-printed mapped items and READMEs; `index_map_ShortDescription()` uses null-coalescing then PHP `trim`, returning null for empty selected text.
- [Fieldtype/Readme/Item.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Fieldtype/Readme/Item.php) and [Readme/Main.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Fieldtype/Readme/Main.php) derive catalogue documentation; they are not import schemas or runtime guarantees.

## F04

**Effective repository order and intentional overrides.**

- [Fieldtype/Config.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Fieldtype/Config.php) builds initial username/core-organisation sources and prepends configured target-3 repositories.
- [Utilities/RepoHelper.php, `get()`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Utilities/RepoHelper.php#L39) selects published sources and queries ordering descending; `modelRepoDetails()` maps host type and credentials. Combined with prepending, distinct configured repository entries are searched in ascending ordering.
- [Abstraction/Grep.php, `existsRemotely()`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Grep.php#L935) returns the first indexed match; `searchAllRepos()`, `getBranchName()` and `indexRemote()` define search-order, branch and caching behaviour.
- [Fieldtype/Grep.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Fieldtype/Grep.php) identifies the `joomla-fieldtypes` network target; its inherited [remote search](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Remote/Grep.php#L47) retrieves only the selected match and does not retry later same-GUID items when that payload fails.

The core GitHub repository's mandatory role is **project policy** from the owner. It is independent of the inspected legacy default network/organisation configuration. An authorized fork can deliberately override its same identity by preceding it; a newly invented unrelated Field Type cannot reuse its GUID.

## F05

**Import, explicit refresh and local state.** [Fieldtype/Service/Fieldtype.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Fieldtype/Service/Fieldtype.php) wires the Field Type remote services to Data Item/Items and approved paths. [Abstraction/Remote/Get.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Get.php#L119) implements `init()` (local-first unless forced), `reset()` and `item()` (remote fetch/update with request tracking). `init()` reports an added category after invoking `set()` without testing that return value; inspecting persisted data is therefore necessary rather than treating a category alone as proof of storage success.

[FieldtypesController::initPowers/resetPowers](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/FieldtypesController.php#L63) shows the UI initialization route and reset authorization/selection handling. [Package/Builder/Get.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Builder/Get.php#L298) delegates reset to the correct entity service. These paths do not imply that a Git push updates local JCB records automatically.

## F06

**Repository/database encoding boundary.** [Data/Item.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Data/Item.php#L207) chooses insert/update by identity. [Model/Upsert.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Model/Upsert.php#L39) uses `json_encode(..., JSON_FORCE_OBJECT)` for JSON-stored fields; [Model/Load.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Model/Load.php#L39) decodes them. A native property object/list is portable input; a nested serialized JSON string would be double-encoded by the current upsert path.

## F07

**Field authoring, examples and database suggestions.** [ComponentbuilderHelper::getFieldTypeProperties](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Helper/ComponentbuilderHelper.php#L1555) reads published Field Types and their property rows, handles settings/XML/examples, groups PHP properties, and conditionally returns database suggestions. Adjacent `getPropertyExample()`, `shouldForceLoadAllProperties()` and `buildXmlAttributeLine()` establish the seed, force marker and string assembly behaviour.

[media/js/admin/field.js](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/media/js/admin/field.js) applies the response in the Field editor. The helper returning `null_switch` is not evidence that every client branch copies it; the current database-copy block must be checked and the resulting concrete Field inspected. The generic helper does not enforce the `adjustable` flag as a lock.

## F08

**Compilation from existing local definitions.**

- [Compiler/Field/Data.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Data.php#L296): `getQuery()` selects concrete Field `a.*` plus joined Field Type name/properties by GUID; `getData()` decodes properties once; the service caches loaded fields.
- [Compiler/Field/TypeName.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/TypeName.php#L37): ordinary type example, Custom/CustomUser XML type, `@` own-custom marker and fallback handling.
- [Compiler/Field/Attributes.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php#L375): property iteration; `getValue()` special handlers; `modelValue()` translation; `setValue()` mandatory fallback and explicit empty default; additional/custom attributes.
- [Compiler/Creator/Builders.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Creator/Builders.php#L850): contextual schema builder uses concrete Field settings. This is why Field Type suggestions, occurrence roles and final SQL must be distinguished.

## F09

**Custom-field code context and encoding.** [Compiler/Utilities/FieldHelper.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Utilities/FieldHelper.php#L37) decodes `type_php*` concrete XML values through `Base64Helper::open`. [Compiler/Field/Attributes.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php#L715) loads additional numbered fragments through 30 and extracts custom configuration. [Compiler/Creator/CustomFieldTypeFile.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Creator/CustomFieldTypeFile.php#L325) distinguishes standard and own-custom output; `prepareCustomFieldBody()` concatenates class-body fragments for the own-custom route. The corresponding target templates and actual base class establish the exact PHP context; use [joomla-research.md](joomla-research.md) and the complete fixture guidance rather than guessing from a property name.

## F10

**Core specimens.** [Core index](https://github.com/joomengine/joomla-fieldtypes/blob/3be64d59378b5650825b97b44dbd58f2cdb82fcb/index.json) contains 49 GUIDs. [Text item](https://github.com/joomengine/joomla-fieldtypes/blob/3be64d59378b5650825b97b44dbd58f2cdb82fcb/src/201327fe-3067-4316-a155-3fe2a52e05c0/item.json) shows the 14-field form, mixed integer/string selectors, keyed property rows, nonconsecutive row labels and omitted unchecked flags. [Custom item](https://github.com/joomengine/joomla-fieldtypes/blob/3be64d59378b5650825b97b44dbd58f2cdb82fcb/src/dd2e1f4b-f5db-45e8-85fa-efd27bae7b6a/item.json) and [Privacy@ item](https://github.com/joomengine/joomla-fieldtypes/blob/3be64d59378b5650825b97b44dbd58f2cdb82fcb/src/60c1d674-8bb7-4b31-97ed-ee1f16bc412a/item.json) show specialised patterns. Preserve the [original licence](https://github.com/joomengine/joomla-fieldtypes/blob/3be64d59378b5650825b97b44dbd58f2cdb82fcb/LICENSE.txt) when copying specimens.

All 49 inspected item `properties` values were objects. That empirical fact supports the native nested representation; it does not prove every description/default in the core is current for Joomla 6. The core is the identity/reuse authority, while the target Joomla implementation establishes runtime behaviour.

## F11

**Architecture context.** [Blueprint representation](https://github.com/joomengine/architecture/blob/7ac0ba83361e4b1d5181d2a441989ab17d50d63f/DOCS/blueprints/representation.md) explains portable projections; [asset/catalogue roles](https://github.com/joomengine/architecture/blob/7ac0ba83361e4b1d5181d2a441989ab17d50d63f/DOCS/blueprints/assets.md) identifies the distinct distribution repositories; [Greeting Field trace](https://github.com/joomengine/architecture/blob/7ac0ba83361e4b1d5181d2a441989ab17d50d63f/DOCS/examples/field-trace.md) separates Field Type identity, concrete Field settings and contextual output. Browse the broader publication at [architecture.joomlacomponentbuilder.com](https://architecture.joomlacomponentbuilder.com/) through [the architecture router](../architecture/README.md).

## Known distinctions and verification limits

| Evidence/issue | Consequence |
| --- | --- |
| Core GUID catalogue versus source-network defaults | The core GitHub catalogue is mandatory policy; inspect the actual JCB repository registration/network resolution rather than assuming its literal URL is always first/last by default |
| Intentional duplicate GUIDs across repositories | Preserve ordered provenance and selected/shadowed definitions; duplicates are not automatically corruption |
| A matched index can point to a broken payload | Selected payload failure does not imply fallback to the next same-GUID source |
| Existing database records and request/compiler caches | Fetching Git changes or moving a source does not prove consumers now use it |
| `properties` strings in a supplied legacy file | The current storage path double-encodes them; use an explicit validated migration to native JSON |
| `adjustable` metadata | Do not claim enforced immutability in the current generic helper/compiler path |
| Examples versus runtime defaults | Verify Joomla classes/ancestors/layouts; preserve source disagreements as documented findings |
| SQL/storage suggestions | Verify concrete saved Fields and generated schema; catalogue changes do not rewrite existing Fields' SQL settings automatically |
| Custom PHP | Context and runtime validity require target template/class inspection, PHP lint and integration; metadata shape alone proves none of them |

Source inspection and static validation are reported separately from integration. No statement here claims a live JCB/Joomla import, compilation, database migration or browser test was performed merely because the source was read. The workflow acceptance report must record those outcomes explicitly.

## Refresh procedure

1. Record the intended JCB branch and exact target Joomla/PHP versions; fetch the selected refs without altering the user's working checkout.
2. Read the current core index and all additional registered/task-specific indexes. Record revisions and effective order, including declared overrides.
3. Compare changed metadata, forms, remote config/set/get, ordering, model encoding, UI helper/client, compiler and target runtime sources against these pins.
4. Update every affected field rule/example/test together. Do not change the inspection date without recording what was rechecked.
5. Run the documented static and fresh-agent checks, then the integration procedure on a representative new/existing Field when available. Keep any unavailable stages explicit.
6. Preserve the old supported-version distinction if a newly inspected implementation differs. Source code proves actual behaviour; project policy states the expected authoring standard.
