# atpaawej/skills

This repo contains agent skills for Claude Code and other coding agents.

## Layout

Skills are organized into bucket folders under `skills/`:

- `engineering/` — code design, standards, architecture
- `project/` — project setup and onboarding

## Adding or updating a skill

### 1. Make your changes

Edit the relevant `SKILL.md` and any reference files.

### 2. Create a changeset

After making changes, you MUST create a changeset file. Ask the user:

> "What kind of change is this? (patch / minor / major)"

| Bump | When |
|---|---|
| **patch** | Bug fixes, tweaks, wording improvements — no new behaviour |
| **minor** | New skill, new feature in an existing skill, new reference file |
| **major** | Breaking change — skill rename, removed skill, changed invocation model |

Then write a `.md` file in `.changeset/` with the following format:

```markdown
---
"atpaawej-skills": <patch|minor|major>
---

<one or more lines describing the change>
```

Name the file `<descriptive-kebab-name>.md`.

### 3. Commit

Commit both the code change and the changeset file together. Do NOT run `npm run version` or bump the version yourself — that happens during release.

## Releasing

Run `npm run version` to consume all pending changesets, bump the version, and generate `CHANGELOG.md`. Then commit and tag.
