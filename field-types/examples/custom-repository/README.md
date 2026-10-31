# Own-custom Field Type repository fixture

This catalogue contains one original own-custom definition: [Previewedtext@](src/58d75b15-b4d8-4192-a8a7-19fac5881b0b/item.json). Its reserved fixture GUID is `58d75b15-b4d8-4192-a8a7-19fac5881b0b`; the [index](index.json) locates it.

The `@` name selects JCB's own-custom path. The suggested concrete type is `previewedtext`, the parent selector is `text`, and `type_php_1.example` contains a complete `getInput()` method. It calls `parent::getInput()` to reuse Joomla TextField, then appends an HTML-escaped preview of the value. Its readable source is [custom-body.php.txt](../custom-body.php.txt). The method body and JSON string must agree byte for byte.

This code belongs inside the generated class. It contains no PHP opening tag, namespace, `use` statement, class wrapper or duplicate `$type` property. JCB supplies those from its own-custom template and header. A standard `Custom` list field instead expects the inside of `getOptions()`; moving this complete method there would be invalid.

## Acceptance in a test consumer

1. Import this fixture into an isolated JCB instance using the workflow, then create a Field selecting it. Confirm concrete `type="previewedtext"`, `extends="text"`, and the PHP editor containing the complete method.
2. Attach the Field to a test view, compile for Joomla 6, and inspect both generated class and form. Confirm the class uses/extends `Joomla\CMS\Form\Field\TextField`, contains exactly one `getInput()` method, and resolves through the component's registered field namespace.
3. Lint the generated class, then load the form in Joomla 6.2.0. Assert the actual field object is the generated class, because a fallback Text input could hide a class-resolution failure.
4. Bind an ordinary string and a string containing `<`, `>`, `&`, quotes. The parent input must still render; the appended preview must display escaped text without executing markup. Save/reload the field through the consumer's normal validation and storage path.
5. Record JCB/PHP/Joomla versions, generated paths and results. This fixture was source-reviewed and structurally validated; no import, compilation or live runtime pass is implied by its presence here.

Use the actual JCB Field editor/custom-PHP handling to create the concrete encoded XML. Do not concatenate the raw method into an XML attribute: its quotes, markup and line breaks require the correct field-storage transformation. The raw JSON property example and the concrete Field's encoded PHP attribute are different representations.

Do not reuse its identity or impose its exact custom type name on another project. Generate/check a new GUID for a new definition and verify type-name collisions separately. See [example policy](../README.md) and [research evidence](../../joomla-research.md).

Follow [AGENTS.md](AGENTS.md). This original fixture uses the [CC0 license](LICENSE).
