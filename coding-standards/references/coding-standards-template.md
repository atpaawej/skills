# Coding Standards

<!--
Required sections are always present.
Optional sections appear only when the skill produced content for them.
-->

## 1. Purpose & Scope

<!-- What this project is, what these standards cover, who follows them. -->

## 2. Naming Conventions

| Category | Convention | Examples |
|---|---|---|
| Files | <!-- e.g. kebab-case, snake_case, PascalCase --> | |
| Variables | | |
| Functions | | |
| Classes / Types | | |
| Constants | | |
| Git branches | | |

## 3. Code Style & Formatting

- **Formatter**: <!-- e.g. Prettier, gofmt, ruff --format -->
- **Linter**: <!-- e.g. ESLint, golangci-lint, ruff -->
- **Key rules**: <!-- the handful of non-default rules that matter most -->
- **Indentation**: <!-- spaces or tabs, count -->
- **Quotes**: <!-- single vs double -->
- **Semicolons**: <!-- required or not -->
- **Line length**: <!-- e.g. 80, 100, 120 -->

## 4. File & Module Organization

<!-- How the project is laid out. Where source goes, where tests go, how imports are structured. -->

- **Source layout**: <!-- e.g. src/, lib/, packages/ -->
- **Test location**: <!-- next to source, __tests__/, tests/ -->
- **Import ordering**: <!-- groups, absolute vs relative -->
- **Module boundaries**: <!-- what one module should not reach into -->

## 5. Error Handling

<!-- The project's philosophy and patterns for errors. -->

- **Approach**: <!-- e.g. exceptions, result types, error returns -->
- **Error types**: <!-- custom error classes, error codes, envelope types -->
- **Logging**: <!-- what level for what, structured logging? -->
- **Edge cases**: <!-- timeouts, cancellation, resource cleanup -->

---

<!-- Below: optional sections. Include only when the skill produced content. -->

## 6. Testing Standards

- **Framework**: <!-- e.g. Vitest, Jest, pytest, Go test -->
- **Naming**: <!-- test file naming, test case naming -->
- **Coverage target**: <!-- percentage or "none" -->
- **Pattern**: <!-- unit vs integration vs e2e split -->
- **Mocking strategy**: <!-- what to mock, what not to -->

## 7. Type Discipline

<!-- Only for typed languages or TypeScript. -->

- **Strictness**: <!-- strict mode? any types banned? -->
- **Any/unknown policy**: <!-- when to use what -->
- **Generics**: <!-- when to reach for generics vs concrete types -->
- **Third-party types**: <!-- DefinitelyTyped? bundled? -->

## 8. Documentation Requirements

- **API docs**: <!-- JSDoc, TSDoc, godoc, rustdoc — required where? -->
- **README per module**: <!-- required pattern or ad-hoc -->
- **Architecture docs**: <!-- ADRs, decision records -->

## 9. Git & Commit Conventions

- **Commit format**: <!-- Conventional Commits, etc. -->
- **Branch naming**: <!-- feature/, fix/, prefix patterns -->
- **PR conventions**: <!-- size limits, review requirements -->

## 10. Performance & Security Constraints

<!-- Only when the project has specific non-functional requirements. -->

- **Performance budgets**: <!-- response time, bundle size -->
- **Security rules**: <!-- input validation, auth patterns, dependency scanning -->
- **Observability**: <!-- metrics, tracing, structured logging -->
