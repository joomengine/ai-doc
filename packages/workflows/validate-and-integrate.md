# Validate, import, compile and exercise a package

## Acceptance boundaries

| Stage | What a pass establishes | What it does not establish |
| --- | --- | --- |
| Source structure | Checked locators, record shapes, identities and declared references agree under the tool's profile | Complete scanner coverage or valid application behaviour |
| Acquisition | Intended records/assets exist in the tested JCB database/filesystem | External catalogues were imported or all downstream code works |
| Push/export | Inspected destination commits contain the expected source graph | Atomic publication, portability or successful compilation |
| Fresh-instance round trip | Another clean instance can acquire the tested graph and preserve its intended values | Every component root or target matrix |
| Compilation | The actual selected consumer produces inspected artifacts | Installation, upgrade and runtime success |
| Installation/runtime | Named scenarios pass on the tested Joomla/PHP/runtime | Native platform behaviour or untested versions |

Use [Playground](../../testing/playground/README.md) by default for authorized package implementation tests, with its [configuration guide](../../testing/playground/configuration.md). Follow the shared setup, artifact export, Code/debugging, persistence and recovery procedures. This page adds package-specific assertions. Record actual outcomes in [package verification](../verification.md); the [shared verification record](../../testing/playground/verification.md) proves only its stated observations. Neither an earlier Power import nor this written procedure is a package pass.

## 1. Freeze inputs and check structure

Record the selected root entity/key, candidate repository/read branch/commit, baseline commit, JCB contract revision, exact installed JCB/Joomla/PHP versions, browser/Playground build, and intended target matrix. Include ordered package/dependency catalogues with exact commits, selected and shadowed identities, asset origins and licensing. The [examples](../examples/README.md) distinguish fixtures from real learning specimens; use their actual branches and do not relabel an example as newly authored production source.

From this documentation checkout, run the applicable command with existing paths:

```bash
bash tools/validate-package-repository.sh /absolute/path/candidate \
  --with /absolute/path/package-dependency \
  --with /absolute/path/joomla-fieldtypes
```

The tool's candidate-first input order is not proof of JCB's effective repository order. It reads the supplied local bytes without fetching or asserting freshness. Exit `1` identifies malformed/unsafe input; exit `2` identifies unresolved references. Add `--report NEW_REPORT_FILE` for retained provenance/order, selected/shadowed occurrences and findings. Read [Tools](../../tools/README.md) for accepted external catalogue shapes and incomplete coverage, including local database-ID links and token-derived dependencies. Inspect the selected root's closure, reverse users of changed shared records, embedded code references and external dependencies. Missing references remain unresolved until a known source is checked; do not omit them or silently weaken the application to pass validation.

## 2. Configure acquisition and external sources

In a separate test JCB site, configure the candidate as **Packages** target `4`, actual GitHub/Gitea provider/host/owner/name, enabled state, intended order and explicit read branch. Keep write branches empty for read-only acquisition tests. The packaged fallback may point to legacy Gitea `joomla/packages`; do not assume it means GitHub `joomengine/packages`. Inspect the effective source set and provenance as described in the [shared guide](../../testing/playground/README.md#3-configure-the-candidates-real-jcb-repository-connection).

Import the required Field Types using their separate target `3` and [acceptance path](../../field-types/workflows/validate-and-integrate.md), including the official core catalogue and project additions. Configure/resolve Super Power and Joomla Power sources separately. Check local values and target compatibility. Package Builder skips unavailable service handlers; a dependency row alone does not guarantee the external definition is acquired.

For package dependencies distributed across repositories, account for the selected-repository constraint: Init/Pull propagates that selected repository to dependency retrieval. Prepare required shared package records from their actual repositories before an ordinary Init, or use a coherent candidate export containing the required package graph. Ordinary Init can reuse existing local records. Forced Pull instead tries the selected source even for existing records; record not-found results and do not describe this as an automatic fallback to other repositories. External/global catalogues remain separate.

## 3. Exercise Init, Pull and Reset as distinct tests

Use **Joomla Components** and its supported authenticated toolbar. The [operation table](README.md#operation-scopes-that-govern-these-workflows) gives exact controllers and implementation evidence, including Module, Plugin, Admin View, Field and Library entry routes. Use the matching list/controller for those entities; for another model inspect its actual controller and Remote Config instead of substituting the component task or inferring the area name from a display label.

| Test | Setup and action | Required observation |
| --- | --- | --- |
| New acquisition | Clean instance; Init, choose the candidate repository and intended root | Root and each expected reachable record/asset actually saved; result log interpreted record by record |
| Existing local preservation | Save a harmless local marker, then reopen Init selection | Already-local rows are marked local and disabled for selection in the inspected UI. Confirm the existing record remains intact without bypassing that guard; do not report a candidate refresh or newly discovered dependencies. A direct repeated-initializer check, if separately performed, is a harness test, not this GUI action. |
| Explicit candidate update | Preserve local work; Pull from the candidate containing a distinctive changed value | Intended root and reached package records refreshed from that source; all not-found/errors investigated |
| Ordered override | Set an intentional same-key candidate ahead of the original; Reset selected local root | Actual configured winner used; inward child refresh checked; ordinary outward Fields/Views/code references are not assumed refreshed |

A fresh independent product uses new record identities; a maintenance update or intentional override retains the same identity. Record which case is under test. After each operation, inspect the imported persistent values before saving an edit form: a form save can apply defaults or transform older values and would obscure the acquisition result. Then separately save/reopen the relevant forms to test editor persistence and compare any differences. Do not rely on a toast or the `added` count. Initialization's success classification is not a transactional integrity check. The already-local selection guard is implemented by the pinned [selection-table layout](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/layouts/powerselectiontable.php).

Inspect at least the following for the actual graph:

- Component identity, code name, version, Joomla target, enabled feature/code flags and meaningful empty/default/sentinel values.
- Child record parent keys, association rows/order and menu/ACL/API options; Admin View field assignments including tabs, edit/list/search/filter/title/alias choices.
- Concrete Field GUID, external Field Type GUID, saved XML, datatype/length/default/nullability/index/storage settings. Check custom Field code and dependencies separately from catalogue metadata.
- Referenced Views/Dynamic Gets, selection/query/join/result settings, Custom Code natural keys, placeholders, validation rules, layouts/templates and library associations used by this root.
- Actual file/folder contents, expected paths and hashes; a JSON locator alone is not an acquired image, source file or archive.

Compare code and nested data against the authoritative repository through the documented transformations. Local numeric database IDs can differ from portable keys. Do not directly insert database rows to bypass a failed import and call it acquisition success.

For assets, preserve original test files/directories before forced replacement. The inspected [asset Reset path](../specification.md#files-and-folders) loses descriptor destination information that stock index entries do not restore; successful stock asset Reset is not established by source inspection. Test the current runtime explicitly and report failure rather than treating a root Reset as an asset pass. Init/Pull retain the descriptor path; inspect every acquired/restored byte and destination. Forced file/folder replacement can remove prior content before a later write/extraction fails, so keep a recoverable checkpoint.

## 4. Prove export and a fresh-instance round trip

If authoring/Push is within scope, complete [Author in Playground and Push](author-in-playground.md), including the audit of **all** writable package destinations and real credential configuration. A missing token is an export blocker, not permission to simulate a completed Push. Capture resulting remote commits and inspect every expected settings/index/README/asset diff. Keep acquisition-only tests read-only when publication is outside scope.

Create a second independent JCB instance with no local candidate graph. Explicitly configure dependency catalogues and the candidate read branch at the exported commit. Init the root and compare the saved values/relationships/assets with the source instance. This reveals dependencies accidentally supplied only by the original database/filesystem.

For an authorized write round trip, make a small distinctive edit in the second instance, Push to the isolated candidate branch, inspect the source diff, and Pull into another clean instance/checkpoint. Verify preserved stable identities and the intended edit. Re-export without changes when possible and compare: account for only contract-defined generated differences. Do not dismiss unexpected changing settings, missing assets or stale index summaries as harmless formatting. Record Push, remote inspection and fresh acquisition independently if one fails.

## 5. Compile the component that actually consumes the change

Open JCB **Compiler**, select the imported test component and requested Joomla target, and compile. Check that the root's relevant associations actually include the changed Field/View/code/assets. An unrelated successfully compiled component does not test the candidate.

Capture compilation messages and **Download Component**. Preserve the ZIP and hash, extract/list it outside the browser or inspect through the supported artifact path, and verify the actual generated paths for that target. The shared guide describes artifact transfer and blockers; no ZIP bytes or extractable files means artifact inspection is unrun, not inferred.

| Changed feature | Inspect in the generated extension |
| --- | --- |
| Component identity/version | Manifest, extension/code name, namespace/provider/bootstrap and target requirements |
| Concrete Fields/Admin View | Form XML, language strings, model/table/form handling, list filters/order, ACL and menu registration |
| Data schema/storage | Install SQL, upgrade SQL, column names/types/length/null/default/indexes and storage transformation code |
| Application relationships | Selector/query target, persisted key/value shape, joins, missing-target handling and ACL filtering |
| Site/Custom View/Dynamic Get | Generated query/model/view/template output, result shape, parameters and escaping |
| Code/Power dependencies | Generated classes/autoload/services, correct namespaces and method signatures; no unresolved intended placeholders/tokens |
| Files/folders/libraries | Present payload bytes, correct installation destinations, manifest registrations and asset loading |

Parse XML and lint relevant PHP on the declared supported PHP targets. Compare a baseline compile for maintenance changes. Treat compile success as one stage: inspect warnings, missing optional services and unexpectedly absent output. Correct durable defects in the authoritative blueprint/dependency/compiler source, refresh, rebuild and retest. JoomEngine Code edits to generated/installed PHP are diagnostic until reproduced from maintained source.

## 6. Install and exercise the application

Install the generated package using Joomla's supported extension installer in a disposable compatible site; use a separate Joomla-only site where a clean consumer is useful. Record installer output and actual extension version. Verify installed output agrees with the package. For an update, first install the baseline and create representative records, then install the candidate and check preserved data/schema/configuration. A fresh install cannot prove an upgrade works.

Execute the feature's real runtime route. For the minimal CRUD graph, open its administrator list, create a record with valid input, save, reopen and compare values, edit it, test relevant required/invalid/empty/zero/boundary cases, then check list/search/filter/order and permissions with the intended user roles. Verify server-side validation and stored representation, not only rendering. Exercise delete/state/history behaviour only where the feature claims it. For relationships, test existing/missing/inaccessible targets and actual save/reload; for site views or assets, open the rendered page and check query results, escaping, browser/network errors and registrations. For modules/plugins, trigger their actual application/event context.

Run the affected supported Joomla/JCB/PHP matrix, including minimum supported versions where syntax, form classes or APIs matter. Check the shared Playground configuration for currently available versions; do not silently substitute another target. Browser WASM/adapted-JCB success does not establish native PHP, host executables, recursive HTTP, mail or remote service behaviours. Use a suitable authorized native environment for requirements outside the browser's coverage and label its results separately.

## 7. Preserve evidence and recover

Retain the root/key ledger, exact source/runtime revisions, effective repository order, selected operation/source, sanitized messages, before/after record and remote diffs, exported ZIP hash, generated/installed paths, runtime cases and matrix outcomes. Mark each stage passed, failed, blocked or not run with its reason. A saved site or share URL is not itself a receipt or portable source graph.

Before discarding a failure, preserve the test checkpoint and minimal reproducer. A partial Push may have committed some files; inspect remote state before retrying or reverting. A reverted Git commit does not restore imported database rows, migrated data or installed files: restore/refresh and rebuild/reinstall the appropriate layers explicitly. Follow [debugging](debug.md) and [human issue reporting](../../testing/reporting-issues.md) for a reproducible upstream defect. Never merge solely because one acceptance stage passed.
