# Create a package repository from an empty directory

## Inputs and intended output

Obtain the application's concrete requirements, root extension type, Joomla/JCB/PHP targets, repository owner/host, baseline and candidate branches, licensing, and publication scope. Record the exact JCB source revision, current ordered package repositories, mandatory official Field Types, and any additional Field Type/Power catalogues. Use only repositories the task permits accessing. A private example is not permission to publish its contents.

The output is an indexed source graph and its review evidence. It is not a compiled extension ZIP or a Playground site backup. Use the [contract](../specification.md), [entity references](../reference/README.md), [examples](../examples/README.md) and [tools](../../tools/README.md). The minimal example is an instructional transport fixture, not an assertion that an arbitrary production component will compile.

## 1. Establish a reviewable repository

Start in a new, task-owned directory. With Git installed, these commands create the repository and source directories; they do not create a usable blueprint:

```bash
mkdir my-package
cd my-package
git init --initial-branch=master
mkdir index src
printf '{}\n' > index/joomla-component.json
```

Write the repository README with its purpose, supported target matrix, entry root identities, ordered external sources/read branches, and authoring/validation route. Add the correct license and attribution for original and reused content. Add a short local `AGENTS.md` pointing agents to this module, the identity/serialization rules and that repository's target constraints. An instruction file in this documentation checkout does not govern a separate checkout automatically. Keep credentials, exports of site state and local database dumps out of the source repository.

Commit the initial documentation and create the task's candidate branch. A remote repository/branch must have a real initial commit before JCB can use it; empty local directories are not a remotely readable branch. Configure an authorized GitHub/Gitea remote and publish this initial candidate when that publication is in scope. Open the requested PR early, targeting the agreed base. The attachment's blueprint-authoring project uses `master` as its integration branch; use the authorized candidate branch for review/testing and record any other repository's actual branch rather than assuming all upstream examples use `master`.

## 2. Choose the authoring path

**Recommended for a new application:** follow [Author in Playground and Push](author-in-playground.md). It creates and saves the graph through JCB's own forms and exports with the current serializer. Return here to inspect the exported artifacts and review the resulting diff. This does not eliminate identity, dependency, version or runtime validation.

For direct repository authoring, complete steps 3–6 below. Use the full [minimal repository](../examples/minimal-repository/) to understand the artifact set. Follow its adaptation instructions for fresh identities; never publish its reserved fixture identifiers as an unrelated application. Do not copy an upstream component's complete identity set into a new product and merely rename its root.

## 3. Plan identities and relationships before writing records

Make a small change ledger: entity, repository key, purpose, existing/new/intentional-override decision, owner, and affected consumers. The contract's actual repository key governs identity:

- Preserve an existing key for maintenance of the same entity or an intentional ordered override. Record which source must win and which are shadowed.
- Generate new UUIDv4 values with a cryptographic system facility for distinct new GUID-keyed records. JCB can allocate GUIDs on save; still compare them with all visible current package indexes and pending records. A local database check alone is not a cross-repository collision check.
- Manual Custom Code uses `function_name`, Placeholder uses `target`, and Validation Rule uses `name`. Check these exact natural keys in their own entity indexes; do not replace them with UUIDs. Automated Custom Code has an additional path-derived export exception; inspect the [identity contract](../specification.md#typed-identities-and-supported-families) before adapting that route.
- Direct children use their parent's key and their entity-specific settings filename. They are full linking records, not independent new GUIDs or bare edge lists.
- File/folder identities and payloads follow the separate asset contract; do not generate an `item.json` or substitute a GUID for an opaque pointer.

On Linux, an available system UUID source can be read with `cat /proc/sys/kernel/random/uuid`; allocate once per new record and save the result in the change ledger. Verify its UUIDv4 shape and check its absence before use. For each relevant index, `jq --arg key "$candidate_key" 'has($key)' INDEX_FILE` must return `false` for a genuinely new key. Repeat against every current comparison source and pending index; retain exact revisions and unavailable-source limits. This example is a per-index check, not an automated global uniqueness guarantee. Do not use the Super Power allocator as if it understood package natural keys and child identities.

Plan the smallest complete consuming graph. For an administrator CRUD example: Component → Component Admin Views linking record → Admin View → Admin Fields linking record → concrete Field → external Field Type. Include each link's actual menu/ACL/order/tab/list/edit choices. Add site/custom views, Dynamic Gets, relationships, layouts, templates, libraries, modules/plugins, update records and assets only where the application requires them. Define application-table relationships explicitly; a package dependency edge is not a runtime foreign key or selector implementation.

## 4. Construct authoritative records and locators together

For each record, use its generated entity reference plus the underlying Remote Config, Table metadata, XML form/subforms and SQL at the target revision. Do not invent empty values or infer all required semantics from a specimen. Preserve historical spellings, numeric strings, zero, null, empty structures, storage encodings and code placeholders according to that field's contract. Never base64-encode every string or JSON-encode a native collection twice.

The ordinary component/CRUD example uses these exact locator families:

| Artifact | Locator/payload |
| --- | --- |
| Component | `index/joomla-component.json` → `src/joomla_component/COMPONENT_KEY/item.json` |
| Component Admin Views | `index/component-admin-views.json` → `src/joomla_component/children/COMPONENT_KEY/component-admin-views.json` |
| Admin View | `index/admin-view.json` → `src/admin_view/VIEW_KEY/item.json` |
| Admin Fields | `index/admin-fields.json` → `src/admin_view/children/VIEW_KEY/admin-fields.json` |
| Concrete Field | `index/field.json` → `src/field/FIELD_KEY/item.json` |

Index naming is not a universal snake_case-to-hyphen conversion. Read each entity's Config; for example Validation Rule uses `index/validation_rule.json`. An index summary's `guid` value can hold a natural key or parent key. Write every locator and its actual settings/payload target in the same change. Preserve unrelated entries in shared indexes.

Populate `@dependencies` using the actual relationship/scanner rules in the [specification](../specification.md), including permitted inward child records, outgoing references, subform Fields and supporting code. It is generated transport metadata, not a database field. Do not use a manually complete-looking list to conceal missing real links. Resolve implicit code references separately, including Power tokens, Custom Code, placeholders, templates and layouts.

The global Field Type catalogue remains external: import/resolve it using [Field Types](../../field-types/README.md), with `joomengine/joomla-fieldtypes` mandatory. Super Powers and Joomla Powers retain their own source/identity rules and configured order. Do not create package `src/fieldtype` or `src/power` records to make an unresolved external edge appear local.

## 5. Validate the entire intended root closure

Run the shipped structural command from this documentation checkout, using absolute paths when the repositories are elsewhere:

```bash
bash tools/validate-package-repository.sh /absolute/path/my-package \
  --with /absolute/path/required-package-repository
```

The candidate comes first; subsequent `--with` sources preserve the order supplied. Known external Field Type `index.json` and Power `super-powers.json` inputs are supported alongside package indexes. This is an offline check of supplied bytes, not a remote fetch or freshness guarantee. Exit `1` means malformed/unsafe input; exit `2` means unresolved references. Add `--report NEW_REPORT_FILE` to retain selected/shadowed occurrences, local provenance and findings at a new output path. Use [Tools](../../tools/README.md) for exact coverage, including deferred local database-ID links and incomplete token-derived dependency analysis. Do not remove a genuine dependency just to obtain a zero exit status.

Inspect the selected root's reachable graph and the reverse references of every reused record. Verify no missing settings/assets, accidental key reuse, wrong child parent, omitted index entry or unintended orphan. Check external Field Types and embedded code references with their own tools/evidence. A static validator does not prove a buildable application, nor that a selected-repository Init can fetch dependencies held only in other repositories.

Run [integration acceptance](validate-and-integrate.md) for authorized implementation work. Stage the coherent candidate first so the browser can read the actual revision. Keep review/merge separate: checks passing do not authorize merging the PR.

## 6. Deliver and recover

The review must contain the complete source/index/README/asset diff, identity ledger, selected root, ordered source snapshots, dependency closure and unresolved limitations, plus exact validation stages run. Include the current PR/candidate commit, build artifact hashes and runtime matrix when exercised.

If direct construction produces import or form-save differences, compare against JCB's serialized output and the target source contract; return the correction to the maintained repository. If the input graph is incomplete, obtain the missing authorized definitions or mark the precise dependency blocked. Preserve the candidate branch and evidence; never repair a failed test by silently deleting dependencies, overwriting shared records or changing an unrelated default branch.
