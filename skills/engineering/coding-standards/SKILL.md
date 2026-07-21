---
name: coding-standards
description: Create CODING_STANDARDS.md for any project — walks through essential principles (OCP, deep modules, fail fast), recommends a tailored baseline, then grills the user to customize.
---

# Coding Standards

An **opinionated, model-invoked** skill. Creates `CODING_STANDARDS.md` at the project root by assessing the project, recommending a baseline of **MUST / SHOULD / OPTIONAL** principles from a curated catalog, then grilling the user to customize every applicable section.

The resulting document is **timeless** — rules-only, no file paths, no architecture maps, nothing that drifts when the codebase evolves.

**Leading words** (compact concepts the model already knows — anchor the skill's behavior):
- **OCP** — add behaviour by creating new files, not modifying existing ones
- **Deep Module** — simple interface, substantial hidden implementation
- **Fail Fast** — detect and report errors at the earliest moment
- **CQS** — a method is either a command (void) or a query (returns data), never both
- **YAGNI** — don't add abstraction until the code calls for it
- **POLA** — principle of least astonishment; code should not surprise

**Target audience for the document:** developers coding with AI agents. The standards are written to reduce ambiguity, provide clear patterns, and give agents a reliable behavioural contract.

## Steps

### 1. ASSESS — understand the project

Gather the minimum context needed to recommend the right principles:

- What **language and runtime** is this? (JavaScript/TypeScript, Python, Go, Rust, Java, C#, etc.)
- What **framework** (if any)?
- What **linters, formatters, type-checkers** are configured?
- Is this a **monorepo, single package, or service**?
- Is it a **new project or an existing codebase**?

Do NOT explore the codebase beyond what's needed for these five checks. Do NOT report file counts or directory structure — those facts go stale and the document must not contain them.

**Completion criterion:** Language, framework, tooling, project type, and lifecycle stage are known. Not guessed, not assumed — confirmed from config files or package manifests.

### 2. RESEARCH — load the principle catalog

Context pointer → [[references/principles.md]]

Read the full principle catalog. For each domain, determine which principles apply to the project you assessed:

- For a **CLI tool**: Architecture & Boundaries principles may be less relevant; Discipline & Scope and Error Handling are critical.
- For a **web service or API**: Layered Architecture, OCP, and Explicit Contracts matter most.
- For a **library/package**: Deep Modules, CQS, and POLA are top priority.

Form a mental map of: **MUST apply, SHOULD apply, OPTIONAL for this project.** This map drives the baseline presentation in the next step.

**Completion criterion:** Every domain in the catalog evaluated for this project. No domain skipped. A clear triage (MUST/SHOULD/OPTIONAL) decided, with rationale the skill can explain to the user.

### 3. PRESENT BASELINE — propose the tiered recommendation

Tell the user what you found and what you recommend:

1. **Project summary**: "TypeScript monorepo, NestJS, Prettier + ESLint configured. Looks like a web service."
2. **MUST set**: "Here's what I think every good codebase in your situation needs:" — list the 🔴 MUST principles with one-line rationale each.
3. **Offer the full picture**: "Beyond these, I have SHOULD and OPTIONAL recommendations. Want to hear them?"

Wait for their answer before proceeding. If they say "yes, show me everything" — present the full SHOULD and OPTIONAL sets too. If they say "looks good, let's go" — skip to the grill with just the MUST set.

**Completion criterion:** User has seen the baseline. They know what tier they're engaging with. No ambiguity about which principles are on the table.

### 4. GRILL — walk every applicable section, one at a time

Context pointer → [[references/grilling-rhythm.md]]
Context pointer → [[references/coding-standards-template.md]]

Load the grilling rhythm. Then for every section in the template that applies:

1. **Announce the section**: "Let's talk about naming conventions."
2. **State your recommendation**: "For TypeScript, kebab-case for files and camelCase for variables — that's standard. I recommend we adopt that."
3. **Ask for a decision**: "Good?"
4. **Wait for answer** — one question at a time. No multi-questions.
5. **Confirm you understood**: "So kebab-case for files, camelCase for variables. Correct?"
6. **Move to the next section.**

**Order:** Walk MUST sections first, then SHOULD sections, then explicitly offer OPTIONAL sections. "We've covered the essential sections. This project could also benefit from Type Discipline, Documentation, and Commit Conventions — want to add those?"

**Rules:**
- If a *fact* can be found (e.g., "what formatter do you use?"), look it up rather than asking.
- The *decisions* are the user's — put each one to them and wait.
- Provide your recommended answer with every question — never ask a naked question.
- Do NOT draft the document during this step. No enactment until the grill is complete.

**Completion criterion:** Every applicable MUST and SHOULD section has been covered and a decision recorded. OPTIONAL sections explicitly offered and accepted or declined. User has confirmed the full picture.

### 5. DRAFT — write CODING_STANDARDS.md

Load [[references/coding-standards-template.md]]. Populate every section that was agreed during the grill.

**Rules:**
- Required sections (Purpose & Scope, Naming Conventions, Code Style & Formatting, Module Boundaries, Error Handling) are always present.
- Optional sections appear only if the user accepted them.
- Every rule must include both ✅ GOOD and ❌ BAD examples inline — self-contained, no file references.
- Include the **Boundary System** table (Always Do / Ask First / Never Do).
- Include a **Verification** section at the end: "Before marking PR ready, run: `npm run lint && npm run typecheck && npm run test`."
- Never include file paths, directory structures, or architecture-as-it-stands today.
- Keep the document under ~120 lines. If a rule can be enforced by a linter, do NOT include it.

Present the draft: "Here's what I've drafted. What would you change?"

Iterate on feedback. Keep going until the user says "ship it" or "looks good."

**Completion criterion:** User has approved the document. Every applicable section is populated. No placeholder text remains. No file paths or location facts are present.

### 6. VERIFY — agent self-check

Before writing the file, run this checklist:

- [ ] Does every rule have a ✅ GOOD and ❌ BAD example pair? (No prose-only rules)
- [ ] Are there any file paths, directory descriptions, or architecture facts that will go stale? (Delete them)
- [ ] Is the document under ~120 lines? (If not, prune ruthlessly — run the no-op test per line)
- [ ] Are there any linter-enforceable rules that slipped through? (Delete them — CI enforces those)
- [ ] Does the Boundary System table cover everything? (Always / Ask / Never)
- [ ] Is there a Verification self-check section at the end?

If anything fails the checklist, fix it. Then write `CODING_STANDARDS.md` to the project root.

**Completion criterion:** File exists at `<project-root>/CODING_STANDARDS.md`. All checklist items pass. Document matches what the user approved.
