# library_files_folders_urls serialized field contract

Generated from the pinned [JCB source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php). Read the [package protocol](../specification.md) before editing. The [machine reference](library_files_folders_urls.json) retains every Table property, nested field, form attribute and option; this page is its compact index.

Upstream metadata: Copyright (C) 2015 Vast Development Method. All rights reserved. [GPL-2.0-or-later](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/LICENSE.txt). Extraction does not relicense the upstream material.

Identity: `library` (parent_guid). Index: `index/library-files-folders-urls.json`. Record: `src/library/children/<identity>/library-files-folders-urls.json`.

Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.

| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |
| --- | --- | --- | --- | --- |
| `library` | libraryreadonly | VARCHAR(36) / "" | none | {"type":1,"table":"#__componentbuilder_library","component":"com_componentbuilder","entity":"library","value":"name","key":"guid"} |
| `addfoldersfullpath` | subform | TEXT / "EMPTY" | json | {"folderpath":{"name":"folderpath","type":"text","link":null},"path":{"name":"path","type":"text","link":null},"rename":{"name":"rename","type":"checkbox","link":null}} |
| `addfilesfullpath` | subform | TEXT / "EMPTY" | json | {"filepath":{"name":"filepath","type":"text","link":null},"path":{"name":"path","type":"text","link":null},"notnew":{"name":"notnew","type":"checkbox","link":null}} |
| `addfolders` | subform | TEXT / "EMPTY" | json | {"folder":{"name":"folder","type":"customfolderlist","link":{"type":2,"table":"","component":"","entity":"","value":"","key":""}},"path":{"name":"path","type":"text","link":null},"rename":{"name":"rename","type":"checkbox","link":null}} |
| `addfiles` | subform | TEXT / "EMPTY" | json | {"file":{"name":"file","type":"customfilelist","link":{"type":2,"table":"","component":"","entity":"","value":"","key":""}},"path":{"name":"path","type":"text","link":null},"notnew":{"name":"notnew","type":"checkbox","link":null}} |
| `addurls` | subform | TEXT / "EMPTY" | json | {"url":{"name":"url","type":"url","link":null},"type":{"name":"type","type":"list","link":null}} |

Ignored fields: `access`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.

- [Remote Config LibraryFilesFoldersUrls](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/LibraryFilesFoldersUrls/Remote/Config.php)
- [Form XML](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/library_files_folders_urls.xml)
