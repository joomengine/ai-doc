# field serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](field.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `guid` (guid). Index: `index/field.json`. Record: `src/field/<identity>/item.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `name` | text | VARCHAR(255) / "" | none | null |
| `fieldtype` | fieldtypes | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_fieldtype","component":"com_componentbuilder","entity":"fieldtype","value":"name","key":"guid"} |
| `datatype` | list | CHAR(64) / "" | none | null |
| `indexes` | list | CHAR(64) / "" | none | null |
| `null_switch` | radio | CHAR(64) / "" | none | null |
| `store` | list | INT(11) / "0" | none | null |
| `on_get_model_field` | textarea | TEXT / "EMPTY" | base64 | null |
| `on_save_model_field` | textarea | TEXT / "EMPTY" | base64 | null |
| `initiator_on_get_model` | textarea | TEXT / "EMPTY" | base64 | null |
| `xml` | hidden | TEXT / "EMPTY" | json | null |
| `datalenght` | list | CHAR(64) / "" | none | null |
| `javascript_view_footer` | editor | TEXT / "EMPTY" | base64 | null |
| `css_views` | editor | TEXT / "EMPTY" | base64 | null |
| `css_view` | editor | TEXT / "EMPTY" | base64 | null |
| `datadefault_other` | text | CHAR(64) / "" | none | null |
| `datadefault` | list | CHAR(64) / "" | none | null |
| `datalenght_other` | text | CHAR(64) / "" | none | null |
| `javascript_views_footer` | editor | TEXT / "EMPTY" | base64 | null |
| `add_css_view` | radio | TINYINT(1) / "0" | none | null |
| `add_css_views` | radio | TINYINT(1) / "0" | none | null |
| `add_javascript_view_footer` | radio | TINYINT(1) / "0" | none | null |
| `add_javascript_views_footer` | radio | TINYINT(1) / "0" | none | null |
| `initiator_on_save_model` | textarea | TEXT / "EMPTY" | base64 | null |
| `guid` | text | VARCHAR(36) / "" | none | null |

Ignored fields: `access`, `catid`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config Field](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Field/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/field.xml)
