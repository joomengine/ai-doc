# component_custom_admin_menus serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](component_custom_admin_menus.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `joomla_component` (parent_guid). Index: `index/component-custom-admin-menus.json`. Record: `src/joomla_component/children/<identity>/component-custom-admin-menus.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `joomla_component` | joomlacomponents | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_joomla_component","component":"com_componentbuilder","entity":"joomla_component","value":"system_name","key":"guid"} |
| `addcustommenus` | subform | TEXT / "EMPTY" | json | {"name":{"name":"name","type":"text","link":null},"name_code":{"name":"name_code","type":"text","link":null},"link":{"name":"link","type":"text","link":null},"icon":{"name":"icon","type":"filelist","link":null},"mainmenu":{"name":"mainmenu","type":"checkbox","link":null},"dashboard_list":{"name":"dashboard_list","type":"checkbox","link":null},"submenu":{"name":"submenu","type":"checkbox","link":null},"before":{"name":"before","type":"componentadminmenus","link":{"type":1,"table":"#__componentbuilder_admin_view","component":"com_componentbuilder","entity":"admin_view","value":"system_name","key":"guid"}}} |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config ComponentCustomAdminMenus](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/ComponentCustomAdminMenus/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/component_custom_admin_menus.xml)
