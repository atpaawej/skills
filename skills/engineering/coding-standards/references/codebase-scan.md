# Codebase scan

Checklist for exploring a codebase to infer its coding conventions. Use the Agent tool with `subagent_type=Explore` for each category. Report findings factually — don't interpret or judge.

## 1. Root config files

Look for files that encode conventions mechanically. These are the single source of truth for what the tooling enforces.

- `.editorconfig`
- `.prettierrc` / `.prettierrc.*` / `prettier.config.*`
- `.eslintrc*` / `eslint.config.*`
- `tsconfig.json` — strictness flags
- `go.mod`, `Cargo.toml`, `Gemfile`, `pyproject.toml`, `build.gradle*`, `Package.swift`
- `.golangci.yml`, `rustfmt.toml`, `ruff.toml`
- `.gitignore`, `.gitattributes`

For each config found: note the key non-default settings and the ecosystem they belong to.

## 2. File naming

Walk the source tree, top levels first. For each directory:

- What naming convention do files use? (kebab-case, snake_case, PascalCase, camelCase)
- Are there any naming conventions per file type? (e.g. `.test.ts` vs `.spec.ts`, `.component.tsx`)
- Any exceptions or inconsistencies?
- Note 3-5 concrete examples.

## 3. Source layout & imports

- Where does source code live? (`src/`, `lib/`, root?)
- Where are tests? (co-located, `__tests__/`, `tests/`?)
- Are imports absolute or relative? Grouped? (external vs internal)
- Any barrel files (`index.ts`)? Any path aliases?
- How are modules organized? (by feature? by file type? by layer?)

## 4. Code style

Read 5-10 representative source files across different areas:

- Indentation: spaces or tabs? How many?
- Semicolons: used or not?
- Quotes: single or double?
- Trailing commas: used?
- Bracket placement: same line or new line?
- Any notable patterns (early returns, guards, destructuring prevalence)

## 5. Naming in code

From the same files:

- Variables: camelCase, snake_case?
- Functions: camelCase, snake_case?
- Classes / constructors: PascalCase?
- Types / interfaces: PascalCase? `T` prefix? `I` prefix?
- Constants: UPPER_CASE or camelCase?
- Private members: underscore prefix or plain?

## 6. Error handling patterns

- Try/catch blocks: used everywhere, or sparingly?
- Error types: custom classes? Error codes? Result types? (Go-style `(val, err)` or Rust `Result`)
- Logging: structured (JSON) or plain? Which library?
- How are edge cases handled? Null checks, optionals, guard clauses?

## 7. Testing patterns

- Test framework: Vitest? Jest? pytest? Go testing? cargo test?
- Test file naming: `*.test.ts`, `*.spec.ts`, `*_test.go`?
- Coverage: is there a coverage config? A badge in README?
- Test style: describe/it blocks? function-based? Table-driven?

## 8. Documentation

- JSDoc/TSDoc comments on exported functions?
- README per module/directory?
- Any existing `CONTRIBUTING.md`, `ARCHITECTURE.md`, ADRs?
- Inline comments: sparse, moderate, exhaustive?

## 9. Existing standards

Scan README, CONTRIBUTING, any existing docs for mentions of:

- Coding conventions
- Preferred tools
- Commit message format
- PR/Review expectations

## Output

Synthesize into a structured report, grouped by template section. For each finding: state what was observed, and note whether it's consistent across the codebase or isolated. Example:

> **Naming — files:** kebab-case (consistent across 40+ files). 2 legacy files in snake_case remain.
> **Naming — variables:** camelCase (consistent).
> **Error handling:** try/catch in controller layer, error-returning types in domain layer. No custom error classes.
