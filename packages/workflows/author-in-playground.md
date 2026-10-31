# Author a package in Playground and Push its source

This path starts with JCB's forms, then exports the saved authoring graph through **Push** to an authorized GitHub/Gitea candidate branch. It is suitable for creating a new application or editing a known package graph. It does not require writing every JSON record by hand.

## Inputs and preparation

Have a concrete feature design, supported Joomla/JCB/PHP target, chosen root type, repository/base/candidate branches, source and dependency revisions, and the intended publication scope. Start with [repository creation](create-repository.md) if the destination is empty. The remote candidate branch must exist at a recorded initial commit. Use the [shared Playground setup](../../testing/playground/README.md) and [configuration reference](../../testing/playground/configuration.md); verify the installed JCB version rather than treating a deployment recipe label as proof.

Select a disposable JCB site and give saved sites distinct names. Preserve intentional local work before importing over an existing identity. For an existing application, acquire its graph using the appropriate [operation scope](README.md#operation-scopes-that-govern-these-workflows) before editing. For a new application, use fresh identities; do not rename an imported root and assume all shared child/Field/View identities became new.

## 1. Prepare external dependencies and the saved graph

Choose the application's real graph first. Steps 3–5 describe the CRUD component exercise; a module with component options does not need an unrelated Admin View or database table. For that path, use the module/settings instructions immediately below the sequence.

1. Inspect the required Field Types through their own repository target (`3`), starting with the official `joomengine/joomla-fieldtypes` and any project additions. Import missing types using the [Field Type procedure](../../field-types/workflows/validate-and-integrate.md). Verify actual local GUIDs, properties and defaults. A package's declared `fieldtype` edge does not run the separate Field Type importer automatically.
2. Resolve any Super/Joomla Power references in their own ordered catalogues and target-compatible code. Follow Joomla/core reuse first, then the shared Super Powers foundation, then specialist implementations. Record exact dependencies and selected provenance; do not add unrelated package-local copies.
3. Create concrete **Fields** in JCB. Choose each Field Type by GUID, set the actual XML name/type/label/properties and the required validation. Set datatype, length/custom length, default/custom default, nullability, indexes and storage deliberately. Field Type examples/default suggestions are not a substitute for the application's data contract. Save and reopen.
4. Create the required **Admin View**. Set its system/singular/plural names and target-specific options. In its field association editor, attach the saved Fields with intentional ordering, tab, edit/list/search/filter/title/alias choices. The exported `admin_fields` child must preserve these row settings, not just Field GUIDs. Add field relations/conditions/custom tabs only where needed. Save and reopen the associations.
5. Create the **Joomla Component**, set its code name, display/system names, version, author/license details and preferred Joomla target. Add the Admin View through its component association editor, choosing menu/dashboard/ACL/API and order options appropriate to the design. Save and reopen. The component's `component_admin_views` linking record is part of the maintained graph.
6. Add required Site/Custom Admin Views, Dynamic Gets, layouts/templates, configuration, router, assets, modules/plugins or update records through their actual editors and associations. Each feature needs a real component link or code reference. An unassociated record elsewhere in JCB will not become part of this root merely because it exists in the database.
7. Inspect all newly generated identities against the current visible catalogues and the pending graph. Preserve keys for deliberately shared or updated records; record intentional overrides. JCB's save-time local uniqueness check does not establish absence from all remote sources. Natural-key entities and parent-key child records follow their own contracts.

The CRUD exercise's minimal result is a Component linked to an Admin View containing a concrete Field. Expand it to match the actual feature rather than using that shape as a universal production design. Use the [entity references](../reference/README.md) to interpret the controls and serialized values. The installed version can label or arrange tabs differently; confirm saved fields and references, not just the screen labels.

For a **Joomla module with component settings**, follow [Extensions](../models/extensions.md) and [Component options](../models/component.md#options-menus-and-dashboards):

1. Create the Module through **Joomla Modules**, with fresh checked GUID, names/version, explicit client (`joomla_module.target=1` site or `2` administrator), and actual entry/template/helper code in the correct slots. Enable only the helper/header/code features required by the requested behaviour. Do not fabricate a full class in a method/body slot.
2. Create/reuse the concrete configuration Fields. Attach module parameters through `joomla_module.fields`: set `module=1` for module configuration, the intended `fields_name`/`fieldset` and nested Field GUIDs/custom values. Other form groups and custom Field/rule paths need their own explicit settings. These parameters do not independently create an application table.
3. Create/reuse the consuming Component. Add component-level settings through `component_config.addconfig`, whose rows contain Field GUID, `custom_value` and `tabname`. Module parameters and component options are distinct stores; the implementation must deliberately read the intended source. Do not claim they synchronize automatically.
4. Attach the Module through the Component's `component_modules.addjoomla_modules` rows. Its `target=0` means compile and export, `1` compile only, `2` export only. This flag is distinct from the Module's site/administrator client. The documented compiler path uses this consuming-component attachment; no standalone compiler selector is assumed.
5. Save/reopen both root and child/nested settings, then export and validate the actual graph below. Inspect emitted component options and module forms/manifest/code. Install, configure and publish the module in the correct client/position/menu context; save/reopen component options and module parameters independently, then exercise their actual consuming behaviour.

The [Module](../reference/joomla_module.md), [component module links](../reference/component_modules.md), [component configuration](../reference/component_config.md) and their linked JSON references give exact fields and nested options. A plugin follows its separate group/class/event path in the Extensions guide; do not substitute module client/position rules.

## 2. Make the Push destination and credentials concrete

Open JCB **Repositories** in the disposable site. Inspect all effective package connections, including configured/fallback entries and globally inherited credentials. Record the destination's:

| Setting | Expected value |
| --- | --- |
| Content target | Packages (`4`) |
| Provider | GitHub (`2`) or Gitea (`1`), matching the real host |
| Host/organization/repository | Exact authorized destination; no credential in the URL |
| Published state/order | Effective source configuration recorded; archived state can still qualify in the inspected helper |
| Read branch | Explicit branch for later acquisition; independent of the write branch |
| Write branch | The authorized existing candidate branch, never an unintended integration/production branch |
| Access setting | A working repository override or intentionally selected global credential |
| Author name/email | Intended commit attribution where configured |

**Inspect every effective writable Packages connection before Push.** In the inspected implementation, the default package setter accepts every repository with a nonempty write branch other than literal `default`. Selecting one root selects source records, not a destination. Selecting one source during Init/Pull does not restrict a later Push. In this disposable site, clear the write branches of all unintended connections or otherwise remove them from the effective configuration; retain needed read-only dependency sources. Confirm the effective result rather than assuming a disabled row removed a fallback. Include any service-specific writable targets used by the selected graph in the audit.

Use an already authorized credential capable of writing repository content to the intended candidate and satisfying its branch protections. Configure it through JCB's password **Token** field (or the deliberately selected global setting). Limit its repository access to the task's destination where the provider supports that. Check the provider's current permission model when creating a credential; a read-only/public fetch token does not prove write access. Never put tokens in chat, repository files, launch URLs, screenshots, command arguments or a public test receipt. Use the supported credential-entry/handoff flow if user input is required.

If no suitable credential or write authorization is available, finish/save the local authoring graph and perform independent checks. Report **Push not run: missing authorized write access**. Do not click Push with guessed credentials, claim a remote export occurred, or change an unrelated repository to make the step pass. A whole-site backup can preserve work under the shared guide, but is not a package repository export and may contain credentials/private state.

## 3. Preflight the source graph and publish the candidate

Capture the selected root key, intended reachable records/assets, local changes, all writable destinations and each candidate's starting commit. Preserve a JCB/site checkpoint when needed. If the graph was imported, compare intentional edits with the source baseline before export; shared records can belong to other roots too. Review code/assets for private data and licensing before publication.

When this concrete write falls within the task's authorization, select the component in **Joomla Components** and invoke **Push** (`joomla_components.pushPowers`; the edit form also provides `joomla_component.pushPowers`). Use the supported authenticated button flow and normal permissions. Do not use Init/Pull as an export operation. Source-backed scopes and pinned controller links are in [Workflow operations](README.md#operation-scopes-that-govern-these-workflows).

Capture every area/repository success, warning and error. The builder recursively processes discovered records and files/folders. It performs multiple remote writes; it is not one atomic graph commit. A successful root message, or one successful destination, does not establish that all required dependencies/assets reached every intended destination. Keep the candidate isolated from production throughout the operation.

## 4. Inspect the actual remote export

Fetch the candidate after Push and compare the exact before/after commits. Inspect the whole diff, including generated indexes and README files, settings and raw assets. Confirm:

- Only authorized destinations/branches changed, with no secret or unintended private content.
- The selected root and required linking records exist at the Config-defined paths. Parent keys, natural keys and shared identities remain correct.
- Code/collections/XML survive the documented serialization; no truncation, double encoding or accidental coercion occurred.
- Required dependency rows, supporting records and assets are present or have explicit external resolution. Power tokens and Field Types still need their separate checks.
- Index summaries agree with settings. Existing-item update and new-item create take different paths: the inspected setter accumulates index updates for newly created items; changed existing names/descriptions can leave stale index summaries. Inspect and repair an actual discrepancy in the candidate source using the contract instead of trusting the toast.
- No unrelated records were deleted or copied from the source instance merely to satisfy a missing link.

Run `bash tools/validate-package-repository.sh CANDIDATE_DIR`, adding ordered `--with SOURCE_DIR` inputs required by the graph as documented in [Tools](../../tools/README.md). Retain nonzero results and resolve or explicitly report them. Review a partial export before retrying: compare remote state first, correct the cause, and retry only the needed authorized operation. Never force-push over concurrent work.

## 5. Prove portability in a fresh instance

Follow [integration acceptance](validate-and-integrate.md), especially the fresh-instance round trip. Start a second JCB instance with no local candidate records, configure the candidate's actual **read** branch, explicitly prepare external Field Types/Powers, acquire the root, inspect saved records, compile the real component, install and exercise it. The source authoring instance can hide missing exports because it already contains dependencies and files.

If write testing is in scope, make a controlled saved change in that second instance, Push it to the isolated candidate, inspect its remote diff, then Pull the resulting revision into a third clean instance or a clean preserved checkpoint. Record exact revisions and compare substantive data, not local numeric IDs or legitimately generated metadata. A second no-change export is a useful stability check; report any drift instead of normalizing it away without evidence.

Deliver the PR/diff, root/identity ledger, source and runtime revisions, destination audit without secrets, before/after commit(s), validation results, actual round-trip stages and unresolved limitations. The compiled extension download and Playground backup are separate artifacts; label them accurately. Do not merge automatically.
