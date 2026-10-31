# Package field references

Generated from JCB `408703a857ad937479b1e28de7f693af178dcc83` using `bash tools/generate-package-contracts.sh SOURCE OUTPUT`. Regenerate into a separate directory and review the diff. PHP literals are tokenized; inspected PHP is never included or executed. XML is parsed without DTD or network access.

The JSON files preserve full source field metadata and nested subfields; form options, defaults, filters, showon and validation attributes are evidence, not a complete compiler schema. The schemas are deliberately bounded envelopes and accept exported nulls. Unknown fields fail this pinned profile and require source review. See [protocol](../specification.md), [inventory](../model-contracts.json) and [tool limits](../../tools/README.md).

| Entity | Identity | Fields |
| --- | --- | --- |
| [admin_custom_tabs](admin_custom_tabs.md) | `admin_view` / parent_guid | 2 |
| [admin_fields](admin_fields.md) | `admin_view` / parent_guid | 2 |
| [admin_fields_conditions](admin_fields_conditions.md) | `admin_view` / parent_guid | 2 |
| [admin_fields_relations](admin_fields_relations.md) | `admin_view` / parent_guid | 2 |
| [admin_view](admin_view.md) | `guid` / guid | 87 |
| [class_extends](class_extends.md) | `guid` / guid | 5 |
| [class_method](class_method.md) | `guid` / guid | 8 |
| [class_property](class_property.md) | `guid` / guid | 7 |
| [component_admin_views](component_admin_views.md) | `joomla_component` / parent_guid | 2 |
| [component_config](component_config.md) | `joomla_component` / parent_guid | 2 |
| [component_custom_admin_menus](component_custom_admin_menus.md) | `joomla_component` / parent_guid | 2 |
| [component_custom_admin_views](component_custom_admin_views.md) | `joomla_component` / parent_guid | 2 |
| [component_dashboard](component_dashboard.md) | `joomla_component` / parent_guid | 3 |
| [component_files_folders](component_files_folders.md) | `joomla_component` / parent_guid | 5 |
| [component_modules](component_modules.md) | `joomla_component` / parent_guid | 2 |
| [component_placeholders](component_placeholders.md) | `joomla_component` / parent_guid | 2 |
| [component_plugins](component_plugins.md) | `joomla_component` / parent_guid | 2 |
| [component_router](component_router.md) | `joomla_component` / parent_guid | 8 |
| [component_site_views](component_site_views.md) | `joomla_component` / parent_guid | 2 |
| [component_updates](component_updates.md) | `joomla_component` / parent_guid | 2 |
| [custom_admin_view](custom_admin_view.md) | `guid` / guid | 38 |
| [custom_code](custom_code.md) | `function_name` / natural_key | 13 |
| [dynamic_get](dynamic_get.md) | `guid` / guid | 34 |
| [field](field.md) | `guid` / guid | 24 |
| [file_system](file_system.md) | `key` / asset_key | 3 |
| [joomla_component](joomla_component.md) | `guid` / guid | 88 |
| [joomla_module](joomla_module.md) | `guid` / guid | 42 |
| [joomla_module_files_folders_urls](joomla_module_files_folders_urls.md) | `joomla_module` / parent_guid | 6 |
| [joomla_module_updates](joomla_module_updates.md) | `joomla_module` / parent_guid | 2 |
| [joomla_plugin](joomla_plugin.md) | `guid` / guid | 36 |
| [joomla_plugin_files_folders_urls](joomla_plugin_files_folders_urls.md) | `joomla_plugin` / parent_guid | 6 |
| [joomla_plugin_group](joomla_plugin_group.md) | `guid` / guid | 3 |
| [joomla_plugin_updates](joomla_plugin_updates.md) | `joomla_plugin` / parent_guid | 2 |
| [layout](layout.md) | `guid` / guid | 10 |
| [library](library.md) | `guid` / guid | 9 |
| [library_config](library_config.md) | `library` / parent_guid | 2 |
| [library_files_folders_urls](library_files_folders_urls.md) | `library` / parent_guid | 6 |
| [placeholder](placeholder.md) | `target` / natural_key | 2 |
| [site_view](site_view.md) | `guid` / guid | 38 |
| [template](template.md) | `guid` / guid | 10 |
| [validation_rule](validation_rule.md) | `name` / natural_key | 4 |
