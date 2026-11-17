# Defects

Each defect is a property failing, with a tell you can see in the file. Diagnose with the property number; repair with the move.

| Defect | The tell | Property | Repair |
|---|---|---|---|
| **Tautological** | The expected value is computed the way the code computes it: `expect(parse(s)).toEqual(expected)` where `expected` came from `parse`; a constant asserted against itself | 1, 4 | Replace the computed value with a literal sourced from the spec, or delete the test |
| **Assertion on a mock** | `toHaveBeenCalledWith` on a collaborator the module owns; call counts; call order; the mock supplies the value being asserted | 1, 3 | Assert the outcome the caller sees; keep mocks at process boundaries and assert what they received |
| **Implementation-coupled** | Breaks when a helper is renamed or extracted with no behaviour change; reaches private state; reads the DB to verify what the interface already returns | 2 | Move the assertion to the caller's surface; if it cannot move, the boundary needs fixing |
| **Happy-path only** | One case per new behaviour; the error branch, the empty input, and the boundary are absent | 5 | Walk the branches and add a case per branch; table the cases |
| **Bug-ratifying** | The test passes on pre-fix code; the assertion was changed in the same commit as the fix | 4 | Rebuild the expectation from the reported behaviour, not from the current output; confirm it fails on the old code |
| **Assertion-free** | No assertion; `expect(fn).not.toThrow()` as the only check; a `try/catch` that swallows; an assertion after `return`; an assertion inside an `if` that never runs | 1 | Assert the value or error the caller gets |
| **Over-mocked** | Setup is mostly mock wiring; the module under test appears in its own mock factory; repositories, clocks and helpers all faked | 3, 6 | Use the real object in-process; fake only what leaves the process |
| **Snapshot abuse** | Whole-object snapshot for a one-field behaviour; snapshots regenerated in the same change as the bug fix; snapshot growth outpaces behaviour growth | 7, 1 | Assert the field the behaviour concerns; snapshots stay for pinning legacy output |
| **Negative without a twin** | `not.toHaveBeenCalled`, `rejects`, "does not throw" standing alone | 5 | Add the case where it does happen, same file |
| **Test-only seam** | A production export exists only because a test needed it; the module surface grows with each test file | 2, 3 | Delete the export; if the test genuinely needs it, the boundary is in the wrong place |

## Outside the frame

Two failures are real, common, and not scored by the seven. Name them and hand them to review; do not force them into a property.

- **Coverage theatre.** Tests added to move a number, duplicated assertions, ignore comments, a threshold edited in the same diff. Coverage measures execution, not assertion.
- **Horizontal slicing.** A batch of tests lands before any implementation exists, so the tests describe imagined shapes. The suite commits to a structure nobody had understood yet.

## Reading a test file in one pass

1. **Assertions.** Does every test have one, is it reachable, and could it fail?
2. **Names.** Do they say what a caller gets?
3. **Mocks.** Anything mocked that this repo owns?
4. **Data.** Where did the expected values come from?
5. **Cases.** Which branches of the new code have no test?
