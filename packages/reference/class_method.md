# class_method serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](class_method.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/class-method.json`. Record: `src/class_method/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `name` | text | VARCHAR(255) / "" | none | null |
| `visibility` | list | VARCHAR(255) / "" | none | null |
| `extension_type` | list | VARCHAR(64) / "" | none | null |
| `guid` | text | VARCHAR(36) / "" | none | null |
| `code` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `comment` | textarea | TEXT / "EMPTY" | base64 | null |
| `joomla_plugin_group` | ModalSelect | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_joomla_plugin_group","component":"com_componentbuilder","entity":"joomla_plugin_group","value":"name","key":"guid"} |
| `arguments` | text | TEXT / "EMPTY" | base64 | null |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config ClassMethod](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/ClassMethod/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/class_method.xml)
