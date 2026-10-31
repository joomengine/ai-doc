# Playground verification record

**Observation date:** 31 October 2026. This is a bounded record of an agent-operated live browser test and separate source inspection. It is not a claim that all modules, repository revisions or Playground features were exercised.

## Live Super Power import

The agent opened [the public Playground](https://playground.joomengine.org/) in a cloud Chrome browser and used the ordinary Joomla/JCB GUI. No repository source was published or changed for this test.

| Input or observation | Recorded value |
| --- | --- |
| Deployment | Default `jcb`; prepared site restored files and database and opened administration |
| Joomla version | `6.2.0`, shown by the administrator |
| JCB version | `6.2.0`, shown by the JCB dashboard |
| PHP version | `8.4.1`, shown in deployment activity |
| Browser | Chrome; exact browser version was not captured |
| Repository entry | Newly created `AI Playground import verification`; GitHub provider, Super Power target, organisation `joomengine`, repository `super-powers`, Read Branch `master`; no access token entered |
| Selected source | Explicit GitHub repository card in Powers → Init, showing `joomengine/super-powers` and branch `master` |
| Imported identity | `0e6235bf-08ef-428a-bc0a-93957587e936` |
| Item | `Utilities Regex Helper`, class name `Regex`, type `abstract class`, version `1.0.0` |
| Persisted namespace | `[[[NamespacePrefix]]]\Joomla\Utilities.Regex` in the editor |
| Local record | ID `1268` in that disposable site; this numeric ID is not portable |
| Before/after | Powers list increased from `142` to `143` items |
| Comparison source | [Official settings](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/0e6235bf-08ef-428a-bc0a-93957587e936/settings.json) and [raw body](https://github.com/joomengine/super-powers/blob/9cd980492bed4c8177a6e32b703641950ec93604/src/0e6235bf-08ef-428a-bc0a-93957587e936/code.power) inspected at `9cd980492bed4c8177a6e32b703641950ec93604` |

The GitHub catalogue loaded through JCB. The initially considered `MathHelper` already existed in the prepared site: its row was disabled for initialization. The agent selected the absent `Regex` item instead and initialized only that item. It then reopened the saved record and inspected the GUID, name, type, version, description, portable namespace and all six methods in Properties & Methods: `match`, `capture`, `optional`, `oneOrMore`, `noneOrMore` and `anyOf`. It closed the editor after inspection. This checks persisted data, not merely a notification or the presence of a catalogue row.

The comparison revision records the inspected upstream specimen. The live import selected the moving `master` branch; the exact commit served during each JCB request was not captured or locked, and no byte-for-byte hash comparison was performed. The live deployment's build manifest/source commit was also not captured. Neither value should be inferred from a contemporaneous checkout. Future candidate tests should retain both source and deployed-build provenance as described in the [shared workflow](README.md).

Browser operation exposed two practical points: wait for the expected JCB page/result after actions rather than treating an immediate unchanged snapshot as failure; and use focus/keyboard activation when an off-screen iframe control does not respond to a click, then verify the resulting state. No application JavaScript or database injection was used to manufacture an import result.

## What this test establishes

| Stage | Result and scope |
| --- | --- |
| Default environment startup | **Passed** for the observed Joomla/JCB/PHP combination without external database setup |
| Agent GUI operation | **Passed**: navigate JCB, create/save a repository, choose target/provider/read branch, load catalogue and initialize an absent Power |
| Public GitHub retrieval | **Passed** for this repository and branch without credentials |
| Persistence/inspection | **Passed** for the listed Regex metadata and six-method body after reopening its record |
| Existing-item initialization guard | **Observed**: the already-local MathHelper row could not be initialized again |
| Non-default staging branch | **Not run**; read-branch support is source/form evidence, not a live candidate-branch result |
| Pull/Reset and changed existing record | **Not run** |
| Authored example repositories | **Not imported**; the official Regex item was the live specimen |
| Field Type or Snippet import/consumer tests | **Not run**; a Power import is not evidence for these entity paths |
| Actual consumer compilation/install/runtime | **Not run in this exercise** |
| Other Joomla/PHP targets, editor/debugger or live AI/MCP | **Not exercised in this test** |

## Separate source evidence and continuing use

The [source map](sources.md) pins the Playground implementation inspected for configuration, editor/AI capabilities, runtime constraints and its upstream testing harness. That evidence is separate from this live observation. A compiler test in upstream source or a passing upstream workflow does not establish that a particular contribution has compiled or run.

The documentation expansion passed `tools/check.sh` with jq 1.8.1 and PHP 8.3.6 (75 regression checks), ShellCheck and whitespace checks. Four independent temporary-copy probes confirmed that the checker rejects a missing `test_workflow`, a traversing path, a nonexistent file and a symlink escaping the repository. All ten documented setup links were parsed and normalized against the pinned Playground configuration implementation and checked against its version/deployment catalogue, including the encoded compiler route. These were offline checks; they did not launch those ten environments or exercise the browser workflows.

The project now has a demonstrated browser integration route. Each contribution must use its module's own acceptance procedure and retain a fresh result for the changed identities and revisions. The [Super Powers](../../super-powers/workflows/validate-and-integrate.md), [Field Types](../../field-types/workflows/validate-and-integrate.md) and [Snippets](../../snippets/workflows/integrate.md) workflows define the remaining model-specific checks. Unperformed stages remain explicit even when another stage passes.
