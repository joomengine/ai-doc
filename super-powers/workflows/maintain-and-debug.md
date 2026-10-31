# Maintain and debug an existing power

## Inputs and baseline

Identify the reported behaviour, expected behaviour, triggering caller, affected GUID/service, destination branch, and target PHP/Joomla/JCB versions. Reproduce with the smallest representative input and capture the exception or incorrect result. Avoid logging credentials or complete private request payloads.

Record the repository commit, the selected power's source pair, dependency revisions, and the JCB/component revision if compilation or runtime is involved. An installed component may contain an older compiled copy even when the remote repository is correct. Determine which code the failing process actually loads before editing.

## Locate the failure layer

| Observation | First evidence to inspect | Likely change boundary |
| --- | --- | --- |
| GUID cannot be found | Current index, configured repository order, branch, access, and path values | Registry/configuration or indexed source paths |
| Import succeeds but old behaviour remains | Local JCB record, whether it was refreshed, compiled file, installed extension | Import/compile/deployment lifecycle, not necessarily power logic |
| Class or parent cannot be loaded | Settings dependencies, alias, target availability, generated imports, autoload path | Metadata or consuming component integration |
| Duplicate or unexpected class selected | All occurrences of the GUID with repository provenance and configured order | Intentional override versus accidental collision |
| Syntax error only after compilation | Exact compiled PHP, placeholder substitution, namespace/class declaration, target PHP version | Source body or structural metadata |
| DI service not found | Factory registration order, provider registration, aliases, service identifier | Factory/provider source and corresponding imports |
| Wrong result, exception, timeout, or malformed response | Small reproducer, runtime arguments, dependency contract, transport response | `code.power` behaviour, sometimes a shared dependency |
| README/API signature disagrees with code | Authoritative source pair and assembled PHP | Stale derived documentation/representation |

This table is a triage aid, not proof of a cause. Trace the relevant dependency closure and verify the suspected cause before changing it.

## Repair procedure

1. Read the complete affected body and settings. Use the generated PHP to see their assembled context, then make the repair in the authoritative source pair. Do not patch generated JCB vendor files and stop there.
2. Resolve dependencies using the actual ordered configuration. Report both the selected occurrence and shadowed alternatives. Existing intentional overrides retain identity; do not regenerate a GUID merely because it exists in more than one configured repository. Accidental new-identity collisions must be replaced before publication.
3. Search consumers by GUID, active Power token, class/alias, and DI service name. GUID-only search misses callers using compiled PHP names; class-name-only search misses portable tokens. The display SPK is a different delimiter form.
4. Establish the compatibility boundary: public/protected methods, parameter names/order/types/defaults, return shapes, exception behaviour, constructor requirements, static access, service names, and state/lifecycle semantics. PHP named-argument callers make parameter names part of the public contract.
5. Add a focused regression reproducer for the defect when behaviour changes. Exercise the failing condition and an important working case. Use fakes for remote services where practical; do not require paid live API calls for every test. For a metadata-only repair, prove the affected import/namespace/dependency relationship instead of adding tests that merely repeat the JSON.
6. Implement the smallest complete source change. Keep GUID and established service identity. Add an optional capability or new method when that avoids breaking existing consumers. If compatibility cannot be preserved, use [Evolve shared contracts](evolve-shared-contracts.md).
7. Update `code.php`, relevant index values, and method documentation from the final source. Retain unrelated settings, line-ending conventions, and licensing. An unchanged method body does not justify rewriting every export file.
8. Run [the applicable validation layers](validate-and-integrate.md), inspect the final diff, and push a coherent commit. If a workflow fails, read the failing job and fix its cause; do not rerun deterministic failures without a change.
9. Explain the trigger, cause, corrected behaviour, changed GUIDs/dependencies, compatibility impact, and validation status in the PR. Preserve the original report's context only where it helps review the result.

## Scaling and performance

Treat runtime scaling and growth of the dependency graph as separate tasks. Start with a reproducible workload, the actual installed revision, and a measurable target such as latency, peak memory, request count, or compilation cost. Record the baseline before changing code; a larger class hierarchy alone does not demonstrate improved scalability.

1. Identify the measured bottleneck and ownership: caller workload, repeated queries or remote requests, transport limits, object lifecycle, lookup/compilation, or the power's algorithm. Measure representative small and large inputs and relevant failure cases.
2. Check Joomla facilities and the shared foundation before adding caching, batching, queues, or new abstractions. Document consistency, invalidation, retry, state isolation, and resource limits for any mechanism actually introduced. Avoid implicit cross-user state in shared services.
3. If responsibilities need splitting, keep existing public entry points as compatible adapters where feasible. Add cohesive powers with fresh identities and explicit dependencies; preserve the identities of existing capabilities. Follow [shared-contract evolution](evolve-shared-contracts.md) for consumer migration.
4. Compare the changed implementation against the same baseline, including correctness and resource use. Exercise DI construction and the intended consumer lifecycle. Recheck dependency closure and import/compile cost when graph structure changed.
5. Report the workload, environment, before/after result, compatibility, and limits. Do not claim a performance improvement from a refactor without measurements or treat one measured workload as a universal result.

## Failure recovery

- **Unavailable dependency:** identify the missing GUID and expected role; inspect additional project repositories. A dependency unresolved by the seven baseline repositories is not automatically a broken power. Do not fabricate a replacement implementation to silence the checker.
- **Source and PHP representation disagree:** establish whether the source or representation contains the intended change. Port the intended fix to the source and regenerate/reconcile the representation. Never silently assume the generated file is authoritative.
- **Import returns success but data is stale:** distinguish initialization from refresh/reset and inspect the local record. Recompilation is still necessary to update a compiled consumer.
- **Unexpected destructive reset:** restore the test database snapshot and compare the selected GUIDs/branch. Do not test refresh behaviour against unreviewed production-local edits.
- **Compiler behaviour differs from this guide:** pin the target implementation and record the discrepancy. Update the contract and fixtures when warranted; do not conceal source drift behind a permissive validator.
- **Failure after rollout:** revert the faulty source commit or deliver a compatible corrective commit; reimport and recompile affected consumers. Reverting remote source alone does not rewrite already installed extensions.

## Completion

The fix is complete when its source is corrected, its derived artifacts agree, the relevant reproducer passes, and the tested consumer path reaches the corrected implementation. If import/compile/runtime access was unavailable, state the completed static evidence and the exact remaining integration step. Do not describe an unexecuted acceptance procedure as a passed test.
