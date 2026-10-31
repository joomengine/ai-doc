# Reuse Custom Code and placeholders

[`custom_code`](../reference/custom_code.md), [`placeholder`](../reference/placeholder.md) and [`component_placeholders`](../reference/component_placeholders.md) have different identities and insertion behaviour. They complement ordinary code-bearing fields on views, Fields, extensions and components; they do not turn arbitrary PHP tokens into general package GUID relationships. Read the [package dependency contract](../specification.md) before assuming a scanner will discover a reference.

## Choose the correct kind of reusable code

Use an appropriate Joomla core capability first, then an existing shared Power or other maintained implementation. Use a [Super Power](../../super-powers/README.md) when the requirement is a reusable class/interface/trait with its own namespace/dependency contract. Use a Custom Code record for supported reusable source insertion. Use a [layout/template](presentation-and-queries.md#reuse-layouts-and-templates) for presentation reuse, and a placeholder for a deliberate substitution value. A Snippet is an authoring source/example, not automatic runtime dependency resolution.

Preserve the actual insertion context. A code slot can be a method body, class members, imports/header, SQL, JavaScript or markup. Document the values/types available there, required services and the intended result. A whole class pasted into an existing class-body slot is not made valid by successful JSON validation. Keep raw repository text in the decoded representation prescribed by the reference; do not copy database Base64 into fields whose package importer performs that encoding.

## Manual Custom Code

`target=2` is JCB/manual Custom Code. `function_name` is its natural repository identity and the portable name used in a `[CUSTOMCODE=function_name]` reference. The compiler also understands local numeric identifiers, but they are unsuitable as portable package identities. Preserve a referenced function name for the same shared insertion; renaming it requires updating all callers and checking collisions in the configured sources.

Custom Code supports parameterized reference handling with a `+` argument portion and comma separation. Before using it, inspect the actual compiler parser and substituted argument placeholders, including escaping/separator constraints. The source also marks limitations around IDE-update handling when arguments are used. Do not promise arbitrary strings or nested expressions survive an unescaped comma-based argument syntax. Prefer a real class/function API when complex data passing is required.

The component Remote Config's direct-child list does not automatically export every Custom Code record belonging to a component: its prospective `custom_code` child entry is commented out. Embedded-reference scanning and the actual exported dependency list therefore matter. Verify the named record and any nested code/Power/placeholder references are available; a folder containing the code without a reachable supported reference is not proof of acquisition.

Source: [Compiler/Customcode](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Customcode.php), [Component Remote Config](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Component/Remote/Config.php). Exact selectors and transformation order are implementation-specific; a textual match in a comment and active compiled code should be assessed separately.

## Hash-based automation is a distinct path

`target=1` selects hash-based Custom Code automation. Its form includes the applicable Joomla version, component/path, insertion or replacement `type`, comment mode and line/hash boundary metadata (`from_line`, `to_line`, `hashtarget`, `hashendtarget`). These values describe a source location/update operation; they are not merely alternate labels for a manual named insertion. Use the real JCB automation workflow to establish valid boundaries rather than inventing line numbers or hashes.

There is an inspected identity mismatch to treat as a gap: the specialized export index-map GUID for target `1` derives from its path with `/` replaced by `#`, while the general Custom Code record/bucket/import key remains `function_name`. Do not declare arbitrary automation records round-trip safe from the generic natural-key schema alone. Preserve evidence from the actual export/import and verify that the expected record and target file are updated before relying on this path. See [CustomCode exporter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Remote/CustomCode/Set.php) and the [Custom Code reference](../reference/custom_code.md).

Automatic edits to generated output must be carried into the supported authoritative workflow and regenerated. A one-off editor patch is not a maintained package change, and a preserved hash/line reference can become invalid when its upstream generated context changes.

## Global and component placeholders

[`placeholder`](../reference/placeholder.md) is keyed by the natural `target` string, with a `value`. [`component_placeholders`](../reference/component_placeholders.md) is a child keyed by `joomla_component`; its `addplaceholders` rows carry component-specific target/value pairs. Allocate no independent GUID for those rows or the parent-keyed child.

The component placeholder consumer loads stored placeholders, adds core placeholders, then applies component overrides. It recognizes the supported `[[[name]]]` and `###name###` forms and strips balanced wrappers when normalizing a stored target. Core placeholders can supersede an earlier stored value, and component overrides can supersede the resulting mapping. Use this order deliberately; inspect the [component placeholder source](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Component/Placeholder.php) before shadowing a core name.

An override's value is substituted using the existing mapping before assignment. This is not a promise of arbitrary recursive/fixed-point evaluation or order-independent mutually referring placeholders. Keep dependencies simple, preserve portable compiler placeholders when expected and inspect the final emitted value. Placeholder substitution does not automatically escape HTML, PHP strings, SQL or JavaScript; the receiving context determines the required encoding and validation.

Changing a global natural key/value can affect many unrelated consumers. Inventory active references before updating it; prefer a component override when the change is specifically scoped to that component. Test every intended output context, including zero/empty values and strings with quotes or delimiter-like content.

## Resolve each dependency at its own boundary

| Reference kind | Resolution and required proof |
| --- | --- |
| Declared package GUID/natural-key link | Package dependency resolver and entity-specific import contract; inspect the emitted graph. |
| Field XML nested Fields/custom validation | Field-specific scanners and generated form/rule consumers; see [Fields](fields-and-relationships.md). |
| Custom Code/placeholder insertion | Supported embedded syntax, matching natural key and compiler substitution; inspect final code. |
| Template/layout invocation | Alias discovery and target-specific generated presentation files; inspect nested dependencies. |
| Super/Joomla Power token | Separate Power catalogue and compiler-stage code resolution; not a general Package Resolver edge. |
| External URL/code, server setting or arbitrary class name | No automatic package entity is established by the string alone. Trace the specific consumer and separately supply/test what it requires. |

Do not invent a package `external_code` entity because the local compiler has external-code support or a table exists. Use the [source coverage](../sources.md) and current Remote Config inventory. Likewise, Field Types and Powers require their own operational models, configured sources and source precedence. Package graph completeness cannot prove a required external catalogue was initialized or a generated class can autoload.

## Author, integrate and debug

1. Define the reusable behaviour, actual insertion context, public names and dependencies. Choose core/Power/Custom Code/layout/placeholder according to that need.
2. Preserve existing natural keys and GUIDs for intentional same-item updates; check a new identity against the correct domain. Update every caller for a deliberate rename.
3. Store raw authoritative source and explicit enable flags in the correct record/slot. Build the complete package graph and separately resolve code/catalogue dependencies.
4. Import/reopen the actual stored values. Compile a real consuming component or attached extension and inspect substitutions, namespace/imports, code boundaries and any unresolved tokens.
5. Run the affected behaviour and failure cases on the intended Joomla/PHP target. Where a shared insertion changes, include more than one relevant caller/context in regression checks. Follow [integration validation](../workflows/validate-and-integrate.md).

For literal unresolved tokens, inspect syntax and source precedence before editing emitted code. For absent Custom Code, inspect its target, natural key and dependency selection. For a syntax error, inspect surrounding generated scope and inserted delimiters/imports. For the wrong placeholder value, inspect core/override ordering and receiving-context escaping. For an automation mismatch, retain the original/exported/imported identity and source-boundary evidence; report the unverified path instead of silently recasting it as manual code.
