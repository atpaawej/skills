# Skills Repo

Personal collection of agent skills organized into bucket folders under `skills/`:

- **Promoted buckets**: `engineering/` (code and delivery workflows) and `productivity/` (non-code thinking, communication, and authoring workflows).
- **Non-promoted buckets**: `in-progress/` (active drafts), `misc/` (rarely used), and `deprecated/` (retired).

## Maintenance rules

- **README sync**: Keep the top-level `README.md` and each bucket `README.md` synced when adding, renaming, moving, or removing a skill. Link every skill name to its `SKILL.md`. Group promoted bucket lists and the top-level `README.md` into **User-invoked** and **Model-invoked**; keep non-promoted bucket `README.md`s as flat lists.
- **Invocation & Codex metadata**: Every skill carries `agents/openai.yaml` beside `SKILL.md`, and cross-skill dependencies call the Skill tool by name. Read [`.agents/invocation.md`](./.agents/invocation.md) when setting invocation mode, writing `agents/openai.yaml`, or linking skills together.
- **Skill authoring**: Call the Skill tool with `"writing-for-agents"` before creating or editing any `SKILL.md`.
- **Fresh-context subagents**: Every skill that dispatches a subagent must state explicitly to start it with a fresh context window, preventing harness forks from inheriting parent context.
- **Local linking**: Run `scripts/link-skills.sh` after adding, moving, renaming, or removing any skill outside `misc/` and `deprecated/` to refresh symlinks in `~/.agents/skills` and `~/.claude/skills`.

## Agent skills

### Issue tracker

GitHub Issues in `atpaawej/skills` via `gh`. See `docs/agents/issue-tracker.md`.

### Triage labels

Canonical names, unchanged (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context (`GLOSSARY.md` and `docs/adr/` at repo root). See `docs/agents/domain.md`.
