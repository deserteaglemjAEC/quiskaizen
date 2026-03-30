# Debug Workflow Protocol

Scientific method bug hunting. Form hypotheses, test them, narrow the cause.

## Setup

Collect via `AskUserQuestion`:
1. Symptoms (error messages, unexpected behavior)
2. Reproduction steps (or "intermittent")
3. When it started (commit, deploy, config change, "always")
4. What's been tried already

## Investigation: 7 Techniques

Apply in order. Stop when root cause is found.

### 1. Read the Error
- Parse the FULL stack trace (not just the first line)
- Identify: file, line, function, error type
- Check if the error message is from your code or a dependency

### 2. Reproduce
- Write the minimal steps to trigger the bug
- If intermittent: identify conditions (load, timing, data pattern)
- If you can't reproduce, you can't verify a fix

### 3. Binary Search
- `git bisect start` / `git bisect bad` / `git bisect good <known-good-commit>`
- Or: comment out halves of the suspicious code until the bug disappears
- Narrows: "the bug is in THIS section"

### 4. Print Debugging
- Add strategic logging at trust boundaries:
  - Function entry/exit with arguments
  - Before/after state mutations
  - At conditional branches
- Look for unexpected values, missing calls, wrong order

### 5. Diff Analysis
- `git diff <working-commit>..HEAD` — what changed?
- Compare: config files, env vars, dependency versions
- Look for: renamed variables, changed defaults, removed checks

### 6. Dependency Audit
- Check lockfile changes: `git diff HEAD~10 -- package-lock.json`
- Look for transitive dependency updates
- Check known vulnerabilities: `npm audit` / `pip audit`

### 7. Fresh Eyes
- Re-read the code as if you've never seen it
- Question every assumption: "Why is this here? What if it's wrong?"
- Read the tests — do they actually test what they claim?

## Hypothesis Protocol

For each hypothesis:

```
HYPOTHESIS: I believe [X] causes [Y] because [Z].
TEST: If I [action], I expect [result].
RESULT: [confirmed / disproved / inconclusive]
NEXT: [next hypothesis or "root cause found"]
```

Track all hypotheses. Don't abandon a disproved hypothesis without recording it.

## Output

1. **Root cause** — What, where, why (with file:line references)
2. **Fix** — Applied or recommended (with diff)
3. **Regression test** — Added to prevent recurrence
4. **Related bugs** — Anything else found during investigation
5. **Timeline** — How the bug was introduced and why it wasn't caught

## Chaining

`/autoresearch:debug --fix` — After finding root cause, auto-transition to `/autoresearch:fix` to resolve.
