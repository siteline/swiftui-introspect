# Repository Guidelines

## Release Maintenance

| Branch | Baseline | Purpose |
| --- | --- | --- |
| `main` | Current 27 beta | Development branch and first destination for bug fixes |
| `release/26.x` | `26.0.1` | Maintenance branch for version 26 patch releases |
| `release/1.x` | `1.3.0` | Maintenance branch for version 1 patch releases |

Version 1 maintenance starts from `1.3.0`. The `1.4.0-beta` tags are not release baselines.

### Bug Fixes

- Land bug fixes on `main` first.
- Assess every bug fix merged into `main` for both maintenance branches. Backport it when the fix preserves that branch's public API and supported platforms.
- Keep each backport focused on one fix. Cherry-pick the original commit when it applies cleanly; otherwise adapt only the required source and tests.
- Preserve each maintenance branch's Swift tools version, language mode, deployment targets, package products, formatting, and test framework. Do not merge `main` wholesale into a maintenance branch.
- Do not backport features, new view types, new platform versions, public API changes, toolchain updates, deployment-target changes, packaging changes, or unrelated CI and documentation work.
- If a fix cannot be backported without one of those changes, explain the incompatibility and obtain maintainer approval before changing the maintenance branch.
- Run the affected tests on every changed branch. Create version 1 and version 26 patch releases from their respective maintenance branches.
