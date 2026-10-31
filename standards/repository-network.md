# Discover and use the decentralized JCB repository network

Use the maintained network for public core repository reads when it can reduce GitHub requests, or when GitHub is unavailable or rate-limited. Discover available targets and mirrors from the [JCB community endpoint](https://api.joomlacomponentbuilder.com/v1/network/community/jcb/). The maintainer is expanding this network; a target list captured in these skills is not an exhaustive or permanent list.

This is a shared retrieval workflow for every model. A mirror supplies another route to an existing logical repository. Preserve the model's identities, file contracts, source attribution, repository precedence and validation requirements. Read access through a mirror does not select a contribution destination or authorize Push.

## Contents

- [Discover targets and interpret status](#discover-targets-and-interpret-status)
- [Map a task to its repository](#map-a-task-to-its-repository)
- [Fetch once and reuse the result](#fetch-once-and-reuse-the-result)
- [Read source and retain provenance](#read-source-and-retain-provenance)
- [Handle unavailable endpoints](#handle-unavailable-endpoints)
- [Configure JCB and Playground](#configure-jcb-and-playground)
- [Understand JCB's network integration](#understand-jcbs-network-integration)
- [Evidence and maintenance](#evidence-and-maintenance)

## Discover targets and interpret status

The [official API documentation](https://api.joomlacomponentbuilder.com/) describes unauthenticated JSON GET requests. Project discovery returns `project` and `targets`; each target contains `target` and a `network` array. A node exposes `id`, `name`, `url` and numeric `status`.

| Request | Use |
| --- | --- |
| `/v1/network/community/jcb/` | Discover all currently advertised targets and their nodes in one request |
| `/v1/network/community/jcb/super-powers` | Inspect one target |
| `/v1/network/community/jcb/super-powers/1` | Select nodes monitoring reports online |
| `/v1/network/community/jcb/super-powers/0` | Select nodes monitoring reports offline |

Use the exact discovered target in the corresponding path. These are path segments, not query parameters. No pagination is documented for these responses.

**Maintainer-defined status:** `1` is on/online and `0` is off/offline. The infrastructure monitors endpoints and updates these values. Prefer an online node. A status-0 node may have recovered since monitoring last observed it; a bounded read probe is allowed under [failure recovery](#handle-unavailable-endpoints). Record the probe result separately from the advertised status. A failed discovery request is unknown status, not proof that all repositories are offline.

The response contains repository locations and availability. It does not carry a read branch, commit, synchronization timestamp, content hash or proof of identical bytes. Validate the required ref and retrieved content. Do not describe status `1` as a successful import or as proof that a staging branch exists.

## Map a task to its repository

These mappings identify the current core resources. Refresh discovery before selecting a mirror; additional targets may appear without a skills release.

| Task / logical core repository | Network target | Relevant index |
| --- | --- | --- |
| Super Powers: `joomengine/super-powers` | `super-powers` | `super-powers.json` |
| Field Types: `joomengine/joomla-fieldtypes` | `joomla-fieldtypes` | `index.json` |
| Snippets: `joomengine/snippets` | `snippets` | `snippet-index.json`, `snippet-type.json` |
| Default Packages: `joomengine/packages` | `packages` | Entity-specific files under `index/` |
| Joomla Powers | `joomla-powers` | Follow the actual Joomla Power source contract; this is distinct from Super Powers |
| Specialist Power catalogues | Discover the corresponding target, such as `gitea`, `openai`, `search` or `phpseclib` | Verify the catalogue's format and logical identity |
| Repository discovery | Inspect `repoindex` / `repositories` when returned | Inspect the advertised repository's own documentation |

Use each node's **exact `url`**. Do not construct a mirror by replacing `github.com` in a URL: inspected mirrors commonly use `/joomla/<repository>`, while GitHub sources use `/joomengine/<repository>`. The inspected `repositories` target points to a repository named `repoindex`, demonstrating why target and path must not be assumed equal. A similar name on another forge is not sufficient evidence of a maintained mirror.

Apply a default-core mirror only to the corresponding core source. It does not replace a user's custom fork, unmerged changes, arbitrary package collection or private dependency. `joomengine/joomla-packages` and the separate Hello World repository are distinct sources; do not substitute the `packages` target for them. If the requested source is absent from discovery, retain its authorized source and report any access gap. Follow the model's collision-check rules across core, additional repositories and local unpublished records. Mirrors of the same core are alternative transports, not new independent catalogues or higher-priority overrides.

## Fetch once and reuse the result

An agent may perform discovery with any supported read-only HTTP client. The reproducible commands below use Bash, curl, jq, Git and the [tool prerequisites](../tools/README.md). Run these blocks in the same Bash session from the skills checkout root. The first block makes one project request and saves its receipt in a new temporary directory. It validates the response before publishing the local snapshot.

```bash
set -euo pipefail
network_dir=$(mktemp -d "${TMPDIR:-/tmp}/jcb-network.XXXXXX")
network_url=https://api.joomlacomponentbuilder.com/v1/network/community/jcb/
curl --fail --silent --show-error --location --max-redirs 3 \
	--proto '=https' --proto-redir '=https' \
	--connect-timeout 10 --max-time 30 \
	--output "$network_dir/project.pending.json" "$network_url"
jq -e -s '
	def text: type == "string" and length > 0;
	length == 1 and (.[0] |
	.project == "jcb" and (.targets | type == "array")
	and ([.targets[].target] | length == (unique | length))
	and all(.targets[];
		(.target | text) and (.network | type == "array")
		and all(.network[];
			(.name | text) and (.url | text and startswith("https://"))
			and (.status == 0 or .status == 1))))
' "$network_dir/project.pending.json" >/dev/null
mv -- "$network_dir/project.pending.json" "$network_dir/project.json"
date -u +%Y-%m-%dT%H:%M:%SZ > "$network_dir/observed-at.txt"
printf '%s\n' "$network_url" > "$network_dir/discovery-url.txt"
jq -r '.targets[] | .target as $target | .network[] |
	[$target, .status, .url] | @tsv' "$network_dir/project.json"
printf 'Discovery receipt: %s\n' "$network_dir"
```

Reuse this snapshot across targets in the same acquisition phase. Keep the response and observation time with the task evidence. Refresh after a failed endpoint, a resumed task or before a final freshness-sensitive identity check; do not label a cached status as freshly observed. Refreshing discovery updates endpoint-health evidence only. A final new-identity collision check also needs freshly fetched required indexes; never update an old catalogue timestamp merely because discovery succeeded. Record unresolved synchronization uncertainty. This is an agent workflow policy, not a cache lifetime promised by the service. Prefer an existing suitable checkout and local searches to another remote request.

The following complete example selects an advertised online Field Type mirror and uses it to fetch the official catalogue. The first eligible node is a candidate, not an API-guaranteed priority or fastest endpoint. Inspect the printed URL; use another advertised candidate if it is unsuitable. Prefer community hosts over concentrating routine load on `git.vdm.dev`.

```bash
network_target=joomla-fieldtypes
mirror_url=$(jq -er --arg target "$network_target" '
	[.targets[] | select(.target == $target) | .network[] |
		select(.status == 1) |
		select(.url | startswith("https://git.vdm.dev/") | not)][0].url
	// error("No eligible monitored-online mirror; use the recovery workflow")
' "$network_dir/project.json")
printf 'Selected %s: %s\n' "$network_target" "$mirror_url"
jq -n --arg url "$mirror_url" \
	'{"joomengine/joomla-fieldtypes": $url}' > "$network_dir/sources.json"
bash tools/fetch-entity-catalog.sh field-types \
	"$network_dir/field-types-catalog" --sources "$network_dir/sources.json"
jq '.repositories[] | {id, url, fetch_url, branch, commit, indexes}' \
	"$network_dir/field-types-catalog/manifest.json"
```

`--sources` is an explicit canonical-repository-ID → retrieval-URL map. The fetcher retains canonical `id`/`url`, order and the registry's branch, and records the actual `fetch_url`, fetched commit and index hashes. Both catalogue fetchers support it; see [tools](../tools/README.md) for the exact arguments. Mapped repositories use that transport; unmapped repositories still use their registered source. An override failure fails the fetch rather than silently substituting different bytes. A catalogue is published only after all required sources pass.

These tools already use Git transport rather than GitHub REST to read indexes. A mirror override reduces GitHub-hosted reads as well. A complete Super Power catalogue still requires every registered source: when discovery has no mirror for a required specialist repository, a partial mirror map does not remove that requirement. Do not fabricate a live manifest or mark an incomplete collision scan complete.

## Read source and retain provenance

Catalogue fetchers collect indexes, not every entity payload. For source investigation, fetch the required branch once into a local repository and read the needed files at its recorded commit. For larger investigations, a single shallow checkout can supply many files without one REST request per file. Do not execute downloaded code merely to inspect metadata. Use the returned repository URL with Git or the actual forge's documented raw/content interface; GitHub API URL patterns do not apply to every host.

For a pinned task, require the requested commit or demonstrate the required content/tree equivalence. An unavailable commit or unpublished branch is a named gap; do not replace it with a mirror's default branch and call it the candidate. For ordinary current-source research, record the selected mirror's observed branch tip without making a new GitHub call solely to restate its canonical name. If compared against an already available canonical checkout, record the exact comparison and its scope. One matching index does not prove every asset or every future revision matches.

Retain these fields in the acquisition receipt:

- Canonical repository identity, network target, discovery URL and observation time.
- Advertised status, chosen exact mirror URL and actual read success/failure.
- Requested branch/ref, fetched commit and relevant index/content hashes.
- Model validation result, additional sources, precedence and selected/shadowed identities.
- Any freshness/equivalence uncertainty, missing branches or unresolved dependencies.

For an intentional fork override, preserve its distinct provenance and position. Replacing a core transport must not move the core above that override. Keep contributions and Push directed to the user's authorized repository and write branch. Do not copy a GitHub token to another forge or embed credentials in discovery/source-map URLs; public discovery requires none.

## Handle unavailable endpoints

1. Try a suitable status-1 endpoint for the exact target. Keep timeouts bounded, inspect the Git/HTTP result and validate that the response is the expected data rather than an HTML error page.
2. On an ordinary unavailable/rate-limited read, preserve the failure, refresh discovery once and try another suitable advertised node. Respect any retry timing and host/client access restrictions. Changing transport is not permission to bypass an access control or browser security challenge.
3. If no online node works, a status-0 node may receive one bounded read probe per candidate during this recovery cycle. A successful read is evidence that it was reachable for that operation; preserve the API's reported `0` alongside the observation. Do not rewrite the service's status or poll all offline hosts continuously.
4. If the API is unavailable, a previously saved discovery receipt or known authorized checkout can help, with its age and status explicitly marked stale/unknown. Check the requested revision locally. If live acquisition remains unavailable, state which checks cannot finish; never manufacture a successful fresh catalogue.
5. If the target is absent, stop guessing URL suffixes. Rediscover the project and use the exact target or the independently authorized source. The documented API uses HTTP 403 for unknown system/project/target and HTTP 400 for an invalid status filter; a discovery 403 alone does not establish a GitHub rate limit.

Do not probe every mirror on every invocation. Retain one working source for the acquisition phase, use local files for repeated research, and stop recovery once the required data is obtained.

## Configure JCB and Playground

Read the [Playground procedure](../testing/playground/README.md) and the selected model's acceptance workflow. Discovery aids repository setup; it does not replace Init/Pull/Reset or consumer validation.

For an advertised URL such as `https://codeberg.org/joomla/packages`, the repository base is `https://codeberg.org`, organization is `joomla`, and repository name is `packages`. Select the actual provider supported by the installed JCB version (Gitea-compatible for this example), then the model's repository area/target separately. Do not place the whole repository URL or the network API URL into the base field; do not append `/api/v1` unless that installed field explicitly requires it.

Set and verify the intended **read branch**, published state and effective order. Leave write branch/token empty for a read-only core mirror. Check that a changed host does not retain an unrelated credential. Keep private/custom repositories and staging branches on their actual authorized sources. Use the model's index and expected identity to verify acquisition, then inspect persisted data and the real generated consumer. For Packages, audit all eligible writable repositories before any authorized Push; a mirror selection for reading must not create another export destination.

## Understand JCB's network integration

JCB itself uses this service. The following are source observations at `6.x@408703a857ad937479b1e28de7f693af178dcc83`, not a guarantee about every installed release or every failure path:

- [Network resolver](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Network/Resolve.php#L70) replaces a listed source when its monitored status is `0`, changing base/organization/repository. Unknown/error status leaves the source unchanged. Branch and credentials are not selected by the network response.
- [Status service](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Network/Status.php#L79) selects among online nodes and excludes `git.vdm.dev` by default. Successful status data is cached in memory; this code does not establish a persistent cache TTL.
- [Repository reader](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Grep.php#L207) invokes resolution for a nonempty base with provider `gitea`. A subsequent fetch failure does not automatically run a new mirror selection. Agents reading GitHub directly need this shared discovery workflow rather than assuming JCB will redirect those reads.
- The inspected [Package](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Grep.php#L46) and [Snippet](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Snippet/Grep.php#L46) readers declare singular `package` / `snippet`; direct API checks on 2026-10-31 returned target-not-found for those names, while discovered `packages` / `snippets` returned data. Use discovered names in agent requests and recheck the installed JCB when diagnosing automatic resolution. This bounded mismatch does not imply the entire Package network feature is absent.
- The inspected [PHP API client](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Api/Network.php#L36) appends a status filter only when nonempty; passing integer `0` omits `/0`. Direct HTTP `/super-powers/0` returned offline nodes in the observed check. Use the documented HTTP path when that filter is required, and verify newer client behavior before relying on it.

These source findings aid diagnosis. Prepare a minimal reproduction for [human-led JCB issue submission](../testing/reporting-issues.md) where relevant; this documentation does not patch the JCB runtime.

## Evidence and maintenance

On **2026-10-31**, direct project discovery returned HTTP 200 with 11 targets. Target-specific requests for `packages`, `snippets` and `joomla-fieldtypes` returned JSON; both status-filtered Super Power requests returned only their requested status. Counts and online/offline states are observations, not a static endpoint registry. The API documentation's source link led to a general organization page; no specific backend source revision was established.

A read from advertised `https://codeberg.org/joomla/super-powers` resolved `master@9cd980492bed4c8177a6e32b703641950ec93604`. Its 187-entry `super-powers.json` passed the inspected index checks and matched an already available canonical checkout byte-for-byte, SHA-256 `4c64190a6d3a076458397182f004beee65c89eb98e8a57cc8816da846ed6368d`. That comparison made no new GitHub API request and proves only this recorded index match. Browser import, compilation and runtime were not exercised by these network reads.

An independent existing-agent exercise followed the root skill and this guide using one discovery snapshot, then fetched the Field Type catalogue through `https://codeberg.org/joomla/joomla-fieldtypes` with `--sources`. It retained canonical identity and `master@3be64d59378b5650825b97b44dbd58f2cdb82fcb`, validated 49 entries and zero shadows, and matched the existing canonical index: SHA-256 `2665594ac7792a1a55935cadfe01f2de243491b483d66326234bdfe587191e41`. Manifest/index checks and catalogue freshness passed. No fresh-session, payload, GUID-allocation or JCB runtime test is implied.

The completed change passed 146 offline regressions (38 transport checks plus 108 existing model checks), ShellCheck, documentation/registry checks and skill validation. Transport regressions cover selected bytes and order, older manifests, invalid maps, failed fetches, Git URL rewrites and timeout behavior. The final Field Type fetch was repeated after the transport guards were finalized, reusing the saved discovery response. These checks do not certify every mirror or JCB runtime behavior.

When adding a model, link this guide, identify its logical core and exact discovered target when available, and explain missing-target handling. Preserve the existing shared protocol instead of embedding a fixed host list in each skill. Reverify endpoint shape, source-specific resolution and branch/content behavior when the service or JCB implementation changes.
