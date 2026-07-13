# OCP Glossary

**Closed core / closed zone** — modules declared stable. New features **never** modify them. Their interfaces are frozen by convention.

**Extension point** — a seam purpose-built for new code to attach. An interface, abstract class, hook, or callback that plugin code satisfies.

**Plugin** — code living outside the closed core that implements an extension point. Adding one never touches the core.

**Dependency rule** — dependencies point **inward**: plugins depend on extension points; the closed core never depends on plugins. Extensions may not import other extension categories.

**Extension category** — a named axis of variability — "payment methods", "export formats", "notification channels". Each has its own extension point and family of plugins.

**Registration** — the act of making a plugin known to the core — registry, config file, DI binding, or naming convention.

**Change density** — files a single feature change touches. **Target: 1** (just the new plugin). Higher density = missing extension point. Use this to audit whether the OCP boundary is working.
