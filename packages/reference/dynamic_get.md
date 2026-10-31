# dynamic_get serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](dynamic_get.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/dynamic-get.json`. Record: `src/dynamic_get/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `name` | text | VARCHAR(255) / "" | none | null |
| `main_source` | list | TINYINT(1) / "0" | none | null |
| `gettype` | list | TINYINT(1) / "0" | none | null |
| `php_calculation` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_router_parse` | textarea | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_php_after_getitems` | radio | TINYINT(1) / "0" | none | null |
| `add_php_router_parse` | radio | TINYINT(1) / "0" | none | null |
| `view_selection` | textarea | TEXT / "EMPTY" | none | null |
| `add_php_before_getitems` | radio | TINYINT(1) / "0" | none | null |
| `add_php_before_getitem` | radio | TINYINT(1) / "0" | none | null |
| `add_php_after_getitem` | radio | TINYINT(1) / "0" | none | null |
| `db_table_main` | dbtables | VARCHAR(255) / "" | none | {"type":2,"table":"","component":"","entity":"","value":"","key":""} |
| `php_custom_get` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `plugin_events` | list | VARCHAR(255) / "" | json | null |
| `db_selection` | textarea | TEXT / "EMPTY" | none | null |
| `view_table_main` | ModalSelect | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_admin_view","component":"com_componentbuilder","entity":"admin_view","value":"system_name","key":"guid"} |
| `add_php_getlistquery` | radio | TINYINT(1) / "0" | none | null |
| `join_db_table` | subform | TEXT / "EMPTY" | json | {"db_table":{"name":"db_table","type":"dbtables","link":{"type":2,"table":"","component":"","entity":"","value":"","key":""}},"row_type":{"name":"row_type","type":"list","link":null},"as":{"name":"as","type":"list","link":null},"type":{"name":"type","type":"list","link":null},"on_field":{"name":"on_field","type":"text","link":null},"operator":{"name":"operator","type":"list","link":null},"join_field":{"name":"join_field","type":"text","link":null},"selection":{"name":"selection","type":"textarea","link":null}} |
| `select_all` | radio | TINYINT(1) / "0" | none | null |
| `php_before_getitem` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `getcustom` | text | VARCHAR(255) / "" | none | null |
| `php_after_getitem` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `pagination` | radio | TINYINT(1) / "1" | none | null |
| `php_getlistquery` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_before_getitems` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `filter` | subform | TEXT / "EMPTY" | json | {"filter_type":{"name":"filter_type","type":"list","link":null},"state_key":{"name":"state_key","type":"text","link":null},"operator":{"name":"operator","type":"list","link":null},"table_key":{"name":"table_key","type":"text","link":null},"empty":{"name":"empty","type":"checkbox","link":null}} |
| `php_after_getitems` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `where` | subform | TEXT / "EMPTY" | json | {"table_key":{"name":"table_key","type":"text","link":null},"operator":{"name":"operator","type":"list","link":null},"value_key":{"name":"value_key","type":"text","link":null}} |
| `order` | subform | TEXT / "EMPTY" | json | {"table_key":{"name":"table_key","type":"text","link":null},"direction":{"name":"direction","type":"list","link":null}} |
| `addcalculation` | radio | TINYINT(1) / "0" | none | null |
| `group` | subform | TEXT / "EMPTY" | json | {"table_key":{"name":"table_key","type":"text","link":null}} |
| `global` | subform | TEXT / "EMPTY" | json | {"name":{"name":"name","type":"text","link":null},"key":{"name":"key","type":"text","link":null},"as":{"name":"as","type":"list","link":null},"type":{"name":"type","type":"radio","link":null}} |
| `guid` | text | VARCHAR(36) / "" | none | null |
| `join_view_table` | subform | TEXT / "EMPTY" | json | {"view_table":{"name":"view_table","type":"ModalSelect","link":{"type":1,"table":"#__componentbuilder_admin_view","component":"com_componentbuilder","entity":"admin_view","value":"system_name","key":"guid"}},"row_type":{"name":"row_type","type":"list","link":null},"as":{"name":"as","type":"list","link":null},"type":{"name":"type","type":"list","link":null},"on_field":{"name":"on_field","type":"text","link":null},"operator":{"name":"operator","type":"list","link":null},"join_field":{"name":"join_field","type":"text","link":null},"selection":{"name":"selection","type":"textarea","link":null}} |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config DynamicGet](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/DynamicGet/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/dynamic_get.xml)
