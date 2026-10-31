# Create a Super Power repository from an empty repository

## Inputs and decisions

Obtain the repository's purpose, owner, base branch, licence, supported PHP/Joomla/JCB versions, and the first real capability to implement. Inspect an existing remote before initializing it; a README-only repository is not an empty Git history. Use its actual default branch. The seven registered specimens use their declared branches; that does not require renaming a different project's default branch.

Define the boundary before writing classes: which responsibilities belong in this specialist repository, which are generic enough to reuse from the central foundation, and which Joomla facilities already solve the problem. A new repository does not need its own Factory, HTTP transport, registry, string utility, or base interface merely to resemble another repository.

## Required evidence

- Read the [registry](../../registries/power-repositories.json), [specification](../specification.md), and [reuse rules](../reuse-and-dependencies.md).
- Fetch a fresh complete catalogue. Search the relevant classes and inspect their source settings and bodies, not just names in indexes.
- Record the supported target versions and the source revisions used to establish compatibility. If any necessary external repository cannot be inspected, keep that dependency unresolved rather than inventing its GUID or contract.
- Select a compatible licence and retain the licences of copied/adapted upstream material. A documentation fixture is not evidence that another library's licence permits arbitrary copying.

## Procedure

1. Create a task branch from the selected base. For a genuinely empty remote, initialize a local repository with the intended initial branch and add that remote. Do not overwrite existing history.
2. Add `README.md` describing purpose, targets, installation/import expectations, dependency repositories, and the source-of-truth rule. Add the selected licence file. Add a short `AGENTS.md` directing agents to this module and recording repository-specific constraints. Link to `https://github.com/joomengine/ai-doc/tree/main/super-powers` for the maintained entry point; a revision-pinned link may additionally identify the reviewed contract.
3. Add root `super-powers.json` containing an empty JSON object, `{}`. An empty repository can have a valid empty index; an array `[]` is not the index shape. Create `src/` when the first power is added; Git does not track empty directories.
4. Follow [Create a power](create-power.md) for the first useful class/interface/trait. The [minimal repository example](../examples/minimal-repository/README.md) is a complete specimen of the required files, not a source of reusable new GUIDs. If using it as a structural starting point, replace its identity everywhere and replace its example responsibility with the requested implementation.
5. Declare external dependencies through their existing GUIDs and correct settings fields. List required repository locations and the intended resolution order in the README. Do not copy dependency definitions into this repository simply to make it self-contained.
6. Add the root README index. For each local power include its name, kind, path, settings, raw body, and display SPK. Explain that the active PHP token uses underscores. Keep any per-power README consistent with its actual public methods and dependencies.
7. Add repository checks appropriate to its supported environment. A validation workflow may check out a reviewed `ai-doc` revision and invoke its tools, or vendor the reviewed validation implementation with provenance and an update policy. Do not execute a mutable remote shell script through `curl | bash`. Do not invent a mandatory runtime dependency on this documentation repository.
8. Validate the repository and integrate its first power using [Validate and integrate](validate-and-integrate.md). Configure the test JCB instance's repository and read branch explicitly; pushing a Git repository alone does not register it in every JCB installation.
9. Commit the initial working structure and open the requested PR early. Subsequent commits complete source, documentation, and evidence. State any remaining import/compile limitation in the PR rather than calling the repository production-tested.

## Resulting layout

| Path | Required content |
| --- | --- |
| `README.md` | Repository purpose, supported targets, reuse/import information, dependency sources, and current power index |
| `AGENTS.md` | Entry-point link plus local policy; avoid a second conflicting copy of the whole guide |
| Licence file | The repository's actual licensing terms |
| `super-powers.json` | Object keyed by each local power's GUID, with the full indexed paths and metadata |
| `src/<guid>/settings.json` | Complete authoritative metadata for that power's actual kind and dependencies |
| `src/<guid>/code.power` | Authoritative body; an intentionally empty body is permitted when the definition warrants it |
| `src/<guid>/code.php` | Consistent PHP representation assembled from the source pair and the documented preview context |
| `src/<guid>/README.md` | Purpose, usage, parameters/returns, dependencies, and any relevant generated diagram |

The angle-bracket notation in this table is a path grammar. Actual repository paths contain generated GUIDs, never the literal text `<guid>`.

## Completion and failure conditions

Complete means the index locates every intended power, identities and dependencies resolve, source and representation agree, documentation is navigable, and the validation results are attached. For an intentionally empty catalogue, state that no runtime capability exists yet.

Do not claim successful bootstrap if the licence is unknown, the chosen dependency cannot be resolved, a catalogue fetch was incomplete, a copied fixture GUID remains, or the only implementation is in `code.php`. Resolve those issues within the task; ask the owner only for decisions that cannot be established from the repository or authorized context.
