# admin_fields serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](admin_fields.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `admin_view` (parent_guid). Index: `index/admin-fields.json`. Record: `src/admin_view/children/<identity>/admin-fields.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `admin_view` | adminviewsreadonly | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_admin_view","component":"com_componentbuilder","entity":"admin_view","value":"system_name","key":"guid"} |
| `addfields` | subform | MEDIUMTEXT / "EMPTY" | json | {"field":{"name":"field","type":"ModalSelect","link":{"type":1,"table":"#__componentbuilder_field","component":"com_componentbuilder","entity":"field","value":"name","key":"guid"}},"list":{"name":"list","type":"list","link":null},"order_list":{"name":"order_list","type":"integer","link":null},"title":{"name":"title","type":"checkbox","link":null},"alias":{"name":"alias","type":"checkbox","link":null},"sort":{"name":"sort","type":"checkbox","link":null},"search":{"name":"search","type":"checkbox","link":null},"filter":{"name":"filter","type":"list","link":null},"link":{"name":"link","type":"checkbox","link":null},"tab":{"name":"tab","type":"viewtabs","link":{"type":1,"table":"#__componentbuilder_admin_view","component":"com_componentbuilder","entity":"admin_view","value":"addtabs","key":"id"}},"alignment":{"name":"alignment","type":"list","link":null},"order_edit":{"name":"order_edit","type":"integer","link":null},"permission":{"name":"permission","type":"list","link":null}} |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config AdminFields](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/AdminFields/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/admin_fields.xml)
