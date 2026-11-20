# Repository Guidelines

## Release Maintenance

| Branch | Releases |
| --- | --- |
| `main` | The current major version, and the first destination for features and fixes |
| `release/26.x` | Version 26 |
| `release/1.x` | Version 1 |

- Each maintenance branch has the same tree as `main`, except that it leaves out the platform versions of later yearly OS releases: `release/26.x` has no `.v27`, and `release/1.x` has no `.v26`, `.v27`, or `WebView`, which requires OS 26.
- Land features and fixes on `main` first. After they merge, bring each maintenance branch back to that tree, with one commit per feature or fix.
- CI runs only for pushes to `main` and for pull requests, so pushes to a maintenance branch run no CI. Before pushing one, run its tests on a simulator of the newest OS version it supports, or build it for every platform when no such runtime is installed.
- Create version 1 and version 26 releases from their maintenance branches. Use minor releases for additive features and patch releases for fixes.

## Benchmarks

- Before opening a pull request that changes how introspection finds or customizes its target, such as selectors, probes, or hierarchy traversal, run `mise run benchmarks <base>` against the pull request's base on an Apple silicon Mac. Investigate every ⚠️ increase before opening it.
- Include the comparison table the task prints in the description of any pull request it was run for.

## Tests

- Spell out each platform version in test `.introspect(...)` predicates, such as `.iOS(.v16, .v17, .v18, .v26, .v27)`, rather than a range like `.iOS(.v16...)`. Use ranges only in tests of range predicates themselves.
