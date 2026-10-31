# Module verification record

**Date:** 2026-10-31. This records validation of the initial documentation module, not certification of every Power or future repository revision. Source revisions are in [sources.md](sources.md) and the [repository registry](../registries/power-repositories.json).

## Evidence and review

The work was divided between independent reviews of JCB's implementation, the seven published Power repositories, the architecture publication, workflows, and tooling. The architecture review matched the published manifest's 62 article hashes to its recorded source revision. The JCB review inspected import, export, metadata, form, namespace, dependency, placeholder, and compilation paths and compared the stated Power contract files between the pinned `6.x` and `5.x` sources.

The root/module review corrected an overbroad UUID rule so future modules with natural-key identities follow their own contracts. It also added explicit scaling guidance and checked task routing and local document links. This review establishes the documentation's source coverage and consistency; it does not execute the JCB compiler.

## Fresh-agent creation exercise

An independent agent was given the documentation checkout and the task of creating a minimal Power repository in a separate scratch directory. It read `AGENTS.md`, the root/module entry points, specification, settings reference, creation workflows, complete fixture, and tool instructions. It then:

1. Fetched the seven current indexes: 366 entries, no duplicate GUIDs at the captured revisions.
2. Generated a fresh UUIDv4 through the shipped collision-checking tool.
3. Authored a new `Quorum` power with settings, raw body, PHP representation, index, documentation and licensing.
4. Used both namespace-prefix and component-namespace placeholders, with a dotted final namespace segment. Its declared inspection context resolved to `Acme\Joomla\Approval\Review`.
5. Ran the repository validator and a focused PHP smoke check successfully.

The agent also exercised malformed metadata, paths, generated declarations, raw bodies, and JSON input. The resulting validation fixes and focused regression cases are part of the delivered tooling. The exercise prompted the fixture's missing agent pointer and complete README index to be added. This is evidence that the documented creation path was usable by another agent; it is not a JCB import/compile result.

## Reproducible local checks

Local validation used Bash 5.2.21, jq 1.7, PHP 8.3.6 with its tokenizer extension, and ShellCheck 0.9.0. The offline check passed 34 regression checks, including the maintained PHP smoke test; ShellCheck passed separately. The documented tool prerequisites and coverage limits are in [tools/README.md](../tools/README.md).

```bash
bash tools/check.sh
shellcheck -x -P tools tools/*.sh tools/lib/*.sh tests/*.sh
php -n super-powers/examples/minimal-repository/smoke.php
```

These check documentation links/registries, JSON and shell syntax, positive/negative repository fixtures, GUID catalogue gates, path boundaries, source/representation checks and the maintained example's behaviour. CI repeats the offline checks in its own declared environment; consult the [PR checks](https://github.com/joomengine/ai-doc/pull/1/checks) for the result of the exact published commit.

## Limits and next integration gate

**JCB import/compile not run.** No installed JCB consumer environment was available in this documentation build. The [integration workflow](workflows/validate-and-integrate.md) specifies the remaining import/refresh, two-namespace compilation, generated-path inspection and consumer-runtime procedure.

The supplied repositories are not a closed dependency universe, and several existing artifacts differ from the stricter new-authoring profile. The source survey found 23 structured edges to 14 GUIDs outside the seven indexes and seven indexed generated PHP files missing from the shared foundation snapshot; their settings and bodies were present. These are dated source observations, not exceptions that allow a newly authored repository to omit required artifacts or invent dependencies. No source Power repository was modified by this documentation work.

The final static tool run against the seven recorded source snapshots produced these bounded results:

| Repository | Result |
| --- | --- |
| `search` | 24 powers checked; one transformed body explicitly deferred to JCB comparison |
| `psr` | One power checked |
| `openai` | 17 powers checked |
| `minify` | Nine powers checked |
| `phpseclib` | Metadata/PHP checks reached dependency reporting; nine unresolved edges to five GUIDs outside the catalogue; two transformed bodies deferred |
| `gitea` | Metadata/PHP checks reached dependency reporting; one unresolved GUID outside the catalogue |
| `super-powers` | Stopped at source/representation drift in `0e23f0ac-8a0a-450e-b40c-912bf331bfae`; the first diagnostic must be resolved before claiming a full repository pass |

The shared-foundation failure is a source/representation consistency finding, not evidence that JCB reads `code.php`. The complete source survey and the validator's first-failure behaviour are different forms of evidence.

The validators remain bounded static tools: unknown compiler transformations, full import/alias/inheritance semantics, dependency closure beyond available catalogues, PHP/Joomla version compatibility and runtime behaviour need the documented integration checks. Read the tool's explicit limitations before treating a pass as evidence for a broader claim.
