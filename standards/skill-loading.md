# Load and distribute the JCB skills

Use the complete repository as one portable skill distribution named **`joomengine-jcb`**. Keep its root [SKILL.md](../SKILL.md), [AGENTS.md](../AGENTS.md), model entrypoints, detailed references, registries, shared testing procedures and tools together. The model `SKILL.md` files are co-located task routes that depend on shared parent resources; copying one model directory alone does not create a self-contained installation.

## Obtain a complete checkout

Clone into the directory matching the root skill's frontmatter name:

```bash
git clone https://github.com/joomengine/skills.git joomengine-jcb
cd joomengine-jcb
git rev-parse HEAD
```

Record that revision for reproducibility. For a review or a pinned release, select the explicitly requested branch/commit and record it instead of assuming the default branch contains the candidate. Preserve the complete directory hierarchy in an export and name its top-level directory `joomengine-jcb`. The remote repository name `skills` does not change the skill name or require a checkout directory named `skills`.

## Give the agent an explicit entrypoint

Supply the checkout's absolute path and task, or an accessible task-entry URL with permission to read its linked resources. For a local task, instruct the agent to read `SKILL.md` and `AGENTS.md` from that checkout, then the selected model entrypoint. Resolve Markdown paths relative to the containing document; run shell commands from the checkout root unless a workflow explicitly states otherwise.

| Task | Local entrypoint from checkout root | Published entry URL |
| --- | --- | --- |
| Route a JCB task | [SKILL.md](../SKILL.md) | [Root skill](https://github.com/joomengine/skills/blob/main/SKILL.md) |
| Work with Super Powers | [super-powers/SKILL.md](../super-powers/SKILL.md) | [Super Powers skill](https://github.com/joomengine/skills/blob/main/super-powers/SKILL.md) |
| Work with Field Type catalogues | [field-types/SKILL.md](../field-types/SKILL.md) | [Field Types skill](https://github.com/joomengine/skills/blob/main/field-types/SKILL.md) |
| Work with Snippets and classifications | [snippets/SKILL.md](../snippets/SKILL.md) | [Snippets skill](https://github.com/joomengine/skills/blob/main/snippets/SKILL.md) |
| Author and maintain Package blueprint graphs | [packages/SKILL.md](../packages/SKILL.md) | [Packages skill](https://github.com/joomengine/skills/blob/main/packages/SKILL.md) |
| Author, export and test in browser-hosted JCB | [testing/playground/SKILL.md](../testing/playground/SKILL.md) | [Playground skill](https://github.com/joomengine/skills/blob/main/testing/playground/SKILL.md) |

The `main` URLs are discovery links. Replace `main` with the recorded commit when requesting a reproducible review. Use the root skill and [module registry](../registries/modules.json) to discover additional model routes as they are introduced; do not assume that every architecture subject already has an operational skill.

For a client with a supported local-skill registration mechanism, register the complete `joomengine-jcb` root directory using that client's documented procedure. If it requires copying a skill into a configured location, copy the whole distribution there. Check that the client can read the referenced files and invoke the tools needed for the task. If it cannot load parent/shared resources from a nested route, register the root and read the model file as a referenced instruction document.

For a client without skill registration, provide the explicit files/URLs as task instructions and make the complete checkout available when executable tools are needed. Do not assume nested skills are discovered recursively, a remote URL installs anything, or an `AGENTS.md` in this checkout governs another repository. Do not assert a universal client install directory or invocation syntax. Registration/loading supplies instructions, not browser access, credentials or authorization to publish.

This repository workflow does not install a personal ChatGPT skill. Any client-specific installation is a separate operation with its own documented confirmation and verification.

## Load progressively and keep one authority

1. Read entrypoint metadata to select a task route, then read that route's instructions.
2. Load the exact contract fields, workflow, examples and source evidence needed for the requested change. Do not preload every module or every architecture chapter.
3. Load another model's entrypoint when an actual relationship crosses its boundary, such as a package Field referencing a Field Type or a consumer using a Super Power.
4. Reuse the canonical shared resources: [engineering policy](../AGENTS.md), [registries](../registries/modules.json), [validation tools](../tools/README.md), [Playground](../testing/playground/README.md), and [human issue reporting](../testing/reporting-issues.md). Keep detailed model semantics in their existing contracts and references; route to them instead of maintaining duplicate copies in skill bodies.

Use the task-specific workflow for actual authoring and integration. To inspect tools or check the documentation distribution, run from its root after satisfying [tool prerequisites](../tools/README.md):

```bash
bash tools/validate-power-repository.sh --help
bash tools/validate-field-type-repository.sh --help
bash tools/validate-snippet-repository.sh --help
bash tools/validate-package-repository.sh --help
bash tools/check.sh
```

These commands do not install the skills into a client. A documentation/static check does not certify candidate import, compilation, installation or runtime behaviour; report those stages separately under the selected model's acceptance procedure.

## Maintain portable entrypoints

Follow the [Agent Skills specification](https://agentskills.io/specification), checked 2026-10-31: use required `name` and `description` frontmatter, match `name` to the containing directory, keep the description within 1024 characters, and keep the instruction body below 500 lines. Make triggers specific to JCB artifacts and tasks. Link directly to needed references and preserve their relative paths in the distribution. The root name check applies to its exported/installed directory `joomengine-jcb`; an internal development checkout can have another directory name.

Use this repository's bounded metadata profile: exactly `name` and `description`, with a plain name and a one-line JSON-quoted description that is also valid YAML. This is a project validation convention; the broader specification permits additional fields.

Follow [module authoring](module-authoring.md) when adding a model route. Validate metadata, local destinations and the resulting task workflow; test with only the distributed resources available. Commit source changes through this repository's normal review process. Do not report client installation or successful automatic discovery unless that client operation was actually performed and verified.
