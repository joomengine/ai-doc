# custom_code serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](custom_code.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `function_name` (natural_key). Index: `index/custom-code.json`. Record: `src/custom_code/<identity>/item.json`.

Automated target=1 has a path-derived index GUID while the outer index bucket remains function_name; follow the [identity exception](../specification.md#typed-identities-and-supported-families), not the ordinary record-path shorthand.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `system_name` | text | VARCHAR(255) / "" | none | null |
| `path` | text | TEXT / "EMPTY" | none | null |
| `target` | radio | TINYINT(1) / "0" | none | null |
| `type` | radio | TINYINT(1) / "0" | none | null |
| `comment_type` | radio | TINYINT(1) / "1" | none | null |
| `joomla_version` | number | INT(11) / "3" | none | null |
| `function_name` | text | VARCHAR(255) / "" | none | null |
| `code` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `hashendtarget` | text | VARCHAR(64) / "" | none | null |
| `to_line` | text | VARCHAR(100) / "" | none | null |
| `from_line` | text | VARCHAR(100) / "" | none | null |
| `hashtarget` | text | VARCHAR(64) / "" | none | null |
| `component` | joomlacomponent | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_joomla_component","component":"com_componentbuilder","entity":"joomla_component","value":"system_name","key":"guid"} |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config CustomCode](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/CustomCode/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/custom_code.xml)
