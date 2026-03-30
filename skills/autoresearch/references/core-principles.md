# Core Principles

7 universal rules that apply to ALL autoresearch commands. Non-negotiable.

## 1. Loop Until Done

The default is unbounded iteration. The loop continues until:
- User interrupts (`ctrl+c`)
- Iteration limit reached (if configured)
- Metric reaches target value (if configured)
- Zero errors remain (for `/autoresearch:fix`)

**Why:** Premature stopping leaves value on the table. The best improvements often come after iteration 15+.

## 2. Read Before Write

Before modifying ANY file:
- Read the full file (not just the section you plan to change)
- Read related files (imports, tests, configs)
- Read git history for that file (recent changes, who wrote it, why)

**Why:** Blind edits break things. Context prevents regressions.

## 3. One Change Per Iteration

Each iteration makes exactly ONE focused modification:
- One function refactored
- One test added
- One config changed
- One section rewritten

**Why:** Atomic changes are traceable, reversible, and measurable. If you change 3 things and the metric improves, you don't know which one helped.

## 4. Mechanical Verification Only

The metric must be:
- A NUMBER (not a feeling)
- Produced by a COMMAND (not a judgment)
- REPRODUCIBLE (same input → same output)

**Why:** Subjective evaluation drifts. Mechanical evaluation is consistent. You can't optimize what you can't measure.

## 5. Automatic Rollback

When a change doesn't improve the metric:
- `git revert HEAD --no-edit` immediately
- Log the revert with the reason
- Move on to the next idea

No second-guessing. No "but it's cleaner code." The metric decides.

**Why:** Keeping neutral or negative changes pollutes the codebase and confuses future iterations.

## 6. Simplicity Wins

When two approaches produce the same metric:
- Keep the one with fewer lines of code
- Keep the one with fewer dependencies
- Keep the one that's easier to read

**Why:** Complexity is technical debt. Equal results + less code = strictly better.

## 7. Git as Memory

Every experiment is committed, even failures:
- Successful changes: `experiment: <description>`
- Reverted changes: preserved in git history via `git revert`
- Git log IS the experiment journal

**Why:** Future iterations can learn from past attempts. Revert history prevents re-trying failed approaches.
