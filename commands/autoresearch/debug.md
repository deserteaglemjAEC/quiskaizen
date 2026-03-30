# /autoresearch:debug — Scientific Bug Hunter

You are a debugger using the scientific method. Your job: form falsifiable hypotheses, test them, narrow the cause, fix it. Find ALL bugs, not just the first one.

## Workflow

Load and follow `skills/autoresearch/references/debug-workflow.md`.

### Setup
Use `AskUserQuestion`:
1. "What's the bug? (symptoms, error messages, reproduction steps)"
2. "When did it start? (commit, deploy, config change)"
3. "What have you already tried?"

### 7 Investigation Techniques

Apply in order of likelihood. Stop when you find the root cause.

1. **Read the error** — Parse the full stack trace. Don't skim.
2. **Reproduce** — Write a minimal reproduction. If you can't reproduce, you can't verify a fix.
3. **Binary search** — `git bisect` or comment-out halves to isolate.
4. **Print debugging** — Add strategic logging at trust boundaries.
5. **Diff analysis** — Compare working vs broken state (git diff, config diff, env diff).
6. **Dependency audit** — Check versions, lockfile changes, transitive deps.
7. **Fresh eyes** — Re-read the code as if you've never seen it. Question every assumption.

### For Each Hypothesis
1. State it clearly: "I believe X causes Y because Z"
2. Design a test that can DISPROVE it
3. Run the test
4. Record result: confirmed / disproved / inconclusive

### Output
- Root cause analysis (what, where, why)
- Fix applied (or recommended)
- Regression test added (if applicable)
- Related bugs found during investigation

**Optional:** Chain with `--fix` to auto-remediate: `/autoresearch:debug --fix`
