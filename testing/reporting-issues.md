# Prepare a JCB issue for human submission

**Authority: project-owner policy, 31 October 2026.** The human reviews and submits JCB issues through the [official JCB issue chooser](https://git.vdm.dev/joomla/Component-Builder/issues/new/choose). Agents help investigate and prepare a useful report; they do not submit it under this policy. This preserves a human's sign-off. Difficulty reaching the issue tracker from an agent does not authorize posting somewhere else or circumventing its access controls.

## Establish what failed

Use the module's acceptance procedure and the [shared Playground workflow](playground/README.md) to identify the last successful stage: repository discovery, payload fetch, persistence, refresh, compilation, installation or runtime. Distinguish a malformed candidate definition from a JCB defect, a browser/network restriction and a Playground compatibility problem. A failure in a candidate with unresolved dependencies does not by itself establish a compiler defect.

1. Preserve the exact candidate revision and relevant GUIDs; avoid resetting or overwriting the only failing specimen.
2. Reduce to the smallest component, record or action that still reproduces the failure. Record the actual selected repository, target, branch, enabled state and precedence, rather than merely the intended source.
3. Reproduce once from a known starting state. State whether the result is repeatable, intermittent, or occurred only once. Include Init versus Pull/Reset and fresh versus existing local records when relevant.
4. Record Joomla, JCB, PHP, browser and Playground build/provenance when available. A Playground failure is evidence for that WASM environment; report whether the same case was tried on native Joomla and the result. An unavailable comparison remains unrun.
5. Inspect the relevant generated files and error messages. If an editor patch helps diagnosis, retain its diff, return the fix to maintained source and reproduce after regeneration before describing it as a completed fix.
6. Search existing issues if accessible. Report an inaccessible tracker honestly; do not claim there are no duplicates without checking. A human can perform that check during submission.

For a defect confined to Playground's deployment, editor, persistence or WASM compatibility, identify that evidence and let the human decide whether to report it to [Playground](https://github.com/joomengine/playground/issues) instead of, or alongside, JCB. Keep cross-project findings clearly attributed. Do not automatically cross-post.

## Hand the human a complete draft

Supply the actual values for the affected case, using these sections. This is a content checklist, not a request to create an issue full of unfilled placeholders.

| Section | Required information |
| --- | --- |
| Title | Concrete operation and unexpected result; avoid a guessed cause |
| Environment | Actual Joomla/JCB/PHP versions, browser/platform, Playground source/build and relevant adaptations when known; label unknown values |
| Starting state | Fresh or resumed site, relevant installed extensions, local item existence, repository type/provider/branch/order and dependencies |
| Reproduction | Numbered GUI actions or reproducible supported commands; smallest accessible candidate commit and GUIDs |
| Expected result | Exact field values, generated output or runtime behaviour and its supporting contract |
| Actual result | Observed error and incorrect state, including whether data was persisted or partially changed |
| Evidence | Sanitized error/log excerpt, relevant source/generated diff and screenshot or reproduction archive when useful |
| Verification | Passed, failed, blocked and unrun stages; affected versions and whether native comparison was attempted |
| Diagnosis or proposed fix | Separate established cause from a hypothesis; describe workaround limitations |

Never include access tokens, passwords, session-bound virtual URLs, provider keys, personal/private data or a whole database export merely to supply evidence. Deployment/share URLs describe configuration, not a copy of the current database or an authentication grant. Use public minimal fixtures or let the human decide how to supply private material. Check attached archives and screenshots before proposing them for upload.

End the handoff with the official issue link and a clear request for the human to review, choose the appropriate template and submit. Keep the draft available in the user's requested channel. The human can return the issue URL for later correlation with a fix; do not claim an issue exists before receiving or verifying it.
