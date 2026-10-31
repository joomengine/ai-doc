# Minimal Snippet repository fixture

This complete **documentation fixture** contains one original snippet and one original type, with an external existing library relationship. It demonstrates the current indexed format; it has not been imported into JCB or compiled/rendered as a Joomla view in this documentation build.

| Record | Identity | File |
| --- | --- | --- |
| Service hours panel | `6b3e057c-1587-4969-b032-7631b21e0e0e` | [Snippet item](src/6b3e057c-1587-4969-b032-7631b21e0e0e/item.json) |
| Documentation information panels | `d08dfbab-4e5d-4ecb-a2b6-084102be3446` | [Type item](src/snippet_type/d08dfbab-4e5d-4ecb-a2b6-084102be3446/item.json) |
| Bootstrap v4, external | `6f6650a5-ebff-4783-8508-f0285c0e98a6` | Verify the consuming JCB library record and CSS separately. |

The catalog files are [snippet-index.json](snippet-index.json) and [snippet-type.json](snippet-type.json). The source is the snippet item's `snippet` string; a separate HTML file is not imported. The type is local. The Bootstrap library is deliberately external, showing a real dependency boundary; a passing snippet validator does not establish that its assets are available.

The two fixture UUIDv4 values were generated through Linux `/proc/sys/kernel/random/uuid` and checked against the current core snippet/type indexes and the seven recorded Power indexes on 2026-10-31. They are reserved for these fixtures. New items must generate fresh IDs and perform a current mandatory core check; never copy these identities into a new production catalog.

This original markup illustrates a Bootstrap v4 card without JavaScript. Before use, configure that library in the consumer, translate/adapt the text, make the heading ID unique and escape inserted dynamic values. This does not assert compatibility with Joomla's active template or a different Bootstrap major version. The section remains readable without CSS but styling requires the library.

## Inspect without executing

From this fixture directory, with jq installed:

```sh
jq -er '.snippet' src/6b3e057c-1587-4969-b032-7631b21e0e0e/item.json
jq -e '."@dependencies"[0].value == .type and ."@dependencies"[1].value == .library' src/6b3e057c-1587-4969-b032-7631b21e0e0e/item.json
```

For current-catalog verification, follow [the creation workflow](../../workflows/create.md). Use this fixture to inspect structure and relationships, not as a falsely claimed working component.

The original fixture is dedicated under [CC0](LICENSE). Bootstrap remains a separately licensed external dependency; this dedication does not relicense Bootstrap or other linked upstream content.
