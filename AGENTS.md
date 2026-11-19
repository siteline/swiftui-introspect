# Repository Guidelines

## Release Maintenance

| Branch | Baseline | Purpose |
| --- | --- | --- |
| `main` | Current 27 beta | Development branch and first destination for features and fixes |
| `release/26.x` | `26.0.1` | Maintenance branch for version 26 releases |
| `release/1.x` | `1.3.0` | Maintenance branch for version 1 releases |

Version 1 maintenance starts from `1.3.0`. The `1.4.0-beta` tags are not release baselines.

### Features and Fixes

- Land features and fixes on `main` first. Assess and backport them only after they have merged, as a separate maintenance step rather than part of feature development.
- Assess every feature and fix merged into `main` for both maintenance branches. Backport applicable, backward-compatible changes that preserve each branch's toolchain, supported platforms, and existing public API. Additive public API is allowed when it preserves compatibility with the existing API.
- Keep each backport focused on one feature or fix. Cherry-pick the original commit when it applies cleanly; otherwise adapt only the required source and tests.
- Preserve each maintenance branch's Swift tools version, language mode, deployment targets, package products, formatting, and test framework. Do not merge `main` wholesale into a maintenance branch.
- Do not backport breaking public API changes, new platform versions, toolchain updates, deployment-target changes, packaging changes, or unrelated CI and documentation work.
- If a feature or fix cannot be backported while preserving those compatibility constraints, explain the incompatibility and obtain maintainer approval before changing the maintenance branch.
- Run the affected tests on every changed branch. Create version 1 and version 26 releases from their respective maintenance branches. Use minor releases for additive features and patch releases for fixes.

## Benchmarks

- Before opening a pull request that changes how introspection finds or customizes its target, such as selectors, probes, or hierarchy traversal, run `mise run benchmarks <base>` against the pull request's base on an Apple silicon Mac. Investigate every ⚠️ increase before opening it.
- Include the comparison table the task prints in the description of any pull request it was run for.

## Tests

- Spell out each platform version in test `.introspect(...)` predicates, such as `.iOS(.v16, .v17, .v18, .v26, .v27)`, rather than a range like `.iOS(.v16...)`. Use ranges only in tests of range predicates themselves.
