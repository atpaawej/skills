# Principle Catalog

Seven domains of software design principles, tagged by criticality. Used by the `/coding-standards` skill to recommend a baseline for any project.

**Tags:**
- 🔴 **MUST** — non-negotiable for a healthy codebase
- 🟡 **SHOULD** — strongly recommended, may vary by context
- 🟢 **OPTIONAL** — depends on team or project maturity

---

## 1. Architecture & Boundaries

### 🔴 OCP — Open-Closed Principle
**Core:** Software entities should be open for extension, closed for modification.
**Why it matters for agents:** The most important principle for agent safety. Adding a new case via `else if` in existing code risks breaking the existing branches. Code structured for OCP (strategy pattern, plugin registry, dispatch table) lets an agent add behaviour by creating a new file — never touching the original. Drastically reduces blast radius.
**Also known as:** "Add code, don't edit code."

### 🟡 Layered Architecture (Clean / Hexagonal / Onion)
**Core:** Dependencies point inward. Business logic at the centre; infrastructure, frameworks, and I/O at the edges.
**Why it matters for agents:** Gives agents a reliable navigation heuristic — changing an adapter file can't affect the domain core. This boundary discipline prevents agent-generated spaghetti.
**Watch for:** Over-engineering for small projects. CLI tools and simple services may not benefit.

### 🟡 Deep Modules
**Core:** A module's interface should be simple relative to the complexity it hides. (John Ousterhout)
**Why it matters for agents:** LLMs have finite context. A module with a simple interface (`read(fd, buf, count)`) lets the agent use it correctly without understanding the internals. Shallow modules (complex interface, little functionality) waste the agent's context budget.

### 🟡 DIP — Dependency Inversion Principle
**Core:** Depend on abstractions, not concretions. High-level modules should not depend on low-level modules.
**Why it matters for agents:** Foundation of substitutability. When an agent needs to swap an adapter (e.g., email → SMS), DIP means writing one new file and plugging it in — no cascading changes.

### 🟡 Small Blast Radius
**Core:** A change should touch as few files as possible — ideally one.
**Why it matters for agents:** Every file an agent modifies is an opportunity for a mistake. Design so that a single behavioural change maps to a small, predictable set of files.

---

## 2. Code Structure & Design

### 🔴 SRP — Single Responsibility Principle
**Core:** One reason to change per module/class/function.
**Why it matters for agents:** Agents reason best about small, cohesive units. An SRP-violating class that handles persistence, formatting, and validation forces the agent to hold too much context.

### 🟡 Composition over Inheritance
**Core:** Prefer "has-a" over "is-a". Build behaviour by composing small parts.
**Why it matters for agents:** Deep inheritance hierarchies force agents to hold the full chain in context to understand a class. Composition produces standalone units the agent can grasp independently.

### 🟢 Tell, Don't Ask
**Core:** Tell an object what to do; don't ask for its data and act on it externally.
**Why it matters for agents:** Agents default to procedural "get→transform→set" patterns. Telling (instead of asking) produces more encapsulated designs and reduces the number of files the agent needs to touch.

### 🟢 Law of Demeter
**Core:** Don't talk to strangers. Use only one dot.
**Why it matters for agents:** Chained property access (`a.b.c.d()`) is brittle and creates hidden dependencies — exactly the kind of coupling that causes cascading agent mistakes.

---

## 3. Contracts & Predictability

### 🔴 CQS — Command-Query Separation
**Core:** A method is either a command (void, mutates state) or a query (returns data, no side effects). Never both.
**Why it matters for agents:** Agents rely on signatures and naming — they can't read every method body. A query named `getTotal()` that also flushes the cache will cause downstream bugs. CQS makes signatures trustworthy.

### 🔴 Explicit Contracts
**Core:** Every public API's preconditions, postconditions, and invariants should be enforceable — at the type level, by assertion, or clearly documented.
**Why it matters for agents:** Implicit contracts ("call init() before using this", "the second param must be non-negative") are lethal for agents. Agents can't read every implementation. Explicit contracts prevent silent failures.

### 🟢 POLA — Principle of Least Astonishment
**Core:** Code should behave how it looks like it behaves. Minimise surprise.
**Why it matters for agents:** An agent sees `deleteFile()` and infers it removes the file. If it also writes to the audit log, the agent's mental model is wrong. Consistent, unsurprising APIs are more important when the consumer is an LLM.

---

## 4. Error Handling & Robustness

### 🔴 Fail Fast
**Core:** Detect and report errors at the earliest possible moment. Do not silently swallow, return null, or continue in an invalid state.
**Why it matters for agents:** Agents default to weak error handling — empty catch blocks, silent null returns. A codebase that fails fast gives the agent immediate feedback when it generates something wrong, enabling faster self-correction.

### 🟢 ISP — Interface Segregation Principle
**Core:** No client should depend on methods it doesn't use. Split fat interfaces into role-specific ones.
**Why it matters for agents:** A fat `PaymentProcessor` with 12 methods forces an agent to implement stubs for methods it doesn't need. Small role interfaces (`Refundable`, `Capturable`) let the agent implement only what the task requires.

---

## 5. Discipline & Scope

### 🟡 DRY — Don't Repeat Yourself
**Core:** Every piece of knowledge has a single, authoritative representation in the system. (Applies to *knowledge*, not coincidental similarity.)
**Why it matters for agents:** Agents are prolific generators of repetitive code — they'll produce the same enum, validation, or error handler across N files without noticing. DRY structure counters this.
**Watch for:** Apply the Rule of Three — wait for the third occurrence before abstracting. Agents prematurely abstracting incidental similarity creates tangled abstractions.

### 🟡 YAGNI — You Ain't Gonna Need It
**Core:** Do not add functionality until it is genuinely needed.
**Why it matters for agents:** Agents love gold-plating — extra features, abstraction layers, or configuration options no one asked for. YAGNI counteracts this tendency. Premature abstraction created by an agent is especially harmful because it adds indirection without a human's nuanced understanding of where the code is heading.

### 🟢 Single Source of Truth (Configuration)
**Core:** Configuration values, enum definitions, and constants exist in exactly one place, referenced everywhere else.
**Why it matters for agents:** Agents often duplicate magic strings or redeclare configuration. Centralising configuration prevents drift.

---

## 6. Testing

### 🟡 Test Behaviour, Not Implementation
**Core:** Test what the code does, not how it does it. Tests should pass after refactoring if the external behaviour is unchanged.
**Why it matters for agents:** Agents need stable tests that don't break on internal restructuring. Behavioural tests give agents a reliable safety net.

### 🟡 Test at the Right Level
**Core:** Unit tests for logic, integration tests for boundaries, e2e for critical paths.
**Why it matters for agents:** Agents default to unit tests. Explicit level guidelines keep them from writing integration logic as unit tests (heavy mocking) or writing e2e tests for every simple function.

### 🟢 Deterministic Tests
**Core:** Tests should produce the same result every run. No shared state, no timing dependencies, no network calls.
**Why it matters for agents:** Non-deterministic tests undermine the safety net. Agents can't debug flaky tests — deterministic tests let agents trust their own feedback loop.

---

## 7. Agent-Specific

### 🟡 Context Locality
**Core:** Related code should live physically close together. When an agent reads a file, it should find everything relevant there — not scattered across one-liner shim files.
**Why it matters for agents:** Excessive indirection forces the agent to open more files, consuming context window and increasing the chance of missing a dependency.

### 🟡 Characterization Tests
**Core:** Tests that capture current behaviour without assuming correctness. Run before an agent modifies a module to confirm existing behaviour is preserved.
**Why it matters for agents:** The primary verification mechanism for agent changes. Before modifying code, the agent runs the characterisation tests. If they pass after the change, existing behaviour is preserved.

### 🟢 Navigability
**Core:** The codebase should be easy to navigate by convention — consistent file naming, directory structure, module boundaries.
**Why it matters for agents:** Lets the agent predict where code lives without searching, reducing the files it needs to Read before making changes.
