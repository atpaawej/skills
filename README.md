# Skills

Agent skills for Claude Code and other coding agents. Small, focused, composable — designed to make agents predictably good at specific tasks.

## Quickstart

```bash
npx skills@latest add atpaawej/skills
```

Pick the skills you want. Run `/agent-md` or `/strategic-programming` in your agent. Done.

Or install individually:

```bash
npx skills@latest add atpaawej/skills/agent-md
npx skills@latest add atpaawej/skills/strategic-programming
```

## Why These Skills Exist

### #1: The Agent Doesn't Know How To Navigate Your Project

> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand."
>
> Martin Fowler

**The Problem**: Every time you start a session with an agent, it knows nothing about your project — what commands to run, where things live, what conventions to follow. So it guesses. It uses the wrong test runner, touches files it shouldn't, and produces code that doesn't fit.

**The Fix** is [`/agent-md`](agent-md/). It creates or maintains an `AGENTS.md` / `CLAUDE.md` file that tells the agent exactly how your project works — commands first, then structure, conventions, boundaries, and verifiable definitions of done. One interview, and every future session starts with the right context.

### #2: The Codebase Turns Into A Ball Of Mud

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**The Problem**: Agents accelerate software entropy. They write code fast, and without design discipline, the codebase becomes complex and hard to change at an unprecedented rate.

**The Fix** is [`/strategic-programming`](strategic-programming/). It applies a structured design process before any code is written — map the seams, design for depth, trace the change, verify test signal, match conventions. The change stays local, the interface stays small, and the codebase stays navigable.

## Reference

Skills are **user-invoked** — you type `/skill-name` to run them.

| Skill | Description |
|---|---|
| [`agent-md`](agent-md/) | Create or update AGENTS.md / CLAUDE.md for any project. Interviews for context, generates the canonical template, or audits and updates an existing file when the project evolves. |
| [`strategic-programming`](strategic-programming/) | Applies strategic design discipline before writing code — deep modules, information hiding, change boundaries. Use during architecture, planning, and code review. |
