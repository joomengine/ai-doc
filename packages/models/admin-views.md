# Build Admin Views and their editing/list behaviour

An [`admin_view`](../reference/admin_view.md) defines a generated database-backed administration area. It becomes part of a component through `component_admin_views`, whose per-component flags are described in [component assembly](component.md). The view's four direct children are independent serialized records: [`admin_fields`](../reference/admin_fields.md), [`admin_fields_conditions`](../reference/admin_fields_conditions.md), [`admin_fields_relations`](../reference/admin_fields_relations.md) and [`admin_custom_tabs`](../reference/admin_custom_tabs.md).

These child contracts use the parent `admin_view` GUID as their identity and distinct child filenames. They do not receive additional independent GUIDs. Nested rows in their collections also do not become separate indexed records.

## Design the view before its controls

Choose `name_single`/`name_list`, code-name consequences, table semantics and intended CRUD access. `type=1` is read/write and `type=2` is read-only in the form; do not confuse that with the site's user permissions or with the component attachment's API/website-edit flags. Define authorization for records and the whole view through `addpermissions`; its `implementation` values are `1` record, `2` whole view, `3` both. Test unauthorized routes/tasks as well as toolbar visibility.

`mysql_table_engine`, `mysql_table_charset`, `mysql_table_collate` and `mysql_table_row_format` control generated table settings. The inspected form defaults are InnoDB, utf8mb4, utf8mb4_unicode_ci and DYNAMIC; they describe editor defaults, not universal implicit repository defaults. Ensure charset/collation form a supported pair and the selected engine supports the application's actual constraints. Table settings do not create cross-record foreign keys merely because a field looks like a relation.

Optional SQL data, alias construction, category integration, tabs, linked views, buttons, AJAX, CSS/JavaScript and PHP hooks are feature settings on the view, not extra top-level package entities. `alias_builder_type=2` selects a custom alias builder; `1` uses the default. Preserve field references and verify collisions/empty titles in the real consumer.

The compiler [Adminview/Data::getQuery/getData](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Adminview/Data.php) joins all four children by view GUID, sets names/placeholders and processes tabs, permissions, Fields, history, conditions, relations, linked views, scripts/hooks and SQL. This order explains why an unresolved Field or wrong parent link can affect several later features.

## Attach Fields with `admin_fields.addfields`

Each row references a reusable Field GUID and defines **this view's use** of that Field. The Field record owns its XML/storage; the attachment owns list/edit placement and controls.

| Row setting | Meaning and check |
| --- | --- |
| `field` | Actual Field identity; resolve its external Field Type and embedded dependencies too. |
| `list` | Empty/default, `1` all list views, `3` admin list only, `4` linked lists only, `2` non-database. `2` is not “hide in list”: it changes whether the custom Field is treated as a database column. |
| `title`, `alias`, `link` | Title/alias role and edit-link behaviour; verify the intended title/alias Field, URL and permission context. |
| `search`, `sort`, `filter` | Search/sort eligibility and no/single/multiple filter selection (`filter` empty/`1`/`2`). The column's type and stored representation must support the generated query. |
| `tab`, `alignment`, `order_edit` | Editing layout. Alignment `1/2/3` is left/right/full tab width; `4/5` above/below tabs; `6/7` left/right of tabs. Match tab references to the view's actual tabs. |
| `order_list` | List order; the compiler explicitly treats zero differently when sorting. Use deliberate distinct positions where order matters. |
| `permission` | Field permission selection: editing/access/view (`1/2/3`); verify actual generated ACL and rendering, not just the metadata. |

The [Fields model](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Fields.php) resolves each Field, tracks generated default/spacer/non-database Fields separately, sorts list placement and compares known history for updates. Do not redefine default columns casually or expect an unattached Field to become a table column.

## Conditions are form behaviour

`admin_fields_conditions.addconditions` references target Field GUIDs and a match Field within the view. `target_behavior` is `1` show/toggle, `2` hide/toggle, `3` show only, `4` hide only; `target_relation` is `0` isolated or `1` chained. The match modes distinguish list/radio/checkbox comparisons (`1–3`), active/inactive text (`4–5`), case-sensitive/insensitive all/any keywords (`6–9`), and min/max/exact text length (`10–12`). Read the exact options in the reference before setting `match_options`.

[Model/Conditions](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Conditions.php) resolves these GUIDs against the view's Fields, reads required/filter information from XML and determines custom-field inheritance. Therefore both match and target controls must actually be attached with compatible types. Test initial state, toggling, chained conditions, empty/zero values and required validation. A hidden control is not server-side authorization, and conditional UI must not be relied on to protect privileged values.

## Relations are list composition

`admin_fields_relations.addrelations` selects a `listfield`, optional `joinfields`, `column_name`, `area`, `join_type` and `set`. Area `1` runs before modelling, `3` after modelling and `2` in the view. Join type `1` is concatenation/glue, `2` custom code. `column_name` equal to “Default” (case-insensitive after trim) avoids a heading override; another value creates a language-backed column heading.

This mechanism composes displayed/modelled values; it is not a SQL foreign-key declaration or an Admin View-to-Admin View join-table definition. [Model/Relations](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Relations.php) stores valid-GUID/area entries in field-relation/list-join registries and processes custom code. Check the value available at the selected stage, escaping in the view, missing joined values and export/list differences. Changing an area can change the data/code context even when the same string still parses.

## Tabs, linked views and actions

The view's `addtabs` supplies ordinary tab names. `admin_custom_tabs.tabs` inserts custom HTML around a selected tab: `position=1` before or `2` after, plus its name and permission flag. This is a separate child record; do not store its rows in `admin_view.addtabs`. For Joomla 6, inspect the [version-selected custom-tabs consumer](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/JoomlaSix/Customtabs.php), then test tab placement, translation, IDs, controls and permissions.

`addlinked_views` connects another Admin View for a related listing, with `adminview`, `tab`, `key`, `parentkey` and `addnew`. The keys express the application data join, whereas the GUID expresses the package record dependency. Check the actual stored child/parent key types and values. The `addnew` choices control none/new/new-and-close/close variants; they do not create the missing relation Field or schema for you. [Linked-view consumer](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Linkedviews.php)

Custom-button rows carry method, display name, single/list/both target (`1/2/3`) and default/selection/function type (`0/1/2`). `php_controller`, `php_model` and their list equivalents supply the corresponding implementation. AJAX input rows separately specify request/task/method names, input default/filter, zero handling and user checks. A toolbar button or client-side call does not implement authorization, CSRF handling or safe input processing. Verify the generated task and the requested action, including no selection, multiple selection and unauthorized calls.

## Place PHP and scripts in their actual contexts

Use the corresponding `add_php_*`, `add_css_*`, `add_javascript_*` and toolbar switches. Singular `view` and plural `views` distinguish item/edit and list contexts. `php_before_save`, `php_save` and `php_postsavehook` are different execution points; `php_getitem`, `php_getitems`, `php_getitems_after_all`, `php_getlistquery` and `php_getform` operate at different data/query/form stages. Read the generated method around an insertion before relying on `$data`, `$item`, `$items`, `$query` or a return contract. Supplying nonempty code to a disabled hook does not guarantee inclusion.

Use [Model/Phpadminview](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Phpadminview.php), [Custombuttons](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Custombuttons.php), [Ajaxadmin](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Model/Ajaxadmin.php) and the target architecture/template for a changed hook. This guide does not claim a universal placement map for every PHP/JS/CSS field.

## Build and debug sequence

1. Create/reuse Fields and their supported Field Types; design storage/relationships first. Define the view and complete its owning component attachment.
2. Build `admin_fields` with deliberate column roles, placement and schema inclusion. Add only the necessary conditions, relations and custom tabs, pointing every child to the view GUID.
3. Add linked views/actions/hooks with explicit request permissions and data assumptions. Resolve code/catalogue dependencies.
4. Import and reopen all changed records. Compile the attached view and inspect form XML, table/model/list/query/layout/JS/ACL and SQL output.
5. Install and exercise create/edit/save/reopen/list/search/sort/filter plus the affected permission/condition/related-view cases. Test upgrade preservation when storage or existing identities change.

For a missing column check `list=2`, default-column handling, attachment and generated SQL. For an invisible control check its tab/alignment/conditions/permissions and real form XML. For a bad related list distinguish `addlinked_views` joins from `admin_fields_relations` composition and inspect actual keys. For ignored code inspect its enable flag and insertion context before blaming serialization.
