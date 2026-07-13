---
name: agent-md
description: Create or update AGENTS.md or CLAUDE.md for the current project. Asks which file, interviews for context, then generates or audits against the canonical template.
argument-hint: "File type (AGENTS.md or CLAUDE.md) and whether to create or maintain"
disable-model-invocation: true
---

## Entry points

- **Create** — no existing file, or replacing an inadequate one
- **Maintain** — existing file needs audit and update

## Steps

### 1. Determine the target

Ask the user:
- Which file? `AGENTS.md` (cross-tool standard) or `CLAUDE.md` (Claude Code-specific)
- Create or maintain?

### 2. [Create] Interview for context

Ask these. Skip what's obvious from the codebase.

- Project one-liner
- Languages, frameworks, runtime, package manager
- Build / test / lint / type-check / dev commands — exact invocations with flags
- Test framework, naming convention, coverage targets
- Key directories and what lives where
- Git workflow — branch prefix, commit format, merge strategy
- Boundaries — files/dirs the agent must never touch
- Non-obvious constraints — "use bun not npm", port numbers, env var requirements

For CLAUDE.md: does the user want any Claude Code subagents defined? (test-agent, docs-agent, etc.)

### 3. [Create] Generate

Select the right template from [references/](references/). Populate every section with the interview answers.

Rules:
- Commands first — before any prose
- Include Definition of Done (verifiable exit codes)
- Include escalation rules (when blocked, what to never do)
- Three-tier boundaries — always / ask first / never
- Under 150 lines. Link deep knowledge into `docs/`, don't embed it.
- Exact commands over descriptions.

Write to project root.

**Criterion:** Every template section populated. Under 150 lines.

### 4. [Maintain] Audit

Read the existing file. Check each section against the template:

- Commands — still correct? Outdated flags?
- Project structure — still accurate?
- Code style — still current?
- Testing — framework still the same?
- Git workflow — still accurate?
- Boundaries — any new no-go zones?
- Definition of Done — present? Correct exit codes?
- Escalation rules — present?

Flag drift. Ask user about unclear items.

### 5. [Maintain] Update

Apply the template's structure. Preserve accurate custom content. Remove stale sections. Update changed items.

**Criterion:** Every section matches current project reality. User confirms accuracy.
