# atpaawej/skills

Agent skills for Claude Code and other coding agents. Small, focused, composable.

## Commands

- Install deps: `npm install`
- Create changeset: write a `.md` file in `.changeset/` (see workflow below)
- Version release: `npm run version`

No build, test, lint, or type-check commands — this is a pure markdown repo.

## Project Structure

- `skills/engineering/` — code design, standards, architecture skills (coding-standards, strategic-programming, design-ocp, improve-ocp)
- `skills/project/` — project setup skills (agent-md)
- `.changeset/` — versioning changeset files
- `CLAUDE.md` — this file
- `README.md` — skill index and install instructions

## Boundaries

- Never modify: `node_modules/`, `.changeset/README.md` (auto-generated), `package-lock.json` (auto-generated)
- Ask before: running `npm run version` (this is a manual release step), modifying `package.json` version field
- Always do: create a changeset `.md` file when adding or updating a skill

## Release Workflow

### Adding or updating a skill

1. Make your code changes (edit `SKILL.md` or reference files)
2. Create a changeset file in `.changeset/<descriptive-name>.md`:

   Ask the user: "What kind of change is this? (patch / minor / major)"

   | Bump | When |
   |---|---|
   | **patch** | Bug fixes, tweaks, wording improvements — no new behaviour |
   | **minor** | New skill, new feature in an existing skill, new reference file |
   | **major** | Breaking change — skill rename, removed skill, changed invocation model |

   Format:
   ```markdown
   ---
   "atpaawej-skills": <patch|minor|major>
   ---

   <description of changes>
   ```
3. Commit both the code change and the changeset file together
4. Do NOT run `npm run version` yourself — that happens during release

### Releasing

Run `npm run version` to consume all pending changesets, bump the version, and generate `CHANGELOG.md`. Then commit and tag.

## Definition of Done

All of these pass:
1. Changeset `.md` file created with correct bump type and description
2. Both skill changes and changeset committed together
3. `node_modules/` not committed

## Escalation Rules

- If unsure about the bump type (patch/minor/major): ask the user
- `npm run version` errors: check `.changeset/` for malformed markdown files
- Never: modify `package-lock.json` by hand, run `npm run version` without user approval
