# Joomla Component Builder: agent documentation

Operational documentation for agents working across the **Joomla Component Builder (JCB) ecosystem**. This repository explains how to understand a task, locate authoritative sources, make consistent changes, and verify the result. It is not a replacement for JCB source code or its [architecture publication](https://architecture.joomlacomponentbuilder.com/).

**Start with [AGENTS.md](AGENTS.md), then follow the relevant task below.** Super Powers is the first documented operational module. Other subjects remain routed to the architecture publication until their own modules meet the same acceptance standard.

## Choose the task

| Task | Read next |
| --- | --- |
| Understand, create, extend, maintain, or debug a Super Power repository | [Super Powers](super-powers/README.md) |
| Find the right JCB architecture context | [Architecture map](architecture/README.md) |
| Add another operational module to this repository | [Module authoring standard](standards/module-authoring.md) |
| Check registered Power repositories and their roles | [Power repository registry](registries/power-repositories.json) |
| Determine documented scope and validation status | [Module registry](registries/modules.json) |
| Run the repository checks | [Validation tools](tools/README.md) |

## Shared engineering policy

1. Research Joomla core/framework solutions for the supported versions first.
2. Search [joomengine/super-powers](https://github.com/joomengine/super-powers), the **central shared foundation and reference standard** for JCB-owned reusable classes.
3. Search relevant specialist Power repositories.
4. Implement new code when the existing capabilities do not adequately satisfy the requirement; record the concrete reason.

Reuse is a design decision, not a requirement to inherit from an unsuitable class. Preserve cohesive responsibilities, dependency injection, established public contracts, and portable Power metadata. Shared foundational changes require review of their consumers.

## How to use the documentation efficiently

Read the module entry point, the contract sections relevant to the change, and its workflow. Follow source links when a claim depends on version-specific behaviour or when evidence has changed. Use examples to understand the format; do not copy their identities into new powers.

The documentation distinguishes project policy, implementation behaviour verified at a recorded revision, observed examples, and known gaps. Static validation, JCB import/compilation, and application runtime checks are separate levels of evidence. A check at one level never silently certifies the others.

For an agent working in another repository, explicitly supply this repository URL and the relevant module path, or place a short local `AGENTS.md` reference there. An agent will not necessarily discover these instructions automatically.

This repository's original CC0 [license](LICENSE) is retained. Source examples retain their original attribution and licensing; the repository license does not relicense third-party material.
