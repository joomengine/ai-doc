# Super Power workflows

These procedures apply to PHP Super Power repositories. They do not describe Joomla Power catalogues or component package repositories. Start with the [module entry point](../README.md), [contract](../specification.md), and [settings reference](../settings-reference.md); load only the workflow needed for the task.

| Task | Procedure | Completion artifact |
| --- | --- | --- |
| Start with no repository content | [Create a repository](create-repository.md) | A documented repository with a valid index, first useful power, and declared dependencies |
| Add a new reusable unit | [Create a power](create-power.md) | New identity, source pair, index record, PHP representation, and documentation |
| Repair or improve an existing power | [Maintain and debug](maintain-and-debug.md) | An explained source-level change with preserved identity and relevant regression evidence |
| Change a shared interface or abstraction | [Evolve shared contracts](evolve-shared-contracts.md) | Consumer analysis, compatible rollout or explicit migration, and coordinated validation |
| Establish what actually works | [Validate and integrate](validate-and-integrate.md) | Separate repository, PHP, JCB import, compile, and runtime results |

## Common operating contract

1. Establish the requested repository, base branch, supported PHP/Joomla/JCB versions, intended public behaviour, and authorized scope. Read that repository's own instructions. A package-authoring project's Joomla 6 restriction is not a universal Super Power restriction.
2. Inspect current sources and record their commits. The documentation's recorded revisions explain its evidence; they do not freeze every maintained repository forever.
3. Apply the [reuse order](../reuse-and-dependencies.md): Joomla core/framework, central `joomengine/super-powers`, specialist repositories, then new implementation. Record the actual candidates examined and why the selected dependency fits.
4. Work on a new branch for the task. When a PR is requested, publish a meaningful initial change and open it early; continue pushing coherent increments. A branch with no changes cannot normally produce a useful PR.
5. Treat `settings.json` and `code.power` as the imported source. Keep `code.php`, the index, and READMEs consistent. A corrected generated PHP file alone is not a power fix.
6. Preserve existing GUIDs. Generate new GUIDs with the supplied cryptographic UUIDv4 tool and check every known catalogue, including task-specific repositories. An identity lookup and a name search serve different purposes; perform both.
7. Keep the diff focused, retain licensing, follow tabs and the surrounding brace/docblock conventions, and make no unrelated data cleanup. Do not normalize every `null`, empty string, array, or object into one representation.
8. Run the applicable validation layers and report precisely which passed, failed, or were not run. An absent JCB installation is a limitation to disclose, not a reason to claim a compile passed.
9. Finish with the actual PR, commit, changed GUIDs, compatibility implications, and evidence. Do not merge, release, publish to another repository, or message third parties unless the user's authorized scope includes that action.

## Tools and working directories

Run the commands below from an `skills` checkout. `CATALOG_DIR` and `REPO_DIR` in command descriptions mean paths chosen for the current task, not literal file names to commit. Use the scripts' `--help` before automation. The [tools documentation](../../tools/README.md) defines their guarantees and limitations.

| Operation | Command interface |
| --- | --- |
| Fetch the registered repositories' live indexes | `bash tools/fetch-power-catalog.sh CATALOG_DIR [REGISTRY_JSON]` |
| Allocate an unused identity | `bash tools/new-power-guid.sh CATALOG_DIR [LOCAL_REPO ...]` |
| Check one authored repository against the catalogue | `bash tools/validate-power-repository.sh REPO_DIR CATALOG_DIR` |
| Check this documentation repository | `bash tools/check.sh` |
| Run the tooling regression fixtures | `bash tests/run-tests.sh` |

Keep downloaded catalogues, cloned references, temporary compiled extensions, credentials, and diagnostic logs outside authored source paths. Store only deliberate fixtures or summarized evidence in a PR.

The bundled fetcher supports the registry's public GitHub URL profile. For an additional repository on another host or requiring private access, retrieve its current index through the authorized host connection or checkout, preserve its provenance, and supply its checkout to the GUID check as an additional `LOCAL_REPO`. Do not exclude a known repository simply because this helper cannot fetch it. The helper's URL restriction is not a restriction on which Git hosts JCB supports.
