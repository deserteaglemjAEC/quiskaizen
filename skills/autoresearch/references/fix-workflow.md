# Fix Workflow Protocol

Iterative error resolution. Fix errors one by one until zero remain.

## Setup

Collect via `AskUserQuestion`:
1. Verify command(s) — what shows the errors? (e.g., `npm test`, `tsc --noEmit`, `npm run lint`)
2. Off-limits files — anything that shouldn't be modified?

## Execution Order

Fix in this priority (each category clears before moving to next):

### Priority 1: Type Errors
- Run: `tsc --noEmit` (or equivalent)
- Foundation — everything depends on correct types
- Common fixes: missing imports, wrong argument types, null checks

### Priority 2: Build Errors
- Run: `npm run build` (or equivalent)
- Can't test what doesn't compile
- Common fixes: missing exports, circular dependencies, config issues

### Priority 3: Test Failures
- Run: `npm test` (or equivalent)
- Fix tests that SHOULD pass. Never delete a test to make it pass.
- Common fixes: assertion updates for intentional changes, mock updates, async handling

### Priority 4: Lint Errors
- Run: `npm run lint` (or equivalent)
- Clean up style last
- Common fixes: formatting, unused imports, naming conventions
- Never suppress a lint rule to avoid fixing it

## Per-Error Loop

```
1. Run verify command -> capture full error output
2. Count total errors
3. Pick the FIRST error (top of output, don't jump around)
4. Read the file containing the error
5. Understand the error (type mismatch? missing import? logic error?)
6. Make ONE focused fix
7. git commit -m "fix: <what was fixed>"
8. Re-run verify command
9. Count errors again
   - Decreased -> KEEP (log: keep)
   - Same count but different errors -> KEEP (fixed one, found another)
   - Increased -> REVERT (git revert HEAD --no-edit, log: revert)
10. Log to TSV
11. Repeat until zero errors
```

## Stuck Protocol

If the same error persists for 3 consecutive iterations:
1. Log it as "blocked: <error description>"
2. Skip to the next error
3. Return to blocked errors after all others are resolved
4. If still blocked: ask user via `AskUserQuestion`

## Key Rules

- ONE error per iteration (atomic fixes)
- Never delete tests to pass
- Never suppress lint rules
- Never add `@ts-ignore` or `// eslint-disable` without explicit user approval
- Auto-revert if fix introduces MORE errors
- Log every iteration (even failed attempts)
