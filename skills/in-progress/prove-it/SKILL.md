---
name: prove-it
description: Judge, write, and repair tests by what they can prove rather than how they are built. Use when writing tests, reviewing or fixing a test file, asked "is this test any good", or after any behaviour change. Seven properties — can it fail, does it survive a refactor, does it assert what a caller sees, does its expectation come from outside the code, are the edges covered, is it free of the clock and the network, does a failure localise. Not a TDD workflow; no red-green sequencing.
---

# Prove it

A test earns its place by what it can catch. Seven properties describe that earning; three postures apply them to the test in front of you.

This is understanding, not workflow: no stages, no commits, no loop. The seven questions are the whole skill, asked of a concrete test.

If the working directory has a `GLOSSARY.md` (or `GLOSSARY-MAP.md`), read it silently first and hold to its terms.

## The seven properties

Ask each of one specific test. Every "no" names a defect in [defects](references/defects.md) and points at a repair.

### 1. It can fail

Break the behaviour — in your head, or in the editor with the change reverted — and ask whether the test goes red. If the asserted value came from the code under test, from a mock the test itself set up, or from nothing at all, the test passes either way and proves nothing. The sharpest check: make the smallest edit that should break the behaviour, watch for red, put the edit back.

### 2. It survives change

Rename a function, extract a helper, split a file — same observable behaviour, different internals. A test that survives that is bound to behaviour. A test that breaks was asserting on structure, and it will break for every future refactor, which trains people to rewrite tests instead of trusting them.

### 3. It talks to the outside

Name the caller: a route handler, a CLI command, a client method, another module's public surface. The test asserts what that caller can see — a return value, a thrown error, persisted state, or a message to a system the code does not own. Reaching into internal helpers, private members, or the call graph of things the module owns puts a third user in the room, the test, and production code then has to satisfy it.

### 4. Its expectation comes from elsewhere

Point to where the expected value came from: a spec line, an issue, a worked example, a known-good literal, a screenshot of the product. When the only source is the code's current output, the test ratifies whatever the code does today, bugs included. With no source, write it, label it `characterisation`, and keep it out of any claim that something is fixed.

### 5. It covers the edges

Walk the new behaviour and list its branches: inputs that are empty, tiny, huge, malformed, unauthorised, absent; boundaries on either side of a limit; the failure path alongside the success. Pair each "this never happens" with a case where it does, in the same file. A table of cases is one behaviour with many examples, and reads better than ten near-identical tests.

### 6. It doesn't need the world to cooperate

The test passes on a cold machine, in any order, twice in a row, tomorrow. Clock, randomness, network, sleeps, and shared global state are the usual levers; fake them at the boundary or inject them. A test that needs the world is a test people eventually skip.

### 7. When it fails, you know what broke

The name says what the caller gets, not which function ran. One behaviour per test, so a red result points at one thing. The assertion is specific enough to show the difference — the exact value, the exact error type, the exact field. A magic number or a whole-object snapshot leaves the reader to guess.

## The three postures

### Write

Opens on "write tests for X", on a new behaviour, or at the tail of any behaviour change.

1. Name the caller and the seam before a test exists.
2. Name the behaviour in one sentence, and where its expected value comes from.
3. Write the smallest test that would go red if that sentence stopped being true.
4. Score it against all seven properties. Repair each failure, or state why it stands.

Done when every new test has an answer for all seven, and each "no" carries its reason.

### Improve

Opens on "fix these tests", or when a touched file already has tests.

1. Score the existing tests against the seven, worst first — property 1 outranks the rest.
2. Repair by property rather than taste: each change names the property it restores and what the test was doing instead.
3. When a test cannot reach property 2 or 3 without the module changing shape, say so. That is a boundary finding, not a test finding.

Done when every changed test names the property it repairs and untouched tests still pass.

### Diagnose

Opens on "is this test good?", or when a verdict is owed.

Report per property: pass, fail, or not applicable, with the evidence that decided it. Quote the line. A verdict of "all seven pass" is a complete answer, and the common one for a good test.

Done when every property has a verdict backed by something in the file.

## When properties collide

Ordered, so the cheap property does not win by default:

1. **Property 1 outranks everything.** A test that cannot fail is decoration, however well it scores elsewhere.
2. **Property 4 has no fallback.** No independent oracle means `characterisation`, and it cannot close a claim.
3. **5 with 6:** put the edges on the fastest seam that expresses them; fake the boundary rather than waking the world.
4. **Realism yields to 6.** One test against the real system per critical path is allowed, labelled as such.
5. **7 yields to 5** for a table of cases: many cases, one behaviour, every case named.
6. **When a test needs to reach inside to exist at all, the boundary is wrong.** Fix the module, and the test gets simple.

## Running the proof

Some claims need execution: the revert-and-watch-red check, the rename-and-stay-green check, the actual command for the runner in front of you. See [evidence](references/evidence.md). Judgement covers the rest.

## What this skill leaves alone

- **Sequencing.** When to write a test relative to the code is a workflow choice; this skill judges tests whenever they were written.
- **Coverage.** A coverage delta has never shown that an assertion holds.
- **Speed.** A slow test can be a correct test; cost is a separate conversation from proof.
- **Suite-wide rewrites.** It works on the tests in front of it.
