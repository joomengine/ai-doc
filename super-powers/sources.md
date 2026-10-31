# Sources, evidence scope, and refresh procedure

This ledger identifies the implementation and repository specimens used by the [Super Powers module](README.md). It records evidence, not an assertion that every line of every dependency was audited. Follow the [specification](specification.md), [settings reference](settings-reference.md), and selected workflow for the operational rules derived from these sources.

**Inspection date:** 31 October 2026. Moving branch names are discovery inputs. Commit IDs identify what was actually inspected. Refresh affected evidence before making a change against a newer target.

## Authority order

| Question | Authority | Boundary |
| --- | --- | --- |
| Which implementation should be reused? | Project policy: supported Joomla core/framework first, the central `joomengine/super-powers` foundation next, relevant specialists next, new code when needed. | Reuse preference does not excuse a compatibility defect; inspect the selected capability and supported versions. |
| What does JCB accept, export, and compile? | The relevant JCB implementation at the selected revision, including its forms, metadata, transport, and compiler collaborators. | A single settings example cannot establish all field semantics. |
| What do published repositories contain? | Their exact indexes, settings, bodies, generated views, and licenses at pinned commits. | An existing inconsistency is evidence of that specimen, not a recommended authoring rule. |
| Why is the architecture arranged this way? | The [architecture publication and source map](../architecture/README.md). | Its implementation pins differ from the current module inspection. |
| Does the changed Power actually work? | Recorded structural checks, affected behaviour tests, JCB import/compile results, and runtime checks appropriate to the change. | Static source inspection is not a live compilation certificate. |

## JCB implementation baseline

Primary inspection: [`vdm-io/Joomla-Component-Builder`, `6.x`, `408703a857ad937479b1e28de7f693af178dcc83`](https://github.com/vdm-io/Joomla-Component-Builder/tree/408703a857ad937479b1e28de7f693af178dcc83).

The corresponding `5.x` snapshot was [`eb4bacd7a549fb2f13b48b993c4efac85e7f0029`](https://github.com/vdm-io/Joomla-Component-Builder/tree/eb4bacd7a549fb2f13b48b993c4efac85e7f0029). The inspected Power transport subtree, `Compiler/Power.php`, the compiler Power subtree, and `admin/forms/power.xml` had no differences between those two captures. This comparison establishes those paths' agreement; it does not establish that Joomla 5 and Joomla 6 runtime APIs or every JCB subsystem are interchangeable.

The following links are pinned to the primary inspection. Paths in the first column are relative to `libraries/vendor_jcb/VDM.Joomla/src/`, except where explicitly rooted at `admin/`.

| Source | Responsibility to verify |
| --- | --- |
| [`Componentbuilder/Power/Grep.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Grep.php) | Reads indexed settings and `code.power`; places body text in `main_class_code`. This is the import boundary, rather than `code.php`. |
| [`Componentbuilder/Power/Remote/Config.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Config.php) | Defines `super-powers.json`, `settings.json`, index columns, exporter placeholder defaults, and excluded approval/access fields. |
| [`Componentbuilder/Power/Remote/Set.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Remote/Set.php) | Normalizes exported relationships and splits settings/body; constructs paths and resolved index namespace. |
| [`Abstraction/Grep.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Grep.php) | Traverses configured repositories; inspect lookup order and fallback conditions before resolving duplicate GUIDs. |
| [`Abstraction/Remote/Config.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Config.php) | Supplies inherited configuration and map-building behaviour used by the Power transport. |
| [`Componentbuilder/Table.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Table.php) | Describes `power` fields, storage transforms, and relationships. Read the Power section rather than applying unrelated entity fields. |
| [`Model/Load.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Model/Load.php) and [`Model/Upsert.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Model/Upsert.php) | Apply storage decoding and encoding. Repository text is not the database's encoded representation. |
| [`Componentbuilder/Power/Service/Power.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Service/Power.php) | Wires the Power services and selected collaborators; trace the actual implementation behind a service name. |
| [`admin/forms/power.xml`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/power.xml) | Defines form options, flags, conditional fields, and subform shape. UI constraints and compiler handling are related but distinct evidence. |
| [`Componentbuilder/Compiler/Power.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power.php) | Acquires and prepares Powers; processes namespaces, dependencies, headers, body code, and target context. |
| [`Componentbuilder/Compiler/Power/Selection.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Selection.php) | Applies selection and export gating; distinguishes loaded Powers from items selected for publication. |
| [`Componentbuilder/Compiler/Power/Infusion.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Infusion.php) | Assembles Power code and repository-facing generated material. |
| [`Componentbuilder/Compiler/Power/Injector.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Injector.php) | Resolves embedded Power identities into per-file symbols and imports; inspect alias collision handling. |
| [`Componentbuilder/Compiler/Power/Autoloader.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Power/Autoloader.php) | Processes autoloading and Composer access paths relative to `JPATH_LIBRARIES`. Metadata alone does not install a library. |
| [`Componentbuilder/Compiler/Component/Placeholder.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Component/Placeholder.php) | Supplies component-context placeholders; distinguish these from repository preview defaults. |
| [`Componentbuilder/Compiler/Joomla/Path.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Joomla/Path.php) | Maps Joomla extension source locations for placement-sensitive Powers. |
| [`Componentbuilder/Compiler/JoomlaPower.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/JoomlaPower.php) | Resolves Joomla Power mappings. This is a different payload and contract from a reusable Super Power class. |

Before relying on a class's behaviour, follow the called collaborators and relevant inherited implementation. A filename or method name alone is insufficient evidence. Source comments are useful intent; executable conditions decide the behaviour being documented.

## Official repository inspection

The machine-readable discovery and snapshot records live in [`registries/power-repositories.json`](../registries/power-repositories.json). That registry is the canonical list for tooling. The table here states each repository's role and points to the inspected revision; avoid adding an independently maintained copy of every GUID to this documentation.

| Repository | Role | Inspected revision |
| --- | --- | --- |
| [`joomengine/super-powers`](https://github.com/joomengine/super-powers) | Central shared foundation and project reference standard for reusable JCB code. | [`9cd980492bed4c8177a6e32b703641950ec93604`](https://github.com/joomengine/super-powers/tree/9cd980492bed4c8177a6e32b703641950ec93604) |
| [`joomengine/search`](https://github.com/joomengine/search) | Specialist search infrastructure. | [`b1335ddfd6149c95f6037d3d64459334cd0f5bd7`](https://github.com/joomengine/search/tree/b1335ddfd6149c95f6037d3d64459334cd0f5bd7) |
| [`joomengine/psr`](https://github.com/joomengine/psr) | PSR-related interface definitions represented as Powers. | [`451da5e55ec5ea3a26b7ec44cfe2ec141cc42fd8`](https://github.com/joomengine/psr/tree/451da5e55ec5ea3a26b7ec44cfe2ec141cc42fd8) |
| [`joomengine/phpseclib`](https://github.com/joomengine/phpseclib) | phpseclib integration Powers. | [`77dce1558dbb8b003629d06b7ebb0950f386e2e0`](https://github.com/joomengine/phpseclib/tree/77dce1558dbb8b003629d06b7ebb0950f386e2e0) |
| [`joomengine/openai`](https://github.com/joomengine/openai) | OpenAI client Powers and service providers. | [`96e575e55fd66d8d190c65e6e1de1e7c4577d29d`](https://github.com/joomengine/openai/tree/96e575e55fd66d8d190c65e6e1de1e7c4577d29d) |
| [`joomengine/gitea`](https://github.com/joomengine/gitea) | Gitea client Powers and service providers. | [`6f94a230be9c7ce93f773bb6d1de9dbf147fba5a`](https://github.com/joomengine/gitea/tree/6f94a230be9c7ce93f773bb6d1de9dbf147fba5a) |
| [`joomengine/minify`](https://github.com/joomengine/minify) | Minification-related Powers. | [`8c33c85f6fa22eceb4a1ed0990fa63769fe8ec08`](https://github.com/joomengine/minify/tree/8c33c85f6fa22eceb4a1ed0990fa63769fe8ec08) |

At these snapshots the seven indexes contained 366 entries. That count is a dated inspection result, not a registry invariant or a future uniqueness check. A new Power must be checked against refreshed indexes and any additional repositories configured for the task. The published registry establishes the owner's required baseline; it cannot prove absence from every private or unknown repository worldwide.

The checked-in examples are selected specimens with identified roles and provenance. They demonstrate formats and relationships; they are not automatically preferred implementations for every target or task. See [examples](examples/README.md) and [reuse policy](reuse-and-dependencies.md).

## Evidence refresh procedure

1. Record the task's JCB branch/release, supported Joomla/PHP versions, target Power repository, and ordered additional dependency sources. Do not infer those from an unrelated project's plan.
2. Resolve each moving source ref to an exact commit before inspection. Capture the repository URL, ref, SHA, fetch time, index path, and relevant paths together. Never combine an index from one revision with settings from another without explicitly reporting the mismatch.
3. Read the current source for every affected rule. For serialization changes, compare configuration, export, import, metadata, forms, and real specimens. For compiler changes, follow preparation, injection, and final output paths. For framework reuse, inspect the target-compatible Joomla API.
4. Compare old and new evidence. Classify a difference as changed implementation, changed example, existing defect, or unresolved gap. Do not silently change a documented policy to accommodate an accidental defect.
5. Update the canonical contract, dependent workflow, example/schema/check, and registry inspection record in the same change when the difference affects them. Preserve the old pin if the text still describes a historical claim.
6. Run the relevant validation and record the exact result. A network failure means the live check is incomplete; a cached catalogue is usable only with its revision and limitations stated. Do not report offline evidence as freshly fetched.
7. In the PR, identify source revisions, changed behavioural claims, checks that ran, and checks that did not run. Separate repository validation from JCB import/compile and generated application runtime validation.

## Known scope limits

- This module documents the PHP Super Power repository contract and selected integration behaviours. It does not claim complete coverage of Joomla Powers, package/blueprint serialization, JavaScript/TypeScript Powers, or compiler internals.
- Runtime API compatibility belongs to the specific class and target combination. Correct GUIDs and valid settings do not prove an OpenAI or Gitea endpoint is current, or that an upstream package is installed.
- Source comparisons and checked-in fixtures do not substitute for importing a changed Power into JCB, compiling a consumer, and exercising its affected behaviour. Report unavailable integration checks explicitly.
- The architecture publication has its own edition and evidence scope. Its older compiler pin and integrated extrusion fingerprints must not be relabeled as a full audit of the current branch.
- No identity catalogue can prove universal uniqueness outside the repositories inspected. Secure UUIDv4 generation plus the required live collision checks is the authoring policy; it is not a claim of exhaustive global discovery.
