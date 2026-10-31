# Migrate a package to another supported target

## Inputs and scope

Record the currently supported and proposed Joomla/JCB/PHP versions, exact source contracts, component roots and dependent catalogues, baseline package commit, installed component version, representative persisted data, and compatibility commitments. State whether this is an update of the same product, an additional supported target, or a separate product fork. Keep its identity decision explicit.

Use the [shared Playground configuration](../../testing/playground/configuration.md) to select an actually available target and verify the installed versions. A planned Joomla release or a different selected compiler target does not establish runtime support. An attachment's Joomla 6-only project scope is not evidence that every historical repository specimen supports Joomla 6.

The output is a reviewable migration with source changes, target-specific compilation/runtime evidence and an upgrade/recovery plan. Updating only `preferred_joomla_version` is not a completed migration.

## 1. Compare contracts and runtime APIs

1. Pin both JCB revisions. Compare affected Remote Config fields/ignored values/identity/child rules, Table metadata, XML forms/subforms/options, SQL and compiler transformations. Use the [entity references](../reference/README.md) and [source map](../sources.md), regenerating references against the new inspected source when appropriate. Do not execute arbitrary downloaded source merely to inspect metadata.
2. Inspect Joomla's actual target code for used field classes, inheritance/layouts/attributes, validation rules, component service/namespace/router/event APIs, assets, permissions and extension manifests. Identify removed or changed behaviours and minimum PHP requirements.
3. Resolve the exact target-compatible Field Types, Super/Joomla Powers, libraries and other package dependencies. Preserve order and provenance. A shared GUID can select changed code in another catalogue revision; a compatible name is not enough.
4. Inventory custom PHP/JavaScript/XML/SQL, placeholders and generated code assumptions. Inspect the smallest affected [model guide](../models/README.md) for each change. Keep unsupported or unverified features explicit rather than silently dropping them.

## 2. Apply a complete source migration

Preserve stable record keys for an upgrade of the same product. If creating a genuinely separate product, allocate/remap the entire owned identity graph coherently and retain shared external identities only when intentionally reused. Do not retain another product's GUIDs accidentally or generate new keys merely to avoid resolving an incompatible existing record.

Update the root's target/version settings and all affected source records, nested associations, feature flags and code. Use only options and value representations supported by the destination contract. Preserve portable placeholders and fix code at its authoritative layer, not only in a generated file.

For database changes, specify the original and intended schema/storage, transformation of existing values, indexes/null/default semantics and update sequencing. Concrete Field changes do not automatically migrate an already-installed table. Add the appropriate component update definition/SQL where required, and inspect the emitted upgrade artifacts. A destructive change needs the task's actual data-loss authorization and recovery plan; ordinary reversible source/testing work needs no extra approval pause.

For renamed natural keys, field/column names, namespaces, routes or asset paths, update all references and provide compatibility/migration where old consumers require it. For custom Field Type or Power changes, maintain those sources through their respective modules rather than disguising them as package-owned records.

## 3. Test new and existing consumers separately

Run source validation with the target-compatible ordered dependencies, then [package acceptance](validate-and-integrate.md). Use a clean target JCB instance and explicitly acquire external types/Powers. Compare saved values against source: old form save paths can apply different defaults or strip unsupported properties.

Compile the actual migrated component for the proposed Joomla target, inspect XML/PHP/SQL/assets/manifests, and lint on the minimum and other supported PHP versions affected by the change. Then run both:

| Scenario | Required evidence |
| --- | --- |
| Fresh install on the new target | Successful install, expected schema/registration and real feature runtime cases |
| Existing installation update | Baseline component with representative records/configuration → authorized target/component upgrade sequence → preserved/transformed data and runtime behaviour |
| Continued old-target support, if claimed | Old target compile/install/runtime still passes; otherwise document the intentional support boundary |
| Shared dependent roots | Affected consumers compile and exercise the changed shared definition, or a justified bounded representative set with remaining limits |

Include valid/invalid/empty/zero/boundary values, ACL and relationship cases relevant to the changed feature. Browser success does not prove native server facilities or every host version. Use an authorized native environment for requirements outside Playground's support and record the gap if unavailable.

## 4. Review, publish and recover

Keep changes on the candidate branch and show a complete diff with identity policy, supported-version change, source revisions, dependencies/order, migration instructions and actual matrix results. If GUI-authored, follow the [Push audit](author-in-playground.md) and inspect remote export before acceptance. Preserve the baseline artifact/data snapshot and generated candidate artifact hash. Do not merge or deploy to production merely because a test build passes.

If migration fails, retain the failing artifact and minimal data case. Restore the disposable baseline or use a tested corrective migration; source rollback alone cannot reverse transformed data or platform upgrades. Correct the authoritative source, recompile and rerun the failed upgrade route. Report untested native/old-target/upgrade scenarios explicitly instead of claiming universal compatibility.
