# Agent operating contract

This is the official **JoomEngine Skills** repository for the **whole Joomla Component Builder (JCB) ecosystem**. Its operational modules cover Super Powers, Field Types, Snippets and Packages. Follow the task's relevant skill, module and verification status; do not impose one entity's file format, dependency rules, or identity semantics on another.

## Start here

1. Read `SKILL.md` for task routing and `README.md` for module status. Use `registries/skills.json` to locate the selected model's concise skill entry point. Keep the complete distribution together as described in `standards/skill-loading.md`.
2. Read the selected module's entry point, contract, and relevant workflow. Load supporting references only as the task requires.
3. Before changing implementation-dependent behaviour, inspect the authoritative source at the target revision. Documentation records verified behaviour; it cannot override a changed implementation.
4. Before extending these docs, follow `standards/module-authoring.md`. Use the same module contract, evidence discipline, workflows, validation, and completion criteria for every future subject.
5. For implementation work, follow the module's `test_workflow` in `registries/modules.json` and the shared [Playground integration workflow](testing/playground/README.md). Testing must exercise the affected model, its real consumer and the intended Joomla/PHP target.

## Non-negotiable project policy

- Investigate supported **Joomla core/framework** capabilities first; then `joomengine/super-powers`, the central shared foundation and reference standard; then specialist Power repositories. Reuse suitable code through composition, dependency injection, or inheritance before creating a new implementation.
- In a Super Power repository, `settings.json` and `code.power` are authoritative import inputs. Keep generated `code.php`, indexes, and documentation consistent; a PHP-only patch does not update the imported power.
- For Super Powers, preserve existing GUIDs. Generate new UUIDv4 identifiers with a cryptographically secure system facility and check all registered current indexes plus task-specific repositories before use. Other JCB entities must follow their own module's identity contract; some use natural keys instead of GUIDs. Preserve repository order and provenance when resolving dependencies.
- For Field Types, `joomengine/joomla-fieldtypes` is the official core catalogue; for Snippets, `joomengine/snippets` is the official core catalogue. Every repository in the corresponding domain must include its current core catalogue in new-identity collision checks, together with additional configured repositories and local additions. A distinct new item receives a fresh GUID. An improvement or intentional fork override of the same existing item retains its GUID and records the intended resolution order. Never assign a core identity to an unrelated item.
- For Packages, select the exact model contract before changing identity or serialization. Standalone GUIDs, parent-keyed children, natural keys and file/folder pointers have different rules. Preserve the full affected graph, source provenance and external Field Type/Power dependencies. Inspect every eligible writable package repository before Push; the inspected exporter does not provide a single-destination selection guarantee.
- Use the [shared repository network workflow](standards/repository-network.md) to discover maintained public core mirrors and reduce GitHub reads. Prefer monitored status-1 endpoints; a status-0 endpoint may receive a bounded recovery probe. Discover new targets dynamically, preserve canonical identity/order and actual transport/revision provenance, and keep contribution destinations separate.
- Preserve portable placeholders, field-specific empty/null/sentinel values, public contracts, and upstream licensing. Follow the repository's tabs and established code style.
- Distinguish **project policy**, **verified implementation behaviour**, **observed examples**, and **unverified gaps**. Cite exact source revisions for implementation claims. Never present an inferred or untested feature as verified.
- A successful static check does not prove a JCB import, compilation, or runtime integration. State which checks actually ran and which remain unavailable.
- When browser access and a suitable supported target are available, use Playground by default for authorized implementation validation, unless the user opts out or the task does not affect executable behaviour. Choose the requested versions, verify the installed JCB version, import or refresh the candidate, inspect persisted values, and compile and exercise a real consumer where relevant. Record blockers and unrun stages honestly; browser availability alone is not a pass. Do not add a routine permission pause to already authorized testing. Ask when missing scope, private data, credentials, publication or external effects require the user's decision.
- Use JoomEngine Code to inspect or diagnose generated/installed output. Carry lasting fixes back to the authoritative repository definition, blueprint or compiler source and regenerate; an editor-only patch does not prove the maintained source works.
- JCB issue submission is human-led. Prepare a minimal, sanitized reproduction and direct the user to the [official JCB issue chooser](https://git.vdm.dev/joomla/Component-Builder/issues/new/choose) using the [reporting procedure](testing/reporting-issues.md). Do not submit on the human's behalf under this policy.
- Stay within the requested scope and authorization. Make work reviewable through focused commits and a PR when requested; do not merge merely because checks pass.

## Documentation quality

Write exact operational instructions: inputs, source authority, ordered actions, outputs, checks, and failure recovery. Explain consequential edge cases. Avoid repetitive essays, invented defaults, empty templates, hidden assumptions, and aspirational features described as implemented. Keep one canonical explanation per rule and link to it.

Root documentation remains ecosystem-wide. New modules must be discoverable from the root and the module registry, and must declare their scope, version applicability, evidence, limitations, and completion status.
