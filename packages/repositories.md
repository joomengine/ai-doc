# Package repositories and the inspected examples

[`joomengine/packages`](https://github.com/joomengine/packages) is the default Package repository. Use the [shared network workflow](../standards/repository-network.md) to discover its maintained mirrors; other package repositories retain their own source identities.

These repositories distribute **JCB authoring graphs**, not installable Joomla extension ZIPs. A repository may contain several component roots and reusable entities shared by those roots. Its records, associations, indexes and transported assets have different contracts. Use the [specification](specification.md) and [entity reference](reference/README.md) as the format authority; a convenient example does not redefine the format.

## Pinned corpus and useful roles

The following snapshots were inspected on 2026-10-31. Branch names are discovery inputs; the full commits identify this evidence.

| Repository | Branch and inspected commit | Best use |
| --- | --- | --- |
| [joomengine/packages](https://github.com/joomengine/packages/tree/4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9) | `master@4fd6ce1f2a11a478abb291d03a1a3b32ceeda5c9` | Broad examples: seven component roots, many Fields, custom views, reusable libraries and folder transport |
| [joomengine/joomla-packages](https://github.com/joomengine/joomla-packages/tree/a0041f0d408ca65ac43796f89a90c88063fe85a8) | `master@a0041f0d408ca65ac43796f89a90c88063fe85a8` | Service Directory J5/J6 roots, shared application definitions, routing and richer layout/template use |
| [vast-development-method/hello-world-blueprint](https://github.com/vast-development-method/hello-world-blueprint/tree/5802e7c1d9bfaac005c765ccda830a7d07cd7e12) | `main@5802e7c1d9bfaac005c765ccda830a7d07cd7e12` | First end-to-end learning graph: one component plus a module and plugin, two site views, five Fields, natural-key Custom Code and four assets |

For an agent learning the package lifecycle, begin with [the Hello World trace](examples/reference-traces.md), then inspect a relevant larger example. The smaller graph makes parent/child records and external dependencies easier to follow. It still includes target-specific code and external Field Type/Joomla Power requirements; it is not a dependency-free or automatically compatible starter. The supplied Blueprint Authoring MCP design names Demo J6 as that project's conformance root; this is not a universal package-format requirement. Use [the original fixture](examples/minimal-repository/README.md) for bounded transport/relationship checks. Neither source inspection nor repository size establishes successful import or compilation; consult [verification](verification.md).

## Component roots

Names below are observed index labels. Version suffixes are not compatibility certificates: inspect `preferred_joomla_version`, source code, dependencies and the actual target build.

| Repository | Component index label | GUID |
| --- | --- | --- |
| packages | Demo J4 | `d7d3bc04-6272-470a-91d1-e091ecb10ab6` |
| packages | Demo J5 | `efde995e-60aa-4b39-b644-44349dfb660d` |
| packages | Demo J6 | `1c20aec5-bf1a-44e7-9deb-d1c920ca591d` |
| packages | Hello World J3 | `2dea78a6-e0be-4260-8f7d-b278e0b661a8` |
| packages | HelloWorld (public) | `3745af8f-f96b-4e17-831e-eb4062cd4389` |
| packages | Recipe Manager | `d7e30702-ec49-45ac-8897-0389d61d6da0` |
| packages | eHealth Portal | `eaabada6-9a90-4dc8-a3ca-22d275f4ec64` |
| joomla-packages | Service Directory J5 | `35a38329-d1e9-43df-a8f8-af1b8e6d8bd9` |
| joomla-packages | Service Directory J6 | `160d0efb-6bf0-48eb-8d46-55cf74729501` |
| hello-world-blueprint | HelloWorld | `3745af8f-f96b-4e17-831e-eb4062cd4389` |

The repeated Hello World GUID identifies overlapping representations of the same component, not two fresh identities. Across the complete indexes, packages/joomla-packages share 109 typed `(entity, identity)` entries, packages/hello-world-blueprint share 31, and joomla-packages/hello-world-blueprint share 12. These counts do **not** say the corresponding payloads are identical. Preserve source/order and compare selected payloads before treating either occurrence as an override. Do not import every source indiscriminately or create a new application by renaming an existing root while retaining all its identities.

## Complete index inventory

Each cell counts entries in the named index, including children and assets as separate categories. `—` means the index is absent from this snapshot, not unsupported by JCB. This inventory covers every index found in the three repositories; the [entity reference](reference/README.md) covers the implementation's broader model inventory.

| File under `index/` | packages | joomla-packages | hello-world-blueprint |
| --- | ---: | ---: | ---: |
| `admin-custom-tabs.json` | 1 | — | 1 |
| `admin-fields-conditions.json` | 7 | 11 | — |
| `admin-fields-relations.json` | 1 | 2 | — |
| `admin-fields.json` | 63 | 25 | 1 |
| `admin-view.json` | 63 | 25 | 1 |
| `class-extends.json` | 2 | 2 | 2 |
| `class-method.json` | 4 | 3 | 3 |
| `class-property.json` | 6 | 3 | 3 |
| `component-admin-views.json` | 7 | 2 | 1 |
| `component-config.json` | 4 | 2 | — |
| `component-custom-admin-menus.json` | 3 | 2 | — |
| `component-custom-admin-views.json` | 4 | — | — |
| `component-dashboard.json` | 5 | — | 1 |
| `component-files-folders.json` | 4 | 2 | — |
| `component-modules.json` | 4 | — | 1 |
| `component-placeholders.json` | 4 | — | — |
| `component-plugins.json` | 3 | 2 | 1 |
| `component-router.json` | — | 2 | 1 |
| `component-site-views.json` | 6 | 2 | 1 |
| `component-updates.json` | 7 | 2 | 1 |
| `custom-admin-view.json` | 1 | — | — |
| `custom-code.json` | 16 | 25 | 1 |
| `dynamic-get.json` | 10 | 13 | 2 |
| `field.json` | 288 | 133 | 5 |
| `file_folder.json` | 56 | 21 | 4 |
| `joomla-component.json` | 7 | 2 | 1 |
| `joomla-module-files-folders-urls.json` | 1 | — | — |
| `joomla-module.json` | 1 | — | 1 |
| `joomla-plugin-files-folders-urls.json` | 1 | 1 | — |
| `joomla-plugin-group.json` | 7 | 3 | 2 |
| `joomla-plugin.json` | 5 | 2 | 1 |
| `layout.json` | 10 | 20 | — |
| `library-files-folders-urls.json` | 2 | — | — |
| `library.json` | 2 | — | — |
| `placeholder.json` | 4 | 10 | — |
| `site-view.json` | 8 | 7 | 2 |
| `template.json` | 2 | 7 | — |
| `validation_rule.json` | 1 | 2 | — |

| Representation counted | packages | joomla-packages | hello-world-blueprint |
| --- | ---: | ---: | ---: |
| Index JSON files | 37 | 28 | 22 |
| Root `item.json` payloads | 437 | 257 | 24 |
| Child JSON payloads under `children/` | 127 | 55 | 9 |
| Transported asset files, including folder ZIPs | 56 | 21 | 4 |
| Total index entries | 620 | 333 | 37 |

Every indexed settings/asset path exists at these snapshots. This is a path-presence observation; it does not prove graph acquisition, archive safety, library compatibility or executable correctness. The packages asset set includes one ZIP referenced as a folder; the other two snapshots have file assets only. A folder counts as one transported archive here, not as the number of files inside it.

## Format and dependency boundaries visible in the corpus

- Root definitions use `src/<entity>/<identity>/item.json`; owned child payloads use the configured parent directory, `children/<parent-identity>/<child-name>.json`. Index filenames are configured, not universally generated by replacing underscores: `validation_rule.json` and `file_folder.json` retain underscores.
- `custom_code` is addressed by `function_name` for the manual case, `placeholder` by `target` such as `[[[component_acronym]]]`, and `validation_rule` by `name`. Their index field is still called `guid`. Do not require UUID syntax for these natural keys or assign new GUIDs to owned children.
- `file_folder.json` rows have `name`, `path` and `guid`, with no `settings` path. The target is raw file content or a real ZIP for a folder; there is no asset `item.json`. A descriptor carries its original destination, target area and normalized key. See [asset fixture](examples/assets.md).
- Declared unresolved typed targets, when each repository is inspected alone, are 21 distinct Field Types plus four validation-rule names in packages, 16 Field Types in joomla-packages, and four Field Types in Hello World. All of those Field Type GUIDs were present in [core at `3be64d59378b5650825b97b44dbd58f2cdb82fcb`](https://github.com/joomengine/joomla-fieldtypes/blob/3be64d59378b5650825b97b44dbd58f2cdb82fcb/index.json); their definitions remain in the Field Type channel. Availability in that index is not evidence they were installed in a test JCB instance.
- The four packages rule names absent from its own index are `email`, `equals`, `number` and `password`. Corresponding classes exist in [Joomla's inspected Form/Rule directory](https://github.com/joomla/joomla-cms/tree/d7b2268f9184b67866156afb5446717e0612d169/libraries/src/Form/Rule). Resolve whether a rule is native or a custom exported rule in the intended target; a missing package row alone does not justify inventing a replacement.
- Literal Power references are a separate boundary. Scanning JSON payload strings found 13 distinct `Super___...___Power` and 17 `Joomla___...___Power` tokens in packages; 12 and 17 in joomla-packages; and zero and 10 in Hello World. These lexical counts can include comments or inactive code and do not establish runtime use. None of the three snapshots emits `@dependencies` with entity `power`. The inspected package resolver does not turn these tokens into ordinary package dependencies; the compiler's Power machinery must be checked separately. See [reference trace](examples/reference-traces.md#field-types-and-powers-are-separate-contracts).

These are bounded observations of exported graphs and literal references. External URLs, dynamically constructed references, installed framework classes, SQL contents and runtime services require their own inspection. Do not declare a blueprint self-contained merely because every declared local dependency resolves.

## Reproduce and maintain the inventory

For a reviewed checkout, record `git rev-parse HEAD`, then inspect all its indexes without executing payload code:

```bash
for index in "$REPO"/index/*.json; do
	printf '%s\t' "${index##*/}"
	jq 'length' "$index"
done
find "$REPO/src" -type f -name item.json
find "$REPO/src" -type f -path '*/children/*' -name '*.json'
find "$REPO/src/file_folder" -type f
```

`REPO` is the absolute path to that checkout. Use the [package validator](../tools/README.md) and compare dependency identities using their entity/key, not a global GUID-only set. Recompute counts after upstream changes; compare added/removed indexes with the actual JCB model configurations before extending the contract.

Each upstream repository includes a GNU GPL v2 license text. Preserve file-specific headers, component license metadata and third-party asset notices as well; that top-level text is not evidence that every bundled image/library has identical terms. Reference identities and material remain upstream-owned. The separate original fixtures in this module carry their own explicitly scoped CC0 dedication.
