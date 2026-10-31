# Validate repository source and JCB integration

Validation is layered. Each layer answers a different question; report them separately. The supplied shell tools establish static checks, not a replacement JCB compiler.

## Validation matrix

| Layer | What it can establish | What it cannot establish |
| --- | --- | --- |
| JSON and repository checks | Parseable settings/index, consistent identity/paths/SPK, detected references, expected representations | Full PHP semantics, every dynamic dependency, actual JCB persistence |
| Catalogue resolution | Selected known references and their recorded provenance; visible duplicates/shadowing | Worldwide uniqueness or absence of dependencies in other repositories |
| PHP lint | Syntax validity of assembled PHP on the tested interpreter | Correct runtime behaviour or syntax support on untested PHP versions |
| Focused behaviour tests | The exercised implementation and error cases | Every consumer or real external API behaviour |
| JCB import/refresh | The tested JCB version consumes the source pair into its local power record | Correct compilation or installed runtime behaviour |
| JCB compilation | The tested component produces expected PHP, imports, namespaces, placement, and autoloading | Behaviour of every consumer or installation |
| Consumer runtime | The tested service/call works in the recorded environment | Compatibility with untested targets and callers |

## Static sequence

From an `ai-doc` checkout, use the command interfaces in the [workflow index](README.md) and [tool reference](../../tools/README.md):

1. Fetch the current registered catalogue into a fresh directory. Inspect its completion status, revisions, hashes, and resolution order. Preserve additional project-specific repository provenance.
2. Validate the entire authored repository, not just the edited settings file. This catches stale index entries and references to sibling powers.
3. Review every diagnostic. Existing intentionally shadowed identities require an explicit ordered-resolution explanation. A new power must not collide with an existing identity. An unresolved external GUID requires its actual repository; the seven baseline catalogues are not a closed world.
4. Lint assembled `code.php` files and compiled PHP on the minimum supported PHP version and other affected targets. If the local interpreter is unavailable, run the configured CI job and report that environment. Do not apply `php -l` directly to a body fragment and count that as a class syntax check.
5. Execute focused behaviour tests. Where remote APIs are involved, separate deterministic fixtures from any live authorized check. Record test inputs, relevant outputs, and the implementation revision without recording secrets.
6. Review source-to-representation consistency, including imports, declaration, licence, and namespace context. A normalized body substring check catches some drift but cannot prove that every assembled detail matches JCB.
7. Refresh the catalogue before finalizing new identities if work has continued since the first snapshot. Re-run only checks affected by intervening changes.

## JCB import and compile acceptance procedure

**Project policy:** use [JoomEngine Playground](../../testing/playground/README.md) as the default browser integration environment. Follow its shared setup and [repository/branch configuration](../../testing/playground/configuration.md), then perform the Power-specific checks below. A target requiring capabilities unavailable there needs a documented suitable test environment; name the limitation and the checks moved there. Do not silently replace an integration result with static validation.

The [shared receipt](../../testing/playground/verification.md) records an observed upstream Regex import. It does not mean this complete acceptance procedure, a candidate PR branch or this module's fixtures have been exercised. Use a separate disposable test site or preserve the local state affected by the test.

### 1. Record and prepare the environment

- Record the actual installed JCB version/commit when available, Joomla version, PHP version, extension/component revision, changed GUIDs, power repository revision, and all dependency repository revisions. A source-inspected branch is not automatically the installed package: the implementation evidence below is `6.x@408703a` (manifest `6.2.1-alpha1`), whereas the recorded browser smoke test used installed JCB `6.2.0`.
- Choose a small test component with an explicit namespace prefix and component namespace. Use a second distinct namespace context when changing portability, aliases, or placement.
- Preserve any local JCB definitions that differ from remote source before refreshing them. Repository reset is an update operation, not a read-only comparison.
- Use the shared configuration procedure to register the host/owner/repository and **read branch** containing the candidate source. For Powers, the repository target is Super Powers. Record the resolved commit and precedence against other repositories containing the same GUID; the write branch does not select import source. A test of upstream `master` does not establish that a candidate branch imports correctly.
- Configure required dependency repositories and credentials through the test environment. Keep credentials out of the repository and test evidence.

### 2. Import a new power or refresh an existing one

Use the supported authenticated browser flow. These control semantics were verified in the pinned source; check the installed version if its screens or results differ. The actions require their corresponding Joomla permissions and request tokens.

| Action | Selection and source scope | Appropriate assertion |
| --- | --- | --- |
| **Init** | Opens Initialization Selection without requiring local list rows. Choose a repository, then absent remote GUIDs. Calls package initialization with that explicit repository and `force=false`. | A previously absent GUID appears as a persisted local Power with the expected settings/body. Existing local items are skipped; their disabled/local state is not a new import. |
| **Pull** | Opens Pull Selection without requiring local list rows. Choose the intended repository and remote items. Calls initialization with that repository and `force=true`. | A deliberate update to an existing GUID replaces the intended local values from the selected read branch. It can also initialize absent selected items; it is not a Git merge. |
| **Reset** | Requires selected rows in the local Powers list. Resolves their local IDs to GUIDs and resets through the approved ordered repositories, without an explicit repository selection. | The persisted definitions match the first effective source for those GUIDs; this may differ from the source selected in an earlier Init/Pull. |

Preserve any local edits before Pull or Reset. Package operations can also process tracked dependencies/assets: initialization carries the selected repository and force setting into queued dependencies; reset follows its tracked direct-child/asset path. Inspect the reported scope rather than treating a one-item selection as proof that only one database record can be touched. For cross-repository dependencies, make the required local definitions available through their actual sources and verify them; do not assume an explicit-repository import automatically searches every configured source for its dependencies.

For global lookup, the first indexed GUID wins, and an invalid selected payload does not imply fallback to a later duplicate. Changing order or a read branch does not update local records. Use a fresh request after configuration changes, then the appropriate action and persisted-value checks; repository indexes and request trackers can retain state within a request.

Inspect the imported record through JCB:

1. Confirm the GUID, name, type, portable namespace, and version match the proposed settings.
2. Reopen the saved record and confirm `main_class_code` contains the expected `code.power` body. For an update, record a distinctive old/new method, literal or documented behavior before refreshing, then verify the candidate value afterward. Choose a real part of the proposed change rather than adding production test markers. A success toast or an unchanged existing record does not demonstrate refresh.
3. Confirm inheritance, interfaces, imports/aliases, load selections, custom header flags/content, Composer metadata, and licensing values required by this power survived import.
4. Confirm dependency powers are available and selected from the expected repositories. Capture actionable import messages if anything is missing.

Do not expect a `code.php`-only edit to appear in `main_class_code`: the Power grep/import path reads settings plus the indexed raw power body. The inspected initialization getter reports an added category after calling storage without checking its return value, so its log alone is insufficient. If UI inspection only confirms visible methods and metadata, report that scope; do not call it a byte/hash comparison.

### 3. Compile a real reference

Add an actual reference to the changed power in the test component using its active `Super___...___Power` token, or exercise an existing component reference. An unreferenced power may not be included, so a successful compile without a call/reference is insufficient.

For a service-based power, invoke it through the same factory/provider/service identifier intended for consumers. Ensure the changed provider is itself included and registered. For an interface or abstract class, include a concrete implementation/consumer that exercises the changed contract. Where `load_selection` is relevant, verify the intended included-only dependency even if there is no PHP `use` statement. Do not treat an imported dependency or a provider class present in a file as proof that its service was registered or constructed.

Compile the test component and inspect its generated output:

- The expected power file exists in the compiler-selected location; do not hardcode a path from another component.
- Namespace, class name, parent, interfaces, imports, aliases, and trait use are correct for this component context.
- The intended body is present, with expected placeholder resolution and no remaining active Power tokens.
- Dependencies and autoload registration are present, and there are no collisions after namespace relocation.
- Generated PHP lints on the target interpreter.

Use the Playground **Code** interface, following the shared procedure, to locate and read the actual generated or installed files. Record their paths and the relevant namespace/import/body/autoload evidence. An upstream `code.php` preview or the saved raw-body editor is not generated component output. If compilation produces an archive, inspect its contents or install the test build and inspect the installed files; identify which artifact was checked. If the environment cannot run the required PHP lint, perform it in the declared matching PHP environment and record that boundary.

When portability changed, repeat with a different namespace prefix/component namespace and verify that no source-specific resolved prefix leaked into the result.

### 4. Exercise and report the runtime path

Install/run the compiled extension only in the authorized test environment. Exercise the smallest real caller, DI construction, success case, and relevant failure/edge case. For an API client, validate request encoding and response/error handling using controlled fixtures before an optional live service check.

Run the caller through the installed extension's actual route, command or service consumer and assert an observable result. A manually pasted class that bypasses generated imports, autoloading or DI does not verify that path. For a pure helper, record a deterministic input and expected return; for stateful code, also inspect the intended state change and relevant failure case. Do not count opening the editor or compiling an unused class as runtime execution.

Report each stage independently using the [shared evidence procedure](../../testing/playground/README.md) and [receipt](../../testing/playground/verification.md): repository checks, PHP lint/tests, new import or existing-item refresh, generated namespace/path inspection, runtime caller and limits. If import ran but compilation did not, say exactly that. If access or a capability fails, record the observed blocker and the next concrete step; do not retain an obsolete blanket claim that no environment exists.

## Round-trip and drift investigation

Where safe and supported by the test instance, export the imported power to a separate scratch repository/branch and compare its source pair and index with the authored files. Do not export over the candidate branch during diagnosis. Distinguish meaningful value changes from key order, escaped slashes, and LF/CRLF differences; do not ignore field deletion, lost aliases, changed sentinels, or resolved placeholders replacing templates.

A round trip can expose compiler/exporter assumptions missing from a hand-authored definition. Investigate differences against the target source and update either the power or documented contract. It does not authorize normalizing every historical export.

## Source evidence for this procedure

The implementation observations above were checked against JCB `6.x` commit `408703a857ad937479b1e28de7f693af178dcc83`:

- [Powers controller initialization, Pull and Reset](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/PowersController.php): permission/token checks, selection-screen redirects, selected-local-GUID reset.
- [Selection AJAX actions](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Model/AjaxModel.php#L6770): Init uses the selected repository; `pullSelectedPackages()` passes `force=true`.
- [Initialization selection table](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/layouts/powerselectiontable.php#L96) prevents selecting existing local entries; [Pull selection table](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/layouts/powerpullselectiontable.php) does not apply that local-entry exclusion.
- [Package builder](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Builder/Get.php#L124): selected-repository initialization, queued dependencies/assets and reset scope.
- [Remote getter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Get.php): `init`, local-existence behaviour, read-branch selection.
- [Power grep](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Grep.php): settings and raw power loading into `main_class_code`.
- [Repository form](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/repository.xml): separate repository host and read/write branch fields.
- [Grep lookup and cache](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Grep.php#L676): single-source lookup, first remote GUID match and repository index caching. [Power configuration](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Config.php#L201) constructs approved source order.

For another JCB version, verify these paths/actions before applying the procedure. These references support implementation behaviour; the test matrix and reporting requirements are documentation policy.
