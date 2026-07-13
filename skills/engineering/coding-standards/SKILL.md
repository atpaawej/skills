---
name: coding-standards
description: Create or maintain CODING_STANDARDS.md for any project — by grilling the user, inferring from the codebase, or both.
disable-model-invocation: true
---

# Coding Standards

A **grill**-driven skill. It creates or maintains `CODING_STANDARDS.md` at the project root by picking the right mix of interview and codebase analysis.

Three **branches**, picked by the skill and confirmed with you:

- **Greenfield** — no code yet. Grills you on each standard section before writing.
- **Infer** — code exists, no grill. Explores the codebase to extract conventions, then writes.
- **Grill over existing** — code exists AND you want to be grilled. Explores first, then grills you with the findings as context.

Two **entry points**:

- **Create** — no `CODING_STANDARDS.md` exists. Runs Greenfield, Infer, or Grill over existing.
- **Maintain** — `CODING_STANDARDS.md` exists. Re-scans the codebase, compares with the doc, flags drift, asks for updates.

## Steps

### 1. Determine mode and entry point

Check for `CODING_STANDARDS.md` at project root:

- **If it exists** → Maintain entry point. Announce: "I found CODING_STANDARDS.md. I'll audit it against the current codebase." Proceed to step 4 (Drift scan, then apply).
- **If it does not exist** → Create entry point. Check whether source code exists by globbing for `*.ts`, `*.js`, `*.tsx`, `*.jsx`, `*.py`, `*.go`, `*.rs`, `*.rb`, `*.java`, `*.cs`, `*.php`.

  - **No source files found** → Greenfield mode. Announce: "No code found yet — I'll grill you on what standards you want."
  - **Source files found** → Ask user: "I found source code. I can either **(a) Infer** standards from the codebase by exploring it, or **(b) Grill** you over the existing code, exploring first then interviewing you. Which do you prefer?" Let them pick. Offer override: "Or we can do the other mode if you'd prefer."

**Criterion:** Mode is selected, user has confirmed or overridden. No ambiguity about which path to run.

### 2. Gather context

Depends on the mode.

#### Greenfield mode

Load [[references/grilling-rhythm.md]]. Grill the user through every template section, one at a time:

1. Purpose & scope — what this project is, what CODING_STANDARDS.md covers
2. Naming conventions — files, variables, functions, classes, types
3. Code style & formatting — tools, formatter, rules to follow
4. File & module organization — how code is grouped, imports, folder structure
5. Error handling — philosophy, patterns, error types
6. Testing standards — framework, naming, coverage (ask if they want this)
7. Type/type discipline — if they use typed language (ask if relevant)
8. Documentation — JSDoc/TSDoc, README per module (ask if they want this)
9. Git & commit conventions — if not covered elsewhere (ask if relevant)
10. Performance & security — constraints worth documenting (ask if relevant)

**One question at a time.** Wait for the answer before moving to the next topic. If the answer reveals a fact you can check (e.g. "we use Prettier"), you don't need to grill deeper on that — note it and move on. If the answer reveals a decision (e.g. "camelCase for variables"), confirm you've understood correctly before noting it.

**Completion criterion:** Every section that applies to this project has been covered. Optional sections that don't apply have been explicitly skipped. User has seen and confirmed the full picture.

#### Infer mode

Load [[references/codebase-scan.md]]. Use the Agent tool with `subagent_type=Explore` to walk the codebase and populate the scan checklist. Then map findings to template sections:

- File naming patterns → Naming conventions
- Lint/format config → Code style & formatting
- Framework, directory layout → File & module organization
- Error handling patterns → Error handling
- Test patterns → Testing standards (if patterns found)
- Type usage → Type discipline (if patterns found)
- Doc comments → Documentation (if patterns found)

Do NOT ask the user questions during this phase. Synthesize from what you find. If the codebase is too young or inconsistent on a topic (e.g. 2 files use try/catch, 2 files use error returns, no clear winner), note the ambiguity in the document.

**Completion criterion:** Every discoverable convention is extracted. Template sections with no clear signal are marked as "not yet established" rather than guessed.

#### Grill over existing mode

First run the Infer mode's exploration (load [[references/codebase-scan.md]], explore, analyze). Then load [[references/grilling-rhythm.md]] and grill the user on each template section, using the scan findings as context: "I noticed most files use kebab-case naming — is that your preferred convention?"

**Completion criterion:** Codebase explored AND every applicable section grilled. User has confirmed all decisions.

### 3. Build CODING_STANDARDS.md

Load [[references/coding-standards-template.md]]. Populate every applicable section with what you gathered.

Rules:

- Required sections are always present. Optional sections appear only when the mode produced content for them.
- Use exact examples from the codebase (Infer mode) or from user's answers (Greenfield mode).
- Present the draft to the user: "Here's what I've drafted. What would you change?"
- Iterate on feedback. Keep going until user says "ship it" or "looks good."

**Criterion:** User has approved the document. Document covers every applicable section. No placeholder text remains.

### 4. Maintain mode (drift scan)

Read the existing `CODING_STANDARDS.md`. Then load [[references/codebase-scan.md]] and re-explore the codebase. Compare:

- Does the doc say camelCase but codebase now uses kebab-case? → Flag as drift.
- Does the doc list a test framework that's no longer used? → Flag as drift.
- Is the doc's section on error handling still accurate? → Confirm or flag.
- Are there new tools/patterns in the codebase the doc doesn't mention? → Flag as missing.

Present each drift one at a time: "I found that your doc says X, but the codebase now does Y. Would you like to update it?" Let the user decide per drift. Then apply the approved changes and write the updated file.

**Criterion:** Every drift item presented and resolved (updated or intentionally kept). User confirms the updated doc is accurate.

### 5. Write

Write `CODING_STANDARDS.md` to the project root.

**Criterion:** File exists at `<project-root>/CODING_STANDARDS.md` with no placeholder content.
