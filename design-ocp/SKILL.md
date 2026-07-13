---
name: design-ocp
description: Map the closed zones and open slots of a codebase for OCP / plugin architecture. Use when adding features without changing existing code comes up.
disable-model-invocation: true
---

Design the **closed core**, map the **open slots**. You design the interfaces; the agent writes the plugins.

Bold terms defined in [GLOSSARY.md](references/GLOSSARY.md).

## Entry

- **No `OCP-MAP.md`** — greenfield. Proceed to step 1.
- **`OCP-MAP.md` exists** — Stop. The map is already set up. Read it and follow existing extension points. No mapping needed.
- **Retrofitting a messy codebase** — That's a different job (`/improve-ocp`, once written). For now, adapt the greenfield flow.

## Steps

### 1. Map the closed core

Name the zones new features must never touch.

Ask: what domain entities, business rules, and framework code must stay frozen? What would break if an agent edited it?

For each zone, name it and anchor it to a directory.

**Criterion:** Every closed zone named, directory-anchored, user-confirmed.

### 2. Map the open slots

Identify the **extension categories** — axes where new features will arrive. Payment providers? Export formats? Notification channels?

For each category:
- Name it
- Sketch the **extension point** interface — minimum viable method set
- Choose the **registration** mechanism — convention, registry function, config file, or DI binding

State the **dependency rule** and confirm:

> Closed core must never import extension code. Extensions import closed-core interfaces only. Extensions may not import other categories.

**Criterion:** Every category named, interface sketched, registration chosen. User has explicitly acknowledged the dependency rule.

### 3. Write OCP-MAP.md

Populate the [template](references/ocp-map-template.md) → project root as `OCP-MAP.md`.

Show user. Iterate until "ship it."

**Audit:** After the map is finalized, check **change density** — would a typical new feature touch exactly 1 file (the new plugin)? Higher density means a missed extension point. Surface this to the user before approving.

**Criterion:** User-approved, no placeholder text.

### 4. Write the agent contract

Propose a section for `CLAUDE.md` / `AGENTS.md`:

```
## OCP contract

Never modify: src/core/ — closed zone
New features: find the extension point in OCP-MAP.md, implement, register. New files only.
Escalation: If a closed-zone change is unavoidable, stop and ask.
```

**Criterion:** User-approved, written to file.
