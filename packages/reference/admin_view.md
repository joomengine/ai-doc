# admin_view serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](admin_view.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/admin-view.json`. Record: `src/admin_view/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `system_name` | text | VARCHAR(255) / "" | none | null |
| `name_single` | text | CHAR(64) / "" | none | null |
| `short_description` | text | VARCHAR(255) / "" | none | null |
| `php_postsavehook` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_before_save` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_getlistquery` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_getitems` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `ajax_input` | subform | TEXT / "EMPTY" | json | {"value_name":{"name":"value_name","type":"text","link":null},"task_name":{"name":"task_name","type":"text","link":null},"input_default":{"name":"input_default","type":"text","link":null},"input_filter":{"name":"input_filter","type":"list","link":null},"method_name":{"name":"method_name","type":"text","link":null},"allow_zero":{"name":"allow_zero","type":"checkbox","link":null},"user_check":{"name":"user_check","type":"checkbox","link":null}} |
| `source` | radio | TINYINT(1) / "0" | none | null |
| `icon` | media | VARCHAR(255) / "" | none | null |
| `php_batchmove` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_fadein` | radio | TINYINT(1) / "0" | none | null |
| `description` | textarea | TEXT / "EMPTY" | none | null |
| `icon_category` | media | VARCHAR(255) / "" | none | null |
| `icon_add` | media | VARCHAR(255) / "" | none | null |
| `php_allowedit` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_after_delete` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_after_cancel` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `type` | list | INT(11) / "0" | none | null |
| `php_after_publish` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `mysql_table_charset` | list | VARCHAR(64) / "1" | none | null |
| `name_list` | text | CHAR(64) / "" | none | null |
| `addpermissions` | subform | TEXT / "EMPTY" | json | {"action":{"name":"action","type":"list","link":null},"implementation":{"name":"implementation","type":"list","link":null}} |
| `php_getitem` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_getitems_after_all` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `addtabs` | subform | TEXT / "EMPTY" | json | {"name":{"name":"name","type":"text","link":null}} |
| `php_getform` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_save` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_allowadd` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `addlinked_views` | subform | TEXT / "EMPTY" | json | {"adminview":{"name":"adminview","type":"ModalSelect","link":{"type":1,"table":"#__componentbuilder_admin_view","component":"com_componentbuilder","entity":"admin_view","value":"system_name","key":"guid"}},"tab":{"name":"tab","type":"integer","link":null},"key":{"name":"key","type":"text","link":null},"parentkey":{"name":"parentkey","type":"text","link":null},"addnew":{"name":"addnew","type":"list","link":null}} |
| `php_before_cancel` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_batchcopy` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `alias_builder_type` | radio | TINYINT(1) / "0" | none | null |
| `php_before_publish` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_before_delete` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_document` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `alias_builder` | aliasbuilder | VARCHAR(255) / "" | json | {"type":1,"table":"#__componentbuilder_field","component":"com_componentbuilder","entity":"field","value":"name","key":"id"} |
| `mysql_table_row_format` | list | VARCHAR(64) / "0" | none | null |
| `sql` | textarea | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_category_submenu` | radio | TINYINT(1) / "1" | none | null |
| `php_ajaxmethod` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_php_getitem` | radio | TINYINT(1) / "0" | none | null |
| `add_php_getitems` | radio | TINYINT(1) / "0" | none | null |
| `add_css_view` | radio | TINYINT(1) / "0" | none | null |
| `add_php_getitems_after_all` | radio | TINYINT(1) / "0" | none | null |
| `css_view` | editor | TEXT / "EMPTY" | base64 | null |
| `add_php_getlistquery` | radio | TINYINT(1) / "0" | none | null |
| `add_css_views` | radio | TINYINT(1) / "0" | none | null |
| `add_php_getform` | radio | TINYINT(1) / "0" | none | null |
| `css_views` | editor | TEXT / "EMPTY" | base64 | null |
| `add_php_before_save` | radio | TINYINT(1) / "0" | none | null |
| `add_javascript_view_file` | radio | TINYINT(1) / "0" | none | null |
| `add_php_save` | radio | TINYINT(1) / "0" | none | null |
| `javascript_view_file` | editor | TEXT / "EMPTY" | base64 | null |
| `add_php_postsavehook` | radio | TINYINT(1) / "0" | none | null |
| `add_javascript_view_footer` | radio | TINYINT(1) / "0" | none | null |
| `add_php_allowadd` | radio | TINYINT(1) / "0" | none | null |
| `javascript_view_footer` | editor | TEXT / "EMPTY" | base64 | null |
| `add_php_allowedit` | radio | TINYINT(1) / "0" | none | null |
| `add_javascript_views_file` | radio | TINYINT(1) / "0" | none | null |
| `add_php_before_cancel` | radio | TINYINT(1) / "0" | none | null |
| `javascript_views_file` | editor | TEXT / "EMPTY" | base64 | null |
| `add_php_after_cancel` | radio | TINYINT(1) / "0" | none | null |
| `add_javascript_views_footer` | radio | TINYINT(1) / "0" | none | null |
| `add_php_batchcopy` | radio | TINYINT(1) / "0" | none | null |
| `javascript_views_footer` | editor | TEXT / "EMPTY" | base64 | null |
| `add_php_batchmove` | radio | TINYINT(1) / "0" | none | null |
| `add_custom_button` | radio | INT(1) / "0" | none | null |
| `add_php_before_publish` | radio | TINYINT(1) / "0" | none | null |
| `custom_button` | subform | TEXT / "EMPTY" | json | {"icomoon":{"name":"icomoon","type":"list","link":null},"name":{"name":"name","type":"text","link":null},"method":{"name":"method","type":"text","link":null},"target":{"name":"target","type":"list","link":null},"type":{"name":"type","type":"list","link":null}} |
| `add_php_after_publish` | radio | TINYINT(1) / "0" | none | null |
| `php_controller` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_php_before_delete` | radio | TINYINT(1) / "0" | none | null |
| `php_model` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_php_after_delete` | radio | TINYINT(1) / "0" | none | null |
| `php_controller_list` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_php_document` | radio | TINYINT(1) / "0" | none | null |
| `php_model_list` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `mysql_table_engine` | list | VARCHAR(64) / "1" | none | null |
| `add_view_toolbar` | radio | TINYINT(1) / "0" | none | null |
| `mysql_table_collate` | list | VARCHAR(64) / "1" | none | null |
| `view_toolbar` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_sql` | radio | TINYINT(1) / "0" | none | null |
| `add_views_toolbar` | radio | TINYINT(1) / "0" | none | null |
| `views_toolbar` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `guid` | text | VARCHAR(36) / "" | none | null |
| `add_php_ajax` | radio | TINYINT(1) / "0" | none | null |

Ignored fields: `access`, `addtables`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config AdminView](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/AdminView/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/admin_view.xml)
