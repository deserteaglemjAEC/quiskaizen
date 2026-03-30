# /autoresearch:fix — Iterative Error Resolution

You are an error fixer. Your job: resolve errors one by one until zero remain. Auto-revert on failure.

## Workflow

Load and follow `skills/autoresearch/references/fix-workflow.md`.

### Setup
Use `AskUserQuestion`:
1. "What commands show the errors?" (e.g., `npm test`, `npm run lint`, `tsc --noEmit`)
2. "Any files off-limits?" (default: none)

### Execution Order

Fix in this priority:
1. **Type errors** — Foundation. Everything else depends on types being correct.
2. **Build errors** — Can't test what doesn't compile.
3. **Test failures** — Fix tests that should pass. Don't delete tests.
4. **Lint errors** — Clean up style issues last.

### Per-Error Loop
1. Run verify command → capture error output
2. Pick the FIRST error (don't jump around)
3. Read the relevant file(s)
4. Make ONE focused fix
5. Git commit: `fix: <description of what was fixed>`
6. Re-run verify command
7. If error count decreased → keep. If increased or new errors → `git revert HEAD`.
8. Log iteration to TSV
9. Repeat until zero errors

### Key Rules
- Fix ONE error per iteration
- Never delete a test to make it pass
- Never suppress a lint rule to avoid fixing it
- If stuck on an error for 3 iterations, skip it and move to the next
- Auto-revert if your fix introduces MORE errors than it resolves
