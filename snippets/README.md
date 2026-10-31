# Snippet repositories

This module explains how to create, extend, maintain and debug **JCB Snippet repositories**. Snippets provide reusable source material, usually HTML for Site Views, Custom Admin Views, layouts and templates. They help beginners compose working interfaces and let experienced developers reuse documented patterns. They are not Super Power classes, PHP Custom Code records, Joomla extensions or automatically synchronized view implementations.

**Project policy:** [`joomengine/snippets`](https://github.com/joomengine/snippets) is the official **core** catalog. Every new Snippet repository must account for its current GUIDs. A genuinely new item must never reuse a core GUID. Maintaining the same item, including an intentional fork override, retains its identity and requires an explicit provenance/precedence record. Search core before inventing a duplicate pattern.

**Verified baseline:** JCB `6.x` at `408703a857ad937479b1e28de7f693af178dcc83`; core catalog `master` at `a7f536be6ea7a8af5bdf86d81c9f7f547b862365`, inspected 2026-10-31. The format describes these sources, not an untested promise about all JCB/Joomla versions. The core snapshot has 353 snippets and 40 snippet types; its examples reference Bootstrap v4 and UIkit v2 libraries. Old markup is not automatically suitable for the current consuming template or framework. See [sources](sources.md) for the evidence and limitations.

| Task | Read next |
| --- | --- |
| Understand the files, identity, dependencies and import lifecycle | [Specification](specification.md) |
| Author or change a serialized value | [Field reference](fields.md) |
| Start with an empty repository or add a snippet/type | [Creation workflow](workflows/create.md) |
| Fix a snippet, debug missing entries or migrate old flat files | [Maintenance workflow](workflows/maintain.md) |
| Use a snippet in a component and verify its assets/behaviour | [Consumer integration](workflows/integrate.md) |
| Inspect complete examples | [Examples](examples/README.md) |
| Check what was actually tested | [Verification](verification.md) |
| Document another JCB area to the same standard | [Module-authoring standard](../standards/module-authoring.md) |

## Operating invariants

1. The authoritative source is `src/<guid>/item.json`. Its `snippet` field holds raw source text inside JSON. There is no `code.power`, `code.php`, namespace setting or Power SPK in this format.
2. `snippet-index.json` locates snippets. `snippet-type.json` locates separately identified classification records under `src/snippet_type/<guid>/item.json`.
3. `type` and `library` are GUID references, not their display names or installation-local numeric IDs. Type describes a category, not a programming language.
4. Preserve current core, additional repository and local-new-item identities in collision checks. Preserve repository order and provenance during consumer resolution; do not flatten overrides silently.
5. `@dependencies` must match the real relationships. Library definitions and their assets have a separate package/runtime lifecycle. Selecting a catalog snippet does not guarantee asset installation or loading.
6. JCB's snippet selector displays source for inspection/copying. Save clears that selector in the inspected consumers; the compiler processes the consumer's own copied source. Updating a catalog snippet does not rewrite previously copied view code.
7. Keep attribution, upstream license, framework versions, integration instructions and security/accessibility requirements explicit. Imported code and rich preview text are not assumed safe merely because JSON validation passes.

Static tooling validates a bounded repository profile and catalog references. It cannot establish a real JCB import, component compilation, CSS/JavaScript availability, browser accessibility or safe handling of dynamic data. The integration workflow is a required separate gate for claims about a working component.
