# File and folder transport fixture

The [minimal repository](minimal-repository/README.md) contains original non-executable text content in both asset forms. Its [component-files-folders child](minimal-repository/src/joomla_component/children/89db4e90-ea7e-42e2-9805-94b22cf6d636/component-files-folders.json) owns the application placement settings; its descriptors identify the inputs to restore into JCB's custom-content area. These are different destinations.

| Asset | Descriptor | Repository content | Intended compiler placement |
| --- | --- | --- | --- |
| Notice text | `entity: file`, `target: custom`, `value: aidoc-package-notice.txt` | Raw text at `src/file_folder/c3f64e43-5f0c-5b58-8aad-cb1f61ad9fad.txt` | `media/aidoc-package-notice.txt` from the child `addfiles` row |
| Asset folder | `entity: folder`, `target: custom`, `value: aidoc-package-assets` | ZIP at `src/file_folder/54376eec-75f2-5d0c-a47a-6c9bd8e9a4e7.zip`, containing `README.txt` at its root | The child `addfolders` row requests `media/aidoc-package-assets` |

Both descriptors have `table: file_system`, a normalized `key` and `pointer`; neither has an entity-row `direction`. The pointer replaces the key's dot with `--`. The shared [file_folder index](minimal-repository/index/file_folder.json) uses the key as its outer identity and `guid`, and points directly to content. It has no `settings` path.

## Reproducible contents and normalization

The text file contains `Original CC0 package fixture notice.` followed by a newline. The ZIP contains one regular `README.txt` with `Original CC0 folder-transport fixture.` followed by a newline. The archive has no enclosing source-directory prefix, absolute member, traversal path, executable body or symlink. Its filename ending in `.zip` is not itself evidence of a valid archive.

From the distribution root:

```bash
fixture=packages/examples/minimal-repository
unzip -t "$fixture/src/file_folder/54376eec-75f2-5d0c-a47a-6c9bd8e9a4e7.zip"
unzip -Z1 "$fixture/src/file_folder/54376eec-75f2-5d0c-a47a-6c9bd8e9a4e7.zip"
unzip -p "$fixture/src/file_folder/54376eec-75f2-5d0c-a47a-6c9bd8e9a4e7.zip" README.txt
sha256sum "$fixture"/src/file_folder/*
```

Use the current JCB exporter to derive production asset keys. At the pinned implementation, [Normalize::path/key](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Utilities/Normalize.php) resolves the scoped existing path, derives its relative path, substitutes the defined special-character markers, lowercases it and hashes it with UUIDv5's URL namespace. A file's lowercase extension or a folder's `.zip` suffix is then appended. This is not a random entity UUID, a content hash, or plain UUIDv5 of the untouched path. The fixture keys were computed with this exact mapping and cross-checked against the known Hello World `images/demo300.jpg` key.

Changing bytes at the same normalized destination keeps its key; changing the destination requires recomputing key, pointer, index and descriptors together. Distinct paths can collapse under normalization, including case changes, so inspect collisions. The `full` absolute path used during export is local working metadata, not a portable payload field. Never copy an author machine's path into a new installation merely to reproduce a specimen.

## Acquisition, refresh and compiler checks

Ordinary acquisition can preserve an already-local file/folder. A local-present result is not a hash comparison with repository bytes. Verify the intended restored file and folder contents separately from the database records. Forced folder restoration may delete the existing destination before extraction: use an isolated fixture destination and preserve deliberate local edits. The source-inspected asset Reset limitation is documented in the [package specification](../specification.md); do not assume entity Reset and asset refresh have identical behavior.

After compilation, inspect the generated package tree and manifest to establish the actual asset paths, then inspect installed files. The child row's requested path is intent, not evidence that the compiler or installer placed it successfully. If a path is wrong, correct the authoritative child/asset descriptor, regenerate and retest. An installed-file edit alone does not validate source.

Treat archive membership, size, destination scope, overwrite behavior and included licenses as part of review for real assets. The fixture's CC0 text is deliberately simple; it does not certify an unrelated vendor archive. Packages' observed `vendor` ZIP is upstream reference material, not bundled or executed by this example.
