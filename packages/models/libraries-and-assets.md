# Package Libraries, files and folders

A [`library`](../reference/library.md) defines a reusable resource/load policy. Its [`library_config`](../reference/library_config.md) and [`library_files_folders_urls`](../reference/library_files_folders_urls.md) children are keyed by the Library GUID. A component can also attach assets directly through [`component_files_folders`](../reference/component_files_folders.md); modules/plugins have their own [asset children](extensions.md#installer-code-sql-updates-and-assets). The virtual [`file_system`](../reference/file_system.md) contract transports discovered file/folder content. These are separate layers: an asset attachment describes use, while a file/folder dependency carries bytes.

## Choose a Library's role and load policy

The Library form distinguishes `target=1` Media from `2` Libraries and `type=1` Main from `2` Bundle. The media Library selector used by presentation records filters published records to target `1`. Choose the appropriate actual consumer; putting PHP files under a Library record does not prove Composer installation, autoload registration or service wiring. Those requirements must be established by emitted code and the relevant [Power contract](../../super-powers/README.md) when applicable.

For Media Libraries, `how` selects `0` do not add, `1` always add, `2` conditionally add or `3` use custom document PHP. A built-in `4` option exists for selected local core Library IDs. The inspected `Library/Data` contains version-specific fallback handling for those built-ins: Joomla 6 converts that built-in path to normal loading, while older targets can use compiler-level UIkit/FooTable handling. Local numeric IDs are not portable identities; do not copy them into a new package or claim all targets use the same asset strategy.

The form exposes a Bundle's `libraries` collection, and the package metadata can identify its linked records. The inspected ordinary Library registration/data path does not itself demonstrate recursive runtime bundle expansion. Before relying on one Bundle selection to emit every member, trace the exact target's consumer or prove the generated/runtime result. Otherwise attach the required concrete Libraries explicitly. A serialized relationship is evidence of a package dependency, not automatically a resource-loader implementation.

Sources: [Library selector](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Field/LibrariesField.php), [Model/Libraries](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Libraries.php), [Library/Data](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Library/Data.php).

## Conditional loading and configuration

`library_config.addconfig` links reusable Fields, with a consumer-specific `custom_value` and tab name. The inspected Library consumer resolves configuration Fields for `how>1`; merely adding configuration rows does not prove they affect the always-load path. Test generated config and the actual runtime parameter names before writing conditions against them.

For `how=2`, `addconditions` rows combine a selected file, `target_behavior` (`1` include / `2` exclude), `target_relation` (`0` isolated / `1` chained), `option_field`, `option_behaviour` and `field_options`. The form's match choices distinguish list/text behaviours; use the enum and nested shape from the [Library machine reference](../reference/library.json), not invented boolean expressions. Exercise both branches, default values and chained conditions in the actual consuming view.

For `how=3`, `php_setdocument` owns the document-loading logic. Code must match the generated scope and target Joomla APIs, including dependency/order requirements. On Joomla 6 the inspected CSS/JavaScript include helper uses the Web Asset Manager and generated asset names. It is not proof that arbitrary file types receive a browser include or that every third-party script dependency is discovered. Inspect [JoomlaSix/IncludeHelper](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Library/JoomlaSix/IncludeHelper.php).

## Specify source, destination and content processing

| Collection | Meaning to keep separate |
| --- | --- |
| `addfiles` | Select a source file and generated destination `path`, with its `notnew` processing switch. |
| `addfolders` | Select a source folder and destination path, with a `rename` choice. |
| `addfilesfullpath` | Use a source `filepath` rather than the regular selector, still with its own destination and processing switch. |
| `addfoldersfullpath` | Use source `folderpath`, destination and rename choice. |
| `addurls` | For Library/module/plugin children, supply a URL and its loading/copy type; this collection is absent from the component files/folders contract. |

Source availability in the authoring JCB filesystem, repository asset storage and destination inside the generated/installed extension are different paths. A full path on one server is not portable merely because it is a string in JSON. Inspect normalization and dependency output; supply assets through the supported source mapping and verify restoration in a fresh environment.

The component settings consumer treats `rename=1` by using the final destination segment as the new folder name. It also treats `notnew=1` as the path that enables file-content updating; the other path records the file in the no-content-update registry. The historical flag name is easy to misread: choose from actual form/source behaviour and inspect whether placeholders/code processing changed the bytes. Never enable text processing blindly for binary assets. See [Model/Filesfolders](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Filesfolders.php) and [JoomlaSix component settings](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Component/JoomlaSix/Settings.php). Check the corresponding module/plugin consumer before assuming a component-specific destination rule applies unchanged.

URL type choices are `1` default link, `2` local get and `3` link/local dynamic. In the inspected Library structure builder, values greater than `1` trigger content retrieval into media output; type `1` keeps an external link. Verify resulting browser URLs and content, not just an HTTP-success message. A remote link depends on that host at runtime; a copied resource depends on successful build-time retrieval and reproducible source content. Record origin, version/license and any expected hash for external assets. [Library/Structure](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Library/Structure.php).

## File/folder transport is a virtual contract

`file_system` is not a database table with an ordinary `item.json`. File and Folder share `index/file_folder.json` and `src/file_folder`; their virtual mapping has `key`, `value` and `target`, with no normal settings filename. The resolver derives their identity from a normalized path; the key excludes file contents and target scope. Case/path normalization and distinct target roots can therefore produce collisions that must be checked rather than “fixed” by generating a random UUID.

The actual exporter reads a file's bytes or creates a ZIP for a folder. The importer restores file bytes or unzips the folder at the normalized destination. The operational queue also carries pointer/entity/full-path information; do not serialize that local queue wholesale as a package record. Follow the exact algorithm and index shape in [files and folders](../specification.md#files-and-folders) and the [virtual reference](../reference/file_system.md).

The inspected writer rejects missing source paths and empty content; a successful metadata export therefore cannot stand in for a confirmed content transfer. A pre-existing local asset can affect Init behaviour, and forced refresh has different consequences. Use the appropriate [Init/Pull/Reset workflow](../workflows/maintain.md), inspect the imported asset and record what was replaced. Sources: [SetContent](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Remote/SetContent.php), [GetContent](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Remote/GetContent.php), [SetFolder](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Remote/SetFolder.php), [GetFolder](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Remote/GetFolder.php).

## Author, integrate and debug

1. Define each asset's owner, version/license, original location, desired generated/installed destination, loading context and whether its bytes require compiler processing.
2. Reuse/create a Library only when a reusable load policy is appropriate; otherwise use the owner's direct files/folders child. Set load policy and required configuration/conditions deliberately.
3. Supply supported source paths/URLs, destination and processing/rename settings. Generate and inspect asset dependencies, keys and indexes; check normalized-key collisions across the relevant sources.
4. Import into the intended authoring target, inspect restored bytes/paths, then attach the Library to the actual view/layout/template/module consumer.
5. Compile and inspect archive contents, manifest paths, processed text, generated includes and any configuration fields. Confirm binary assets are unchanged when intended.
6. Install and exercise loading/conditional branches in a browser, including network responses, content types, dependency order and missing/offline resource behaviour appropriate to the feature. Record the [integration result](../workflows/validate-and-integrate.md).

For an absent file, separate source resolution, repository transfer, compiler destination and installed manifest failures. For an asset present but unused, inspect `how`, consumer attachment and emitted include logic. For a script failure, inspect browser load order/API compatibility, not only the existence of a `.js` file. A Playground-only network/filesystem limitation needs a documented native follow-up rather than an invented pass; see [shared environment limits](../../testing/playground/README.md).
