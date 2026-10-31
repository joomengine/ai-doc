# Maintain an existing package graph

## Inputs and change boundary

Have the owned repository/candidate branch and baseline SHA, affected root(s), intended behaviour, JCB/Joomla/PHP targets, ordered package/external source revisions, and any existing consumer/data compatibility commitments. Read the affected [model guide](../models/README.md), [entity reference](../reference/README.md) and [serialization contract](../specification.md). Use [Playground authoring](author-in-playground.md) for GUI changes or edit the authoritative repository definitions directly; keep the two representations synchronized through the documented acquisition/export path.

The output is a coherent graph diff with affected-consumer evidence. A repository can contain shared Fields, Views, code, libraries or assets used by multiple component roots. The selected root's directory is not an ownership boundary for everything it uses.

## 1. Establish identity and impact

1. Capture the current root closure and reverse references to each changed key, including references in other authorized package repositories and embedded code. Record the checked sources and inaccessible-source limits. Check the configured winner and shadowed definitions for every intentional override.
2. Preserve keys for changes to the same component/record. A deliberate fork override also preserves identity and documents required order. Allocate fresh identities only for genuinely independent records; copy all needed links coherently when creating a separate application.
3. For a natural-key rename, treat the change as a reference migration. Update every caller/token/index/path and decide whether old consumers need a compatibility definition. Changing only `function_name`, Placeholder `target` or Validation Rule `name` leaves broken callers.
4. Identify public consequences: generated names/namespaces/routes, schema/storage, PHP signatures, ACL, saved configuration, fields/forms, asset paths and supported targets. If compatibility cannot be retained, provide an explicit migration and version policy rather than hiding it in a description edit.

## 2. Edit the authoritative graph

For repository edits, update settings and corresponding indexes/README/assets together using Config-defined paths. Preserve scalar/encoding semantics and unrelated shared entries. Refresh actual dependency metadata after changing references, child associations, subform Fields or embedded code; inspect implicit Power and other code references separately. Read the [relationship guide](../models/fields-and-relationships.md#choose-the-relationship-mechanism) before adding a selector/query or application relation.

For GUI edits, acquire the correct candidate into a disposable instance, preserve local changes, edit/save/reopen through JCB, then follow [Push preflight and export](author-in-playground.md). Audit all writable destinations. Capture the remote diff; a root export can include shared dependencies beyond the record that was visibly edited. Existing-item index summaries may require a deliberate source correction after export.

Keep these changes explicit:

| Change | Required companion work |
| --- | --- |
| Add a Field to a View | Concrete Field source plus `admin_fields` association options and external Field Type resolution |
| Add a View to a Component | View/children plus the correct component linking record and menu/ACL/order choices |
| Change XML/property or Field Type | Existing/new Field comparison; saved XML and current type metadata can interact; use the [Field Type maintenance procedure](../../field-types/workflows/maintain-and-debug.md) |
| Change datatype/default/storage or rename a column | Concrete Field/schema choices, upgrade/data migration, validation and save/reload checks; metadata refresh is not a database migration |
| Change relationship/query | Target key/table/view, query/result shape, selector values, indexes, ACL and missing-target behaviour |
| Add/replace files or folders | Payload and index consistency, hashes/paths/licensing, consuming manifest/reference and actual acquired/installed bytes |
| Remove a record | Reverse-reference audit, root/child associations, index and payload changes, compatibility plan and explicit consumer update |

Repository absence is not a deletion instruction to already-imported JCB records or installed sites. Push is not a garbage collector. Do not delete shared source records simply because one root stops using them, and do not infer that a missing remote record removes a local one. Make any authorized local cleanup and deployed migration a separate, reviewable action.

## 3. Refresh the intended local state

Choose the [actual operation](README.md#operation-scopes-that-govern-these-workflows) for the change:

- Ordinary Init can skip an already-local root and therefore never inspect new remote dependencies. It is insufficient evidence of an update.
- Pull explicitly refreshes from the selected source and carries that source through recursive dependencies. Ensure that source contains the needed package graph; do not assume cross-repository fallback.
- Reset verifies configured-order replacement for selected local items and inward/direct children. Resetting the component does not refresh all outward Views, Fields or code. Pull/refresh those intended records through the appropriate supported flow or reacquire the full candidate in a clean instance.

Inspect the distinctive changed values and dependencies after the operation. Keep required external Field Types/Powers separately current. Reopening an editor, clearing a browser cache, editing a generated file or recompiling without refreshing the authoritative local record does not apply a repository change.

## 4. Validate and review

Run `bash tools/validate-package-repository.sh REPO_DIR` with the needed ordered `--with SOURCE_DIR` arguments. Follow [full acceptance](validate-and-integrate.md), compiling every materially affected root or a justified representative set with stated limits. Compare baseline/candidate generated output and run installation/update/data/runtime cases relevant to the change. For a shared entity, exercise the existing consumer as well as the new use that motivated the change.

Review the complete diff, key stability, reverse-impact analysis, dependency selection, candidate commits, actual stages/matrix and migration steps. If upstream contracts changed, regenerate/reinspect references and rerun affected checks; do not update a baseline label without evidence. Keep the PR current and do not merge automatically.

## Failure and recovery

If a refresh used the wrong winner, preserve the observed local values, fix the effective source order/branch and repeat the appropriate operation. If an export is partial, inspect its remote commits before retrying. If a change fails after schema/data migration, restore from a preserved disposable baseline or apply a designed corrective migration; reverting source alone is insufficient. Carry diagnostic generated-file fixes back to the maintained authoring source and rebuild. Use [debug integration](debug.md) for mismatches across representations.
