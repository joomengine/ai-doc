# Create a new power

## Inputs and evidence

Identify one cohesive responsibility, its public API, supported versions, destination repository, and required dependencies. Search Joomla first, then the shared foundation, then specialist repositories. Record why a new power is needed and whether it should be a class, abstract class, final class, interface, or trait. Do not choose inheritance merely to reuse a helper method; use composition or injected collaborators when that matches the responsibility.

Inspect the nearest valid specimen of the same kind in the destination repository and the [complete examples](../examples/README.md). Read the [settings reference](../settings-reference.md) for every populated field. An unknown field's meaning must be established before copying it into a new definition.

## Allocate identity

1. Fetch all registered live indexes to a new catalogue directory with `fetch-power-catalog.sh`; retain the revision/hash manifest. Include additional authorized repositories known to the project, using current authorized checkouts for hosts outside the fetcher's supported profile. The seven official repositories are the minimum comparison set, not every possible Power repository in existence.
2. Run `new-power-guid.sh` against that complete catalogue and the local destination repository. Include other local branches/checkouts containing new powers when coordinating parallel work. The tool uses a cryptographic UUIDv4 source; do not ask a language model to invent the UUID or copy an example ID.
3. Reserve the resulting identity in the task's new power immediately. When several agents create powers, allocate identities centrally or give each agent a separate generated identity, then validate the combined index before commit. No finite catalogue check proves universal uniqueness; UUIDv4 plus current known-catalogue checks is the project policy.
4. Recheck the final identity set against fresh indexes before the PR is finalized. A cached snapshot explains what was checked; it cannot guarantee nothing changed remotely afterward.

## Author the complete definition

Create `src/<guid>/` and author the following as one logical change:

| Artifact | Required action |
| --- | --- |
| `settings.json` | Set the new `guid`, coherent `name`/`system_name`, actual `type`, version, portable namespace, description, licensing flags/content, and each dependency field needed by this power |
| `code.power` | Write properties, methods, constants, and trait-use statements that belong inside the selected declaration; omit the PHP opening tag, namespace, ordinary import block, and enclosing declaration |
| `code.php` | Assemble the correct preview namespace, imports/aliases, declaration, header/licence, and body; it is a review aid, not the imported implementation |
| `README.md` | Explain purpose, usable calls, dependency requirements, return/error behaviour, and compatibility expectations |
| Root `super-powers.json` | Add the GUID-keyed full entry and all file paths; preserve all existing entries |
| Root `README.md` | Add the power to the relevant namespace grouping/index and link to the new files |
| Existing Factory/provider powers | Only where the architecture needs it: register the new service and ensure every new reference is represented in the relevant source settings |

### Metadata and source rules

- Preserve `[[[NamespacePrefix]]]` and, when intended, `[[[ComponentNamespace]]]` in the source namespace. Do not paste a resolved `VDM` preview namespace back into portable settings. Follow the exact class-name suffix and dot convention in the [specification](../specification.md).
- Use existing dependency GUIDs for `extends`, `implements`, `extendsinterfaces`, `use_selection`, and `load_selection` as appropriate. A namespace import and a runtime dependency are different responsibilities; an imported alias does not construct or register a service.
- For custom Joomla/external types, use the verified custom sentinel, matching custom field, and header/import mechanism. Ensure the class is available on every supported target. Avoid adding a duplicate local wrapper with the same capability merely to create a GUID.
- A trait imported by a namespace `use` still needs its trait-use statement inside the class body. Distinguish that from an ordinary import.
- Preserve field-specific JSON shapes. `null`, `""`, `[]`, object-shaped subforms, numeric flags, and numeric sentinel strings are not interchangeable by assumption.
- Use tabs for indentation of PHP body code and the surrounding brace/docblock style. Use descriptive types and narrow responsibilities. Include actionable exception information without credentials or sensitive payloads.
- Do not invent a new global base abstraction to serve one class. Do not add runtime credentials, environment-specific file paths, or database row IDs to exported metadata.
- Keep upstream licence notices when adapting source. Select the licensing flag that actually corresponds to the chosen template behaviour; do not copy somebody else's author attribution as your own.

### Index and SPK construction

The index key, entry `guid`, settings `guid`, and GUID directory must identify the same power. The complete index contract is in the [specification](../specification.md). Construct `path`, `settings`, `power`, and `code` from that one identity; paths are repository-relative.

The index/display SPK has form `Super---<guid-with-underscores>---Power`. The active source token is `Super___<guid-with-underscores>___Power`. Convert the UUID's internal hyphens to underscores in both forms. Do not use the display form as executable PHP and do not replace unrelated hyphens elsewhere in the code.

The index namespace is the resolved namespace of the representation, while settings retain the namespace template. Changing one into the other because they are not textually identical breaks their distinct roles.

## Integrate and prove the result

1. Inspect the complete diff for accidental copied identities, unrelated formatting changes, stale method documentation, unresolved dependency names, or omitted provider source changes.
2. Run `validate-power-repository.sh` against the complete destination repository and catalogue, then appropriate PHP/behaviour tests. The body is not a standalone PHP file: lint the assembled representation or compile output.
3. Follow the JCB import-and-compile procedure in [Validate and integrate](validate-and-integrate.md), including a non-default namespace context when adding portable namespaces or aliases.
4. Report the new GUID, service identifier if any, API, dependency additions, target matrix, and exact validation status in the PR. A new class is complete only when a caller can reach and use it in the intended architecture.

If a dependency is missing, resolve its repository and revision. If the PHP representation differs from the body, repair the assembly or source. If import drops a field or compilation alters the namespace unexpectedly, inspect the targeted JCB implementation; do not compensate by hardcoding a component-specific namespace into portable source.
