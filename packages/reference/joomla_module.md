# joomla_module serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](joomla_module.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/joomla-module.json`. Record: `src/joomla_module/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `system_name` | text | VARCHAR(255) / "" | none | null |
| `target` | radio | TINYINT(1) / "0" | none | null |
| `description` | textarea | TEXT / "EMPTY" | none | null |
| `add_php_postflight_install` | radio | TINYINT(1) / "0" | none | null |
| `add_php_preflight_uninstall` | radio | TINYINT(1) / "0" | none | null |
| `add_php_preflight_update` | radio | TINYINT(1) / "0" | none | null |
| `update_server_target` | radio | TINYINT(1) / "0" | none | null |
| `addreadme` | radio | TINYINT(1) / "0" | none | null |
| `add_sql` | radio | TINYINT(1) / "0" | none | null |
| `default` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `default_header` | editor | TEXT / "EMPTY" | base64 | null |
| `snippet` | snippets | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_snippet","component":"com_componentbuilder","entity":"snippet","value":"name","key":"guid"} |
| `add_default_header` | radio | TINYINT(1) / "0" | none | null |
| `add_php_postflight_update` | radio | TINYINT(1) / "0" | none | null |
| `add_php_method_uninstall` | radio | TINYINT(1) / "0" | none | null |
| `add_sql_uninstall` | radio | TINYINT(1) / "0" | none | null |
| `add_update_server` | radio | TINYINT(1) / "0" | none | null |
| `libraries` | libraries | TEXT / "EMPTY" | json | {"type":1,"table":"#__componentbuilder_library","component":"com_componentbuilder","entity":"library","value":"name","key":"guid"} |
| `module_version` | text | CHAR(64) / "" | none | null |
| `php_preflight_install` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_preflight_update` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `layout_data` | editor | TEXT / "EMPTY" | base64 | null |
| `php_preflight_uninstall` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `custom_get` | customgets | TEXT / "EMPTY" | json | {"type":1,"table":"#__componentbuilder_dynamic_get","component":"com_componentbuilder","entity":"dynamic_get","value":"name","key":"guid"} |
| `php_postflight_install` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_postflight_update` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `mod_code` | editor | TEXT / "EMPTY" | base64 | null |
| `php_method_uninstall` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_class_helper` | list | TINYINT(1) / "0" | none | null |
| `sql` | textarea | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_class_helper_header` | radio | TINYINT(1) / "0" | none | null |
| `sql_uninstall` | textarea | MEDIUMTEXT / "EMPTY" | base64 | null |
| `class_helper_header` | editor | TEXT / "EMPTY" | base64 | null |
| `readme` | editor | TEXT / "EMPTY" | base64 | null |
| `class_helper_code` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `update_server_url` | url | VARCHAR(255) / "" | none | null |
| `fields` | subform | TEXT / "EMPTY" | json | {"module":{"name":"module","type":"checkbox","link":null},"file":{"name":"file","type":"text","link":null},"fields_name":{"name":"fields_name","type":"text","link":null},"fieldset":{"name":"fieldset","type":"text","link":null},"label":{"name":"label","type":"text","link":null},"fields_rules_paths":{"name":"fields_rules_paths","type":"list","link":null},"addrulepath":{"name":"addrulepath","type":"subform","link":null,"fields":{"path":{"name":"path","type":"text","link":null}}},"addfieldpath":{"name":"addfieldpath","type":"subform","link":null,"fields":{"path":{"name":"path","type":"text","link":null}}},"fields":{"name":"fields","type":"subform","link":null,"fields":{"field":{"name":"field","type":"ModalSelect","link":{"type":1,"table":"#__componentbuilder_field","component":"com_componentbuilder","entity":"field","value":"name","key":"guid"}},"custom_value":{"name":"custom_value","type":"textarea","link":null}}}} |
| `add_php_script_construct` | radio | TINYINT(1) / "0" | none | null |
| `php_script_construct` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_php_preflight_install` | radio | TINYINT(1) / "0" | none | null |
| `guid` | text | VARCHAR(36) / "" | none | null |
| `name` | text | VARCHAR(255) / "" | none | null |

Ignored fields: `access`, `update_server`, `add_sales_server`, `sales_server`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config JoomlaModule](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/JoomlaModule/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/joomla_module.xml)
