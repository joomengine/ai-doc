# Field Types verification record

**Inspection date:** 2026-10-31. This record concerns the documentation and bounded static tools delivered with this module. It does not certify every core Field Type or an installed JCB consumer.

## Sources and independent review

The contract review inspected JCB `6.x@408703a857ad937479b1e28de7f693af178dcc83`, the official core catalogue `master@3be64d59378b5650825b97b44dbd58f2cdb82fcb`, and the source paths indexed in [sources.md](sources.md). The official catalogue contains 49 Field Types at that revision. Joomla research independently traced the selected classes, ancestors, setup and rendering paths in Joomla `6.2.0@d7b2268f9184b67866156afb5446717e0612d169`.

Review covered all 14 portable top-level fields; native property rows and database encoding; index locators; effective repository order; intentional same-GUID overrides; import/reset and local state; the effects of property metadata on existing Fields; and custom PHP insertion. The Text/List examples distinguish effective runtime defaults from JCB suggestions and concrete Field choices. The Enum discovery example describes a candidate and its prerequisites, not an implemented catalogue contribution.

## Examples and fresh-agent exercise

Both complete maintained repositories in [examples](examples/README.md) were validated against a freshly fetched core catalogue, including explicit new-identity collision checks. The own-custom example's readable PHP method matches its JSON property example byte for byte. These checks do not generate that class through JCB.

An independent agent followed the entry point, specification, field reference, examples, creation workflows and tool instructions to create a separate scratch Field Type repository. It fetched the current official core, allocated a secure UUIDv4 while checking additional local definitions, authored a complete record/index/documentation set, and passed the static validator with `--new-guid`.

The same agent exercised a separate intentional override of the existing official Text identity. Resolution evidence preserved the selected local definition and shadowed core definition for a proposed configured order; this was not an observed lookup in an installed JCB instance. Ordinary maintenance validation accepted the retained identity; incorrectly declaring it new with `--new-guid` was rejected. This demonstrates the documented difference between a new item and a same-item fork.

## Repeatable checks and coverage

The final local run passed 34 existing Power regression checks plus 41 Field Type/Snippet checks (**75 total**), documentation/registry checks and ShellCheck. The independent review's 22-case negative matrix also passed after its two findings were corrected. All 49 current core Field Type records passed the static authoring profile. The PHP-enabled combined run used PHP 8.3.6; none of these results imply live JCB execution.

From the documentation repository root:

```bash
bash tools/check.sh
shellcheck -x -P tools tools/*.sh tools/lib/*.sh tests/*.sh
```

The focused [entity regression suite](../tests/run-entity-tests.sh) covers complete and empty repositories, mandatory core catalogues, catalogue integrity/freshness, ordered provenance, new-versus-retained identities, canonical paths, escaping symlinks, JSON shape, double-encoded properties, duplicate property names, flag domains, database selectors and index/item consistency. The existing Super Power checks remain part of the combined run. Consult [PR #2 checks](https://github.com/joomengine/ai-doc/pull/2/checks) for the exact published commit's CI result.

The [tool reference](../tools/README.md) identifies the stricter authoring profile and its limits. A historical record rejected by that profile needs investigation; it is not automatically proof that the JCB importer rejects it.

## Integration not executed

**JCB import/reset, compilation, database execution, and live Joomla form checks were not run.** No installed JCB test instance was available. The [integration workflow](workflows/validate-and-integrate.md) supplies the remaining procedure, including both new and existing concrete Fields, namespace/class resolution for custom fields, generated XML/PHP/SQL inspection and runtime validation.

Static success does not establish SQL compatibility, custom PHP inheritance/runtime correctness, Joomla class availability or the effect of a change on every consumer. The core catalogue's existing Text/List descriptions were compared with current Joomla source without changing that upstream repository.
