# Grilling Rhythm

Interview the user about coding standards, one topic at a time. Walk every applicable section of the template, recommend-first, then confirm.

## Rules

- **One question at a time.** Ask one, wait for the answer, then the next.
- **Recommend first.** Never ask a naked question. Always lead with: "I recommend X — good?"
- **Look up facts you can find.** If a question can be answered by checking config files (`package.json`, `tsconfig.json`, `.prettierrc`, etc.), do that instead of asking.
- **Decisions are the user's.** Put each one to them and wait for an answer. But you must propose a specific option, not list options.
- **Confirm you understood.** "So kebab-case for files, camelCase for variables. Correct?"
- **No enactment until fully confirmed.** Do not write or edit CODING_STANDARDS.md until every applicable section has been covered and the user has approved the full picture.

## Cadence per section

For each section in the template:

1. **Announce**: "Let's talk about [section name]."
2. **State your finding**: "Your project is TypeScript with Prettier configured."
3. **State your recommendation**: "For naming: I recommend kebab-case for files and camelCase for variables — that's standard in the JS ecosystem."
4. **Confirm**: "Good?"
5. **Record the decision.** Move to the next section.

## Sections — order

Walk in this order. MUST and SHOULD sections are always covered. OPTIONAL sections are offered after the essentials.

### MUST (always cover)
1. Non-Negotiable Architecture Decisions (pull from the principle catalog based on assessment)
2. Naming Conventions
3. Code Style & Formatting
4. Module Boundaries
5. Error Handling

### SHOULD (always cover)
6. Testing Standards

### OPTIONAL (offer after essentials)
7. "We've covered the essentials. This project could also benefit from Type Discipline, Documentation, Commit Conventions, or Performance constraints. Want to add any of those?"

If yes → grill each accepted section the same way: recommend → confirm → move on.

## Guard

If the user seems unsure or says "I don't know," recommend a sensible default for their ecosystem and confirm:

- **JavaScript/TypeScript**: kebab-case files, camelCase variables/functions, PascalCase types/classes
- **Python**: snake_case files/variables/functions, PascalCase classes
- **Go**: snake_case files, camelCase exported, PascalCase types
- **Rust**: snake_case files/variables/functions, PascalCase types/traits
- **Layered architecture** — default to Clean/Onion for web services; skip for CLI tools and libraries
- **Fail fast** — always recommend for any project type

## Anti-patterns

- ❌ Asking multiple questions at once
- ❌ Asking "what do you want?" without giving a recommendation
- ❌ Asking questions you could answer by reading a config file
- ❌ Drafting the document mid-grill (do that in Step 5)
