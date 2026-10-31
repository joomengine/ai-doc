# layout serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](layout.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/layout.json`. Record: `src/layout/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `name` | text | VARCHAR(255) / "" | none | null |
| `description` | text | VARCHAR(255) / "" | none | null |
| `dynamic_get` | dynamicget | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_dynamic_get","component":"com_componentbuilder","entity":"dynamic_get","value":"name","key":"guid"} |
| `snippet` | snippets | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_snippet","component":"com_componentbuilder","entity":"snippet","value":"name","key":"guid"} |
| `guid` | text | VARCHAR(36) / "" | none | null |
| `php_view` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_php_view` | radio | TINYINT(1) / "0" | none | null |
| `layout` | editor | TEXT / "EMPTY" | base64 | null |
| `libraries` | libraries | TEXT / "EMPTY" | json | {"type":1,"table":"#__componentbuilder_library","component":"com_componentbuilder","entity":"library","value":"name","key":"guid"} |
| `alias` | text | VARCHAR(255) / "" | none | null |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config Layout](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Layout/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/layout.xml)
