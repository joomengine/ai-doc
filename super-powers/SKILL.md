---
name: super-powers
description: "Create, extend, maintain, debug and validate JCB PHP Super Power repositories, including settings.json, code.power, GUIDs, indexes, portable namespaces and dependencies. Use for reusable JCB classes, interfaces, traits, shared contracts and Power import or compilation failures. Do not use as the contract for Joomla Powers, Field Types, Snippets or package records."
---

# Work with JCB Super Powers

Use this entrypoint within the complete `joomengine-jcb` checkout; retain its shared parent resources. Follow [skill loading](../standards/skill-loading.md) and [AGENTS.md](../AGENTS.md). Read [scope and applicability](README.md), then load only the task-relevant references below.

Record the target repository and branch, requested behaviour, existing identity or new-item decision, supported JCB/Joomla/PHP versions, and authorized dependency sources. Inspect the affected source and [specification](specification.md) before editing. Use [sources.md](sources.md) to verify implementation-dependent claims at the target revision.

| Task | Load and follow |
| --- | --- |
| Discover a maintained core mirror or recover public source access | [Shared repository network](../standards/repository-network.md) |
| Start an empty repository | [Create a repository](workflows/create-repository.md) |
| Add a class, interface or trait | [Create a Power](workflows/create-power.md) and affected [settings fields](settings-reference.md) |
| Fix, extend, debug or improve performance | [Maintain and debug](workflows/maintain-and-debug.md) |
| Change a public interface or foundation | [Evolve shared contracts](workflows/evolve-shared-contracts.md) |
| Select dependencies or decide between reuse and new code | [Reuse and dependencies](reuse-and-dependencies.md) |
| Import, compile and exercise the result | [Validation and integration](workflows/validate-and-integrate.md) |

Preserve these boundaries:

- Edit `settings.json` and the raw declaration body in `code.power`; keep the index and derived `code.php` consistent. A complete PHP file is not a raw Power body, and an empty body can be valid.
- Preserve an existing GUID. Allocate a distinct new UUIDv4 through `tools/new-power-guid.sh` using a current complete catalogue and all local unpublished additions; follow the creation workflow rather than copying fixture IDs.
- Keep portable placeholders and documented null/empty/sentinel values. Do not replace a portable namespace with one observed in a single compiled component.
- Research Joomla first, then the central `joomengine/super-powers` foundation, then specialist repositories. Preserve ordered resolution and shadowed provenance; a catalogue membership check is not full dependency compatibility or closure.

Run commands from the checkout root using [tools/README.md](../tools/README.md). Validate the complete candidate with `tools/validate-power-repository.sh`, using the actual repository and catalogue paths. Resolve failures or report the specific unsupported transformation; inspect explicitly skipped PHP checks. Load another model's skill only when an actual dependency or consumer requires it.

For executable changes, follow [Playground setup](../testing/playground/README.md) and the module's integration workflow: verify persisted import/refresh, a real consuming reference and caller, generated output, installation and runtime behaviour. Return durable fixes from generated files to authoritative source and rebuild.

Finish with a reviewable source/index/representation diff, the GUID decision and dependency provenance, tested revisions and versions, exact static and integration results, and remaining limits. Consult [verification.md](verification.md) for historical evidence; do not count an earlier import as acceptance of this change. Prepare reproducible JCB defects for [human issue submission](../testing/reporting-issues.md).
