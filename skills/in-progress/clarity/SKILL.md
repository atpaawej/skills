---
name: clarity
description: Distill a tangled thought, stuck decision, or messy artifact into what is actually happening, the crux, hidden assumptions, and the next concrete move.
disable-model-invocation: true
---

# Clarity

Cut through **fog**. Take whatever messy thought, stuck choice, or tangled artifact the user brings and surface what is real, what matters, and what moves next.

If the working directory has a `GLOSSARY.md` (or `GLOSSARY-MAP.md`), read it silently first and hold to its terms.

## Voice and discipline

- **Plain, calm, direct prose.** Every sentence earns its place.
- **Facts apart from assumptions.** Label unverified claims, fears, and inferences as assumptions rather than treating them as fixed reality.
- **Split conflated terms.** When one vague word (*"broken"*, *"scale"*, *"risky"*, *"stuck"*) bundles two or three distinct ideas, name each meaning separately.
- **Stay self-contained.** End with a concrete move the user can take immediately; never assume external tools or other skills.

## Working loop

### 1. Draw out the dump if empty

When invoked with no context or only a bare signal (*"I'm stuck"*), skip explaining this framework and ask two short prompts:
1. What is happening right now? Dump it raw — half-baked or contradictory is fine.
2. What decision, friction, or outcome is forcing the issue today?

Wait for the dump before moving to step 2.

### 2. Route to the fog's shape

Read the single reference matching the dominant shape of the input. Load a second only when the dump genuinely spans two shapes.

| The dump looks like | Read |
| --- | --- |
| Overload, competing threads, mixed facts and worry, unclear bottleneck | [tangles](references/tangles.md) |
| Circling options, false binaries, competing trade-offs, analysis paralysis | [decisions](references/decisions.md) |
| A pasted or referenced note, doc, thread, or half-formed concept with blurred points | [artifacts](references/artifacts.md) |

When the user points to a file or thread, read only what they pointed to.

### 3. Distill through five lenses

Produce a crisp breakdown using the lenses that actually apply (skip any lens that would only force filler):

1. **What's actually happening** — observable facts stripped of story, worry, or padding.
2. **The crux** — the single question, tension, or bottleneck everything else hangs on.
3. **Hidden assumptions & false constraints** — what is treated as fixed, binary, or urgent without evidence, plus any conflated terms split apart.
4. **Signal vs. noise** — what moves the needle now vs. secondary threads to park.
5. **Next concrete move** — the smallest reversible step or choice that resolves or tests the crux.

Check before finishing: every conflated term split, every unverified constraint marked as an assumption, and one concrete move named.

### 4. Pinpoint remaining unknowns

End with **1–3 sharp questions** only when a critical unknown blocks naming the crux or next move. When the fog is already clear enough to act, stop after **Next concrete move**.
