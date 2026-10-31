# Complete examples and observed variations

Use examples to understand the [specification](../specification.md), not to override it. Read the [reuse policy](../reuse-and-dependencies.md) before creating production code. Do not copy an example GUID for a new power. An existing GUID may be used as a dependency or retained when maintaining that same power.

## Locally complete minimal repository

[The minimal repository](minimal-repository/README.md) contains every file needed to inspect one standalone power's packaging:

- A GUID-keyed `super-powers.json` locator with resolved inspection namespace and SPK.
- `src/<guid>/settings.json` with identity, structure, licensing, portable namespace and explicit empty values.
- `src/<guid>/code.power` containing only the class body, with tabs and docblocks.
- `src/<guid>/code.php` containing its derived PHP representation for `NamespacePrefix=VDM`.
- Repository and per-power READMEs, license and an executable PHP smoke check.

The fixture identity is `25a2c706-36eb-49ec-bbbb-be8218b101e1`. It was securely generated for this documentation and checked against the seven recorded source snapshots. It is reserved for this fixture and is not an official published reusable Power. For another power, generate and collision-check a fresh UUIDv4, then update **all** identity-bearing locations together. The [new-power workflow](../workflows/create-power.md) supplies the operational procedure.

`IntegerInterval::contains()` has an intentionally small, dependency-free contract so packaging can be understood independently of Joomla services. This is not a reason to create production copies of utilities already supplied by Joomla or the shared foundation.

### Expected source-to-output mapping

| Source | Meaning | Derived inspection result |
| --- | --- | --- |
| `guid` | Stable identity belonging to this fixture | Same index key, settings GUID, directory and SPK identity. |
| `name: "IntegerInterval"` | PHP symbol name | `final class IntegerInterval`. |
| `type: "final class"` | Declaration kind | Final class rather than a normal class or interface. |
| `namespace: "[[[NamespacePrefix]]]\\Joomla\\AiDocExample\\IntegerInterval"` | Portable namespace specification with terminal symbol segment | Namespace `VDM\Joomla\AiDocExample` for this representation; class `IntegerInterval` is declared separately. |
| `code.power` | Indented member definitions | The same member body appears inside the declaration braces. |
| `extends: ""`, null selection fields | No superclass or Power dependencies selected | No generated superclass, interface list or Power imports. |
| `add_head: 0`, `head: ""` | No custom header requested | No header imports. |
| `add_licensing_template: 2` | Use the explicit licensing template | The fixture's CC0 license header appears before its namespace. |

The fixture is not a compiler implementation. Its inspection file was assembled for documentation; production output must follow JCB's actual exporter/compiler for the selected revision. A passing PHP smoke check proves the example method and syntax in that PHP runtime, not JCB import or compilation. Namespace relocation and placement still require the integration checks described in the workflows.

## Complete upstream examples pinned to inspected revisions

Each linked directory contains its **complete settings, body, PHP representation and documentation**. Follow the file links within it; do not infer unshown fields from the short observations below. These are read-only specimens of existing identities. No upstream source is relicensed by this documentation.

| Variation | Complete source | What to inspect and what it proves |
| --- | --- | --- |
| Shared abstract factory | [`super-powers/2e5bf608-de5c-4b00-a20d-47c26aa350d9`](https://github.com/joomengine/super-powers/tree/9cd980492bed4c8177a6e32b703641950ec93604/src/2e5bf608-de5c-4b00-a20d-47c26aa350d9) | `abstract class`, GUID-based interface, enabled Joomla `Container` import, abstract `createContainer()` plus shared factory methods. |
| Cross-repository inheritance and name collision | [`openai/d78bee89-6f7e-42b6-917e-17f05b238490`](https://github.com/joomengine/openai/tree/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/src/d78bee89-6f7e-42b6-917e-17f05b238490) | `extends` references the shared Factory GUID; generated PHP aliases the parent as `ExtendingFactory`; the specialist class retains its own name and static container. |
| Joomla service provider and local Power imports | [`openai/ccf3141a-929d-4466-b122-9ace2eea8d70`](https://github.com/joomengine/openai/tree/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/src/ccf3141a-929d-4466-b122-9ace2eea8d70) | `implements: ["-1"]`, custom `ServiceProviderInterface`, enabled header, `use_selection` map and explicit DI alias/share/constructor wiring. `Service.Api` also illustrates dotted namespace syntax. |
| Custom Joomla parent alias | [`openai/4c58b254-aea5-40aa-b54d-9586a1690451`](https://github.com/joomengine/openai/tree/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/src/4c58b254-aea5-40aa-b54d-9586a1690451) | `extends: "-1"`, `extends_custom: "JoomlaHttp"`, import alias in `head`, `add_head: 1`. The CMS HTTP namespace here is historical; follow the version-aware guidance in the reuse policy. |
| Interface extending another interface | [`super-powers/1d0a2283-2d00-4c98-bf93-19e96c846d62`](https://github.com/joomengine/super-powers/tree/9cd980492bed4c8177a6e32b703641950ec93604/src/1d0a2283-2d00-4c98-bf93-19e96c846d62) | `type: "interface"`, `extendsinterfaces` GUID array and interface method declarations. Do not substitute a class's `implements` field. |
| Trait | [`super-powers/59b1a2ea-d77e-4040-ac8c-e65cd8743e9b`](https://github.com/joomengine/super-powers/tree/9cd980492bed4c8177a6e32b703641950ec93604/src/59b1a2ea-d77e-4040-ac8c-e65cd8743e9b) | `type: "trait"`; body contains methods and depends on host behaviour such as `$this->get()`. Importing a trait name and composing it in a host class are different operations. |
| Dependency loaded without a normal selected import | [`super-powers/9c513baf-b279-43fd-ae29-a585c8cbc4f0`](https://github.com/joomengine/super-powers/tree/9cd980492bed4c8177a6e32b703641950ec93604/src/9c513baf-b279-43fd-ae29-a585c8cbc4f0) | Non-null `load_selection` rows, each containing `load`. Check the compiler behaviour in the specification instead of rewriting these rows into `use_selection`. |
| Composer wrapper and a genuinely empty body | [`phpseclib/6da44dff-a221-4f22-b9d9-b2fc2a724b4b`](https://github.com/joomengine/phpseclib/tree/77dce1558dbb8b003629d06b7ebb0950f386e2e0/src/6da44dff-a221-4f22-b9d9-b2fc2a724b4b) | Zero-byte `code.power`; custom `PublicKeyLoader` parent; nested Composer access point/import; `[[[ComponentNamespace]]]` and dotted syntax in the namespace. The empty body is valid because inherited behaviour supplies the class's purpose. Runtime still needs the actual library. |
| Upstream interface licensing | [`psr/171fcb39-ae27-4c2b-b091-2f70b824288b`](https://github.com/joomengine/psr/tree/451da5e55ec5ea3a26b7ec44cfe2ec141cc42fd8/src/171fcb39-ae27-4c2b-b091-2f70b824288b) | Existing PHP-FIG attribution and MIT licensing, interface members and their original contract. Do not replace the notices with a JCB-owned or documentation license. |

The registry also includes `search`, `gitea` and `minify`. Their complete indexes were inspected in the same survey; their absence from a row above does not exclude them from GUID or reuse searches. Read their domain-specific sources when the task needs those capabilities.

## Do not turn observed values into universal rules

The corpus contains both numeric `-1` and string `"-1"` for custom inheritance, `composer` as an empty string, array or keyed object, and selection fields represented by null or keyed objects. Some current settings contain null `property_selection` and `method_selection`; other settings omit them. Preserve field-specific semantics and read the settings reference before normalizing anything.

A `code.php` file can expose a useful resolution example while also containing old API assumptions. Source structure inspection is not a live service test. A documented specimen demonstrates its identified convention only; it does not establish universal correctness, current upstream API support, security suitability or compatibility with every Joomla version.

## Example maintenance rule

When changing a local fixture, update settings, body, representation, index and explanatory outputs together, run the static checks and smoke check, and state whether JCB was actually used. When upstream evidence changes, record the new commit and reassess the conclusion; never replace a pinned URL with a moving branch while leaving the old claim marked verified.
