# Evolve shared interfaces and abstractions

`joomengine/super-powers` is the preferred shared foundation and reference standard for JCB-owned reusable PHP. Its abstractions can have consumers in many repositories and private projects. The absence of a public caller in the seven registered indexes does not prove that a change is safe.

## Inputs and evidence

Specify the requested capability or defect, exact shared GUIDs, target versions, and whether a public contract change is intended. Inspect the current declarations, dependency graph, DI wiring, and at least the known affected consumers. Search beyond direct `extends`: interfaces, trait use, constructor injection, callback registration, aliases, service strings, and embedded SPKs can create dependencies.

Build a concise consumer table with repository/revision, consumer GUID or source path, relationship, relied-upon contract, and required action. Include known private consumers by permitted identifier/summary without publishing their code or credentials. Mark uninspected consumers as unknown rather than assuming compatibility.

## Decide the compatibility strategy

| Change | Default strategy | Evidence needed |
| --- | --- | --- |
| Correct implementation while preserving documented contract | Keep identity and API; add regression coverage | The defect and important existing use cases |
| Add an optional capability | New method, optional trailing argument, collaborator, or new power as appropriate | Existing calls remain valid; named arguments/defaults and state remain coherent |
| Add required interface method | Treat as breaking for implementers | Every known implementer updated or an explicit successor/interface migration |
| Change constructor, return shape, thrown errors, or service key | Treat as potentially breaking | Consumers and factory/provider wiring inspected; compatibility adapter or migration |
| Replace a responsibility with a different abstraction | Consider a successor power with a new identity | Clear old/new responsibility and deprecation path |
| Fix metadata/namespace or alias | Keep identity unless genuinely a different power | Existing tokens, imports, compiled paths, and consumers still resolve |

Do not create a new GUID just to hide a breaking revision of the same power. Do not preserve a GUID while quietly replacing its meaning with an unrelated class. The owner-approved compatibility/migration policy determines whether a successor is warranted.

## Ordered rollout

1. State the before/after contract and why Joomla or an existing shared abstraction cannot already supply it. Keep generic framework facilities in Joomla; keep domain-specific behaviour in the specialist repository.
2. Prefer a compatible foundation change first. Add extension points only when a demonstrated consumer needs them, and keep interfaces narrow.
3. Update the foundation source pair and derived artifacts. Preserve exact aliases and service identifiers unless the plan explicitly migrates them.
4. Update specialist consumers on coordinated branches, referencing the foundation's exact proposed revision. Do not make a consumer depend on an unpublished GUID or pretend a dependency branch has merged.
5. Validate the foundation and each representative consuming repository with the combined dependency snapshot. Test both old supported calling patterns and the new behaviour. Test concrete implementations of changed interfaces, not only abstract declarations.
6. Run a representative JCB import/compile in the supported target matrix. Exercise at least one service constructed through the real provider/factory path when DI changed.
7. Document release/import order, required reimport/recompile steps, compatibility period, and rollback. `power_version` is metadata; do not assume it creates a dependency solver or prevents JCB importing an incompatible change.
8. Link coordinated PRs and report readiness individually. Merge or release only within the authorized task. If integration access is unavailable, keep the corresponding evidence explicitly pending.

## Required migration information

A breaking-change proposal must identify affected GUIDs and public methods/service keys; old and new usage; supported target versions; the consumer update order; how existing JCB records are refreshed; the need to recompile/install consumers; and how to recover. State whether a compatibility adapter exists and when removal is permitted. Avoid an arbitrary universal deprecation interval: use the maintained project's actual version and release policy.

## Completion and stop conditions

Complete means the compatibility or migration story is concrete, all known affected sources are updated or explicitly covered by an adapter, and validation evidence identifies tested revisions. Stop the incompatible portion if a required consumer contract or authorization is unknown; continue compatible investigation, documentation, and independent fixes. Never label a change universally safe based only on the public catalogue.
