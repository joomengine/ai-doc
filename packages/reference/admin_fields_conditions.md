# admin_fields_conditions serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](admin_fields_conditions.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `admin_view` (parent_guid). Index: `index/admin-fields-conditions.json`. Record: `src/admin_view/children/<identity>/admin-fields-conditions.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `admin_view` | adminviewsreadonly | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_admin_view","component":"com_componentbuilder","entity":"admin_view","value":"system_name","key":"guid"} |
| `addconditions` | subform | MEDIUMTEXT / "EMPTY" | json | {"target_field":{"name":"target_field","type":"targetfields","link":{"type":1,"table":"#__componentbuilder_field","component":"com_componentbuilder","entity":"field","value":"name","key":"guid"}},"target_behavior":{"name":"target_behavior","type":"list","link":null},"target_relation":{"name":"target_relation","type":"list","link":null},"match_field":{"name":"match_field","type":"matchfield","link":{"type":1,"table":"#__componentbuilder_field","component":"com_componentbuilder","entity":"field","value":"name","key":"guid"}},"match_behavior":{"name":"match_behavior","type":"list","link":null},"match_options":{"name":"match_options","type":"textarea","link":null}} |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config AdminFieldsConditions](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/AdminFieldsConditions/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/admin_fields_conditions.xml)
