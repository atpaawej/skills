---
description: Canonical template for CLAUDE.md — Claude Code-specific agent instructions with subagent support.
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
- [Preferred patterns]
- [Error handling pattern]

## Testing

- Framework: [name]
- Tests: [location convention]
- Fixtures: [location]
- Coverage: [target %]

## Git Workflow

- Branch from `main` with `[prefix]/` prefixes
- Commit messages: [format]
- Merge: [squash / rebase / merge commit]

## Boundaries

- Never modify: [list]
- Ask before: [list]
- Always do: [list]

## Definition of Done

All of these pass:
1. `[lint command]` exits 0
2. `[test command]` exits 0
3. `[type-check command]` exits 0
4. Files committed with [conventional format]

## Escalation Rules

- Tests fail after 3 attempts: stop and report full output
- Missing dependency: check [lockfile/manifest] first
- Merge conflicts: stop and show conflicting files
- Never: delete files to fix errors, force push, skip tests

## Agents

Define Claude Code subagents for this project. Each entry is a `###` heading with indented key-value pairs.

### [agent-name]
description: [what this agent does — drives invocation accuracy]
tools: [comma-separated: read, write, edit, bash, glob, grep, web, todo]
model: [model-id — e.g. anthropic/claude-sonnet-4-6]

### [agent-name]
description: [what this agent does]
tools: [comma-separated]
model: [model-id]
```
