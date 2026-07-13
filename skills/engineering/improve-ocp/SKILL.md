---
name: improve-ocp
description: Scan a codebase for OCP violations and produce an actionable IMPROVE-OCP.md grouped by target structure. Use when codebase is tightly coupled, agents keep breaking things, or after running /design-ocp on an existing project.
disable-model-invocation: true
---

Scan for **extract** opportunities — signals that the codebase has no OCP discipline — and design the target closed core + extension points. Ends with a machine-readable `IMPROVE-OCP.md` you approve and hand to an agent to implement.

If the codebase is greenfield or already well-designed, use `/design-ocp` instead.

Bold terms defined in [GLOSSARY.md](references/GLOSSARY.md).

## Steps

### 1. Extract — find the signals

Walk the codebase. Look for all 7 signals. Use the Agent tool with `subagent_type=Explore` for the broad sweep, then read specific files to confirm.

| # | Signal | What to check |
|---|---|---|
| 1 | Direct `new` of a dependency | Classes constructing their own dependencies instead of accepting them via interface. `new StripeGateway()` inside a payment service. |
| 2 | Cross-category import | A module in one domain importing from another domain's implementation files. `src/payments/stripe.ts` importing `src/notifications/email.ts`. |
| 3 | Implementation imports | Importing concrete files rather than their interfaces. `import { StripeGateway } from './gateways/stripe'` instead of `import { PaymentGateway } from './interfaces'`. |
| 4 | No interfaces at module boundaries | Functions accepting primitives or leaking implementation types. `processOrder(userId: number, rawInput: object)` instead of `processOrder(user: User, command: PlaceOrderCommand)`. |
| 5 | Shotgun surgery evidence | A `git log` check — do most feature changes touch the same handful of files? (bonus — only if git history available) |
| 6 | Feature code mixed with core code | Domain or framework directories containing feature-specific logic. `src/core/pricing.ts` has Stripe-specific discount code. |
| 7 | No registry / plugin loader | The app has no concept of "register your plugin here" anywhere in the codebase. |

Do NOT ask the user during this step. Just sweep and collect.

**Criterion:** Every directory with source code has been checked. All findings collected in a structured list. No obvious OCP signal missed.

### 2. Design — propose the target

From the violations cluster, design the target OCP map.

**For each closed zone you propose:**
- [ ] Name it and anchor it to a directory

**For each extension category you propose, you must complete ALL three sub-items before presenting:**
- [ ] **Sketch the interface** — minimum viable method set the plugin must implement. Write it as a concrete signature the agent can use to scaffold later.
- [ ] **Choose the registration mechanism** — convention, registry function, config file, or DI binding
- [ ] **State the dependency rule** — "closed core never imports extension code; extensions import core interfaces only"

Do NOT skip any of these three. If you aren't sure about a mechanism, pick the simplest option and flag it to the user.

**Then present to the user for confirmation:**

> "Here's what the signals tell me. I see these closed zones and extension categories forming. Does this match your understanding of the codebase? Any adjustments?"

Let the user adjust before writing.

**Criterion:** Every closed zone named and anchored. Every extension category has an interface sketch, a registration mechanism, and a dependency rule stated. User has confirmed or adjusted the target.

### 3. Write — produce IMPROVE-OCP.md

Populate the [template](references/improve-ocp-template.md) → project root as `IMPROVE-OCP.md`.

Structure:
- **Target OCP map** — the closed zones and extension points from step 2
- **Violations grouped under target** — each violation listed under the zone/category it affects, with severity (high/medium/low) and suggested fix
- **Migration order** — what to fix first, second, third

**Criterion:** File written. User can read it and understand the target structure and what needs to change.
