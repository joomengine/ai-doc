# library serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](library.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/library.json`. Record: `src/library/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `name` | text | VARCHAR(255) / "" | none | null |
| `target` | radio | TINYINT(1) / "1" | none | null |
| `how` | filebehaviour | TINYINT(1) / "1" | none | {"type":2,"table":"","component":"","entity":"","value":"","key":""} |
| `type` | radio | TINYINT(1) / "0" | none | null |
| `description` | text | VARCHAR(255) / "" | none | null |
| `libraries` | librariesx | TEXT / "EMPTY" | json | {"type":1,"table":"#__componentbuilder_library","component":"com_componentbuilder","entity":"library","value":"name","key":"guid"} |
| `php_setdocument` | textarea | MEDIUMTEXT / "EMPTY" | base64 | null |
| `addconditions` | subform | MEDIUMTEXT / "EMPTY" | json | {"file":{"name":"file","type":"libraryfiles","link":{"type":2,"table":"","component":"","entity":"","value":"","key":""}},"target_behavior":{"name":"target_behavior","type":"list","link":null},"target_relation":{"name":"target_relation","type":"list","link":null},"option_field":{"name":"option_field","type":"libconfigfield","link":{"type":1,"table":"#__componentbuilder_field","component":"com_componentbuilder","entity":"field","value":"name","key":"guid"}},"option_behaviour":{"name":"option_behaviour","type":"list","link":null},"field_options":{"name":"field_options","type":"textarea","link":null}} |
| `guid` | text | VARCHAR(36) / "" | none | null |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config Library](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Library/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/library.xml)
