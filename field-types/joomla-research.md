# Research Joomla before proposing a Field Type

A Field Type catalogue describes how JCB authors a Joomla field. It does not define Joomla's actual runtime API. For a new type or property, prove the relationship from the selected Joomla implementation through the JCB metadata and generated XML to the concrete field behaviour.

**Inspected target:** Joomla CMS tag [`6.2.0`](https://github.com/joomla/joomla-cms/releases/tag/6.2.0), commit [`d7b2268f9184b67866156afb5446717e0612d169`](https://github.com/joomla/joomla-cms/tree/d7b2268f9184b67866156afb5446717e0612d169), checked 31 October 2026. GitHub's official release metadata identified this as a non-prerelease. This is the target for the worked examples, not a claim that all Joomla releases behave identically. JCB implementation references below use `6.x` commit `408703a857ad937479b1e28de7f693af178dcc83`.

## Keep the five layers distinct

| Layer | Example | Authority and meaning |
| --- | --- | --- |
| Joomla effective runtime behaviour | Omitted `maxlength` does not produce a `maxlength` HTML attribute in the default Text layout. | The field's setup, inheritance, layout data, and selected layout together establish the result. A PHP property declaration alone is insufficient. |
| JCB catalogue suggestion | The official Text item's `maxlength.example` is `"50"`. | A suggested value exposed when authoring a field; it is not Joomla's default. |
| Concrete JCB Field choice | A particular Field uses `maxlength="120"`. | The actual field XML and per-field settings determine this use, subject to compiler transformations. |
| Form value and binding | A new form has an initial value; a saved record has a bound value. | `Form::loadField()` uses the explicit supplied value, or bound data with an XML default fallback. Readonly does not replace saved data with the default. |
| Database/storage choice | `VARCHAR`, length `128`, `NOT NULL`, storage transform and SQL default. | JCB Field Type storage defaults can suggest settings for a Field. They are not Joomla HTML input properties and do not make a browser `maxlength` a server-side or database constraint. |

The official core catalogue is [`joomengine/joomla-fieldtypes`](https://github.com/joomengine/joomla-fieldtypes). Every new Field Type identity check must include its current index, even when publishing to a separate repository. Reuse or improve its existing definition where suitable. An intentional same-item fork/override retains the GUID and records source order; it is different from allocating a genuinely new identity.

## A reproducible investigation

1. **Choose the target.** Resolve an official Joomla release tag or explicitly selected development ref to its exact commit. Record Joomla/PHP/JCB versions. A moving `*-dev` branch is not a stable release number.
2. **Find the actual class and resolution path.** Search `libraries/src/Form/Field`, then inspect `FormHelper::loadFieldType()` and the component's field prefixes when custom lookup is involved. Confirm the resolved class; Joomla can fall back to Text when loading a requested type fails, so a rendered textbox alone does not prove a custom field loaded.
3. **Walk the inheritance and traits.** Read the class declaration, its ancestors, used traits, `setup()`, magic property setters/getters, and explicit XML reads. Do not infer a hierarchy from naming. At this pin both `TextField` and `ListField` extend `FormField` directly; there is no intervening `InputField`.
4. **Follow rendering and validation.** Trace `getInput()`, `getLayoutData()`, `collectLayoutData()`, the chosen layout and any overrides, `filter()`, `validate()`, and supporting assets. An XML attribute can be consumed by a layout or parent rather than appearing in the leaf class.
5. **Inventory each proposed property.** Record exact case, owner, accepted representation, omitted/empty behaviour, coercion, output, version availability, and the consuming symbol. Separate JCB directives from native Joomla XML. A public PHP property is not automatically an XML attribute.
6. **Compare the existing catalogue.** Read the current official item and any configured override with provenance. Distinguish a missing feature, outdated description, implementation defect, and intentional project convention. Do not overwrite an existing GUID or publish a second version of the same type merely to improve wording.
7. **Choose examples and storage intentionally.** Write concrete examples with their rationale. Declare required/adjustable/translatable metadata based on JCB's needs, and select storage defaults separately. Do not label an example as a core default.
8. **Exercise a consumer.** Import/reset in a test JCB environment, create a Field, inspect its stored XML, compile, inspect the generated form/class/SQL, then load, bind, render, validate and save it in the declared Joomla target. Include omitted attributes and an explicit non-default value. Record which stages actually ran.

## Worked source trace: Text and List

The following are immutable source links for the inspected Joomla release.

| Source | Relevant responsibility |
| --- | --- |
| [`TextField.php`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/libraries/src/Form/Field/TextField.php), `setup`, `getInput`, `getOptions`, `getLayoutData` | Text-specific coercion, datalist options, global-value hint, layout selection and layout data. |
| [`ListField.php`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/libraries/src/Form/Field/ListField.php), `setup`, `getOptions`, `getInput` | Header and option handling, conditional options, selected/disabled states, optional global choice and list rendering. |
| [`FormField.php`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/libraries/src/Form/FormField.php), `__set`, `setup`, `getName`, `filter`, `validate`, `getLayoutData`, `getLayoutPaths` | Common attributes and coercion, name/group handling, filters/validation and layout context. The class uses `DatabaseAwareTrait` and `CurrentUserTrait`; those establish runtime services, not a list of XML field properties. |
| [`Form.php`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/libraries/src/Form/Form.php), `loadField` | Type loading, dependency injection, explicit/bound/default value selection, and the fallback Text field. |
| [`FormHelper.php`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/libraries/src/Form/FormHelper.php), `loadFieldType` | Namespaced/prefixed class discovery. Confirm the consumer's registered prefixes. |
| [`layouts/joomla/form/field/text.php`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/layouts/joomla/form/field/text.php) | Actual input markup, default CSS class, optional attributes, character-counter asset and datalist. |
| [`layouts/joomla/form/field/list.php`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/layouts/joomla/form/field/list.php) | Select CSS class, disabled rendering and readonly hidden-value inputs. |
| [`layouts/joomla/form/field/list-fancy-select.php`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/layouts/joomla/form/field/list-fancy-select.php) | An explicitly selected alternate layout. Its requirements must be checked separately from the default List layout. |

### Properties and effective defaults at this pin

This table is a worked evidence inventory, not an exhaustive replacement for all Joomla field documentation. It covers the attributes used in the fixtures and meaningful differences found in the official Text/List catalogue entries.

| Property | Joomla 6.2.0 behaviour | Catalogue/authoring implication |
| --- | --- | --- |
| `type` | `Form::loadField()` defaults an absent type to `text`; the resolved class has its own type. | JCB should emit the intended explicit type and verify class resolution, rather than rely on fallback. |
| `name` | `FormField` constructs names/IDs with form control and group; multiple fields gain `[]`. | Set the concrete Field name, not a globally unique catalogue GUID. |
| `label`, `description`, `hint` | Common field/layout code consumes these; translation is enabled by default unless disabled through the supported flags. | Catalogue `translatable` governs JCB language generation and is distinct from Joomla's runtime translation flags. |
| `size` | Common setup casts to integer; omission becomes `0`, and default layouts omit the attribute when empty. | Text's catalogue example `10` is a suggested display size, not its maximum length or database size. |
| `maxlength` | Text casts it to integer; omission becomes `0`, and no maxlength markup is emitted. | Official example `50` is a suggestion. Choose and test the application limit independently. |
| `charcounter` | Text defaults false; setup enables it only when the string, lowercased, equals `true`. The Text layout loads `short-and-sweet` and counter markup. | `"1"` is not interchangeable with `"true"` for this particular setting. Verify the web asset is available. |
| `class` | Common setup trims supplied classes. Default Text layout adds `form-control`; default List layout adds `form-select`. Required setup can append `required`. | Official examples `text_area`/`list_class` are extra chosen classes. Old catalogue prose claiming automatic `text_area` or `inputbox` is not the effective default here. |
| `required`, `disabled`, `readonly`, `autofocus` | Common setter recognizes the exact string `true`, the attribute's own name, or `1`; omission becomes false. | Use clear `true`/`false` examples. Validation has its own checks: do not infer identical handling in every consumer merely from the rendering setter. |
| `readonly` versus `disabled` | Default List layout disables the visible select for either; readonly additionally supplies hidden value inputs. Text renders the corresponding native attribute. | Neither setting means "replace bound data with default". Test posted values and server rules separately. |
| `multiple` | List inherits the common false default; the selected layout emits `multiple` and naming changes when enabled. | A multiple-value Field needs a deliberate persistence/transform choice. A single-value SQL default is not enough. |
| `autocomplete` | Although the PHP property declares `on`, common setup assigns the missing XML value as an empty string. The Text layout then omits the attribute. | Do not quote a declaration as the effective rendered default. An explicit `off` is a field choice. Browser behaviour after omission is a separate layer. |
| `default` | `Form::loadField()` uses a supplied value, or bound data falling back to the XML default. `translate_default` can affect the fallback. | Catalogue `example`, XML `default`, bound data and SQL `datadefault` are distinct values. |
| `layout` | Text defaults `joomla.form.field.text`; List defaults `joomla.form.field.list`. A nonempty XML layout overrides it. | The catalogue example `joomla.form.field.list-fancy-select` selects a variant; it is not List's runtime default. |
| `inputmode`, `dirname`, `addonBefore`, `addonAfter` | Text setup/layout code consumes these even though they are absent from the inspected core Text catalogue. `dirname` enables a generated companion direction-field name for `dirname`, `true`, or `1`. | Catalogue absence does not prove Joomla absence. Add a researched property with its exact case and semantics when needed. |
| `<option>` children and `header` | List reads child options; its header becomes an initial empty-value option. Text also uses child options for a datalist. | JCB List's `option` metadata is compiler input, not a native Joomla `option="a|A,b|B"` attribute. Inspect the resulting child elements. |
| `useglobal` | Text can replace its hint with a resolved global value; List can prepend a global-choice option. Both branches read the XML value directly. | Inspect these branches before proposing boolean-like values; do not assume every attribute uses the common boolean setter. They require application context. |
| `filter`, `validate`, `pattern`, `showon`, `data-*` | These belong to different paths: server filtering, rule validation, layout/client constraints, conditional rendering and arbitrary data attributes. | Identify each actual consumer; a property appearing in HTML does not prove server validation. Do not label all of them "input attributes" with identical guarantees. |

The observed catalogue comparison uses the pinned [Text item](https://github.com/joomengine/joomla-fieldtypes/blob/3be64d59378b5650825b97b44dbd58f2cdb82fcb/src/201327fe-3067-4316-a155-3fe2a52e05c0/item.json) and [List item](https://github.com/joomengine/joomla-fieldtypes/blob/3be64d59378b5650825b97b44dbd58f2cdb82fcb/src/a51dfc06-1b9b-4d0a-86ba-f705bcd40d4d/item.json). These source-backed differences are documentation findings; this module does not silently edit the official catalogue.

## A concrete discovery candidate: Enum

At the inspected snapshots, Joomla 6.2.0 includes [`EnumField`](https://github.com/joomla/joomla-cms/blob/d7b2268f9184b67866156afb5446717e0612d169/libraries/src/Form/Field/EnumField.php), marked `@since 6.2.0`, while the 49-entry official catalogue has no item named Enum or property example declaring `type="enum"`. This is a candidate gap to investigate, not an automatic contribution or proof that no configured specialist catalogue already provides it.

`EnumField` extends `ListField`, which extends `FormField`. Its `getOptions()` requires a nonempty `enum` attribute naming an autoloadable PHP enum; an absent/unknown enum throws `InvalidArgumentException`. Backed enum cases use their backing values, pure cases use their names. Optional `prefix` supplies the prefix for uppercased translation keys. The implementation merges the inherited List options with the enum cases, so the inherited layout, option handling, selection and common field attributes still matter.

A valid proposal must therefore establish at least: minimum supported Joomla version; how the consumer's enum class is shipped and autoloaded; whether values are integers or strings and how they are persisted; all required translation keys; inherited List options/layout behaviour; explicit error cases; and actual JCB handling of this previously uncatalogued type. Do not invent a general `ENUM` SQL default from the PHP class name. A PHP enum is a runtime dependency; a JCB Field Type property does not install that class.

Comparing core field filenames with catalogue names is only discovery. Names can differ, aliases and custom profiles can exist, and runtime requirements can make a direct metadata-only addition incomplete. Record that assessment before allocating a new GUID through the official-core-plus-additional-catalogue check.

## JCB-specific properties and custom PHP

Properties such as `option`, `extends`, `prime_php`, and `type_php_*` can be JCB authoring/compiler instructions. They must not be described as Joomla core XML attributes merely because they occur in the catalogue.

The inspected [`Field/Attributes.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Field/Attributes.php), particularly `getTypePHP()`, extracts code from the concrete Field's encoded XML attributes. [`Creator/CustomFieldTypeFile.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Compiler/Creator/CustomFieldTypeFile.php) then chooses the template and inserts the appropriate code. Plain JSON property examples remain plain text; encoding a concrete Field's PHP XML attribute is a different transformation.

| Custom path | What the code supplies | What JCB supplies |
| --- | --- | --- |
| Standard `Custom`, extending list/radio/checkboxes | The `type_php_1` family supplies the body of the generated `getOptions()` method. | The class wrapper, imports and method declaration in the selected template, such as [`FORM_LIST_FIELD.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/compiler/joomla_6/FORM_LIST_FIELD.php). Do not insert another method declaration into that method body. |
| Own custom Field Type identified by `@` | The body-code groups can supply complete methods/properties inside the class; `type_phpHEADER_*` supplies header material. | [`FORM_CUSTOM_FIELD.php`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/compiler/joomla_6/FORM_CUSTOM_FIELD.php) supplies namespace, class declaration, parent and type property. Do not put `<?php`, a namespace or another enclosing class into a body group. |

Follow the selected parent's real API. Parent mapping is compiler-dependent: even `extends` strings are interpreted by JCB, not simply copied as a fully qualified class. Validate the generated `use` statement and `extends` declaration. A `@` marker or an arbitrary new type name alone does not provide implementation.

For expensive or reusable custom behaviour, first investigate Joomla's existing field capabilities and then shared Powers; keep field rendering focused. The [examples](examples/README.md) distinguish a core-field catalogue profile from an own-custom method-body specimen. Their identities are fixtures, and their integration acceptance remains a separate JCB task.

## Required proposal evidence

A new proposal should include the selected class and inheritance chain; every added property's source consumer and omission/coercion rule; the chosen layout and assets; existing core/specialist catalogue comparison; suggested example versus runtime default; concrete Field/XML example; storage rationale; generated custom class evidence if applicable; identity/collision result; and the checks actually performed. Link the canonical evidence rather than copying complete Joomla classes into the catalogue.
