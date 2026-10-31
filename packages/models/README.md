# Choose the package records that implement a feature

These guides explain how JCB records become an application. Read the [package contract](../specification.md) first, then load the guide for the task and the exact entity references it links. The [field reference](../reference/README.md) records serialized fields, nested structures, form domains and source locations; these guides explain consequential choices, consumers and checks rather than duplicating that inventory.

**Implementation baseline:** JCB `6.x` at [`408703a857ad937479b1e28de7f693af178dcc83`](https://github.com/vdm-io/Joomla-Component-Builder/commit/408703a857ad937479b1e28de7f693af178dcc83), inspected 2026-10-31. Joomla-version-specific compiler paths must be checked for the chosen build target. A form option or recorded UI default is not proof that a missing repository field receives that default on import. Exact repository transforms come from the package contract, not from a database dump.

## Route by intended result

| Intended result | Guide |
| --- | --- |
| Define a component, attach views, configure options/dashboard/router or release an update | [Component assembly](component.md) |
| Build a database-backed CRUD screen, organize fields/tabs or control list presentation | [Admin Views](admin-views.md) |
| Choose form input, storage, application relationships or validation | [Fields and relationships](fields-and-relationships.md) |
| Query data, render a frontend/custom backend page, reuse a template/layout | [Presentation and Dynamic Gets](presentation-and-queries.md) |
| Build/attach a module or plugin and its class members/update records | [Modules, plugins and class records](extensions.md) |
| Load a library, transfer files/folders, package assets or diagnose a missing resource | [Libraries and assets](libraries-and-assets.md) |
| Reuse code, substitute placeholders, or resolve embedded code dependencies | [Custom Code and placeholders](code-and-placeholders.md) |

## Three different meanings of “model”

1. **Serialized entity:** an indexed record with an actual `Package/*/Remote/Config.php` contract. The current source has 40 database-backed entities plus the virtual `file_system` contract used by File and Folder. The record's own key and dependencies belong to the package graph.
2. **Nested submodel:** a structured value inside a serialized entity, such as `admin_fields.addfields`, `dynamic_get.join_view_table`, or `component_updates.version_update`. A row is not a new top-level entity or a directory merely because it has several fields. Preserve its exact nested field names, flags and reference values.
3. **Compiler feature:** behaviour implemented from one or more records, such as generated SQL, an API endpoint, frontend editing, router methods, custom field code, asset loading or version-history comparison. A feature name is not authorization to invent `src/<feature>/item.json`.

`component_mysql_tweaks` is a useful boundary example: the compiler reads its local table, but the inspected package contracts contain no matching Remote Config and the component's direct-child allowlist omits it. Read [the schema/update section](component.md#schema-data-and-updates); do not invent a portable entity to fill the gap.

The supplied Blueprint Authoring MCP architecture is design context for a separate Joomla-6-focused authoring product. Its subscription, deployment and branch choices are not universal package-format rules. The actual package source decides serialization. This module explains authoring plus consumer verification; it does not claim a hosted MCP service exists.

## Complete entity coverage

Every current logical package contract is routed below. For a field's allowed values, ignored columns or exact representation, open its reference before editing.

| Guide | Entity references |
| --- | --- |
| Component assembly | [`joomla_component`](../reference/joomla_component.md), [`component_admin_views`](../reference/component_admin_views.md), [`component_site_views`](../reference/component_site_views.md), [`component_custom_admin_views`](../reference/component_custom_admin_views.md), [`component_config`](../reference/component_config.md), [`component_router`](../reference/component_router.md), [`component_dashboard`](../reference/component_dashboard.md), [`component_custom_admin_menus`](../reference/component_custom_admin_menus.md), [`component_updates`](../reference/component_updates.md) |
| Admin Views | [`admin_view`](../reference/admin_view.md), [`admin_fields`](../reference/admin_fields.md), [`admin_fields_conditions`](../reference/admin_fields_conditions.md), [`admin_fields_relations`](../reference/admin_fields_relations.md), [`admin_custom_tabs`](../reference/admin_custom_tabs.md) |
| Fields/validation | [`field`](../reference/field.md), [`validation_rule`](../reference/validation_rule.md) |
| Presentation/queries | [`site_view`](../reference/site_view.md), [`custom_admin_view`](../reference/custom_admin_view.md), [`dynamic_get`](../reference/dynamic_get.md), [`layout`](../reference/layout.md), [`template`](../reference/template.md) |
| Modules/plugins/classes | [`joomla_module`](../reference/joomla_module.md), [`joomla_module_updates`](../reference/joomla_module_updates.md), [`joomla_module_files_folders_urls`](../reference/joomla_module_files_folders_urls.md), [`joomla_plugin`](../reference/joomla_plugin.md), [`joomla_plugin_updates`](../reference/joomla_plugin_updates.md), [`joomla_plugin_files_folders_urls`](../reference/joomla_plugin_files_folders_urls.md), [`joomla_plugin_group`](../reference/joomla_plugin_group.md), [`class_extends`](../reference/class_extends.md), [`class_method`](../reference/class_method.md), [`class_property`](../reference/class_property.md), [`component_modules`](../reference/component_modules.md), [`component_plugins`](../reference/component_plugins.md) |
| Libraries/assets | [`library`](../reference/library.md), [`library_config`](../reference/library_config.md), [`library_files_folders_urls`](../reference/library_files_folders_urls.md), [`component_files_folders`](../reference/component_files_folders.md), [`file_system`](../reference/file_system.md) |
| Code/placeholders | [`custom_code`](../reference/custom_code.md), [`placeholder`](../reference/placeholder.md), [`component_placeholders`](../reference/component_placeholders.md) |

Field Types, Super Powers, Joomla Powers, Snippets, repository connection records, language/translation records, server records and help documents are not extra package entities merely because JCB has a form or table for them. Follow the [source coverage/exclusions](../sources.md) and their own domain contracts. A Field's `fieldtype` points to the separate [Field Type catalogue](../../field-types/README.md); active Power tokens point into code catalogues under the [Power contract](../../super-powers/README.md).

## Build a feature deliberately

1. Define the application result and target: who edits/views which data, relationships/cardinality, required storage and authorization, runtime Joomla/PHP versions and extension ownership.
2. Choose the smallest actual records and nested settings that implement it. Start with Joomla core capabilities and existing shared code. Reuse a shared record deliberately; give an independently adapted record a new checked identity rather than mutating unrelated consumers.
3. Read each entity's reference and its compiler consumer. Set the corresponding enable flag when supplying optional code. Preserve import representations and natural keys; do not copy local numeric IDs or UI-only controls into package JSON.
4. Attach records to the root through real linking children and outbound references. A Field, View or Library stored in the repository pool is not automatically part of every component.
5. Recompute/verify package dependencies, then resolve non-package catalogues and embedded code references. A complete GUID graph does not prove that an application selector, SQL join or runtime service points at the right data.
6. Import/refresh the intended revision, reopen persisted authoring values, compile an actual consumer, inspect the emitted artifacts and run the affected behaviour. Follow [package validation](../workflows/validate-and-integrate.md) and [Playground](../../testing/playground/README.md). Record unsupported source paths or unrun stages explicitly.

For debugging, work from repository payload → imported record → linking/nested settings → compiler feature → generated artifact → installed runtime. A repair made only to generated PHP or the browser editor does not correct the package blueprint; carry it back to source, regenerate and retest.
