# Coding Standards

<!--
Required sections are always present.
Optional sections appear only when the user accepted them during the grill.

Structure:
- Top: 3-5 non-negotiable architecture decisions specific to this project
- Middle: Rule sections with ✅ GOOD / ❌ BAD example pairs (≤15 rules total)
- Bottom: Boundary system (Always / Ask / Never) + Verification self-check
-->

## Non-Negotiable Architecture Decisions

<!--
3-5 rules that anchor everything below. These are the project's core architectural
commitments — chosen from the principle catalog based on what fits this project.

Examples:
- We follow OCP — add behaviour by creating new files, never by adding branches to existing code
- We fail fast — validate at boundaries, never silently swallow errors
- CQS: commands return void, queries return data, never both
-->

## Naming Conventions

| Category | Convention | Examples |
|---|---|---|
| Files | | |
| Variables | | |
| Functions | | |
| Classes / Types | | |
| Constants | | |

✅ GOOD: <!-- example -->
❌ BAD: <!-- counterexample -->

## Code Style & Formatting

- **Formatter**:
- **Linter**:
- **Key rules**:
- **Line length**:

✅ GOOD: <!-- example -->
❌ BAD: <!-- counterexample -->

## Module Boundaries

<!-- Rules about how modules interact — NOT where they live. -->

- **One public API per module** — index.ts at the module root IS the public face. Everything else is an implementation detail.
- **No circular dependencies** between modules.
- **Package by domain, not by layer** — group by feature, not by file type.

✅ GOOD: <!-- example -->
❌ BAD: <!-- counterexample -->

## Error Handling

- **Approach**: <!-- exceptions, result types, explicit error returns — pick one -->
- **Never** catch and silently swallow. If you catch, you handle or re-throw.
- **Validate at boundaries** — function arguments, API inputs, file reads. Fail fast.

✅ GOOD: <!-- example -->
❌ BAD: <!-- counterexample -->

---

<!-- Below: optional sections. Include only when accepted during the grill. -->

## Testing Standards

- **Framework**:
- **Naming**:
- **Levels**: <!-- unit vs integration vs e2e — what goes where -->
- **Deterministic** — no shared state, no timing, no network in unit tests.

✅ GOOD: <!-- example -->
❌ BAD: <!-- counterexample -->

## Type Discipline

- **Strictness level**:
- **Any/unknown policy**:
- **Generics** — when to reach for them vs concrete types

✅ GOOD: <!-- example -->
❌ BAD: <!-- counterexample -->

## Documentation Requirements

- **What requires docs**: <!-- every public API, complex modules, architecture decisions -->
- **Format**: <!-- JSDoc, TSDoc, godoc, etc. -->

✅ GOOD: <!-- example -->
❌ BAD: <!-- counterexample -->

## Git & Commit Conventions

- **Commit format**:
- **Branch naming**:
- **PR conventions**:

## Performance & Security Constraints

<!-- Only when the project has specific non-functional requirements. -->

- **Performance budgets**:
- **Security rules**:
- **Observability**:

---

## Boundary System

| Always Do | Ask First | Never Do |
|---|---|---|
| <!-- pattern 1 --> | <!-- pattern 1 --> | <!-- pattern 1 --> |
| <!-- pattern 2 --> | <!-- pattern 2 --> | <!-- pattern 2 --> |

## Verification

Before marking a PR ready, run:

```bash
<!-- the project's check command(s): lint, typecheck, test -->
```

If the above command fails, investigate and fix before requesting review.
