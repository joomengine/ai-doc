# Package examples

Use these examples for different kinds of evidence. The original fixture demonstrates the portable graph and its representations. The pinned upstream trace demonstrates a real, larger authored design; its import/build result belongs in the module's [verification record](../verification.md).

| Need | Example |
| --- | --- |
| Small complete graph with ordinary records, owned children and an external Field Type | [Original minimal repository](minimal-repository/README.md) |
| Natural-key Custom Code and Placeholder, including literal reference and dependency agreement | [Natural-key path in the minimal repository](minimal-repository/README.md#natural-key-and-field-type-boundaries) |
| Raw file content, a real folder ZIP, normalization and destination boundaries | [Asset transport](assets.md) |
| Trace a component, module and plugin through a real blueprint | [Pinned Hello World and larger-reference traces](reference-traces.md) |
| Start an empty repository for a new application | [Empty-repository boundary](minimal-repository/README.md#from-an-empty-repository) and [creation workflow](../workflows/create-repository.md) |

The minimal repository's three UUIDs and two natural keys are **reserved fixture identities**, never a shared pool of new application identifiers. Its original definitions, prose and tiny text assets are dedicated under [CC0](minimal-repository/LICENSE). It contains no copied upstream executable body, illustration or third-party library. Referencing the core Text Field Type preserves that existing dependency's identity; it does not make its upstream implementation CC0.

Examples use JCB `6.x@408703a857ad937479b1e28de7f693af178dcc83` contracts and the dated corpus in [repositories](../repositories.md). A structural pass is not evidence of a successful JCB import, regeneration, installation or runtime test. Follow the [Playground acceptance workflow](../workflows/validate-and-integrate.md) for those stages.
