# Configure a reproducible Playground test

Use [the common workflow](README.md) to acquire and test a candidate. This reference describes the inspected deployment, not an unrestricted Joomla/PHP installer. Evidence: [P01–P07](sources.md), inspected 2026-10-31.

Playground's URL selects its runtime/deployment and initial Joomla route. It does **not** select a Power/Field Type/Snippet Git read branch. Configure that repository's content target, provider, read branch, enabled state and precedence **inside JCB**, following the [common acquisition workflow](README.md#3-configure-the-candidates-real-jcb-repository-connection). Changing `path`, `deploy` or a Joomla/PHP version does not import a candidate revision.

## Available version baseline

| Selection | Pinned release | Available PHP selections |
| --- | --- | --- |
| `joomla=5.4.10` | Joomla 5.4.10; JCB recipe source package 5.2.0 | `8.3`, `8.4`, `8.5` |
| `joomla=6.2.0` | Joomla 6.2.0; JCB recipe source package 6.2.0 | `8.3`, `8.4`, `8.5` |
| `php=8.3` | PHP 8.3.11 | Both catalogued Joomla releases |
| `php=8.4` | PHP 8.4.1; default | Both catalogued Joomla releases |
| `php=8.5` | PHP 8.5.2 | Both catalogued Joomla releases |

The default is Joomla 6.2.0 / PHP 8.4 / `deploy=jcb`. PHP URL values are catalogue **minor keys**, not arbitrary patch versions. `joomla=5.4` resolves to the highest available matching catalogue release; use the exact release for a repeatable receipt. A bare `joomla=5` is not accepted by this parser. A syntactically plausible version that is absent or incompatible still fails validation.

These are the versions published by the inspected Playground, not a claim about the latest or safest releases elsewhere. There is no Joomla 7 or alpha deployment in this baseline. Do not invent a `joomla=7...` link or advertise prerelease support until the live manifest, recipe compatibility and runtime evidence actually include it. When the live catalogue changes, recheck the [source freshness procedure](sources.md#freshness-and-maintenance) before updating this table.

## Ready-to-use test links

These select `jcb`, an exact Joomla release and a temporary site, with automatic startup disabled so the operator can inspect setup. Click **Launch** after checking it. They use the prepared JCB installation when available; they do not force the full installer to run.

| Joomla | PHP 8.3 | PHP 8.4 | PHP 8.5 |
| --- | --- | --- | --- |
| 5.4.10 | [Open J5 / PHP 8.3](https://playground.joomengine.org/?deploy=jcb&joomla=5.4.10&php=8.3&persist=0&start=0) | [Open J5 / PHP 8.4](https://playground.joomengine.org/?deploy=jcb&joomla=5.4.10&php=8.4&persist=0&start=0) | [Open J5 / PHP 8.5](https://playground.joomengine.org/?deploy=jcb&joomla=5.4.10&php=8.5&persist=0&start=0) |
| 6.2.0 | [Open J6 / PHP 8.3](https://playground.joomengine.org/?deploy=jcb&joomla=6.2.0&php=8.3&persist=0&start=0) | [Open J6 / PHP 8.4](https://playground.joomengine.org/?deploy=jcb&joomla=6.2.0&php=8.4&persist=0&start=0) | [Open J6 / PHP 8.5](https://playground.joomengine.org/?deploy=jcb&joomla=6.2.0&php=8.5&persist=0&start=0) |

For the compiler page, the entire **inner Joomla path including its query** is one encoded `path` value:

[Open the J6 compiler with setup first](https://playground.joomengine.org/?deploy=jcb&joomla=6.2.0&php=8.4&persist=0&start=0&path=%2Fadministrator%2Findex.php%3Foption%3Dcom_componentbuilder%26view%3Dcompiler).

This decodes to `/administrator/index.php?option=com_componentbuilder&view=compiler`. An unescaped `&view=compiler` would instead become an outer Playground parameter. Use URL parameter encoding once, not manually nested escaping. The path must begin with `/`, stay inside the Joomla site and exclude protocol-relative URLs, backslashes and traversal segments. It is not the owning Playground URL or the session's generated `__site/...` prefix.

For a saved test use a task-specific key, for example [J6 saved test setup](https://playground.joomengine.org/?deploy=jcb&joomla=6.2.0&php=8.4&persist=1&key=aidoc-review-example&start=0). **Replace the example key** before using it for independent work. Reusing a key can reopen existing local test data. A key is browser-local organization, not an access secret or a portable site identifier.

## Verified URL parameters

Boolean parameters accept `1/0`, `true/false` or `yes/no` without case sensitivity. Unknown parameter names are not a way to add configuration: use the supported deployment document/UI for richer settings.

| Parameter | Behaviour and important boundary |
| --- | --- |
| `deploy=jcb` | Selects a known deployment ID compatible with the selected Joomla major. See presets below. |
| `joomla=6.2.0` | Exact release, or supported minor prefix such as `5.4`; resolves against the live catalogue. |
| `php=8.4` | Selects an available PHP catalogue minor compatible with the resolved Joomla release. |
| `path=...` | Local initial Joomla path, maximum 2048 characters; alias `initialPath`. If both exist, `path` wins. |
| `name=Review%20site` | Site name, nonempty text up to 100 characters. |
| `language=en-GB` | Joomla language tag, distinct from UI language. A non-English choice needs an available pinned/configured language package; a valid-looking tag alone does not install one. |
| `uiLanguage=af` | Rocket interface language, handled independently by its localization layer; does not change Joomla content language. |
| `login=no` | Disables automatic administrator login; Credentials displays the generated login details. Does not configure an arbitrary username/password. |
| `persist=0` | Temporary site. Default is persisted. Saving/keeping a temporary site later changes its lifecycle. |
| `key=task-example` | Site key: 1–64 characters, beginning with a letter/digit; remaining characters may also be `.`, `_`, `-`. Select/reopen only the intended local site. |
| `fresh=1` | Creates an independent key and bypasses prepared snapshots to run the recipe. Does not delete another saved site. The UI consumes the flag after launch and keeps the resulting key; it can replace a supplied key. |
| `toolbar=0` | Hides Rocket header/footer, retaining edge restore controls. Alias `hideToolbar=1`; if both occur, explicit `hideToolbar` takes precedence. Leave controls visible for ordinary testing. |
| `start=0` | Suppresses the automatic launch countdown; show setup first. `start=1` allows automatic startup. Normal entry offers a cancellable countdown; custom shared setup may still require its built-in review. |
| `extensions=[...]` | URL-encoded JSON array of package objects `{ "url": "https://…", "sha256": "…" }`; digest optional here. Adds packages to the chosen recipe. Maximum 30 entries in this input. |
| `extension=...` | Repeatable single package URL; appended to the `extensions` array. Use the array form to supply SHA-256. |
| `commands=[["cache:clean"]]` | URL-encoded JSON array of Joomla console argument arrays; alias `startupCommands`. `commands` wins when both exist. These are command names/arguments, not shell commands or `php` invocations. |
| `config=https://.../deploy.json` | Fetches a public deployment JSON document over an allowed package-style URL; the host must permit browser access. |
| `sha256=...` | Optional 64-hex digest for the `config` document; it is not a blanket hash for all packages. |
| `#deploy=...` | Encoded public deployment document generated by Share. Query settings can override decoded settings; prefer UI-generated documents/links over hand-building this encoding. |

Package URLs require HTTPS, except HTTP on `localhost`, `127.0.0.1` or `[::1]`, and must not contain embedded credentials or fragments. A supplied SHA-256 is verified. Direct package download is limited to 128 MiB and cross-origin access requires CORS. Startup commands have bounded argument counts/lengths; commands execute after installation, without a host shell. A failed setup action stops provisioning, and a completed saved installation does not replay its original commands on reopen. Public Share output excludes administrator credentials/local site keys; do not place secrets in package URLs or arguments. [P02–P05](sources.md)

Use the Deployment UI or a schema-valid deployment document for PHP settings, menus, template parameters, multiple language choices and custom content. Their presence in internal configuration does not imply a same-named query parameter is parsed. Share can generate/import deployment JSON or a hosted-configuration link. It limits generated links to 16 KiB and documents to 1 MiB; the lower-level URL parser's larger bound does not remove Share's limit.

## Deployment presets

| ID | Joomla support in this baseline | Use |
| --- | --- | --- |
| `jcb` | 5 and 6 | Default JCB authoring environment; initial route opens Component Builder. |
| `jcb-mcp` | 6 only | JCB plus MCP package 1.0.10. Same-browser authenticated transport/discovery; current content-editing limitation still applies. |
| `blank` | 5 and 6 | Joomla alone; useful as a separate clean consumer for a compiled package. |
| `servicedirectory` | 5 and 6 | Service Directory demonstration. |
| `heritage-demo` | 5 and 6 | Prepared multilingual demonstration. |
| `patchtester` | 5 and 6 | Joomla Patch Tester deployment. |
| `weblinks` | 5 and 6 | Weblinks deployment. |

For example, [Joomla-only J6 test setup](https://playground.joomengine.org/?deploy=blank&joomla=6.2.0&php=8.4&persist=0&start=0) has no JCB compiler. [JCB + MCP setup](https://playground.joomengine.org/?deploy=jcb-mcp&joomla=6.2.0&php=8.4&persist=0&start=0) does not expose a remote server endpoint for an external agent. Do not select unrelated demos merely because their presets are available.

Prepared deployments restore installed files/database from an exact-release snapshot and rotate administrator credentials on each new import. `fresh=1` runs the original recipe instead. Neither path downloads an unpinned latest JCB release. Existing saved installations retain their content/version when the public prepared package changes; verify what is actually running. [P03–P04](sources.md)

## Lifecycle, persistence and evidence

| Action/state | Effect |
| --- | --- |
| Normal entry | Stages the last successfully used saved site and its last safe route where available; it can therefore differ from a brand-new default deployment. |
| Choose site/PHP/Joomla/deploy | Stages changes; Launch validates before switching the runtime. Changing Joomla/deploy selects a separate profile rather than upgrading the saved Joomla installation. |
| Change PHP through supported controls | Restarts PHP while retaining site data; record the effective patch/settings after the switch. |
| Editor Save | Writes the active virtual file. Does not by itself mean the preview refreshed or all persistent site stores flushed. |
| Playground Save | Flushes site files and database; a successful save advances its saved-state indication. Saving a temporary site keeps its state under a saved identity. |
| Close | Closes workers; a saved site can reopen. Temporary state must be kept/exported first if needed. |
| Reset / delete saved entry | Deletes the selected saved site and its editor draft record. Preserve needed evidence and follow the authorized task scope before using it. |
| Share | Public deployment configuration for an independent installation. Does not transfer modified files/database or private credentials. |
| Complete Download | Site files, SQL, prepared-import data and deployment instructions. Browser sessions/private runtime metadata/caches are excluded; review application data before sharing an export. |
| Recovery files | Raw saved-file recovery can include private credentials/sessions, and excludes SQL. Keep it private; it is different from a normal portable export. |

Files, sessions, cookies and database use IndexedDB for this origin/site identity. Only one tab owns a saved site; open another distinct site for independent simultaneous testing. File and database persistence are separate stores, not a combined atomic transaction. Wait for successful Save, preserve failures, and export important work: browser eviction, clearing or interrupted closure can lose data. A raw preview URL needs its owner runtime and cannot reopen someone else's private instance.

The default PHP settings are `upload_max_filesize=128M`, `post_max_size=160M`, `max_execution_time=60`, `max_input_time=60`, `max_input_vars=10000`, `memory_limit=512M`. The settings dialog validates bounded values and verifies actual PHP results after restart. Increasing a setting does not remove browser memory, package or transport limits. `runtimeInfo` on an explicitly created API handle exposes actual PHP version/extensions/PDO drivers/effective settings; in UI-only operation record observable version/settings information and identify anything unavailable. [P06–P07](sources.md)

For embedding, the parent and child need compatible cross-origin isolation; an iframe `allow="cross-origin-isolated"` attribute alone is insufficient. Prefer the standalone Playground for testing unless the embedding itself is under test. On hosts without isolation headers, the supplied service worker can require one reload. A repeated isolation failure is a blocker to diagnose, not a reason to disable browser security.
