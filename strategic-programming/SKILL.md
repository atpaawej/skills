---
name: strategic-programming
description: Applies strategic design discipline before writing code. Trigger when the user discusses architecture, module design, code structure, or before implementing a non-trivial feature. Trigger on phrases like "how should I structure", "plan the design", "think about architecture", "design quality", "deep modules", "information hiding." Also triggers during code review when structural problems surface.
---

Bold terms are defined in [GLOSSARY.md](GLOSSARY.md).

## Context

Three entry points, each with a different path through the steps:

- **New design** — full process
- **Refactor** — skip step 1 (existing modules are the seams). Run steps 2-5 against the refactored design.
- **Bug fix** — skip to step 3. If the fix touches multiple modules, the seam is wrong — redesign, then step 5.

## Steps

### 1. Map the seams

Identify what's likely to change. Each likely-to-change decision gets its own **seam** — a module boundary the rest of the system must not cross.

**Criterion:** Every likely change is assigned to exactly one module. You can name what each seam hides.

### 2. Design for depth

Write the public API first, before any implementation. **Depth** is measured by what callers *don't* need to know.

**Criterion:** The API is minimal and complete. Removing any method breaks a real caller. Adding any method would not simplify callers.

### 3. Trace the change

Pick one realistic requirement change. Trace it through the design. Count files touched.

**Criterion:** One change touches exactly one file. If it touches more, the seam is in the wrong place — redesign, don't proceed.

### 4. Verify test signal

Describe the unit test for each module. Hard to describe = interface is wrong.

**Criterion:** Every module has a describable test. Complex test plan means redesign the interface, not write a complex test.

### 5. Match conventions

Audit the codebase. The design must use existing patterns. Any deviation earns its place with a documented reason.

**Criterion:** No new pattern without justification. Every justification refers to a concrete shortcoming of the existing approach.
