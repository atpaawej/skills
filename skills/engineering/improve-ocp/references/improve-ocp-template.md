# IMPROVE-OCP

> This file lists OCP violations found in the codebase and the target architecture to extract toward.
> Review each item. Approve or reject. Then tell an agent: "implement IMPROVE-OCP.md".

## Target OCP Map

### Proposed closed zones

| Zone | Directory | Purpose |
|---|---|---|
| Core domain | `src/core/` | Business rules, entities, stable domain logic |
| | | |

### Proposed extension points

| Category | Interface | Location | Registration |
|---|---|---|---|
| | | | |

### Dependency rule

> Closed core must never import extension code. Extensions import closed-core interfaces only. Extensions may not import other categories.

---

## Violations

### Zone: <zone-name>

| # | File | Signal | Severity | Fix |
|---|---|---|---|---|
| 1 | `src/...` | Direct `new` of dependency | high | Accept via interface, inject in constructor |
| 2 | `src/...` | Feature code mixed with core | high | Extract feature code into extension, keep interface in core |
| | | | | |

### Extension category: <category-name>

| # | File | Signal | Severity | Fix |
|---|---|---|---|---|
| 1 | `src/...` | No interface at module boundary | medium | Extract interface, rename existing class as plugin |
| 2 | `src/...` | Cross-category import | high | Remove import; extension categories must be independent |
| | | | | |

---

## Migration order

1. **Extract interfaces** — create the closed-core interfaces first (safe, non-breaking)
2. **Create directory structure** — scaffold extension point directories
3. **Move plugins** — move existing implementations into extension directories, wire registration
4. **Update imports** — point all callers from concrete imports to interface imports
5. **Delete old code** — remove now-unused concrete references from core

## How to use this file

1. Read the target map — understand the destination
2. Review each violation — approve or reject
3. Once approved, tell an agent: "Implement IMPROVE-OCP.md"
4. The agent works through migration order, one step at a time
