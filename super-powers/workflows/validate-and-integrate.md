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

This is an executable acceptance procedure for an operator/agent with a suitable test JCB instance. It is not evidence that this documentation build ran JCB. Use a disposable or backed-up development instance, not an unreviewed production instance.

### 1. Record and prepare the environment

- Record the JCB version/commit, Joomla version, PHP version, extension/component revision, changed GUIDs, power repository revision, and all dependency repository revisions.
- Choose a small test component with an explicit namespace prefix and component namespace. Use a second distinct namespace context when changing portability, aliases, or placement.
- Preserve any local JCB definitions that differ from remote source before refreshing them. Repository reset is an update operation, not a read-only comparison.
- In the test instance's repository configuration, select the correct host/owner/repository and **read branch** containing the candidate source. Record precedence against other repositories containing the same GUID. Do not change the production/default branch merely to test a PR.
- Configure required dependency repositories and credentials through the test environment. Keep credentials out of the repository and test evidence.

### 2. Import a new power or refresh an existing one

Use JCB's supported Powers initialization/refresh actions for the targeted version. In the inspected JCB `6.x` implementation, `powers.initPowers` opens initialization selection; the selected-powers reset action resolves the GUIDs and calls the package builder's reset path. Both operations require the relevant Joomla permissions and request token. Use the UI/API's supported authenticated flow rather than constructing unauthenticated controller requests.

Initialization and refresh are not equivalent. The remote getter's `init(..., force=false)` leaves a power that already exists locally classified as local; that is not proof the changed body was imported. Select the intended existing GUID and use the supported refresh/reset operation when verifying an update.

Inspect the imported record through JCB:

1. Confirm the GUID, name, type, portable namespace, and version match the proposed settings.
2. Confirm `main_class_code` contains the expected `code.power` body, including a distinctive changed method where relevant.
3. Confirm inheritance, interfaces, imports/aliases, load selections, custom header flags/content, Composer metadata, and licensing values required by this power survived import.
4. Confirm dependency powers are available and selected from the expected repositories. Capture actionable import messages if anything is missing.

Do not expect a `code.php`-only edit to appear in `main_class_code`: the Power grep/import path reads settings plus the indexed raw power body.

### 3. Compile a real reference

Add an actual reference to the changed power in the test component using its active `Super___...___Power` token, or exercise an existing component reference. An unreferenced power may not be included, so a successful compile without a call/reference is insufficient.

For a service-based power, invoke it through the same factory/provider/service identifier intended for consumers. Ensure the changed provider is itself included and registered. For an interface or abstract class, include a concrete implementation/consumer that exercises the changed contract.

Compile the test component and inspect its generated output:

- The expected power file exists in the compiler-selected location; do not hardcode a path from another component.
- Namespace, class name, parent, interfaces, imports, aliases, and trait use are correct for this component context.
- The intended body is present, with expected placeholder resolution and no remaining active Power tokens.
- Dependencies and autoload registration are present, and there are no collisions after namespace relocation.
- Generated PHP lints on the target interpreter.

When portability changed, repeat with a different namespace prefix/component namespace and verify that no source-specific resolved prefix leaked into the result.

### 4. Exercise and report the runtime path

Install/run the compiled extension only in the authorized test environment. Exercise the smallest real caller, DI construction, success case, and relevant failure/edge case. For an API client, validate request encoding and response/error handling using controlled fixtures before an optional live service check.

Report each stage independently with its exact revisions and observed result. A suitable report includes: repository checks; PHP versions and lint/test results; JCB import/refresh result; compile namespace/path inspection; runtime result; and any limitation. If JCB was unavailable, write **“JCB import/compile not run”** and retain this procedure as the next concrete validation step.

## Round-trip and drift investigation

Where safe and supported by the test instance, export the imported power to a separate scratch repository/branch and compare its source pair and index with the authored files. Do not export over the candidate branch during diagnosis. Distinguish meaningful value changes from key order, escaped slashes, and LF/CRLF differences; do not ignore field deletion, lost aliases, changed sentinels, or resolved placeholders replacing templates.

A round trip can expose compiler/exporter assumptions missing from a hand-authored definition. Investigate differences against the target source and update either the power or documented contract. It does not authorize normalizing every historical export.

## Source evidence for this procedure

The implementation observations above were checked against JCB `6.x` commit `408703a857ad937479b1e28de7f693af178dcc83`:

- [Powers controller initialization and reset](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/PowersController.php): permission/token checks, initialization selection, selected-GUID reset.
- [Remote getter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Get.php): `init`, local-existence behaviour, read-branch selection.
- [Power grep](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Power/Grep.php): settings and raw power loading into `main_class_code`.
- [Repository form](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/repository.xml): separate repository host and read/write branch fields.

For another JCB version, verify these paths/actions before applying the procedure. These references support implementation behaviour; the test matrix and reporting requirements are documentation policy.
