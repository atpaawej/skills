# Skills Repo Glossary

Canonical terms for this repository. Skills like `to-spec`, `to-tickets`, `triage`, and `domain-modeling` use this vocabulary.

## Language

**Bucket**:
A top-level category folder under `skills/`: `engineering/`, `productivity/`, `in-progress/`, `misc/`, or `deprecated/`.
_Avoid_: category, folder group, namespace

**Promoted bucket**:
Either `engineering/` or `productivity/`. Promoted skills are listed in the top-level `README.md` and linked locally by `scripts/link-skills.sh`.

**Skill**:
A folder containing a `SKILL.md` (plus `agents/openai.yaml` and optional `references/`, `assets/`, `scripts/`).

**Model-invoked**:
A skill reachable by both the model (via its `description`) and the human. Default mode: omits `disable-model-invocation` and `policy.allow_implicit_invocation`.

**User-invoked**:
A skill reachable only when the human explicitly invokes it (`disable-model-invocation: true` in `SKILL.md` and `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

**Issue tracker**:
GitHub Issues for `atpaawej/skills`, accessed via `gh`. See `docs/agents/issue-tracker.md`.
_Avoid_: backlog manager, backlog backend, issue host

**Triage role**:
One of the five canonical state-machine labels applied to an issue (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). Mapped in `docs/agents/triage-labels.md`.

## Relationships

- A **Bucket** holds many **Skills**
- Every **Skill** is either **Model-invoked** or **User-invoked**
- An **Issue tracker** holds issues tagged with one **Triage role** at a time
