# custom_admin_view serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](custom_admin_view.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/custom-admin-view.json`. Record: `src/custom_admin_view/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `system_name` | text | VARCHAR(255) / "" | none | null |
| `name` | text | VARCHAR(255) / "" | none | null |
| `description` | text | VARCHAR(255) / "" | none | null |
| `main_get` | ModalSelect | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_dynamic_get","component":"com_componentbuilder","entity":"dynamic_get","value":"name","key":"guid"} |
| `add_php_view` | radio | TINYINT(1) / "0" | none | null |
| `javascript_file` | editor | TEXT / "EMPTY" | base64 | null |
| `css_document` | editor | TEXT / "EMPTY" | base64 | null |
| `view_toolbar` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `js_document` | editor | TEXT / "EMPTY" | base64 | null |
| `default` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `snippet` | snippets | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_snippet","component":"com_componentbuilder","entity":"snippet","value":"name","key":"guid"} |
| `icon` | media | VARCHAR(255) / "" | none | null |
| `add_php_jview_display` | radio | TINYINT(1) / "0" | none | null |
| `context` | text | VARCHAR(255) / "" | none | null |
| `add_php_jview` | radio | TINYINT(1) / "0" | none | null |
| `codename` | text | VARCHAR(255) / "" | none | null |
| `custom_get` | customgets | TEXT / "EMPTY" | json | {"type":1,"table":"#__componentbuilder_dynamic_get","component":"com_componentbuilder","entity":"dynamic_get","value":"name","key":"guid"} |
| `add_js_document` | radio | TINYINT(1) / "0" | none | null |
| `css` | editor | TEXT / "EMPTY" | base64 | null |
| `add_javascript_file` | radio | TINYINT(1) / "0" | none | null |
| `php_ajaxmethod` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_css_document` | radio | TINYINT(1) / "0" | none | null |
| `add_php_document` | radio | TINYINT(1) / "0" | none | null |
| `add_css` | radio | TINYINT(1) / "0" | none | null |
| `libraries` | libraries | TEXT / "EMPTY" | json | {"type":1,"table":"#__componentbuilder_library","component":"com_componentbuilder","entity":"library","value":"name","key":"guid"} |
| `add_php_ajax` | radio | TINYINT(1) / "0" | none | null |
| `dynamic_get` | dynamicgets | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_dynamic_get","component":"com_componentbuilder","entity":"dynamic_get","value":"name","key":"guid"} |
| `ajax_input` | subform | TEXT / "EMPTY" | json | {"value_name":{"name":"value_name","type":"text","link":null},"task_name":{"name":"task_name","type":"text","link":null},"input_default":{"name":"input_default","type":"text","link":null},"input_filter":{"name":"input_filter","type":"list","link":null},"method_name":{"name":"method_name","type":"text","link":null},"allow_zero":{"name":"allow_zero","type":"checkbox","link":null},"user_check":{"name":"user_check","type":"checkbox","link":null}} |
| `php_document` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_custom_button` | radio | INT(1) / "0" | none | null |
| `php_view` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `custom_button` | subform | TEXT / "EMPTY" | json | {"icomoon":{"name":"icomoon","type":"list","link":null},"name":{"name":"name","type":"text","link":null},"method":{"name":"method","type":"text","link":null},"target":{"name":"target","type":"list","link":null},"type":{"name":"type","type":"list","link":null}} |
| `php_jview_display` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_controller` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_jview` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_model` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `guid` | text | VARCHAR(36) / "" | none | null |
| `add_view_toolbar` | radio | TINYINT(1) / "0" | none | null |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config CustomAdminView](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/CustomAdminView/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/custom_admin_view.xml)
