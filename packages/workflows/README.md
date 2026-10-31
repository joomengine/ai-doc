# Package workflows

Start with the [package contract](../specification.md), then choose the task below. A package repository holds a shared graph of JCB authoring records and assets. A component is one root into that graph; a successful operation on its root alone does not establish a complete application.

| Task | Procedure | Required result |
| --- | --- | --- |
| Start from an empty repository | [Create a repository](create-repository.md) | Indexed, reviewable source graph with declared external dependencies |
| Build through JCB's browser editor and export source | [Author in Playground and Push](author-in-playground.md) | Saved JCB graph, inspected candidate-branch export, and fresh-instance acquisition |
| Change an existing component or shared record | [Maintain a package graph](maintain.md) | Stable intended identities, updated relationships and affected-consumer checks |
| Explain a missing record, failed import or generated defect | [Debug integration](debug.md) | Reproducible failure traced to the responsible representation |
| Move to another supported Joomla/JCB/PHP target | [Migrate the target](migrate-target.md) | Explicit compatibility changes and fresh-install/upgrade evidence |
| Accept a candidate | [Validate and integrate](validate-and-integrate.md) | Separate structure, acquisition, export, compilation, installation and runtime results |

**Project policy:** use [Playground](../../testing/playground/README.md) by default for authorized implementation testing on a supported target. It is also a practical authoring environment: create Fields, Views and the Component with JCB, then use the package Push path to export their graph to an authorized candidate branch. The [configuration guide](../../testing/playground/configuration.md) governs setup, supported versions, persistence and browser limitations. A documentation-only task does not imply running every live operation.

The procedures describe the inspected JCB `6.x` contract at `408703a857ad937479b1e28de7f693af178dcc83`. Compare the installed version before using a named action. [Package sources](../sources.md) identify implementation authority; [package verification](../verification.md) records actual results. Examples, expected results and prescribed acceptance cases are not completed test evidence.

## Operation scopes that govern these workflows

The component list is `index.php?option=com_componentbuilder&view=joomla_components` in JCB administration. Use its supported authenticated UI with normal permissions and request tokens; the task names below identify source behaviour, not unauthenticated links to invoke.

| Action | Inspected route | Scope and limitation |
| --- | --- | --- |
| Init | `joomla_components.initPowers`; selection `power=Component`, `target=Joomla Components` | Chooses a repository and remote roots. Calls initialization without force. An existing local record is skipped before its remote dependencies are read. |
| Pull | `joomla_components.pullPowers`; the corresponding pull selection | Uses the selected repository with `force=true`. The same repository and force flag propagate to queued package records/assets. This is not general ordered federation across all configured repositories. |
| Reset | `joomla_components.resetPowers`; edit controller also has `joomla_component.resetPowers` | Resolves selected local record IDs to repository keys, then uses configured remote order/read branches. Recurses through declared inward/direct-child dependencies, not ordinary outgoing references. Asset refresh has its own path. |
| Push | `joomla_components.pushPowers`; edit controller also has `joomla_component.pushPowers` | Serializes selected local roots and discovered dependencies/assets. Generic package export targets every effective package repository having a nonempty write branch other than literal `default`. It is not restricted to the source previously selected for Init/Pull. |

The following additional list controllers were inspected at the same revision. Each exposes `.initPowers`, `.pullPowers`, `.resetPowers` and `.pushPowers` with its own entity and selection area; for example `fields.pullPowers` selects concrete package Fields, not Field Type catalogue entries. Use the real list for an independently refreshed dependency.

| List/controller prefix | Builder entity | Selection `power` |
| --- | --- | --- |
| [`joomla_modules`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/Joomla_modulesController.php) | `joomla_module` | `JoomlaModule` |
| [`joomla_plugins`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/Joomla_pluginsController.php) | `joomla_plugin` | `JoomlaPlugin` |
| [`admin_views`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/Admin_viewsController.php) | `admin_view` | `AdminView` |
| [`fields`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/FieldsController.php) | `field` | `Field` |
| [`libraries`](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/LibrariesController.php) | `library` | `Library` |

Owned child records are traversed through their parent and retain the parent-key contract. Do not invent separate UUIDs or toolbar routes from their filenames. For other standalone models, consult the relevant model/source reference and actual controller before extending this routing table.

Missing remote handlers can be skipped by the builder. In particular, a package `fieldtype` dependency is not proof that the separate Field Type service imported it. Prepare external types through the [Field Type workflow](../../field-types/workflows/validate-and-integrate.md); resolve Power tokens through their own catalogues and compiler path. An `added` result is not a substitute for inspecting the saved row: the inspected initialization logger does not check the return from the local setter before logging that category.

**Push requires a destination audit.** Before authorizing the actual button press, make its graph and all effective writable destinations concrete. If publication is already authorized, proceed after this preflight without asking again. In a disposable test instance, clear unintended write branches or exclude the connections from the effective configuration. Merely selecting a candidate on a previous screen does not narrow Push. Record destination host/owner/repository/branch and starting commit without credentials. See [the complete authoring procedure](author-in-playground.md).

## Pinned operation evidence

- [Component list controller](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/Joomla_componentsController.php) and [edit controller](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Controller/Joomla_componentController.php): permissions, selection routes, local-ID conversion and builder calls.
- [AJAX model](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/src/Model/AjaxModel.php#L6764): `initSelectedPackages` and `pullSelectedPackages`; [builder getter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Builder/Get.php): recursive selected-repository propagation, missing services and restricted Reset traversal.
- [Shared getter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Get.php): existing-local skip, read branch and result logging.
- [Builder setter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Builder/Set.php) and [shared setter](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Abstraction/Remote/Set.php): graph export, write-branch gating, default `targetRepo=true`, per-file writes and success scope.
- [Package repository configuration](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/libraries/vendor_jcb/VDM.Joomla/src/Componentbuilder/Package/Config.php) and [repository form](https://github.com/vdm-io/Joomla-Component-Builder/blob/408703a857ad937479b1e28de7f693af178dcc83/admin/forms/repository.xml): content target `4`, configured/fallback sources, read/write branches and credential fields.

These are verified implementation behaviours. The workflow ordering, preflight checks, compatibility matrix and evidence requirements are project guidance derived from them.
