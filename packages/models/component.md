# Assemble and release a component

The `joomla_component` record is a root into a shared package graph. Its linked records are not an embedded directory tree and its repository is not an installation ZIP. Use the [entity reference](../reference/joomla_component.md) for exact names/representations and [models overview](README.md) for the evidence baseline.

## Root identity and build settings

Keep `system_name` (authoring identification), `name` (component-facing naming), `name_code` (generated code/extension naming), `guid` (package identity), `component_version` and `preferred_joomla_version` distinct. The compiler sanitizes the code name and derives generated names; a display-name change is not a reliable extension rename. Renaming code/table namespaces after installation needs a migration plan and a comparison of manifest, class namespaces, SQL tables, links and installed paths.

The form exposes `preferred_joomla_version` with UI default `6`; the compilation target still has to be selected and recorded. Namespace prefix, Power directory, menu prefix, Git/backup folders and similar overrides have controlling settings. Empty/global, `0` and override values are not interchangeable. In particular, `add_namespace_prefix` uses an empty global choice versus `1` override; set the prefix together with that choice. Resolve placeholders in the intended component context rather than hardcoding the generated namespace into portable source.

Author/company/contact/license/version metadata flows into generated files and manifests. Supply truthful attribution and license terms. Optional README, CSS, JavaScript, helper/event and installer code needs both its code value and the matching enable setting. An enabled hook's execution context matters: installer preflight/postflight/method code is not a request controller; helper code is not automatically an invoked method. Test the particular lifecycle event it affects.

The package Remote Config excludes fields including access, export/sales details, update-server record, translation credentials and created/modified timestamps. A visible component form control therefore does not establish that its value is portable. Consult the reference's actual ignored set before exporting local configuration or secrets. [Component Remote Config](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Component/Remote/Config.php) defines the package boundary; [Component/Data::getQuery/energize](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Component/Data.php) loads and processes the compiler inputs.

## Attach views through full linking records

Each child below is keyed by its parent's `joomla_component` GUID; do not allocate a separate GUID for this parent-keyed child contract. Its repeatable collection is a nested submodel. Preserve the full row: view links also carry the component-specific feature policy.

| Record / nested collection | Decisions and consumer effects |
| --- | --- |
| [`component_admin_views.addadmin_views`](../reference/component_admin_views.md) | `adminview` identifies an Admin View. Menu/dashboard placement, checkin/history/access, Joomla custom fields, metadata, import/export (`port`), filters, frontend edit/create and API selection belong to this attachment. `add_api`: `0` none, `1` list, `3` item, `2` both. `edit_create_site_view`: empty none, `1` add, `2` add with menu. These switches need actual authorization/runtime tests. |
| [`component_site_views.addsite_views`](../reference/component_site_views.md) | `siteview` plus menu, metadata, default-view and public-access choices. Decide one intended entry/default page and confirm routing/access with a logged-out and authorized user where relevant. A custom frontend read page is distinct from an Admin View's generated frontend edit form. |
| [`component_custom_admin_views.addcustom_admin_views`](../reference/component_custom_admin_views.md) | `customadminview` plus menu/dashboard/metadata choices and linked Admin View/menu positioning. A custom backend page does not automatically create a CRUD table. |

The root compiler joins these child tables by the root GUID and passes their collections to `Model/Adminviews`, `Siteviews` and `Customadminviews`. An indexed view without the component attachment is not proof that it will compile into that component. Keep only the intended owning child record for each component/child-table role; do not create competing records as a substitute for adding a row to the existing collection. Inspect imported child records after acquisition, not just the root.

## Options, menus and dashboards

[`component_config.addconfig`](../reference/component_config.md) attaches reusable Field GUIDs to component options, with `custom_value` and `tabname` overrides. The compiler resolves each Field and applies naming/uniqueness within its config context. This does not attach a database column to an Admin View. Check the generated options XML, default/override values, persistence in component parameters and the code that reads them.

[`component_custom_admin_menus.addcustommenus`](../reference/component_custom_admin_menus.md) defines extra menu entries through name/code/link/icon and mainmenu/submenu/dashboard/position settings. A menu link is navigation, not an access-control grant or an implementation of the destination. Confirm the route exists and permissions are enforced there.

For the standard dashboard, [`component_dashboard`](../reference/component_dashboard.md) supplies `dashboard_tab` rows (`name`, `header`, `html`) and `php_dashboard_methods`. The root's `dashboard_type` distinguishes default (`1`) from dynamic (`2`), with a selected dynamic dashboard. Choose the intended mode first; do not assume additional tab HTML replaces a selected custom dashboard. Exercise the actual landing page, method calls, output escaping, permissions and assets.

## Router settings

[`component_router`](../reference/component_router.md) is a real portable child despite its absence from the inspected public specimen. Its modes are not one shared boolean:

| Setting | Form values |
| --- | --- |
| `mode_constructor_before_parent` | `1` default, `2` manual Site View selection, `3` code |
| `mode_constructor_after_parent` | `1` none, `3` code |
| `mode_methods` | `0` none, `1` default, `3` code |

Supply the matching manual collection/code field for the chosen mode. `Model/Router::set` processes code only for mode `3`; mode `2` decodes the manual collection. The compiler also derives routing information from Site View main selection and frontend edit views. A default item route relies on the expected main-get/table/key/alias relationship, not just the view's display name. Verify generated router methods and round trips for list/item routes, missing items, aliases, menu context and frontend editing. Do not treat a successful component import as an SEF-routing test. [Router consumer](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Router.php)

## Schema, data and updates

Schema comes primarily from [Admin Views and concrete Fields](fields-and-relationships.md), not from the label “package.” Table engine/charset/collation/row format are Admin View settings; Field datatype/length/default/nullability/index/storage decisions determine columns and model transformations. Inspect actual install and upgrade SQL.

There are separate SQL paths:

- Root `add_sql`/`sql` and `add_sql_uninstall`/`sql_uninstall` supply explicitly enabled component SQL.
- Admin View `add_sql` and source/table/dump settings control additional data generation for that view.
- [`component_updates.version_update`](../reference/component_updates.md) carries release-specific version, MySQL, URL and optional advanced update metadata. Match the component's release progression and installed-version upgrade path. The form contains historical example/default target-version patterns; do not copy a Joomla-5 pattern into a Joomla-6-only release without checking it.
- Compiler history comparison (`Model/Historycomponent`, `Historyadminview`, `Fields`, `Updatesql`) can produce update SQL from known earlier local state. A fresh importer has not necessarily reproduced that history. Do not assume a change to JSON generates a safe migration for every existing installation.
- **Local compiler feature outside current package serialization:** `component_mysql_tweaks.sql_tweak` is joined by `Component/Data`, then processed by `Model/Sqltweaking`. It can disable a view's added demo SQL or limit selected numeric IDs/ranges. It is neither schema definition nor a portable entity in this baseline. If the task needs these settings, record the missing portable contract and use a separately established supported path; never invent an index or silently omit the requirement.

Sources: [SQL tweak consumer](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Sqltweaking.php), [update comparison](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Updatesql.php), [component update form](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/component_updates.xml).

## Assembly and acceptance

1. Establish the root identity, supported target, component name/namespace/version and actual intended installation behaviour.
2. Create/reuse views, Fields, queries and assets through their model guides. Add complete linking-child records pointing back to this root. Attach [modules/plugins](extensions.md) and [files/libraries](libraries-and-assets.md) only when required.
3. Configure options/menu/dashboard/router and enabled code hooks. Keep local credentials and deployment paths outside the portable payload where the contract excludes them.
4. Resolve the full closure and import it into a suitable JCB instance. Reopen the root and every changed child collection; check intended row flags rather than counting imported entities.
5. Compile for the declared target. Inspect manifest, namespaces, view selection, menu/options XML, router, install/update/uninstall SQL, hooks and packaged assets. Install a clean instance and upgrade a copy of an earlier supported release when migration is involved.
6. Exercise real user routes and permissions. Record failed or unrun installer/update/native checks separately. A package that imports and compiles can still lose data on update or expose an unintended page.

When a feature disappears, first inspect its component link/enable flag and imported child record; then the compiler-selected target and generated file. When an upgrade fails, compare the old installed schema/version, generated update filenames/order and explicit SQL before changing the component GUID.
