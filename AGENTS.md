# Agent operating contract

This repository documents the **whole Joomla Component Builder (JCB) ecosystem**. Super Powers is its first operational module. Follow the task's relevant module; do not impose Super Power file formats on other JCB entities.

## Start here

1. Read `README.md` for task routing and module status.
2. Read the selected module's entry point, contract, and relevant workflow. Load supporting references only as the task requires.
3. Before changing implementation-dependent behaviour, inspect the authoritative source at the target revision. Documentation records verified behaviour; it cannot override a changed implementation.
4. Before extending these docs, follow `standards/module-authoring.md`. Use the same module contract, evidence discipline, workflows, validation, and completion criteria for every future subject.

## Non-negotiable project policy

- Investigate supported **Joomla core/framework** capabilities first; then `joomengine/super-powers`, the central shared foundation and reference standard; then specialist Power repositories. Reuse suitable code through composition, dependency injection, or inheritance before creating a new implementation.
- In a Super Power repository, `settings.json` and `code.power` are authoritative import inputs. Keep generated `code.php`, indexes, and documentation consistent; a PHP-only patch does not update the imported power.
- For Super Powers, preserve existing GUIDs. Generate new UUIDv4 identifiers with a cryptographically secure system facility and check all registered current indexes plus task-specific repositories before use. Other JCB entities must follow their own module's identity contract; some use natural keys instead of GUIDs. Preserve repository order and provenance when resolving dependencies.
- For Field Types, `joomengine/joomla-fieldtypes` is the official core catalogue; for Snippets, `joomengine/snippets` is the official core catalogue. Every repository in the corresponding domain must include its current core catalogue in new-identity collision checks, together with additional configured repositories and local additions. A distinct new item receives a fresh GUID. An improvement or intentional fork override of the same existing item retains its GUID and records the intended resolution order. Never assign a core identity to an unrelated item.
- Preserve portable placeholders, field-specific empty/null/sentinel values, public contracts, and upstream licensing. Follow the repository's tabs and established code style.
- Distinguish **project policy**, **verified implementation behaviour**, **observed examples**, and **unverified gaps**. Cite exact source revisions for implementation claims. Never present an inferred or untested feature as verified.
- A successful static check does not prove a JCB import, compilation, or runtime integration. State which checks actually ran and which remain unavailable.
- Stay within the requested scope and authorization. Make work reviewable through focused commits and a PR when requested; do not merge merely because checks pass.

## Documentation quality

Write exact operational instructions: inputs, source authority, ordered actions, outputs, checks, and failure recovery. Explain consequential edge cases. Avoid repetitive essays, invented defaults, empty templates, hidden assumptions, and aspirational features described as implemented. Keep one canonical explanation per rule and link to it.

Root documentation remains ecosystem-wide. New modules must be discoverable from the root and the module registry, and must declare their scope, version applicability, evidence, limitations, and completion status.
