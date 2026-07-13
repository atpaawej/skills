---
name: design-ocp
description: Design an OCP-compliant codebase — closed core, extension points, dependency rules, agent contract. Use when designing a new project's architecture, defining where new features should plug in, or planning how to keep the codebase closed-for-modification. Trigger on phrases like "add new features without changing existing code", "plugin architecture", "extension points", "closed for modification", "OCP", "feature as plugin".
---

Design the codebase so every new feature means a **new file**, never an edit to stable code. You are the architect; the agent is the syntax writer. As Matt Pocock says: *"Design the interface, delegate the implementation."*

This skill sits in the same family as `codebase-design` but in a different room:

| Skill | Room |
|---|---|
| `codebase-design` | **Depth** — how to make modules deep (interface-to-implementation ratio, seams, locality) |
| `design-ocp` | **Closedness** — how to make codebases closed-for-modification (core boundaries, extension points, dependency rule) |

Both are **model-invoked** — the agent reaches for them when the conversation reaches their room.

Bold terms are defined in the [Glossary](#glossary) below.

## Entry points

The agent checks what exists and picks the flow:

- **No `OCP-MAP.md` + no code (or early code)** → Greenfield flow. Proceed to step 1.
- **No `OCP-MAP.md` + existing codebase that works well** → Greenfield flow. Interview to establish the current boundaries, then map them.
- **User runs `/improve-ocp` on a messy codebase** → Not this skill. That's the retrofit companion. The agent should note: "That's the `/improve-ocp` skill — not `/design-ocp`. They're different tools."

## Process

### 1. Scope

Ask the user:

- What's the project? One-liner.
- Language, framework, runtime.
- What's the **core domain**? The business rules, entities, and stable logic that should never need to change.
- What features have been built or are planned? Build a sense of what varies.

Do NOT ask all at once — one conversationally. If you already know this context (e.g. user ran `/grill-me` first), skip straight to step 2.

**Criterion:** Project and core domain identified. User has named what's stable.

### 2. Identify the closed core

Grill the user to define what lives in the **closed core**:

- What are the domain entities and business rules that must be absolutely stable?
- What would break if an agent touched it?
- What never varies, no matter how many features are added?
- What must be compiled, tested, and frozen?

Mark each as a **closed zone** with a directory anchor and purpose.

**Criterion:** Every closed zone is named, rooted to a directory, and the user agrees it's never modified by new features.

### 3. Map extension categories

Identify the axes of variability — the **extension categories** where new features will arrive:

- Payment methods? Export formats? Notification channels? Authentication providers? Data sources? UI themes?
- What's the most likely source of new features in the next 6 months?
- Each category must be distinct — if two categories would produce the same interface shape, collapse them.

**Criterion:** Every extension category has a name, a one-line description, and the user has confirmed it describes a real axis of change.

### 4. Design extension points (interface sketches only)

For each extension category, design the **extension point** — the interface a **plugin** must satisfy:

```
PaymentProvider { charge(amount, currency): Result }
NotificationChannel { send(message): void }
ExportFormat { render(data): string }
```

Rules:
- Design the **minimum viable interface** — fewer methods is better. Ask: "Can a plugin implement this interface and do its job? Would removing any method break a real plugin?"
- Use the project's own types and domain language.
- Do NOT write implementation or tests — just the interface contract. The agent fills the slots.
- Mark any existing code that already implements this extension point as the first plugin.

**Criterion:** Every extension category has its interface sketched. User has confirmed each is minimal and complete.

### 5. Lock the dependency rule

State the single rule that preserves OCP, in one sentence:

> **Dependency rule:** The closed core must never import, reference, or know about any extension code. Extensions may import closed-core interfaces. Extensions may NOT import other extension categories.

Check with the user: "Does this rule match your architecture? Any exceptions?"

If the user names an exception, it becomes an **escalation rule** (see step 7's agent contract).
If the user is using a DI framework / plugin loader / module system, confirm it enforces this direction.

**Criterion:** User confirms the dependency rule. Any exceptions are recorded as escalation conditions.

### 6. Choose the registration mechanism

How does a new **plugin** get discovered by the **closed core**? One of:

- **Convention over config** — "put files in `extensions/payments/` and the framework loads them"
- **Registry function** — `registerPaymentProvider('stripe', stripePlugin)`
- **Config file** — `config/payments.ts` imports and exports registered providers
- **DI container binding** — declare the binding, container wires it

Pick the simplest option the language/framework supports. Grill only if there's ambiguity.

**Criterion:** Registration mechanism chosen and user has confirmed it's feasible.

### 7. Generate OCP-MAP.md

Write `OCP-MAP.md` at the project root using the template from [[references/ocp-map-template.md]]. Populate every section with the decisions from steps 2-6.

Present it to the user: "Here's what I drafted. What would you change?"

Iterate on feedback. Keep going until the user says "ship it" or "looks good."

**Criterion:** User has approved the document. Every section populated. No placeholder text.

### 8. Generate the agent contract section

Propose a section for `CLAUDE.md` (or `AGENTS.md`, whichever exists) that encodes the OCP rules for the syntax-writing agent:

```markdown
## Open-Closed Principle

This codebase is designed to be **closed for modification, open for extension**.

### Never modify files in:
- `src/core/` — domain entities, business rules (closed zone)
- `src/framework/` — bootstrap, plugin loader (closed zone)

### Adding new features:
1. Read `OCP-MAP.md` — find the right extension category
2. Implement the matching interface in `src/extensions/<category>/`
3. Register via `<registration mechanism>` (see OCP-MAP.md)
4. Never modify files in closed zones

### Escalation:
If a feature genuinely requires a closed-core change, stop and ask. 
Do not modify closed-core files without explicit human approval.
```

Ask the user: "Shall I add this to your CLAUDE.md / AGENTS.md?"

**Criterion:** User has approved the contract. Section written to the correct file. If neither `CLAUDE.md` nor `AGENTS.md` exists, ask the user which one to create.

## Glossary

**Closed core** — the set of modules declared stable. New features **never** modify them. Their interfaces are frozen by convention.

**Extension point** — a seam purpose-built for new code to attach. An interface, abstract class, hook, or callback that plugin code satisfies.

**Plugin** — code living outside the closed core that implements an extension point. Adding one never touches the core.

**Dependency rule** — dependencies point **inward**: plugins depend on extension points; the closed core never depends on plugins.

**Extension category** — a named axis of variability — "payment methods", "export formats", "notification channels". Each has its own extension point and family of plugins.

**Registration** — the act of making a plugin known to the core — registry, config file, DI binding, or naming convention.

**Change density** — number of files a single feature change touches. **Target: 1** (just the new plugin). Higher density = missing or wrong extension point.

### Relationship to codebase-design glossary

This glossary sits **above** the `codebase-design` vocabulary:

| This glossary | codebase-design term |
|---|---|
| Extension point | sits at a **seam** |
| Plugin | is an **adapter** satisfying an **interface** |
| Closed core | the set of modules whose **depth** we protect |
| Change density | **leverage** measured in reverse — how many callers (zero) change when a plugin lands |

## Sister skill: /improve-ocp

A separate **user-invoked** skill ([issue #1](https://github.com/atpaawej/skills/issues/1)). The flow:

1. User runs `/improve-ocp`
2. Skill scans existing codebase for OCP violations
3. Produces `IMPROVE-OCP.md` — actionable, machine-readable
4. User reviews, approves, says "implement this"
5. Agent executes from the file

Do NOT attempt to do `/improve-ocp`'s job inside `/design-ocp`. If the user asks about improving an existing codebase that's not OCP-compliant, point them to `/improve-ocp`.
