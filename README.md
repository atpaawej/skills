# Skills

Agent skills for Claude Code and other coding agents. Small, focused, composable — designed to make agents predictably good at specific tasks.

## Quickstart

```bash
npx skills@latest add atpaawej/skills
```

Pick the skills you want. Run `/agent-md` or `/coding-standards` in your agent. Done.

Or install individually:

```bash
npx skills@latest add atpaawej/skills/skills/project/agent-md
npx skills@latest add atpaawej/skills/skills/engineering/strategic-programming
npx skills@latest add atpaawej/skills/skills/engineering/coding-standards
npx skills@latest add atpaawej/skills/skills/engineering/design-ocp
npx skills@latest add atpaawej/skills/skills/engineering/improve-ocp
```

## Skills

User-invoked — type `/skill-name` to run them.

### `engineering/` — code design, standards, architecture

| Skill | What it does |
|---|---|
| [`coding-standards`](skills/engineering/coding-standards/) | Creates `CODING_STANDARDS.md` for any project. Assesses the project, recommends a curated baseline of essential principles (MUST/SHOULD/OPTIONAL), then grills you to customize. Timeless — rules only, no file paths, nothing that drifts. |
| [`strategic-programming`](skills/engineering/strategic-programming/) | Applies strategic design discipline before writing code — deep modules, information hiding, clean seams. Use during architecture, planning, and code review. |
| [`design-ocp`](skills/engineering/design-ocp/) | Design a codebase that's **closed for modification, open for extension**. Defines the closed core, extension points, dependency rules, and agent contract so every new feature is a new file — never an edit to stable code. |
| [`improve-ocp`](skills/engineering/improve-ocp/) | **Retrofit** an existing messy codebase toward OCP. Scans for 7 violation signals, proposes a target OCP map, and produces an actionable `IMPROVE-OCP.md` you approve and hand to an agent. |

### `project/` — project setup

| Skill | What it does |
|---|---|
| [`agent-md`](skills/project/agent-md/) | Create or update `AGENTS.md` / `CLAUDE.md` for any project. Interviews for context, generates the canonical template, or audits and updates when the project evolves. |

## Why These Skills Exist

### #1: The Agent Doesn't Know How To Navigate Your Project

> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand."
>
> Martin Fowler

**The Problem**: Every time you start a session with an agent, it knows nothing about your project — what commands to run, where things live, what conventions to follow. So it guesses. It uses the wrong test runner, touches files it shouldn't, and produces code that doesn't fit.

**The Fix** is [`/agent-md`](skills/project/agent-md/). It creates or maintains an `AGENTS.md` / `CLAUDE.md` file that tells the agent exactly how your project works — commands first, then structure, conventions, boundaries, and verifiable definitions of done. One interview, and every future session starts with the right context.

### #2: The Codebase Has No Consistent Standards

> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand."
>
> Martin Fowler

**The Problem**: Without documented conventions, every developer (and every agent) writes code a slightly different way. Files drift from one style to another. Code reviews fill up with formatting nits. New joiners — human or AI — have no compass for "how we do things here."

**The Fix** is [`/coding-standards`](skills/engineering/coding-standards/). It creates a `CODING_STANDARDS.md` that tells everyone what's expected — naming, style, module boundaries, error handling, testing philosophy. The agent recommends a baseline from a curated principle catalog, classifies them by importance, and grills you to customize. The result is timeless — rules only, no file paths, nothing that goes stale.

### #3: The Codebase Turns Into A Ball Of Mud

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**The Problem**: Agents accelerate software entropy. They write code fast, and without design discipline, the codebase becomes complex and hard to change at an unprecedented rate.

**The Fix** is [`/strategic-programming`](skills/engineering/strategic-programming/). It applies a structured design process before any code is written — map the seams, design for depth, trace the change, verify test signal, match conventions. The change stays local, the interface stays small, and the codebase stays navigable.

### #4: The Agent Keeps Breaking Working Code

> *"You should be able to extend the behavior of a system **without having to modify that system**."*
>
> Robert C. Martin (Uncle Bob), [The Open-Closed Principle](http://blog.cleancoder.com/uncle-bob/2014/05/12/TheOpenClosedPrinciple.html)

**The Problem**: Agents don't know what they shouldn't touch. You ask for a new feature, the agent finds existing code that's *close* to what you want, edits it — and breaks tested, working functionality. Every new feature becomes a game of whack-a-mole.

**The Fix** is the OCP skill pair:

1. [`/design-ocp`](skills/engineering/design-ocp/) — greenfield. Produces `OCP-MAP.md` + agent contract for `CLAUDE.md`.
2. [`/improve-ocp`](skills/engineering/improve-ocp/) — retrofit. Scans existing codebases for OCP violations, produces `IMPROVE-OCP.md` you approve and hand to an agent.

*You are the architect. The agent is the syntax writer. Design the interface, delegate the implementation.*

## Design Principles

- **Self-contained.** Each skill owns its logic. No external dependencies, no runtime, no package install.
- **Composable.** Skills can be installed individually or as a set. Use what fits, skip the rest.
- **Predictable.** Every step has a completion criterion. The agent takes the same process every run.
- **Progressive disclosure.** The `SKILL.md` is lean. Reference material lives in linked files, loaded only when needed.
- **Right-invoked.** User-invoked skills fire when you type them. Model-invoked skills (like `coding-standards`) fire autonomously when the agent detects the need — zero cognitive load for you.

## License

MIT
