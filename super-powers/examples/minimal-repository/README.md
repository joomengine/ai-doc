# Minimal Super Power repository fixture

This is a complete, self-contained **documentation fixture** with one power. It is intended for file-format inspection and local static/runtime checks. It has not been imported into or compiled by JCB in this documentation build.

| Name and kind | Power directory | Authoritative settings | Authoritative body | PHP representation |
| --- | --- | --- | --- | --- |
| [IntegerInterval](src/25a2c706-36eb-49ec-bbbb-be8218b101e1/README.md), final class | [src/25a2c706-36eb-49ec-bbbb-be8218b101e1](src/25a2c706-36eb-49ec-bbbb-be8218b101e1) | [settings.json](src/25a2c706-36eb-49ec-bbbb-be8218b101e1/settings.json) | [code.power](src/25a2c706-36eb-49ec-bbbb-be8218b101e1/code.power) | [code.php](src/25a2c706-36eb-49ec-bbbb-be8218b101e1/code.php) |

Purpose: inclusive integer interval rule with no external dependencies. Fixture GUID: `25a2c706-36eb-49ec-bbbb-be8218b101e1`.

Display SPK: `Super---25a2c706_36eb_49ec_bbbb_be8218b101e1---Power`. The corresponding active PHP token uses `Super___25a2c706_36eb_49ec_bbbb_be8218b101e1___Power`; neither form may be reused as a new power's identity. Read [AGENTS.md](AGENTS.md) before maintaining this fixture.

The machine-readable locator is [super-powers.json](super-powers.json). The PHP representation was assembled for inspection with `NamespacePrefix=VDM`. The source retains `[[[NamespacePrefix]]]`; it must adapt to a consuming project's namespace.

This fixture's GUID was generated with Node's cryptographic `crypto.randomUUID()` and checked against the seven source snapshots listed in [the registry](../../../registries/power-repositories.json) on 2026-10-31. That is a recorded snapshot check, not a guarantee of worldwide uniqueness or permission to publish the identity elsewhere. For a new power, generate and check a new GUID using current catalogs.

The example deliberately has no dependencies so a reader can first verify the packaging contract. Real work must first follow [the reuse policy](../../reuse-and-dependencies.md). Do not copy this toy rule into the shared foundation as a new production capability.

Code indentation uses tabs. JSON uses four-space indentation, matching the inspected Power exports. This fixture uses LF; existing repositories may use CRLF in code bodies and escaped CRLF in JSON. Avoid unrelated normalization.

## Local smoke check

From this directory with PHP 7.4 or later:

```sh
php smoke.php
```

The smoke check loads only the derived PHP representation. It checks boundaries, an outside value, and reversed bounds. It does not prove JCB's importer, compiler, namespace relocation, or DI integration.

## License

The original fixture code and documentation use the repository's [CC0 dedication](LICENSE). Upstream powers linked from the examples guide retain their own licenses.
