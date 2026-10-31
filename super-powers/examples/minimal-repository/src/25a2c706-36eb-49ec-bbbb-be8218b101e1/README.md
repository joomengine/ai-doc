# IntegerInterval

**Documentation fixture; not an official published power.**

GUID: `25a2c706-36eb-49ec-bbbb-be8218b101e1`. Type: `final class`.

The authoritative inputs are [settings.json](settings.json) and [code.power](code.power). [code.php](code.php) is a derived inspection fixture using `NamespacePrefix=VDM`; it is not a JCB import input.

`contains(int $value, int $minimum, int $maximum): bool` includes both bounds. Reversed bounds throw `InvalidArgumentException`. It has no Power, Joomla, Composer, or application-service dependencies. It demonstrates source packaging, not a recommended replacement for an existing production helper.

Creation rule: this identity belongs to this fixture. Generate and collision-check a fresh UUIDv4 for a different power; update the directory, settings, index key, index paths, SPK, and documentation together.
