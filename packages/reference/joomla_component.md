# joomla_component serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](joomla_component.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/joomla-component.json`. Record: `src/joomla_component/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `system_name` | text | VARCHAR(255) / "" | none | null |
| `name_code` | text | VARCHAR(255) / "" | none | null |
| `short_description` | text | VARCHAR(255) / "" | none | null |
| `companyname` | text | CHAR(64) / "" | none | null |
| `buildcompsql` | textarea | MEDIUMTEXT / "EMPTY" | base64 | null |
| `jcb_powers_path` | text | VARCHAR(255) / "" | none | null |
| `add_update_server` | radio | TINYINT(1) / "0" | none | null |
| `add_sql` | radio | TINYINT(1) / "0" | none | null |
| `add_php_postflight_install` | radio | TINYINT(1) / "0" | none | null |
| `mvc_versiondate` | list | TINYINT(1) / "0" | none | null |
| `remove_line_breaks` | radio | TINYINT(1) / "1" | none | null |
| `add_placeholders` | radio | TINYINT(1) / "0" | none | null |
| `debug_linenr` | radio | TINYINT(1) / "0" | none | null |
| `add_php_preflight_install` | radio | TINYINT(1) / "0" | none | null |
| `description` | textarea | TEXT / "EMPTY" | none | null |
| `add_php_method_uninstall` | radio | TINYINT(1) / "0" | none | null |
| `author` | text | VARCHAR(255) / "" | none | null |
| `assets_table_fix` | list | TINYINT(1) / "3" | none | null |
| `email` | text | VARCHAR(255) / "" | none | null |
| `website` | url | CHAR(255) / "" | none | null |
| `add_git_folder_path` | radio | CHAR(1) / "" | none | null |
| `license` | textarea | VARCHAR(255) / "" | none | null |
| `add_css_admin` | radio | TINYINT(1) / "0" | none | null |
| `dashboard_type` | radio | TINYINT(1) / "1" | none | null |
| `bom` | filelist | CHAR(64) / "" | none | null |
| `component_version` | text | CHAR(64) / "" | none | null |
| `add_css_site` | radio | TINYINT(1) / "0" | none | null |
| `image` | media | VARCHAR(255) / "" | none | null |
| `dashboard` | dynamicdashboard | VARCHAR(64) / "" | none | {"type":1,"table":"#__componentbuilder_custom_admin_view","component":"com_componentbuilder","entity":"custom_admin_view","value":"system_name","key":""} |
| `copyright` | textarea | VARCHAR(255) / "" | none | null |
| `add_php_preflight_update` | radio | TINYINT(1) / "0" | none | null |
| `preferred_joomla_version` | number | INT(11) / "3" | none | null |
| `add_php_postflight_update` | radio | TINYINT(1) / "0" | none | null |
| `add_powers` | radio | TINYINT(1) / "1" | none | null |
| `add_php_method_install` | radio | TINYINT(1) / "0" | none | null |
| `add_sql_uninstall` | radio | TINYINT(1) / "0" | none | null |
| `readme` | editor | TEXT / "EMPTY" | base64 | null |
| `update_server_target` | radio | TINYINT(1) / "0" | none | null |
| `git_folder_path` | text | VARCHAR(255) / "" | none | null |
| `changelog_server_url` | url | VARCHAR(255) / "" | none | null |
| `add_namespace_prefix` | radio | CHAR(1) / "" | none | null |
| `namespace_prefix` | text | VARCHAR(255) / "" | none | null |
| `javascript` | editor | TEXT / "EMPTY" | base64 | null |
| `css_admin` | editor | TEXT / "EMPTY" | base64 | null |
| `add_menu_prefix` | radio | CHAR(1) / "" | none | null |
| `css_site` | editor | TEXT / "EMPTY" | base64 | null |
| `menu_prefix` | text | VARCHAR(100) / "" | none | null |
| `php_preflight_install` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `toignore` | text | TEXT / "EMPTY" | none | null |
| `php_preflight_update` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_postflight_install` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `php_postflight_update` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `addcontributors` | subform | TEXT / "EMPTY" | json | {"name":{"name":"name","type":"text","link":null},"title":{"name":"title","type":"text","link":null},"email":{"name":"email","type":"text","link":null},"website":{"name":"website","type":"url","link":null},"use":{"name":"use","type":"list","link":null},"show":{"name":"show","type":"list","link":null}} |
| `php_method_uninstall` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `emptycontributors` | radio | TINYINT(1) / "0" | none | null |
| `php_method_install` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `number` | number | INT(11) / "0" | none | null |
| `sql` | textarea | MEDIUMTEXT / "EMPTY" | base64 | null |
| `sql_uninstall` | textarea | MEDIUMTEXT / "EMPTY" | base64 | null |
| `addreadme` | radio | TINYINT(1) / "0" | none | null |
| `update_server_url` | url | VARCHAR(255) / "" | none | null |
| `creatuserhelper` | radio | TINYINT(1) / "0" | none | null |
| `adduikit` | list | TINYINT(1) / "0" | none | null |
| `add_backup_folder_path` | radio | CHAR(1) / "" | none | null |
| `addfootable` | list | TINYINT(1) / "0" | none | null |
| `backup_folder_path` | text | VARCHAR(255) / "" | none | null |
| `add_email_helper` | radio | TINYINT(1) / "0" | none | null |
| `add_php_helper_both` | radio | TINYINT(1) / "0" | none | null |
| `add_jcb_powers_path` | radio | CHAR(1) / "" | none | null |
| `php_helper_both` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_changelog_server` | radio | TINYINT(1) / "0" | none | null |
| `add_php_helper_admin` | radio | TINYINT(1) / "0" | none | null |
| `changelog_server_target` | radio | TINYINT(1) / "0" | none | null |
| `php_helper_admin` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_admin_event` | radio | TINYINT(1) / "0" | none | null |
| `changelog_server` | servers | INT(11) / "0" | none | {"type":1,"table":"#__componentbuilder_server","component":"com_componentbuilder","entity":"server","value":"name","key":"id"} |
| `php_admin_event` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_php_helper_site` | radio | TINYINT(1) / "0" | none | null |
| `php_helper_site` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `add_site_event` | radio | TINYINT(1) / "0" | none | null |
| `buildcomp` | radio | TINYINT(1) / "0" | none | null |
| `php_site_event` | editor | MEDIUMTEXT / "EMPTY" | base64 | null |
| `guid` | text | VARCHAR(36) / "" | none | null |
| `add_javascript` | radio | TINYINT(1) / "0" | none | null |
| `name` | text | CHAR(64) / "" | none | null |
| `metakey` | textarea | TEXT / null | none | null |
| `metadesc` | textarea | TEXT / null | none | null |
| `metadata` | null | TEXT / null | json | null |

Ignored fields: `access`, `export_key`, `joomla_source_link`, `export_buy_link`, `update_server`, `add_sales_server`, `sales_server`, `translation_tool`, `crowdin_project_identifier`, `crowdin_project_api_key`, `crowdin_username`, `crowdin_account_api_key`, `created`, `modified`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config Component](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Component/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/joomla_component.xml)
