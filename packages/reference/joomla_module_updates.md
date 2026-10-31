# joomla_module_updates serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](joomla_module_updates.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `joomla_module` (parent_guid). Index: `index/joomla-module-updates.json`. Record: `src/joomla_module/children/<identity>/joomla-module-updates.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `joomla_module` | joomlamodules | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_joomla_module","component":"com_componentbuilder","entity":"joomla_module","value":"system_name","key":"guid"} |
| `version_update` | subform | MEDIUMTEXT / "EMPTY" | json | {"version":{"name":"version","type":"text","link":null},"mysql":{"name":"mysql","type":"textarea","link":null},"url":{"name":"url","type":"url","link":null}} |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config JoomlaModuleUpdates](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/JoomlaModuleUpdates/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/joomla_module_updates.xml)
