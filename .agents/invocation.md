# Model-invoked vs user-invoked

Every `SKILL.md` in this repo is a skill. The axis that splits them is **invocation**, who can reach it:

- **User-invoked**: reachable **only by the human typing its name**. Set `disable-model-invocation: true` in the frontmatter (Claude Code) and `policy.allow_implicit_invocation: false` in `agents/openai.yaml` (Codex). The `description` is **human-facing**: a one-line summary read by a person browsing slash-commands, with trigger lists stripped.
- **Model-invoked**: reachable by **model or user**. The default: omit `disable-model-invocation` and the `policy` block from `agents/openai.yaml`. The `description` is **model-facing** and keeps rich trigger phrasing ("Use when the user wants…, mentions…, asks for…") so auto-invocation fires. The test for whether a skill should stay model-invoked: _could the model usefully reach for this autonomously?_

Each harness excludes a user-invoked skill from the model's reach in its own way, so nothing but the human can fire it: no other skill can. A user-invoked skill may invoke model-invoked skills, but it can never reach another user-invoked skill.

Every skill also carries an `agents/openai.yaml` beside its `SKILL.md`. It holds Codex UI metadata: `interface.display_name` and `interface.short_description` for the skill picker, and, for user-invoked skills, the `policy.allow_implicit_invocation: false` that pairs with `disable-model-invocation`. Keep the two in sync: a skill is user-invoked in both harnesses or neither.

Bucket `README.md`s and the top-level `README.md` group entries into **User-invoked** and **Model-invoked**.

## Dependencies between them

Express operative dependencies as an explicit instruction to **call the Skill tool** with the named skill (`Call the Skill tool with "grilling"`), rather than deep `../other-skill/FILE.md` cross-references or a bare `/skill` mention. Naming the tool and dropping the leading `/` keeps dependencies harness-neutral. Shared reference docs live inside the skill that owns them; other skills reach that material by calling the Skill tool with it, not by linking across folders.

The Skill tool takes one skill per call. A step that needs two skills must specify two calls (`Call the Skill tool twice, for "grilling" and "domain-modeling"`).

This convention holds only when the named skill is **model-invoked**. When a step's precondition is a **user-invoked** skill (such as `setup-matt-pocock-skills`), instruct the human to run it (`/setup-matt-pocock-skills`) rather than calling the Skill tool.

## Passive vs active domain work

Merely _reading_ `GLOSSARY.md` for vocabulary is a one-line prose pointer, not the `domain-modeling` skill. Only the active build/sharpen discipline (challenge terms, edge-case scenarios, write ADRs, update `GLOSSARY.md` inline) is `domain-modeling`.
