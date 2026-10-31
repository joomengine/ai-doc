# Super Power repository contract

Read this before changing the structure of a Power repository. For individual fields, use [settings-reference.md](settings-reference.md). For operations, start at [README.md](README.md). Statements marked **Policy** are the project's authoring rules; **Implementation** describes the inspected JCB source; **Observation** describes an existing repository and is not a promise of correctness.

## Scope and evidence

**Implementation baseline:** JCB `6.x` at [`408703a857ad937479b1e28de7f693af178dcc83`](https://github.com/vdm-io/Joomla-Component-Builder/commit/408703a857ad937479b1e28de7f693af178dcc83), inspected 2026-10-31. The inspected `Componentbuilder/Power/` subtree, `Compiler/Power.php`, `Compiler/Power/` subtree and `admin/forms/power.xml` are byte-identical on `5.x` at [`eb4bacd7a549fb2f13b48b993c4efac85e7f0029`](https://github.com/vdm-io/Joomla-Component-Builder/commit/eb4bacd7a549fb2f13b48b993c4efac85e7f0029). That comparison does not prove compatibility of every PHP method in a Power with every Joomla version. GitHub's `master` branch endpoint redirected to `5.x` during inspection; record explicit branch and commit rather than treating `master` as a version contract.

This specification concerns **PHP Super Powers**. Joomla Powers, component package blueprints, JavaScript powers and other JCB entities have separate formats. Do not apply `super-powers.json` or the PHP class-body rules to them by analogy.

The implementation reads:

1. The repository's `super-powers.json` locator index.
2. The indexed `settings.json` definition.
3. The indexed `code.power` body, assigned to `main_class_code` for import.

`code.php` is not read by this import path. An edit only to `code.php` has no effect on the imported implementation. Sources: [Power/Grep.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Grep.php#L86), [Power/Remote/Config.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Config.php#L57).

## File ownership and layout

| Path | Meaning | Maintenance responsibility |
| --- | --- | --- |
| `super-powers.json` | JSON object keyed by Power GUID; locates every published Power | Add/update the corresponding entry when a Power is created or moved; preserve other entries |
| `src/<guid>/settings.json` | Portable definition and dependency selectors | Authoritative metadata; edit here |
| `src/<guid>/code.power` | Plain PHP class/interface/trait body | Authoritative implementation; edit here |
| `src/<guid>/code.php` | Assembled PHP representation for inspection | Keep consistent with the source definition and declared generation context |
| `src/<guid>/README.md` | Description, methods, usage/dependencies and optional class diagram | Keep consistent with the actual Power |
| `README.md` | Repository role and catalogue/navigation | Explain reuse, supported runtime, installation/import configuration and local guidance |
| `LICENSE` or existing licence file | Repository licensing | Preserve upstream provenance and per-file notices; do not assume one licence applies to every dependency |

**Policy:** newly authored repositories use this layout and include all five Power-related files plus repository documentation and licence. The index controls retrieval, but arbitrary alternate paths offer no benefit here and complicate validation. Paths must be relative, remain inside the repository, use `/`, and exactly match case. Never publish local absolute paths, credentials, or database record IDs as repository identity.

**Implementation:** the base remote config uses `src`, `guid`, `settings.json` overridden for Powers, and `README.md`; the Power config specifies the two code paths and index map. A readable empty `code.power` is valid for a wrapper with no additional members. A missing body file is not the same thing. The remote loader at this revision can return settings when the body fetch fails; therefore an agent must independently reject missing/unreadable body files rather than treating that tolerance as a valid authoring pattern.

## Index entry: complete real example

This existing service-provider entry comes from [`joomengine/openai@96e575e`](https://github.com/joomengine/openai/blob/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/super-powers.json). It is a reference to an existing Power, **not an identifier to copy for a new Power**.

```json
{
    "07858e1f-5698-4227-8941-03dc93557938": {
        "name": "Utilities",
        "type": "class",
        "namespace": "VDM\\Joomla\\Openai\\Service",
        "code": "src/07858e1f-5698-4227-8941-03dc93557938/code.php",
        "power": "src/07858e1f-5698-4227-8941-03dc93557938/code.power",
        "settings": "src/07858e1f-5698-4227-8941-03dc93557938/settings.json",
        "path": "src/07858e1f-5698-4227-8941-03dc93557938",
        "spk": "Super---07858e1f_5698_4227_8941_03dc93557938---Power",
        "guid": "07858e1f-5698-4227-8941-03dc93557938"
    }
}
```

| Member | Exact interpretation |
| --- | --- |
| Object key and `guid` | Same identity as `settings.guid` and the `src` directory name |
| `name` | Resolved declaration name; normally identical to the settings name, but the compiler supports placeholders in names |
| `type` | Declaration kind: `class`, `abstract class`, `final class`, `interface`, or `trait` |
| `namespace` | Resolved PHP **namespace without the class name**, not the portable namespace template |
| `path` | Power directory |
| `settings`, `power`, `code` | Full repository-relative file paths, not filenames relative to `path` |
| `spk` | Display/distribution key, using the delimiter form shown above |

Use one index object member per identity, with no duplicate JSON keys. Sort entries by GUID for stable diffs (the compiler exporter sorts with `ksort(..., SORT_STRING)`). An empty repository begins with `{}`, not `[]`; it becomes useful to JCB once it contains an indexed Power. Adding a GUID directory without adding its index entry does not make it discoverable.

The remote exporter resolves its documented presentation placeholders to `VDM`, `Componentbuilder`, `Componentbuilder`, and `componentbuilder` for `NamespacePrefix`, `ComponentNamespace`, `Component`, and `component`. Compiled exports can reflect the consuming project context. Therefore resolved index names/namespaces are **derived output in a stated context**, never a reason to overwrite source placeholders. Sources: [Remote/Config.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Config.php#L142), [Remote/Set.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Set.php#L567), [Infusion.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Infusion.php#L315).

## Identity, SPK and source token are different forms

| Form | Existing example | Use |
| --- | --- | --- |
| GUID | `c54c92da-2dd7-4136-81c9-1785f2fa0af5` | Index key, settings identity, dependency selectors |
| SPK | `Super---c54c92da_2dd7_4136_81c9_1785f2fa0af5---Power` | Index/documentation distribution key |
| PHP source token | `Super___c54c92da_2dd7_4136_81c9_1785f2fa0af5___Power` | JCB code placeholder resolved during compilation |

**Policy:** keep an existing GUID when correcting, extending or renaming the same Power. A genuinely new Power gets a cryptographically generated UUIDv4. Before using it, check every current index in the [repository registry](../registries/power-repositories.json), the target repository, and any additional repositories configured for the task. A random UUID has negligible accidental collision probability; a uniqueness check is still required, and it proves uniqueness only within the checked catalogue at the recorded revisions. Never invent an identifier from memory or reuse an example's identity.

The SPK changes hyphens **inside** the GUID to underscores while using `---` around it. PHP tokens use `___` around it. Copying an SPK verbatim into PHP does not produce a valid source token. Sources: [Base::index_map_IndexKey](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Base.php#L490), [Power/Extractor.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Extractor.php#L187).

## Namespace templates and physical placement

A settings namespace is a **placement template ending in the declaration/file name**. It is not simply the text for PHP's `namespace` statement. The compiler:

1. Expands known placeholders in the template.
2. Splits on backslashes.
3. Removes the final backslash-separated segment.
4. Splits that final segment on dots, if present. Its last part becomes the PHP filename stem and must equal the resolved declaration name. Earlier dotted parts become subdirectories beneath `src` and namespace segments.
5. Uses the remaining backslash segments as the library prefix, joined with dots for the library directory name.
6. Combines the backslash prefix and dotted subdirectories for the PHP namespace. The complete class name includes the final declaration name.
7. Uses Joomla extension placement when its namespace resolver recognizes the target extension namespace; otherwise uses the configured Power library directory.

Examples below assume `NamespacePrefix = Acme` and `ComponentNamespace = Inventory`; those values demonstrate substitution, not settings to hard-code.

| Settings namespace | PHP namespace | Class | Ordinary library-relative placement |
| --- | --- | --- | --- |
| `[[[NamespacePrefix]]]\Joomla\Openai\Chat` | `Acme\Joomla\Openai` | `Chat` | `Acme.Joomla.Openai/src/Chat.php` |
| `[[[NamespacePrefix]]]\Joomla\Openai\Service.Api` | `Acme\Joomla\Openai\Service` | `Api` | `Acme.Joomla.Openai/src/Service/Api.php` |
| `[[[NamespacePrefix]]]\Joomla\[[[ComponentNamespace]]].Crypt.KeyLoader` | `Acme\Joomla\Inventory\Crypt` | `KeyLoader` | `Acme.Joomla/src/Inventory/Crypt/KeyLoader.php` |

The third row deliberately follows a real phpseclib wrapper's convention. The location of the last **backslash** matters: replacing all dots with backslashes in the settings changes the library boundary even if the eventual PHP namespace looks the same. Do not “normalize” it.

The default ordinary library parent in the inspected compiler is `libraries/jcb_powers`; `jcb_powers_path` can override it. A component namespace such as `[[[NamespacePrefix]]]\Component\[[[ComponentNamespace]]]\Administrator\Service.Provider` instead matches the extension path resolver and goes to `admin/src/Service/Provider.php` in the component build. Site, module and plugin routing also exists; inspect `Compiler/Joomla/Path.php` and the target extension build before asserting its installed path. A repository's `src/<guid>/code.php` path is never the installed class path.

Sources: [Power::setNamespace](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L460), [Joomla/Path.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Joomla/Path.php#L58), [Component/Placeholder.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Component/Placeholder.php#L134).

**Policy:** preserve placeholder spelling and case. Do not introduce an unknown placeholder without its provider, expected value, evaluation stage and validation case. Do not substitute values taken from a generated `code.php` into a portable source. The compiler's support for additional custom placeholders does not guarantee they exist in a consuming project.

## Dependency graph and lookup

| Source | Dependency effect |
| --- | --- |
| `extends` GUID | Loads a base class, creates the import and inheritance clause |
| `extendsinterfaces` GUIDs | For an interface, loads parent interfaces and builds its `extends` clause |
| `implements` GUIDs | Loads interfaces and adds their names to the declaration |
| `use_selection[*].use` | Loads Powers and emits namespace imports; `as` controls the import alias |
| `load_selection[*].load` | Loads Powers without automatically importing their names into this Power |
| `Super___...___Power` in active code | Requires token extraction and injection; include it in dependency analysis |
| `composer` | Registers external imports and autoloader access paths, not Power GUID dependencies |
| Enabled custom header/declaration strings | May depend on Joomla, PHP, Composer or other supplied symbols; inspect rather than assuming absence of a GUID means absence of a dependency |

`load_selection` does not instantiate a class, register a service provider or call its methods. A service-provider Power must still be registered through application/factory code. Namespace `use` in the file header is distinct from a trait `use` statement inside the class body. Loading/importing a trait does not itself apply it.

**Implementation:** when a required Power is absent from JCB's database, the compiler can attempt remote/local retrieval and retry. When a record is already present, it is read locally; fetching the latest Git commit does **not** automatically update an existing database record. Remote import has a `force` path; the exact JCB UI/update operation must be included in an integration test. Sources: [Power.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php#L360), [Remote/Get.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Get.php#L119).

**Implementation:** configured repositories are searched in order, within the chosen remote/local search order. The first matching indexed GUID wins for that search. Read and write branches are configuration values, not always the repository's default branch. Source: [Abstraction/Grep.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Grep.php#L907).

**Policy:** preserve `(repository, branch, commit, GUID, path)` provenance for every resolution. Do not flatten duplicate GUIDs into an unordered dictionary. New unrelated Powers must not collide. An intentional override/fork retaining identity must be explicitly authorized and reported with precedence and shadowed definitions. A dependency missing from the local repository is normal; a dependency unresolved across the configured catalogue is a blocker until the missing source is located or the target explicitly supplies it. Never generate a replacement GUID or delete a reference merely to make validation pass.

Check both dependency closure and compatibility: interface method signatures, constructor contracts, service identifiers, PHP named-argument names, target Joomla APIs, extension installation requirements and runtime configuration. A resolved GUID only proves identity discovery.

## Source, storage and generated PHP

| Layer | Representation |
| --- | --- |
| Repository `code.power` | Raw text for the members inside the declaration; no opening `<?php`, namespace or outer class braces |
| Repository `head` and `licensing_template` | JSON string values containing decoded text, with normal JSON escapes |
| Repository selection/composer fields | Native JSON arrays/objects/null or documented empty forms, not JSON strings containing another serialized document |
| JCB database | `head`, `licensing_template`, `main_class_code` use base64 storage; selectors use JSON storage |
| Compiler | Loads the database representation, decodes it, resolves custom code/placeholders and assembles PHP |

The repository layer must not be base64-encoded to imitate the database. JCB's data model performs the transformations. Sources: [Table.php: power fields](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php#L3963), [Model/Load.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Model/Load.php#L39), [Model/Upsert.php](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Model/Upsert.php#L39).

The compiler's exported `code.power` uses the preserved unexpanded body. Its linker exports preserved namespace/header/custom-field values, while its `code.php` representation uses the processed namespace, imports, description, declaration and body. The direct remote exporter writes settings/body/readmes and index entries; it does not itself generate the full `code.php` representation. These are different export paths, so byte-for-byte identical settings ordering or empty forms are not guaranteed. Sources: [Infusion::code/raw/linker](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Infusion.php#L403), [Remote/Set::createItem](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Set.php#L425).

**Policy:** maintain the generated representation in the same change; use a real JCB export for complex compilation features. A local representation generator may support an explicitly bounded subset. It must fail clearly on unsupported constructs and must not claim to replace JCB. Do not require raw-body substring equality where placeholders or custom code legitimately expand; check semantic correspondence in the chosen context and the original source separately.

## Invalid authoring patterns and their corrections

| Invalid or misleading pattern | Correct treatment |
| --- | --- |
| Updating only `code.php` | Change the body/settings, then refresh derived files |
| Copying an example GUID for a new utility | Generate UUIDv4 and check current catalogues |
| `namespace` without its final class name | Include the matching declaration/file name in the settings template |
| Hard-coding `VDM` because it appears in an index | Preserve the source placeholder and state the generation context |
| Treating `add_licensing_template: 1` as “custom enabled” | `1` selects global licensing; `2` selects nonempty custom licensing |
| Treating `"-1"` as a missing GUID | It is the custom inheritance/interface sentinel where applicable |
| Replacing empty body with fabricated methods | Preserve a valid empty wrapper and verify its dependency |
| Assuming `composer` installs packages | Supply and document the library/autoloader installation independently |
| Treating all missing/null/empty values as interchangeable | Apply [field-specific rules](settings-reference.md), preserving established forms |
| Assuming a successful import compiled the whole graph | Run the stated compilation/runtime checks; report their limits |

## Conformance boundary

Static conformance requires valid JSON, matching identities, valid paths, a coherent namespace template, legal field shapes, resolved required dependencies, compatible declarations, source/representation consistency and up-to-date documentation. It also requires a stated target PHP/Joomla/JCB compatibility range and preserved licences.

Integration conformance requires importing/updating the intended GUIDs in an isolated target JCB instance, compiling representative consumers, checking generated paths/imports/autoloading and exercising changed behaviour. Repeat with a different namespace prefix and component namespace when portability changed. A local schema or PHP syntax check cannot establish those facts. Report actual execution evidence separately from source inspection and proposed checks.
