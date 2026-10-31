# Debug package acquisition, export and generated behaviour

## Inputs and evidence

Capture the exact failure, expected result, root/entity/key, source branch/commit, JCB/Joomla/PHP/Playground versions, operation actually used, effective repository order and selected source, and the smallest relevant source/record/output diff. Preserve the failed test site or exported artifacts before reset. Follow [shared debugging and persistence](../../testing/playground/README.md); sanitize credentials, private data and recovery files.

Keep four representations distinct: repository source, JCB database/filesystem authoring state, compiled extension, and installed runtime. Locate the first point where expected and observed data differ. Fixing a later representation can help diagnosis, but does not prove the maintained source works.

## Ordered diagnosis

| Symptom | Check first | Next action and success evidence |
| --- | --- | --- |
| Candidate does not appear | Actual content target `4`, provider/host/owner/name, enabled state, read branch, candidate commit and correct entity index path | Read the actual remote index; resolve provider/auth/CORS/rate-limit errors separately from format errors. Confirm the desired root key appears from the expected source. |
| Init reports local but candidate differs | Existing local identity and ordinary Init's skip | Preserve local edits; use intended Pull or a clean instance. Inspect distinctive persisted values, not the local result category. |
| Root appears but dependencies are missing | Result log, declared dependencies and real links, handler availability, selected-repository propagation | Check each source. Prepare missing external Field Types separately. Acquire shared package dependencies from their own sources or provide a coherent candidate export; do not assume federation inside selected-source Pull. |
| Reset changes the root but not a Field/View | Reset's inward-child-only traversal and configured winner | Refresh the actual outgoing record explicitly or use a clean full candidate import. Verify both parent linkage and the changed record. |
| Wrong definition wins | Effective order/fallback sources, ambiguous duplicate owner/repository records, read branches and local existing record | Record selected and shadowed definitions, correct disposable configuration, then run the appropriate refresh. Selecting a source for Pull and configured-order Reset test different behaviours. |
| Added/success message but wrong saved data | Payload/settings locator, field encoding/types, setter/database failure, unsupported service | Compare actual saved form/record and messages. Do not bypass with direct database inserts and report successful import. |
| New source dependency never discovered | Already-local root was skipped, missing scanner pattern or absent actual reference | Inspect Resolver/Config and the authoritative reference. Recompute metadata and refresh appropriately; manually adding a dependency does not create its consuming feature. |
| Asset missing or stale | `file_folder` index/payload, pointer/key/source/destination, retrieval/reset path and provider response | Compare expected/acquired bytes and hashes. Test asset acquisition independently; a JSON import or root Reset is not file/folder success. Consult the contract's asset limitations. |
| Push cannot write | Effective write branch, real credential and provider branch protection, repository initialization | Correct only the authorized candidate setup; retain sanitized errors. With no usable credential, mark export blocked rather than pretending it ran. |
| Push changed an unexpected destination | Every effective writable package connection | Stop further writes, record affected commits, and prepare a scoped corrective action within authorization. Generic package Push is not destination-scoped by previous selection. |
| Push reports success but export is incomplete | Per-area/repository messages and remote commits, missing service, graph/payload coverage | Inspect all expected records and indexes. Resolve the cause and retry deliberately; a multi-file graph export is not atomic. |
| Existing item's title/description is stale in discovery | Settings changed but index summary did not | Compare existing-update vs new-create paths; repair the actual inconsistent index/README under the contract and retest discovery. |
| Compile succeeds but feature is absent | Actual selected component, persisted association/feature flags, compiler target and generated output | Trace from root through child rows to consumed record. Include the feature through its real authoring link, refresh and regenerate. |
| Generated PHP/XML fails | Saved code/XML, external Power/Field Type versions, namespaces/signatures/placeholders/encoding | Lint/parse the generated artifact; locate source input or compiler transformation causing it, correct source and repeat the build. |
| Rendered form saves unexpected data | Concrete Field XML/storage/schema, filters/validation/model hooks and installed version | Submit bounded valid/invalid/empty/zero cases, inspect stored representation and reload. Catalogue defaults and HTML rendering alone do not establish storage behaviour. |
| Only update installation fails | Baseline version/data/schema, generated update SQL/version paths | Reproduce baseline→candidate installation with preserved data; design and test the migration instead of relying on a fresh install. |

## Trace and correct the responsible layer

1. Reproduce with the smallest root and source set that still fails, preserving the identity and reference pattern that triggers the issue. Do not remove the failing dependency and call the resulting unrelated component fixed.
2. Compare authoritative source with the saved local record through its documented transformations. Recheck branch SHA before blaming stale caches. If a supported refresh/reload is needed, record it and inspect values again; arbitrary cache clearing is not proof.
3. Compare the saved graph with the compiled ZIP and installed files. Use JoomEngine Code to inspect/debug actual runtime files under the shared guide. Retain diagnostic diffs and request details; a stopped POST may already have changed state.
4. Apply the durable correction to package definitions, the external catalogue or compiler source that owns the fault. Refresh the correct local records, recompile and reinstall. Repeat the original failing case and one relevant unchanged case.
5. For an upstream defect, preserve exact pinned inputs, sanitized logs, minimal steps, expected/observed output and environment limits. Follow [human issue reporting](../../testing/reporting-issues.md); do not submit automatically.

## Output and recovery

Deliver the cause supported by evidence, the authoritative correction/diff, identities and consumers affected, original case outcome, focused regression results and remaining matrix gaps. If blocked, state which stage and concrete cause; a network failure does not establish invalid package JSON, and a static pass does not establish a successful import.

Restore a disposable checkpoint when needed, preserving evidence first. For partial exports, inspect remote state and concurrent work before corrective commits; do not force-reset a shared branch. Restoring source, JCB rows, deployed schema/data and installed files are separate operations. Repeat [acceptance](validate-and-integrate.md) at the affected layers before calling the maintained change fixed.
