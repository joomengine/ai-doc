# file_system serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/File/Remote/Config.php). Read the [package protocol](../specification.md) before editing. The [machine reference](file_system.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `key` (asset_key). Index: `index/file_folder.json`. Raw payload: `src/file_folder/<key>` (no item.json). The three fields below come from the virtual Remote Config map, not a database table or repository JSON record. See [file/folder transport](../specification.md#files-and-folders).

There is no Table definition, form or SQL storage/default for this virtual entity. File/Folder Config supplies an explicit map; these fields describe transport values, while the indexed payload is a raw file or ZIP archive.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `key` | null | virtual / null | none | null |
| `value` | null | virtual / null | none | null |
| `target` | null | virtual / null | none | null |

The explicit File/Folder map bypasses the database Table field projection.

- [Remote Config File](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/File/Remote/Config.php)
- [Remote Config Folder](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Folder/Remote/Config.php)
