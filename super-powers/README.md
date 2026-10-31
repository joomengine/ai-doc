# Super Powers: operational module

Use this module to **create, extend, maintain, debug, or scale a PHP Super Power repository**, including starting from an empty repository. The instructions apply across the seven registered repositories and can be extended to additional authorized repositories. The repository named [`joomengine/super-powers`](https://github.com/joomengine/super-powers) is the central shared foundation and reference standard; *Super Power repository* also describes the format used by specialist repositories.

## Scope and evidence

This module covers PHP power definitions, GUID identities, settings, raw class bodies, indexes, generated representations, dependencies, namespace placeholders, authoring workflows, and validation. It does not define JCB package entity repositories, Joomla Power mappings, JavaScript powers, component UI design, an OpenAI modernization project, or MCP service implementation.

The implementation baseline is the inspected JCB `6.x` revision, with a comparison against `5.x`, plus the seven repository snapshots recorded in the [source map](sources.md) and [repository registry](../registries/power-repositories.json). This is not a promise of compatibility with every JCB/Joomla/PHP release. Establish the actual target versions before making a change and recheck any affected contract against that source.

## Choose the task

| Task | Required reading |
| --- | --- |
| Understand how the files and compiler fit together | [Specification](specification.md), then the relevant [settings](settings-reference.md) |
| Create a repository from nothing | [Create a repository](workflows/create-repository.md) |
| Add a new class, interface, trait, or abstraction | [Create a power](workflows/create-power.md) |
| Fix, extend, or debug an existing power | [Maintain and debug](workflows/maintain-and-debug.md) |
| Improve performance or grow a Power subsystem | [Scaling and performance](workflows/maintain-and-debug.md#scaling-and-performance), then [shared-contract evolution](workflows/evolve-shared-contracts.md) |
| Change a shared interface or foundational class | [Evolve shared contracts](workflows/evolve-shared-contracts.md) |
| Verify a change from metadata through JCB | [Validation and integration](workflows/validate-and-integrate.md) |
| Choose an existing dependency | [Reuse and dependency policy](reuse-and-dependencies.md) |
| Learn meaningful format variations | [Complete reference examples](examples/README.md) |
| Run checks or generate a new GUID | [Tools](../tools/README.md) |
| Verify authority or refresh this module | [Sources and freshness](sources.md) |

## The maintenance boundary

JCB imports **`settings.json` plus `code.power`** through the index. The settings describe identity and structure; `code.power` contains the raw class/interface/trait body. `code.php` is a derived assembled representation useful for review and PHP validation. Editing only that representation leaves the authoritative definition unchanged.

The contract is larger than PHP syntax: index paths, GUIDs, settings relationships, namespace placeholders, imports, aliases, service registrations, and generated output must agree. Valid external dependencies need not be present in the same repository. An empty body can be intentional. Read the exact field semantics before normalizing a seemingly unusual value.

## Required engineering decisions

1. **Reuse in order:** inspect Joomla core/framework first, then the shared `super-powers` foundation, then specialist repositories. Create new implementation only where suitable reuse does not satisfy the requirement.
2. **Preserve identity:** retain an existing power's GUID through fixes, renames, and improvements. A distinct new power needs a securely generated UUIDv4 checked against the current registered indexes and all additional repositories in scope. Never copy an example's identity.
3. **Keep portable source:** retain intended `[[[NamespacePrefix]]]`, `[[[ComponentNamespace]]]`, and other documented placeholders. Do not replace them with a namespace observed in one generated component.
4. **Respect compatibility:** preserve public methods, parameter names used by named arguments, return contracts, service identifiers, aliases, and dependency expectations unless the task deliberately introduces a documented migration.
5. **Follow existing style:** tabs for PHP indentation, established brace and docblock conventions, small cohesive responsibilities, dependency injection, and original attribution/licensing.
6. **Report evidence accurately:** distinguish structural checks, source review, JCB import/compile results, and runtime behaviour. These are separate checks.

## Dependency lookup and GUID checks are different operations

When creating a new identity, search for collisions across all required current indexes. When resolving an existing dependency, retain the configured repository order and show the selected definition and any shadowed alternatives. Do not flatten multiple repositories into a dictionary that silently overwrites provenance.

The seven repositories are the owner's minimum official discovery set, not a claim that every possible dependency lives there. The inspected corpus contains references outside that set. An unresolved reference requires identifying and adding its authorized source, or reporting the missing source; inventing a substitute class or assigning a new GUID to the intended dependency is not a resolution.

## What completion means

A source change is ready for review when the requested behaviour is implemented in the authoritative files, all affected representations and navigation are consistent, relevant checks pass, and the review describes compatibility, source revisions, and remaining verification limits. Use the workflow's integration recipe on the supported JCB/PHP/Joomla environment before claiming import/compile/runtime acceptance.

This module ships static tooling and complete integration procedures. The module's recorded [verification status](../registries/modules.json) is the evidence for what has actually been exercised; documentation does not substitute for an installed JCB environment.
