# Reuse and dependency resolution

## Purpose and authority

This file defines **project policy** for choosing infrastructure and tracing dependency impact. The [specification](specification.md) defines the serialization and compiler contract. The [repository registry](../registries/power-repositories.json) identifies the seven mandatory discovery and GUID-collision-check sources, with inspected commits. Repository listings and examples are evidence of existing practice; they do not make every existing implementation defect a recommended pattern.

## Required infrastructure search order

Before introducing an implementation, perform and record the following search:

1. **Joomla core and Framework first.** Check the supported Joomla and PHP versions, installed Framework package versions, available classes/interfaces, deprecations and runtime context. Prefer the existing HTTP, URI, registry, database, DI, event, application or other service when it satisfies the requirement. Joomla CMS and Joomla Framework are related but distinct namespaces and versioned dependencies.
2. **`joomengine/super-powers` second.** This is the central shared foundation and reference standard for JCB-owned reusable code. Inspect its interfaces, abstractions, utilities, factories and providers before building a specialist equivalent. Reuse the existing power by GUID when its contract fits. Do not copy its body into a new GUID merely to change the consuming component's namespace.
3. **Relevant specialist Power repositories next.** Search their indexes and source definitions. Confirm that the selected power's dependencies are available to the consuming installation and that its current public API meets the requirement.
4. **Write new code for the remaining responsibility.** State the missing capability and why the inspected alternatives do not supply it. Put generally reusable foundations in the shared repository only when that placement is in the task's scope. Keep application-specific policy and specialist service behaviour in their appropriate repository.

A sufficient decision record is concrete: candidate class or GUID, inspected revision, required operation, supported version, choice, and reason. Do not add boilerplate architectural essays when the existing class clearly fits.

Reuse is not synonymous with inheritance. Use constructor injection and composition to consume services; extend an abstraction when its lifecycle and protected contract are intended for extension; use an interface to define a replaceable boundary. Avoid subclassing only to inherit unrelated convenience methods. Preserve established factory entry points where compatibility requires them, while keeping new domain logic independently constructible and testable.

### Joomla HTTP illustrates why version checks matter

The OpenAI [HTTP settings snapshot](https://github.com/joomengine/openai/blob/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/src/4c58b254-aea5-40aa-b54d-9586a1690451/settings.json) uses custom inheritance from the alias `JoomlaHttp`, imported from `Joomla\CMS\Http\Http` in `head`. This is a useful **serialization example**, not a prescription to choose that namespace for new work.

The [Joomla 6 deprecation documentation](https://manual.joomla.org/updates/54-60/new-deprecations/) checked on 2026-10-31 deprecates the CMS HTTP package in favour of `Joomla\Http`, with removal planned for Joomla 8. Select the appropriate Framework implementation for the target's installed version and verify response handling. The [Framework HTTP documentation](https://framework.joomla.org/docs/4.x/http/classes/Http) and [response documentation](https://framework.joomla.org/docs/4.x/http/classes/Response) are starting points; do not apply a 4.x package API to an older installed package without checking it. A service wrapper should add the domain-specific headers, authentication or endpoint rules that are needed, and continue to use Joomla's transport.

## Three dependency categories

| Category | Representation | What must be verified |
| --- | --- | --- |
| Other Super Powers | GUIDs in structural settings and/or embedded Power tokens | Resolve the GUID against the ordered authorized catalogs; inspect the selected definition and its transitive dependencies. |
| Joomla/PHP runtime types | Imported names in an enabled `head`, custom inheritance/interfaces, or fully qualified types in code | The type exists in the consuming runtime; signatures and lifecycle match its version. These are not missing GUID dependencies. |
| Composer or other shipped libraries | `composer` metadata, imports, autoload access points and consuming-project packaging | The actual package, supported version and autoload files are supplied. A metadata entry alone does not install a Composer package. |

The registry is a **baseline**, not a claim that every power dependency in the ecosystem lives in these seven repositories. Do not turn a missing lookup into a fake local class or invent a GUID to make the check pass.

## Ordered resolution and provenance

Keep two operations separate:

- **Collision discovery:** scan every registered current index and task-specific repository for an identifier, preserving all matches. New identities must not duplicate those matches.
- **Consumer resolution:** use the actual order configured for the consuming JCB installation. Preserve the selected source and shadowed alternatives; order can change which existing definition is loaded.

The registry's array order is the order supplied by the project owner. It does not override an installation's configured order. An intentionally maintained override can share an existing identity; that is different from assigning an existing GUID to an unrelated new class. Document overrides explicitly and inspect both definitions before changing them.

For each selected dependency record: repository, branch or configured ref, exact commit, index path, GUID, settings path, body path, and why the dependency is needed. Resolve transitively with a visited set. Report cycles with the traversed GUIDs; do not recursively loop or automatically reject every cycle as invalid PHP. Inheritance cycles are invalid; mutually referring services or imports need lifecycle-specific assessment.

If a dependency does not resolve:

1. Confirm the identifier is a GUID dependency rather than a custom sentinel, runtime name or Composer import.
2. Check whether the configured catalogs are complete and current; retain failed fetches as failures, not empty indexes.
3. Inspect the source power's settings, comments and README for its intended owner, then locate only authorized additional repositories.
4. If access or ownership remains unknown, report the exact unresolved edge and source revision. Leave that dependency's runtime integration unverified. Do not silently delete it, copy an unrelated class, or claim a complete closure.

The structured-settings survey on 2026-10-31 found **366 unique indexed GUIDs and no duplicates** across the seven recorded snapshots. It also found **23 structured dependency edges to 14 distinct GUIDs absent from those indexes**. These counts cover `extends`, `implements`, `extendsinterfaces`, `use_selection` and `load_selection`; they do not establish completeness for embedded source-code references. They are dated observations, not validation exceptions or a global uniqueness guarantee. A fresh task must refresh the relevant catalogs.

## Concrete shared-factory and DI trace

The following is a verified structural trace, pinned to the registry snapshots:

| Layer | Power | Responsibility |
| --- | --- | --- |
| Shared interface | [`FactoryInterface`, `caf33c5d-858c-4f9a-894f-ab302ec5445a`](https://github.com/joomengine/super-powers/tree/9cd980492bed4c8177a6e32b703641950ec93604/src/caf33c5d-858c-4f9a-894f-ab302ec5445a) | Declares the shared factory contract. |
| Shared abstraction | [`Factory`, `2e5bf608-de5c-4b00-a20d-47c26aa350d9`](https://github.com/joomengine/super-powers/tree/9cd980492bed4c8177a6e32b703641950ec93604/src/2e5bf608-de5c-4b00-a20d-47c26aa350d9) | Supplies `_($key)` and lazy `getContainer()`; requires the subclass's `createContainer()`. |
| Specialist factory | [`Openai.Factory`, `d78bee89-6f7e-42b6-917e-17f05b238490`](https://github.com/joomengine/openai/tree/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/src/d78bee89-6f7e-42b6-917e-17f05b238490) | Extends the shared GUID, owns its static container, creates `Joomla\DI\Container`, registers its two providers. |
| Endpoint provider | [`Service.Api`, `ccf3141a-929d-4466-b122-9ace2eea8d70`](https://github.com/joomengine/openai/tree/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/src/ccf3141a-929d-4466-b122-9ace2eea8d70) | Implements Joomla's `ServiceProviderInterface`, registers class aliases and named services, constructs endpoint objects with dependencies. |
| Utilities provider | [`Service.Utilities`, `07858e1f-5698-4227-8941-03dc93557938`](https://github.com/joomengine/openai/tree/96e575e55fd66d8d190c65e6e1de1e7c4577d29d/src/07858e1f-5698-4227-8941-03dc93557938) | Supplies HTTP, URI and response services and component-parameter configuration. |

For example, `Openai.Chat` is registered by the API provider. Its constructor dependencies are requested by service key from the same container. The factory's `use_selection` entries cause the provider classes to be available as imports; the body still calls `registerServiceProvider(...)`. An imported provider is not automatically registered. Likewise, a selected endpoint power is not automatically exposed under a service key.

When adding a service, update the relevant GUID-based imports, provider registration, constructor factory and consumer documentation together. Preserve existing aliases, service names, constructor requirements, lifecycle and sharing/protection choices unless the task explicitly includes a compatible migration. Never infer the meaning of a positional DI argument from another container library; inspect the target Joomla DI version. The [Joomla dependency-injection documentation](https://manual.joomla.org/docs/next/general-concepts/dependency-injection/) is orientation, not a substitute for the installed signature.

## Impact assessment for shared foundations

Before changing a shared power:

1. Search every relevant index and settings file for inbound GUID relationships.
2. Search bodies and enabled headers for SPKs, compile-time tokens, aliases, fully qualified class names and service keys. Some relationships are implicit in source or runtime configuration.
3. Include downstream constructor calls, method overrides, interface implementations, named arguments, exceptions, return shapes, null handling and state-sharing assumptions in the compatibility assessment.
4. Choose an additive method or a separate new power when that preserves an established public contract. A GUID identifies the same power over time; it is not a version selector.
5. Run focused behavioural checks and representative consumer import/compile/runtime checks. Record consumers that could not be inspected or executed.
6. Describe migration and release sequencing when multiple repositories must change together. Do not merge a shared break before its consumers can accept it.

## Style and licensing when reusing code

Follow existing tabs for PHP indentation, brace placement, docblocks and naming. Preserve intentional line endings; source bodies can contain CRLF even when surrounding repository files use LF. Avoid formatting-only churn in a behaviour patch. Keep classes focused, inject dependencies explicitly and use meaningful exception contracts.

The central foundation is a preferred design reference, not permission to erase third-party conventions or notices. For example, `minify` contains MIT-attributed upstream adaptations and `psr` retains PHP-FIG attribution. Check each power's `licensing_template` as well as repository-level licensing before moving or copying code. Prefer a dependency over a duplicated source file when the existing identity and contract can be reused.
