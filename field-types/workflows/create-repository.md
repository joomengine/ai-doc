# Create a Field Type repository

## Inputs and scope

Establish whether this is a new catalogue, a fork of an existing catalogue, or a small overlay providing intentional overrides. Record the purpose, repository/branch, licence, supported targets, intended resolution order, and first capability. Inspect an existing remote before initializing Git; a README-only remote already has history.

A catalogue can document several supported Joomla fields without implementing their PHP classes. If the task requires a new runtime field class, identify how the component/Joomla extension supplies that class and its assets. The Field Type catalogue does not install them by itself.

## Evidence before authoring

- Inspect current `joomengine/joomla-fieldtypes` and all project-specific catalogues; record their revisions and how the target JCB installation resolves them.
- Read the [exact file contract](../specification.md), [serialized fields](../fields-reference.md), and nearest [complete example](../examples/README.md).
- For a fork/overlay, identify the existing GUIDs being retained and why the override is needed. For new definitions, follow the mandatory core-plus-project collision check in the [creation workflow](create-field-type.md).
- Research the actual supported Joomla implementation using [the source-based procedure](../joomla-research.md). Do not copy outdated property descriptions solely because they exist in the official catalogue.

## Ordered construction

1. Create a task branch from the selected base, preserving existing history. For an empty remote, initialize the intended initial branch and add the correct remote.
2. Add a root `README.md` with purpose, supported targets, catalogue provenance, expected repository order, import/refresh instructions, and a Field Type index. Add the actual licence; preserve upstream notices for forked/adapted material.
3. Add a short `AGENTS.md` linking to `https://github.com/joomengine/ai-doc/tree/main/field-types`, with the repository's own target constraints. State the mandatory official-catalogue collision check and the distinction between existing-identity overrides and new identities. Do not duplicate the entire module into a second independently maintained guide.
4. For a new empty catalogue, add root `index.json` containing `{}`. Use an object, not `[]`. Add `src/` with the first item; an empty directory is not tracked by Git. For a fork, retain the existing index and item identities.
5. Add the first useful Field Type using [Create a Field Type](create-field-type.md), or modify the same-GUID record using [Maintain and debug](maintain-and-debug.md). Do not allocate fresh GUIDs to every item in a fork.
6. Keep the index entry's name, description, GUID, directory, and item path aligned with the actual item. Use the canonical `src/<guid>/item.json` layout; the inspected remote reader constructs `item.json` from the entry's `path`, so changing only the `settings` locator is not a supported relocation.
7. Add each item's README and root navigation. Explain any custom implementation, Joomla extension dependency, or supported-version restriction. A description promising an unavailable runtime class is not a working catalogue entry.
8. Run the repository validator with a current catalogue, then execute the applicable JCB integration recipe. Configure the test instance to read this repository and branch explicitly; creating or pushing a Git repository does not automatically register it in every JCB instance.
9. Open the requested PR after the first meaningful commit and continue with reviewable increments. Record exact static and integration results, unresolved gaps, intended override order, and affected GUIDs.

## Resulting files

| Path | Content |
| --- | --- |
| `README.md` | Catalogue scope, supported targets, source/reuse policy, import information, ordering, and current index |
| `AGENTS.md` | Module pointer and repository-specific constraints |
| Licence file | Actual licensing terms and retained upstream notices |
| `index.json` | GUID-keyed locator object; entries include `name`, `path`, `settings`, `guid`, and `desc` |
| `src/<guid>/item.json` | The Field Type's authoritative metadata, property definitions, and optional database defaults |
| `src/<guid>/README.md` | Purpose, property semantics, version applicability, source evidence, and usage caveats |

The angle-bracket notation is a path grammar; real paths contain the actual GUID. No PHP file, Super Power Key, or `code.power` is required by this catalogue format.

## Completion and recovery

Complete means every intended entry resolves to a coherent item, identities follow the chosen new/fork/override policy, references and documentation resolve, and the validation level is disclosed. An intentionally empty index is a valid starting structure, not an implemented field capability.

If fetching the official catalogue fails, do not allocate a new GUID from an incomplete collision set. Resolve access or preserve the incomplete work and report the exact missing source. If an overlay is selected unexpectedly, inspect configured repository ordering rather than renaming GUIDs. If import rejects a valid-looking item, compare the targeted JCB reader and field contract; do not adopt the Super Power file format as a workaround.
