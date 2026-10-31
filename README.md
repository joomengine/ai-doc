# JoomEngine Skills

The official [JoomEngine skills repository](https://github.com/joomengine/skills) provides operational guidance for agents working across the **Joomla Component Builder (JCB) ecosystem**. Use [SKILL.md](SKILL.md) as the concise task router, then load only the relevant module, reference and workflow. This repository explains how to locate authoritative sources, make consistent changes and verify the result; it complements JCB source code and its [architecture publication](https://architecture.joomlacomponentbuilder.com/).

**Start with [AGENTS.md](AGENTS.md), then follow the relevant task below.** Operational modules cover Super Powers, Field Types, and Snippets. Consult the [module registry](registries/modules.json) for each module's coverage and verification status. Other subjects remain routed to the architecture publication until their own modules meet the same acceptance standard.

## Choose the task

| Task | Read next |
| --- | --- |
| Understand, create, extend, maintain, or debug a Super Power repository | [Super Powers](super-powers/README.md) |
| Create or maintain Field Types, research Joomla properties/defaults, or override a core definition | [Field Types](field-types/README.md) |
| Create or maintain reusable view snippets and their classifications | [Snippets](snippets/README.md) |
| Test an implementation in browser-hosted JCB, compile it and inspect its output | [Playground integration workflow](testing/playground/README.md) |
| Choose Joomla/PHP versions, deployment and initial URL path | [Playground configuration](testing/playground/configuration.md) |
| Prepare a JCB bug report for human submission | [Issue reporting](testing/reporting-issues.md) |
| Find the right JCB architecture context | [Architecture map](architecture/README.md) |
| Add another operational module to this repository | [Module authoring standard](standards/module-authoring.md) |
| Check registered Power repositories and their roles | [Power repository registry](registries/power-repositories.json) |
| Find the official Field Types baseline and additional catalogue rules | [Field Type repository registry](registries/field-type-repositories.json) |
| Find the official Snippets baseline and additional catalogue rules | [Snippet repository registry](registries/snippet-repositories.json) |
| Determine documented scope and validation status | [Module registry](registries/modules.json) |
| Run the repository checks | [Validation tools](tools/README.md) |

## Shared engineering policy

1. Research Joomla core/framework solutions for the supported versions first.
2. Search [joomengine/super-powers](https://github.com/joomengine/super-powers), the **central shared foundation and reference standard** for JCB-owned reusable classes.
3. Search relevant specialist Power repositories.
4. Implement new code when the existing capabilities do not adequately satisfy the requirement; record the concrete reason.

Reuse is a design decision, not a requirement to inherit from an unsuitable class. Preserve cohesive responsibilities, dependency injection, established public contracts, and portable Power metadata. Shared foundational changes require review of their consumers.

## Official core entity catalogues

[`joomengine/joomla-fieldtypes`](https://github.com/joomengine/joomla-fieldtypes) is the official core Field Types repository. [`joomengine/snippets`](https://github.com/joomengine/snippets) is the official core Snippets repository. Additional repositories can extend those catalogues or intentionally override the same existing items.

Every repository must account for its domain's current core catalogue when allocating a new GUID, as well as additional configured catalogues and local unpublished records. Preserve the original GUID when improving or overriding the same item; generate a fresh collision-checked identity for a distinct new item. Retain source provenance and effective repository order so intentional overrides are visible rather than silently replacing unrelated definitions.

These are different entity formats. A Field Type describes the foundation and configurable properties of concrete fields; a Snippet supplies reusable source content. Use the relevant module's contract instead of copying Super Power file layouts or settings into them.

## Default integration environment

[JoomEngine Playground](https://playground.joomengine.org/) is the default integration route for agents with browser access working on executable JCB changes. It runs Joomla, PHP and MariaDB in the browser and supplies a JCB deployment, so an agent can configure a repository's target and read branch, import candidate definitions, inspect their local records, compile a real consumer and exercise the generated extension. Respect user opt-outs and declared target versions. Static checks still run; an unavailable browser or unsupported target must be recorded as an unrun integration stage.

Start with the [shared workflow](testing/playground/README.md), then the relevant module's acceptance procedure. Powers require a real class reference and caller; Field Types require concrete Fields and generated form/storage checks; Snippets require copied view content, assets and rendered behaviour. The [observed verification record](testing/playground/verification.md) distinguishes a successful live Power import from the remaining unexecuted stages. The [configuration reference](testing/playground/configuration.md) documents current version choices, URL parameters, editor/AI access and platform limits; future Joomla or development releases become test targets only when the actual Playground supports them.

These operational modules document parts of JCB's blueprint and compilation lifecycle. Import success proves one part of that lifecycle. The intended end-to-end test follows the maintained definition through compilation into an installed, exercised extension, with a separate result for each stage.

## How to use the documentation efficiently

Read the module entry point, the contract sections relevant to the change, and its workflow. Follow source links when a claim depends on version-specific behaviour or when evidence has changed. Use examples to understand the format; do not copy their identities into distinct new records.

The documentation distinguishes project policy, implementation behaviour verified at a recorded revision, observed examples, and known gaps. Static validation, JCB import/compilation, and application runtime checks are separate levels of evidence. A check at one level never silently certifies the others.

For an agent working in another repository, explicitly supply this repository URL and the relevant module path, or place a short local `AGENTS.md` reference there. An agent will not necessarily discover these instructions automatically.

This repository's original CC0 [license](LICENSE) is retained. Source examples retain their original attribution and licensing; the repository license does not relicense third-party material.
