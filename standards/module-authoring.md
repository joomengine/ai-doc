# Standard for introducing and maintaining an operational module

**Authority: project policy.** Apply this standard whenever an agent is asked to document another JCB subject to the same standard as Super Powers. The term *module* here means a documentation unit, not a Joomla extension or a JCB data model. This policy governs documentation work; it does not invent new JCB formats.

## 1. Outcome and scope

A completed module must let a fresh agent perform its advertised tasks from the actual supported inputs to a correct, reviewable output, without reconstructing unstated conventions. The module must also tell the agent when the evidence is insufficient, which source to inspect, and what cannot yet be validated.

Detail is required where it changes correctness. Explain all consequential field semantics, dependencies, version constraints, exceptions, and recovery steps. Do not substitute long prose for an exact contract, repeat the same rule across documents, or present speculative features as current behaviour.

Do not create an empty family of modules to make the repository look comprehensive. Introduce a subject when it has an actual task, inspected authority, and useful operational content. Keep the root about the whole ecosystem.

## 2. Authority and evidence

Assign each consequential statement one of these meanings, explicitly in a section or table where necessary:

| Class | Meaning | Required support |
| --- | --- | --- |
| Project policy | What maintainers require | This operating contract or an explicit project-owner decision |
| Verified behaviour | What the implementation actually does | Repository, branch, exact commit, file/symbol, and explanation of the relevant path |
| Observed example | What an inspected specimen contains | Exact repository revision and path; it does not prove every valid variant |
| Derived guidance | A recommended action based on evidence | Supporting rules plus the reasoning and its limits |
| Known gap | Something not established or not tested | Exact missing evidence, impact, and next verification step |

Use immutable source URLs for implementation claims, with symbol names so the relevant code remains discoverable. Record the inspection date and branch as well as the commit. Links to moving branches can supplement these references for discovery; they cannot replace pinned evidence. Do not copy dates, counts, commit IDs, or validation outcomes from an old conversation as if reverified.

When sources disagree, describe the disagreement. Source code establishes actual implementation behaviour; documented project policy establishes intended maintenance practice. An exported example may expose a defect or an older format. Do not turn it into a rule simply because it exists. Where resolution changes the intended contract, keep the issue explicit rather than silently rewriting history.

Read relevant architecture chapters first for context, then inspect the actual implementation. Depending on the subject, this may include metadata maps, XML forms, SQL, serializers, importers, compilers, generated output, runtime classes, and upstream framework documentation. A schema inferred only from examples is not a complete semantic contract.

## 3. Required module layout

Use a descriptive lowercase directory name with hyphens. The following are required responsibilities; a small module may combine reference sections in one file if navigation stays precise.

| Path or responsibility | Required content |
| --- | --- |
| `README.md` | Scope/non-scope, supported versions, source baseline, task routing, operating invariants, verification limits |
| `specification.md` | Exact artifact/operation contract, lifecycle, identities, relationships, encoding, transformations, and edge cases |
| Field/reference documentation when structured data exists | Every serialized field: type/domain, absent/null/empty semantics, conditions, references, transforms, examples, and authority |
| `workflows/` | Complete creation, maintenance, debugging, compatibility, and verification procedures for advertised tasks |
| Module-specific integration workflow | Shared Playground setup plus exact model operations, assertions on persisted data, real consumer construction, compilation/output checks, runtime scenarios and recovery |
| `examples/` | Minimal complete valid examples plus meaningful variants, provenance, execution instructions, and restrictions on reuse |
| `sources.md` | Evidence map, pinned revisions, upstream references, discovered disagreements, and freshness procedure |
| Schemas/tooling when useful | Structural checks and cross-file validation, documented dependencies, nonzero failure exits, and clear coverage limits |

The module must be linked from the root README and `registries/modules.json`. Record `id`, `path`, `entrypoint`, `status`, `scope`, `source_baseline`, `test_workflow`, and `verification`. `test_workflow` is a repository-relative path to that module's actual acceptance procedure, not merely the shared environment guide. The repository checker requires it to exist. `status` must be `in-progress`, `documented`, or `deprecated`; `documented` means the documentation meets this standard, not that every target environment has been exercised. `verification` must separately state static and integration evidence.

Choose one canonical location for each rule. Use links and short reminders elsewhere. Make the reading path task-based: fixing a method should not require reading every architecture chapter, while creating an empty repository must lead through every necessary step.

## 4. Contract completeness

For each identity and artifact, document:

- Its purpose, owner, stable identifier, and how it is created, located, updated, and removed.
- The source of truth and derived artifacts, including which process consumes each file.
- Required files, exact paths, case sensitivity, encodings, and meaningful empty files.
- All relevant field types, accepted representations, defaults actually applied, invalid values, and conditional combinations.
- The difference between omission, `null`, an empty string, an empty array/object, a sentinel, and a populated value where behaviour differs.
- Local and external references, lookup order, missing dependencies, shadowed definitions, and cycle behaviour if established.
- Placeholder syntax, substitution timing/context, and escaping rules where they exist.
- Import/export/compile/runtime transformations; version or environment requirements.
- Public compatibility commitments, licensing, and security boundaries relevant to the operation.

Avoid a rigid schema that rejects valid existing variants unless it is explicitly an opt-in stricter authoring profile. Explain whether a validator implements the interchange contract, a new-authoring policy, or a partial structural check. Never claim JSON Schema can validate runtime or cross-repository semantics by itself.

## 5. Workflow contract

Each advertised task must have an executable or unambiguous ordered workflow containing:

1. **Inputs and prerequisites:** exact artifacts, target versions, repository/branch, permissions already required by the task, and installed tools.
2. **Authority discovery:** which sources to inspect and what to record before acting.
3. **Actions:** the complete sequence, with actual commands where practical. Explain conditional branches and choices rather than silently guessing.
4. **Outputs:** every affected source and derived artifact, identities preserved/generated, and expected resulting structure.
5. **Validation:** commands or exact manual operations, expected result, and what each proves.
6. **Failure and recovery:** how to recognize incomplete input, stale evidence, invalid metadata, unavailable dependencies, or incompatible behaviour and what to do next.
7. **Review:** what the change summary must disclose and what remains unverified.

Commands must match shipped tools, include their prerequisites, handle paths safely, and fail visibly. Do not instruct agents to execute downloaded repository code merely to inspect metadata. Fetching indexes and reading source is different from running it. Use Bash and jq for repository/build automation in this project; introduce another runtime only when the requirement justifies it explicitly.

Workflow authorization follows the user's task. Documentation must not add blanket approval pauses for ordinary authorized work. Do not imply permission to publish, send communications, or merge beyond that task.

### Default Playground path for every model

Link the [shared Playground workflow](../testing/playground/README.md) and [configuration reference](../testing/playground/configuration.md) from each module's entry point and acceptance procedure. With browser access, a supported target and authorization for implementation/testing, an agent uses this path by default. Honor an explicit opt-out, a read-only/documentation-only task or another requested environment. Offer or ask about testing only when a real scope decision remains; do not require the user to repeat permission for ordinary authorized validation. Report unsupported versions, unavailable browsers, network failures and other blockers instead of silently skipping tests or changing targets.

For each newly introduced model, document these specifics rather than merely saying “test in Playground”:

1. The applicable repository target/provider and identity rules, enabled-state and ordering checks, read branch and dependencies. Some subjects have no repository importer; document their actual supported entry path instead of inventing one.
2. The actual Init, Pull, Reset, save/export or other operations available in the targeted release: what they select, replace, preserve or traverse. Similar toolbar labels do not establish identical semantics across models or versions.
3. The persisted fields and relationships to inspect after import or editing, including encoding, defaults, identity, dependency resolution and a distinctive expected change. A success notification is insufficient evidence.
4. The smallest real consuming blueprint/component that exercises the changed item. Name required references, linked fields/views, namespaces, libraries, assets and permissions. An unreferenced record and an unrelated successful compile do not test the change.
5. The expected generated XML/PHP/SQL/assets and installed runtime actions, including meaningful failure cases. Cover creation and updates separately where they differ. State when compilation is not applicable and provide the actual consuming path.
6. The relevant Joomla/JCB/PHP matrix, version-specific assertions and native-platform checks. Read currently supported Playground targets from its configuration; do not present planned Joomla 7, alpha or development releases as available.
7. The evidence to retain and failure recovery, including return of diagnostic editor changes to authoritative source, regeneration and the [human issue-reporting procedure](../testing/reporting-issues.md).

JoomEngine Code can aid inspection and debugging; its installed files are a separate representation from database-held JCB definitions and repository source. Describe how changes return to the correct authoring layer. The optional in-Playground AI, browser automation and MCP are distinct capabilities with different access and execution limits; reuse the shared guide's current evidence instead of assuming they are interchangeable.

## 6. Examples and reusable instructions

Use complete examples at the smallest size that demonstrates the rule. Cover meaningful variations, not dozens of equivalent snippets. For a repository format, include creation from an empty directory and at least one realistic dependency relationship.

Separate immutable reference specimens from newly created fixtures. Record source commit and original license for copied material; do not relicense it. Example identifiers must be clearly marked reference-only or fixture-only, and creation instructions must generate fresh identities. Never let an example accidentally become a globally reused production identity.

Describe how a maintained repository points agents back to this guide. A root `AGENTS.md` in this documentation repository does not automatically apply to other checkouts. A consumer can add a brief local pointer identifying the module and required rules while retaining its own target/version constraints.

Do not require provider-specific hidden memory, a particular model, embeddings, tensors, or a hosted knowledge service. Markdown and structured registries are portable authorities. Optional retrieval indexes or consolidated editions must be derived from those sources and must not become conflicting editable copies.

## 7. Verification and acceptance

Run the checks appropriate to the module and record actual outcomes:

| Level | What to demonstrate | What it does not establish |
| --- | --- | --- |
| Documentation | Local links resolve; task routing and registry paths exist; commands and claims agree | Runtime correctness |
| Structure | Schemas/validators accept intended variants and reject meaningful invalid cases | Successful JCB import/compilation |
| Consumer integration | Representative import/export/compile round trip on declared versions | Every downstream application |
| Runtime | Relevant behaviour/compatibility in an actual consumer | Universal compatibility |
| Fresh-agent exercise | A new agent can follow a declared task using only the published instructions and required sources | All possible tasks or versions |

Use focused negative tests for corruption, unresolved or conflicting references, accidental ID reuse, and other meaningful failure modes. Do not add tests that merely restate static prose or mirror implementation with no independent assertion.

A fresh-agent exercise must identify the input task, documents loaded, output inspected, defects found, corrections made, and checks actually run. It is not enough to ask whether the writing looks clear. Unavailable integration environments are a recorded limitation, never a fabricated pass. Integration procedures must still be complete enough for a maintainer to execute.

Before marking a module `documented`, require:

- Scope and evidence map are explicit; every advertised workflow has a complete path.
- Significant settings and lifecycle edge cases have authoritative support or named gaps.
- Examples and tool commands agree with the contract and work at their stated validation level.
- A `test_workflow` links the module to Playground and defines model-specific import/update, consumer, compilation and runtime acceptance (or explains why a stage is inapplicable). Its verification record distinguishes performed, failed, blocked, declined and not-run stages with evidence.
- Root and module navigation, registry entries, and relevant CI checks pass.
- Independent review or a fresh-agent exercise has been performed and blocking findings resolved.
- The PR states changes, source revisions, verification evidence, and remaining limits truthfully.

## 8. Delivery and continuing maintenance

Create a focused branch and open a draft PR early when requested. Push coherent increments so the work is visible. Update the PR title/body around the finished result, remove obsolete progress claims, and mark ready after the documented checks pass. Keep merging separate unless authorized.

When adding future modules, reuse this standard rather than copying Super Power-specific fields or tool assumptions. Update root routing, the module registry, and any shared tooling only where the new contract requires it. Do not silently broaden a validator or alter another module's requirements.

When upstream changes, compare the recorded revision with the new target. Reinspect affected fields/behaviours, update examples and tests, and record the new evidence. Preserve compatibility notes where old supported versions differ. Update a consolidated guide from the canonical source files if one exists. State exactly what was revalidated; an updated date alone is not evidence of review.
