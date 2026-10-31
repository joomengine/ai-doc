# Text Field Type repository fixture

This is a complete single-item Field Type catalogue for structural validation. Its reserved fixture identity is `24dbee13-a034-4efd-aed2-9aaca97a5225`.

| File | Role |
| --- | --- |
| [index.json](index.json) | GUID locator and description. |
| [item.json](src/24dbee13-a034-4efd-aed2-9aaca97a5225/item.json) | Authoritative Field Type metadata and suggested properties/storage. |
| [Item README](src/24dbee13-a034-4efd-aed2-9aaca97a5225/README.md) | Human/agent description of that item. |
| [AGENTS.md](AGENTS.md) and [LICENSE](LICENSE) | Fixture operating boundary and original material's CC0 terms. |
| [example-form.xml](example-form.xml) | Illustrative native Joomla form using the researched values. It is not an imported catalogue payload or a compiler-captured output. |

The name and type map to Joomla's existing TextField. A new PHP implementation is unnecessary. The profile includes inherited common attributes and Text's character counter, and selects examples rather than claiming they are core defaults.

Use this fixture only in isolated testing. Do not import its identity into a production catalogue or publish it as a competing official Text definition. Real improvements/overrides of the same Text item preserve its official GUID. See [example rules and validation](../README.md).

This original fixture uses the [CC0 license](LICENSE). Joomla/JCB source references retain their own licenses.
