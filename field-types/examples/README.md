# Complete Field Type examples

These original fixtures demonstrate the Field Type repository contract and a concrete dependency on Joomla's existing field implementation. They are not updates to the official catalogue and are not a certificate of completed JCB import/compilation.

| Example | Purpose | Identity |
| --- | --- | --- |
| [Minimal core Text profile](minimal-repository/README.md) | Complete `index.json`, `src/<guid>/item.json`, item README, and a separate illustrative form XML. | `24dbee13-a034-4efd-aed2-9aaca97a5225`, fixture only |
| [Own-custom Text extension](custom-repository/README.md) | Complete custom repository with an `@` type and a complete method inside its code property; reuses Joomla TextField. | `58d75b15-b4d8-4192-a8a7-19fac5881b0b`, fixture only |
| [Custom body](custom-body.php.txt) | Reviewable source of the custom item's raw `type_php_1.example`. | No separate identity; not a standalone PHP class/file |

Both UUIDv4 values were generated using the operating system's cryptographic facility and checked against the current official 49-entry core index at `3be64d59378b5650825b97b44dbd58f2cdb82fcb`. They remain permanently reserved for these examples. Generate a fresh identity for a genuinely new definition; check the live core catalogue, all configured additional repositories, and local additions. Same-item improvements/intentional overrides retain the existing identity instead.

## Provenance and applicability

The metadata, explanations, XML and PHP method here were authored for this documentation and use the repository's [CC0 license](../../LICENSE). They do not copy the complete upstream Joomla or JCB classes. Format/behaviour evidence comes from:

- Official catalogue `joomengine/joomla-fieldtypes` at `3be64d59378b5650825b97b44dbd58f2cdb82fcb`.
- JCB `6.x` at `408703a857ad937479b1e28de7f693af178dcc83`.
- Joomla CMS `6.2.0` at `d7b2268f9184b67866156afb5446717e0612d169`.

The [Joomla research guide](../joomla-research.md) links the exact source consumers, including inherited attributes, layouts and custom-code insertion. Inspect the target again before claiming another version is supported. The official sources retain their own copyrights and licenses.

## Validate the repository contract

From the `ai-doc` root, with Git, Bash and jq installed:

```bash
catalog_dir=$(mktemp -d)
rmdir "$catalog_dir"
bash tools/fetch-entity-catalog.sh field-types "$catalog_dir"
bash tools/validate-field-type-repository.sh field-types/examples/minimal-repository "$catalog_dir"
bash tools/validate-field-type-repository.sh field-types/examples/custom-repository "$catalog_dir"
```

These checks validate the documented structural profile and identities against the fetched catalogue. They do not render Joomla forms, create SQL, or run the compiler. Follow [validation and integration](../workflows/validate-and-integrate.md) to establish those results. Preserve the fetched catalogue manifest as evidence for a real change.

## Important modelling choices

The minimal fixture deliberately keeps `name="Text"` and property `type.example="text"`. It demonstrates a standalone transport item under a fixture identity; it is not advice to fork the official Text definition under a new production GUID. For real Text improvements or repository overrides, preserve the official Text GUID `201327fe-3067-4316-a155-3fe2a52e05c0`. Do not rename the catalogue item arbitrarily and assume its PHP binding is unchanged: JCB's type naming and the property/type context both participate in compilation.

The storage suggestion uses `datalenght="Other"` plus `datalenght_other="128"`, preserving JCB's spelling and selector semantics. Browser `maxlength="120"` is a separate deliberate choice. Neither value is presented as Joomla's default, and the difference does not itself provide server-side validation.

The minimal profile exposes a useful subset of Text's supported properties. It does not claim that unspecified Joomla attributes are impossible. Add researched property rows when a use case needs them; removing a row from an existing type can affect its consumers during compilation.
