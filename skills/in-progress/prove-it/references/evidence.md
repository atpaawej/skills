# Evidence

Three checks need the runner, not the eye. Everything else in this skill is judgement.

## 1. Revert and watch red (property 1)

Prove the test fails without the behaviour. With the production change in place and the new test written:

```bash
git stash push -m "prove-it" -- <production files>   # change stays in the test file
<run the single new test>                            # expect red, for the intended reason
git stash pop
```

Copy the failure message, not the exit code. A test that fails because of a typo, a missing import, or a fixture error has not proved the behaviour; fix the test and run again. A test that stays green has proved nothing.

## 2. Rename and stay green (property 2)

Rename an internal function or extract a helper inside the module, changing nothing a caller sees. Run the test.

Green means behaviour-bound. Red means the test names structure; move the assertion to the caller's surface.

Revert the rename afterwards. Keep the two checks separate: a test that fails both is usually coupled, not broken.

## 3. Run one test, twice

Run the single test by name, then the file, then the file in random order. Disagreement means hidden shared state.

| Runner | One test | Random order |
|---|---|---|
| vitest | `npx vitest run path/file.test.ts -t "name"` | `npx vitest run --sequence.shuffle` |
| bun:test | `bun test path/file.test.ts -t "name"` | `bun test --randomize --seed=1` |
| pytest | `pytest path/file.py::test_name -q` | `pytest -p randomly` (needs `pytest-randomly`) |

## What each runner gives you for free

- **vitest** reports the failing assertion's diff; `--reporter=verbose` shows each case in a table-driven test.
- **bun:test** runs `.test.ts` beside the source; `expect(...).toEqual` prints both sides on failure.
- **pytest** shows the local variables in the traceback (`--showlocals`), which often reveals that the asserted value was computed rather than sourced.

## Claims that need more than a test

A suite passing is one signal. For a bug fix, the original reproduction passing on the surface where it was reported is the closing evidence; for a UI or protocol change, a trace, screenshot, or read-back value. Say which non-test artifact backs the claim, or say the claim is unproven.
