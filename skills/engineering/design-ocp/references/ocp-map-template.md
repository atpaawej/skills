# OCP-MAP

> This file defines the **Open-Closed Principle** boundaries for this codebase.
> New features must be **new files** — never edits to the closed core.
> Read this before adding any feature. If you believe a closed zone needs modification, **stop and ask**.

## Closed Zones (never modify)

Files in these directories are **closed for modification**. New features must never edit them.

| Zone | Directory | Purpose | Contents include |
|---|---|---|---|
| Core domain | `src/core/` | Business rules, entities, stable domain logic | Entities, value objects, domain services, repository interfaces |
| Framework | `src/framework/` | Bootstrap, plugin loader, dependency wiring | App bootstrap, plugin registry, DI container configuration |
| | | | |

> **Rule:** If a file is under any directory listed above, do NOT modify it. If a new feature requires a change here, stop and ask the human.

## Extension Points (open for new code)

Every new feature implements one of these extension points. Pick the right category, implement the interface, register it.

| Category | Interface / Contract | Location | Registration | Example plugins |
|---|---|---|---|---|
| Payments | `PaymentProvider { charge(amount, currency): Result }` | `src/extensions/payments/` | Register in `src/extensions/payments/registry.ts` | stripe, paypal, square |
| Notifications | `NotificationChannel { send(message): void }` | `src/extensions/notifications/` | Register in `config/notifications.ts` | email, sms, push |
| Export formats | `ExportFormat { render(data): string }` | `src/extensions/exports/` | Convention — files in this dir auto-loaded | csv, json, pdf |
| | | | | |

> **How to add a new feature:**
> 1. Find the matching extension category above
> 2. Create a new file in the Location directory
> 3. Implement the Interface/Contract
> 4. Register via the Registration mechanism
> 5. Never touch any Closed Zone

## Dependency Rule

```
src/core/  (closed)  ────────── defines interfaces ──────→  (extension points)
     ↑                                                          │
     │                                                          │
     └─── extensions MUST NOT import back ───── extensions implement ──┘
```

- **Closed zones** may NOT import from extension directories
- **Extensions** may import closed-zone interfaces only (not implementations)
- **Extensions** may NOT import other extension categories
- Violating this rule breaks the OCP contract. If you need cross-extension communication, add a new extension point.

## Escalation Rules

Sometimes a genuinely new capability requires adding to the core. This is rare.

| Condition | Action |
|---|---|
| No existing extension category fits | Stop. Ask human: "Should a new extension category be added?" |
| Interface change needed in a closed zone | Stop. Ask human: "The extension point needs a new method — approve this change?" |
| Dependency rule feels constraining | Stop. Ask human: "The design may need an architectural review." |

> **Default answer:** STOP AND ASK. Do not modify closed zones without explicit human approval.
