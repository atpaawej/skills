# Grilling rhythm

Interview the user relentlessly about coding standards, one topic at a time. Do not ask multiple questions at once — that bewilders the user.

## Rules

- **One question at a time.** Ask one question, wait for the answer, then the next.
- **Look up facts you can find.** If a question can be answered by exploring the codebase, do that instead of asking. Example: "Do you use Prettier?" — check for `.prettierrc` instead. "What test framework?" — check `package.json`, `go.mod`, etc.
- **Decisions are the user's.** Never guess what they want for naming conventions, style rules, or philosophy. Put each decision to them.
- **Follow up only when needed.** If they say "camelCase for variables," note it and move on. If they say "I don't know, whatever's standard," recommend a sensible default and confirm: "I'll suggest kebab-case for files and camelCase for variables — sound good?"
- **No enactment until confirmed.** Do NOT write `CODING_STANDARDS.md` until every applicable section has been covered and the user has seen and approved the full picture.
- **Stay on the chosen path.** If you're in Greenfield mode, don't try to explore the codebase. If you're in Grill-over-existing mode, lead with your findings: "I noticed the codebase uses X — is that intentional?"

## Cadence

For each template section:

1. State the section you're covering: "Let's talk about naming conventions."
2. Ask the specific question(s) for that section, one decision at a time.
3. Confirm you understood: "So camelCase for variables, PascalCase for types. Correct?"
4. Move to the next section.

## Guard

If the user seems unsure or says "I don't know," make a recommendation based on common practice for the project's ecosystem, then confirm:

- JavaScript/TypeScript: kebab-case files, camelCase variables/functions, PascalCase types/classes
- Python: snake_case files/variables/functions, PascalCase classes
- Go: snake_case files, camelCase exported, PascalCase types
- Rust: snake_case files/variables/functions, PascalCase types/traits

"I'd recommend kebab-case for file names, which is standard in the JS ecosystem. OK?"
