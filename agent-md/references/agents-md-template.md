---
description: Canonical template for AGENTS.md — the cross-tool standard for agent instructions.
---

```markdown
# [Project Name]

[One-liner: what this project does]

## Commands

- Install: `[package-manager] install`
- Dev: `[command]` (port [port])
- Build: `[command]`
- Test all: `[command]`
- Test single: `[command --filter/pattern]`
- Lint: `[command --fix]`
- Type check: `[command]`

## Project Structure

- `[path]/` — [what lives here]
- `[path]/` — [what lives here]

## Code Standards

- [Language] [strict mode / config file]
- Naming: [camelCase / snake_case / PascalCase per context]
- [Preferred patterns — async/await, functional components, hooks]
- [Error handling pattern — custom exceptions, Result type]

## Testing

- Framework: [name]
- Tests: [location convention — co-located or mirror dir]
- Fixtures: [location]
- Coverage: [target % on new/changed code]

## Git Workflow

- Branch from `main` with `[prefix]/`, `[prefix]/` prefixes
- Commit messages: [format — conventional commits, etc.]
- Merge: [squash / rebase / merge commit]

## Boundaries

- Never modify: [list — secrets, vendor dirs, generated files, prod config]
- Ask before: [schema changes, new deps, CI config, production infra]
- Always do: [run lint, run tests, follow conventions]

## Definition of Done

All of these pass:
1. `[lint command]` exits 0
2. `[test command]` exits 0
3. `[type-check command]` exits 0
4. Files committed with [conventional format]

## Escalation Rules

- Tests fail after 3 attempts: stop and report full output
- Missing dependency: check [lockfile/manifest] first, then ask
- Merge conflicts: stop and show conflicting files
- Never: delete files to fix errors, force push, skip tests
```
