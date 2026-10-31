# Test JCB changes in Playground

[JoomEngine Playground](https://playground.joomengine.org/) runs Joomla, JCB, PHP and MariaDB in the browser. Use it to exercise repository acquisition, JCB authoring, compilation and installed consumer behaviour in a disposable environment. This is the common environment procedure; the entity modules retain their own acceptance tests.

**Project policy:** when implementation work calls for JCB integration testing, use an available suitable Playground/browser environment within the user's authorization. Continue ordinary test setup and reversible test changes without adding an approval pause. Respect an explicit opt-out, a different requested environment, and the browser/tool's actual capabilities. If the environment is unavailable, unsupported or blocked, retain the evidence, continue independent checks, and report the exact unexecuted stage. Never turn a blocked test into a pass or require an account, paid AI provider or public publication merely to run this procedure.

**Evidence boundary:** implementation claims here use Playground `main` at `4a2d017c653a12d5524f677772e4db50aa044e26`, inspected 2026-10-31. Its default recipe uses Joomla 6.2.0 and a browser-adapted JCB 6.2.0 package. JCB acquisition details are additionally traced to the separately pinned JCB `6.x` source. Those are distinct version identities. Compare the live installation before relying on a controller name or format. See [sources and freshness](sources.md) and the [observed verification record](verification.md); neither this procedure nor upstream Playground CI proves a candidate change passed.

## Reading path

| Task | Read next |
| --- | --- |
| Select versions, create a link, reopen or export a test site | [Configuration and lifecycle](configuration.md) |
| Super Power acceptance | [Import, compile and runtime workflow](../../super-powers/workflows/validate-and-integrate.md) |
| Field Type acceptance | [New/existing Field, compilation and runtime workflow](../../field-types/workflows/validate-and-integrate.md) |
| Snippet acceptance | [Acquisition, copied consumer and runtime workflow](../../snippets/workflows/integrate.md) |
| Package blueprint acceptance | [Graph acquisition, component/module/plugin compile and runtime](../../packages/workflows/validate-and-integrate.md) |
| Build in the GUI and export source | [Package authoring, write destinations and Push/read-back](../../packages/workflows/author-in-playground.md) |
| Understand what has actually run | [Verification record](verification.md) |
| Preserve and hand off a defect | [Issue reporting](../reporting-issues.md) |

## Common workflow

### 1. Prepare authoritative source and a testable revision

Read the entity's specification and run its applicable static checks first. Record the source repository, branch, commit, affected identities, dependencies and intended Joomla/PHP targets. Apply the module's identity rules, including fresh catalogue collision checks for genuinely new items. Fixture-only identifiers remain fixture-only.

| Change | Authoritative input to fix |
| --- | --- |
| Super Power | Repository `settings.json` and `code.power`, plus consistent index/derived representations |
| Field Type | Repository `item.json` and index; actual Field choices remain separate JCB authoring data |
| Snippet | Repository item/index/type references; copied consumer markup is maintained separately |
| Package blueprint | Per-model repository payloads/indexes, parent-owned records and assets; see the exact [package contract](../../packages/specification.md) |
| Compiled extension | Its JCB authoring source and dependencies; generated PHP/XML is evidence of the result |

Use the task's staging branch or fork to expose the candidate to JCB. Commit a coherent source/index change and record its SHA. Push that branch when repository publication is already authorized by the task. If publication is outside the authorization, use an approved accessible staging source or report acquisition as blocked; do not silently publish the work. A local checkout invisible to the browser cannot be tested by configuring its filesystem path as a Git repository.

Do not merge or change the production/default branch to make testing convenient. A branch name is a moving pointer: record the tested commit and recheck it after subsequent pushes. If the candidate is already published at the authorized PR branch, use that branch rather than creating an unnecessary second copy.

### 2. Start a separate test site and record its actual environment

Choose a [version-specific link](configuration.md#ready-to-use-test-links), inspect setup and Launch. Use a temporary site for a short test or a uniquely named saved site for work spanning reloads. Keep the owning Playground tab open. Wait for successful provisioning and the actual JCB administrator screen; a loaded outer page is not a successful Joomla launch.

Record the live build's source revision when obtainable from its public `assets/manifest.json`, resolved Joomla/PHP versions, installed JCB version, recipe, browser and candidate revision. The deployment manifest records package provenance; a saved site may still contain an older JCB installation. Use the running site's version information as well. Preserve non-secret setup/progress diagnostics if launch fails. Do not use a guessed `window.playground` global: the shipped UI keeps its runtime handle private to its module. [P01–P04, P07](sources.md)

### 3. Configure the candidate's real JCB repository connection

Open the test JCB instance's Repositories area. Inspect existing records before adding or changing one: a core repository can be present but disabled, configured for another target, or still pointing at another branch. Do not enable every repository. Enable/configure only the intended candidate and needed dependencies, preserving the known test baseline.

Record these values for every effective source:

| Setting | Required check |
| --- | --- |
| Content target | Super Power (`1`), Joomla Power (`2`), Field Types (`3`), Packages (`4`), or Snippets (`5`) as appropriate; a package's concrete Fields differ from Field Type catalogue records |
| Provider/type | GitHub or Gitea matching the actual host; these are independent of the content target |
| Host, organization and repository | Exact source; the inspected GitHub provider normalizes its API base to `https://api.github.com`; Gitea uses the configured base |
| Read branch | Candidate branch containing the tested commit, explicitly set; a write branch does not select import source |
| Published/enabled state | Confirm the record participates in this instance's lookup; mere existence is insufficient |
| Effective order | Candidate and dependency precedence, including every intentional same-GUID override and shadowed source |
| Access | Working public access or appropriately scoped configured credentials; never include tokens in source, URLs, screenshots or receipts |

The inspected JCB helper selects target-matching rows with `published >= 1` and reads `ordering DESC`; each entity config then prepends entries. For distinct repository keys, the resulting configured order puts smaller numbers first. The predicate also includes archived state `2`: do not infer exclusion from its label. Duplicate owner/repository keys collapse and do not include the host; tied order or ambiguous duplicate connections require inspection, not assumptions. Explicit selection can constrain lookup to one repository. Confirm the source actually selected for the item. [J01–J03](sources.md)

Each entity config starts with its configured initialization fallback paths before prepending eligible database rows. Disabling a repository row therefore does not necessarily remove an equivalent fallback source. Inspect the effective source list and selected provenance rather than treating the database row's disabled state as proof of exclusion. [J03](sources.md)

For new Field Type/Snippet identities, the mandatory current official catalogue comparison remains part of source validation even if its connection is disabled in a particular test site. Runtime dependency availability and global catalogue collision checks are different obligations. Follow the corresponding module's registry and dependency rules.

### 4. Acquire or refresh deliberately

Use the entity list's supported authenticated toolbar/selection flow with its normal permissions and request tokens. The inspected controllers use `initPowers`, `pullPowers` and `resetPowers` under `powers`, `fieldtypes` or `snippets`; verify the installed version's actual UI before acting. [J04–J05](sources.md)

| Operation | Meaning and verification |
| --- | --- |
| **Init** | Discover/select remote definitions to acquire. Ordinary initialization preserves an already-local GUID; an “already local” result does not prove the candidate was imported. |
| **Pull** | Opens the pull-selection flow. Inspect the selected source and offered changes, complete the intended selection, then inspect the resulting record. Opening the selection screen is not acquisition evidence. |
| **Reset** in a JCB entity list | Refreshes selected local definitions from remote lookup. Preserve intentional local edits first; verify the expected GUID and source before overwriting. Dependency traversal differs by entity. |
| **Reset** in Playground | Deletes the selected test site's saved files/database. It is unrelated to refreshing an entity. |
| **Push** in JCB | Writes to the configured remote source. It is unnecessary for a read/import test and belongs only to an authorized export/publication step. |

Import only the required items. Capture meaningful success/local/not-found/error results. Inspect the saved local record's GUID, changed content and dependencies; a toast, record count or HTTP 200 is insufficient. For an update, check a distinctive intended difference. If a cached index or wrong branch hides a change, verify remote commit, indexed paths and selection first, then use the target version's supported reload/refresh path. Do not bypass an import failure by writing directly to JCB's database and call that a successful repository import.

Package authoring may start in this GUI: create and connect the actual component/module/plugin records, compile/test them, then export their portable source through Push. Follow the [package authoring workflow](../../packages/workflows/author-in-playground.md) before supplying credentials or writing. Audit all eligible package write destinations; the inspected generic exporter can write beyond one apparently selected repository. Verify the remote payload/index/asset diff and acquire it into another test instance. A compiler ZIP download is not this repository export.

### 5. Exercise the actual authoring consumer

Follow the linked module workflow. A referenced Super Power, an attached concrete Field, or source copied into an actual Snippet consumer must participate in the build. An imported but unused catalogue item proves only acquisition. Preserve and compare existing consumers when the change affects existing identities.

Save/reopen the JCB authoring record and verify that the change persists. Record the test component/view/Field or calling code and relevant configuration. Do not assume that a refreshed catalogue automatically migrates existing Fields, copied snippets or already-installed extensions.

### 6. Compile, inspect, install and run

Compile the selected test component for the intended Joomla target through JCB. Check compilation messages and download the resulting package. Inspect actual generated PHP/XML/templates, dependencies, autoloading/assets and relevant SQL using the module's acceptance criteria. Record the package hash and generated paths where available; successful ZIP creation alone does not prove the changed feature is included.

Use the compiler's **Download Component** result to retain the ZIP outside the browser runtime, then list/extract it into a separate scratch directory for inspection with available ZIP/PHP/XML tools. Keep the original package and its hash alongside the receipt. Upstream's compiler test finds its generated ZIP under `/persist/www/tmp/`, but take the current result/download location as authoritative rather than guessing a filename. Code can inspect files that actually exist in the active site; it does not automatically expand a ZIP into an installed component. After installation, inspect the real installed paths and compare the relevant files with the compiled package. If the available browser cannot download/upload or expose artifact bytes, record that inspection/install stage as blocked instead of inferring package contents from a success page. [P08, P12](sources.md)

Install/update that package through Joomla's supported extension flow in the disposable test site, or in a separate compatible [Joomla-only site](configuration.md#deployment-presets) when a clean runtime consumer is needed. Capture the installer result and open the actual runtime page/caller. Execute the module's success, failure and boundary cases. An isolated browser instance is not a remotely reachable deployment; moving a compiled package to another instance requires its supported download/upload or package-URL flow.

A compiler/runtime failure needs diagnosis against the actual source revision. If using Code to inspect or temporarily instrument generated/installed files, preserve a diff and label it diagnostic. Apply the durable correction to authoritative source, refresh the intended record, recompile and reinstall, then repeat the affected check. A passing test after patching only generated PHP does not validate the repository change.

### 7. Save evidence and report the stages separately

Record source and runtime revisions, repository settings/effective order, changed identities, exact actions, expected/observed results, artifact hashes/paths, and remaining limits. Separate static, discovery, import/refresh, compile, installation and runtime outcomes. Mark skipped or blocked stages explicitly, including the opt-out or concrete blocker. Use the [verification record](verification.md) as an example of bounded evidence, not a result to copy into another task.

Save the test site explicitly if it must survive reloads and export needed artifacts. Keep credentials and private recovery files out of public receipts. A Share link transfers public setup, not the database/files or proof of a completed run. Preserve failures before reset or closing a temporary site. For a reproducible upstream defect, follow [human issue reporting](../reporting-issues.md); do not automatically submit an issue or contact maintainers.

## Inspect and diagnose with JoomEngine Code

Open **JoomEngine Code** beside the running site. Its workspace is the active Joomla document root, `/persist/www`, so it can inspect generated/installed PHP, XML and templates. File **Save/Save All** writes the runtime filesystem; **Refresh site** reloads the preview separately. Later requests can use saved files even before refresh. Playground **Save** persists site state. Unsaved editor drafts are neither saved runtime files nor portable exports. Preserve intended changes and resolve conflicts rather than overwriting a newer file. The editor is not a host terminal or a Git checkout of the source Power catalogue. [P08](sources.md)

Imported Powers, Field Types, Snippets and JCB authoring records are held in the site's database. Browsing or editing a PHP file in Code does not update those records. Use JCB's supported record editor/acquisition flow for them, then compile again. Likewise, updating a repository JSON/body file is not complete until the intended database record is refreshed. Keep repository source, JCB database state, compiled package and installed files distinct when tracing a mismatch.

For a PHP failure, use **Debug and refresh** for the current GET, or **Arm PHP request** with the exact URL/query and method before the matching navigation/form submission. Set a breakpoint in an executed source location; inspect stack/variables and step/continue. Expression evaluation executes PHP and can have side effects. While paused, source writes and normal requests queue: continue/stop before waiting for them. Stopping a POST does not roll back completed writes or authorize replay; inspect state before retrying. [P09](sources.md)

The optional **AI Assistant** is separate from the external agent operating this workflow. It can read bounded context and propose file changes for review; it has no shell or PHP execution tool. It needs a user-configured provider accepting requests from its opaque origin, and live provider compatibility is not established merely by a preset or fixture test. Normal editing/debugging needs no AI key. Its changes still require the authoritative-source/rebuild procedure above. Do not put credentials in project files or ask for them when browser testing does not need the assistant. [P10](sources.md)

For an authorized automated harness, Playground exports `prepareEnvironment()` and `createPlayground()`; the returned handle offers `runtimeInfo`, `configuration`, `installation`, `request`, `runPhp`, filesystem operations, save and export. Upstream Playwright tests demonstrate this path. It requires a compatible browser context and an explicitly created handle, not a server-side PHP endpoint. Follow the active browser tool's rules; do not use a hidden handle or unsupported script evaluation to bypass them. [P07, P12](sources.md)

## Environment limits that change test conclusions

| Boundary | Consequence |
| --- | --- |
| WASM runtime and adapted JCB package | Record browser/PHP/Joomla/JCB and package provenance. Browser success does not certify byte-identical native JCB, 64-bit PHP or every production server. |
| Browser Fetch/CORS | PHP HTTP calls and repository/package downloads still require the host's CORS permission. No public proxy is provided. Diagnose provider/CORS/rate-limit/auth errors before blaming an item format. |
| Occupied PHP worker | Recursive HTTP into the same running instance cannot complete. Use an independent service/instance for such tests where appropriate; do not claim this execution path passed. |
| Optional `jcb-mcp` | Same-browser authentication/discovery is available; content-editing actions requiring recursive Joomla API calls are unsupported in this release. External MCP clients cannot reach a private browser instance via the static URL. |
| Database/host facilities | Real MariaDB/PDO is available; remote database connections, `mysqli`, arbitrary sockets, host executables and a production mail server are not. |
| Browser storage/memory | Save/export deliberately; browser storage may be cleared/evicted, tab closure may interrupt saving, and advertised PHP limits do not guarantee available device memory. |
| Browser isolation | Requires HTTPS/localhost, service workers, Web Locks, IndexedDB, SharedArrayBuffer and cross-origin isolation. This release documents desktop Chromium/Firefox support; unsupported browsers are a recorded blocker. |
| Trusted development | Installed code can access this origin's test data. Site keys organize sites; they are not a hostile-code or multi-tenant security boundary. Use reviewed inputs and appropriate test data. |

The pinned [runtime, package, transport and MCP sources](sources.md) establish these limits. Keep native-environment checks for affected behaviour outside the browser's coverage, and describe exactly which environment passed.
