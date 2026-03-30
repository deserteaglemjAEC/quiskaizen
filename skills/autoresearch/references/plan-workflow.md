# Plan Workflow Protocol

Interactive wizard for configuring an autoresearch loop. Run BEFORE optimization.

## Step 1: Goal Definition

**Ask:** "What are you trying to improve? Describe the current state and desired state."

Extract:
- Target: what file/system/artifact to optimize
- Baseline: current state ("tests pass at 72%", "page loads in 3.2s")
- Desired: target state ("90% coverage", "under 1s load time")

## Step 2: Scope Setting

**Ask:** "Which files should I modify? Which are off-limits?"

- Infer from goal if obvious (e.g., "test coverage" → `src/**/*.test.ts` + `src/**/*.ts`)
- Confirm with user
- Output: include glob + exclude glob

## Step 3: Metric Selection

**Ask:** "How do I measure if a change helped? Give me a command that outputs a number."

If the user doesn't know, suggest:

| Domain | Metric | Command Example |
|--------|--------|----------------|
| Testing | Coverage % | `npm test -- --coverage \| grep "All files"` |
| Performance | Response time | `curl -w "%{time_total}" -s -o /dev/null http://localhost:3000` |
| Bundle size | KB | `du -sk dist/ \| cut -f1` |
| Lint | Error count | `npm run lint 2>&1 \| grep -c "error"` |
| Research | Eval score | `bash eval-research-artifact.sh artifact.md \| tail -1` |
| Content | Word count | `wc -w < output.md` |

**Validate:** Run the command once. Capture baseline number. Confirm direction (higher_is_better / lower_is_better).

## Step 4: Guard Definition

**Ask:** "Is there anything that must NEVER break while I optimize?"

Examples:
- `npm test` (all tests must pass)
- `tsc --noEmit` (types must compile)
- `npm run build` (build must succeed)

Default: none. But recommend at least one guard for code optimization.

## Step 5: Assertion Design

**Ask two questions:**
1. "What makes you NOT trust this output?"
2. "What makes this USEFUL to you?"

Convert answers into binary assertions:
- Each assertion = shell command that exits 0 (pass) or 1 (fail)
- Target: 10-20 assertions minimum
- Categorize: Trust, Usefulness, Rigor, Structure

**Critical:** Design L2+ assertions (structural, statistical), not L1 (keyword presence). Reference FM-001 in `failure-mode-detection.md` — keyword-presence assertions converge trivially.

Good assertion examples:
- `test $(grep -c "^##" artifact.md) -ge 5` (at least 5 H2 sections)
- `test $(wc -l < output.md) -le 500` (under 500 lines — density check)
- `grep -q "Sources" artifact.md && test $(sed -n '/^## Sources/,/^##/p' artifact.md | grep -c "^[0-9]") -ge 10` (10+ numbered sources)

Bad assertion examples:
- `grep -qi "research" artifact.md` (trivially satisfiable)
- `test -f output.md` (existence check — not meaningful)

## Step 6: Iteration Strategy

**Ask:** "Should I run N iterations and stop, or loop until you interrupt?"

Options:
- Unbounded (default) — loop forever, stop on `ctrl+c`
- Bounded — run exactly N iterations
- Target — stop when metric reaches specific value

## Output: Configuration Block

```
Goal: <goal description>
Scope: <include glob> (exclude: <exclude glob>)
Metric: <command> (<higher_is_better|lower_is_better>)
Baseline: <number>
Target: <number or "unbounded">
Guard: <command or "none">
Iterations: <N or "unbounded">
Assertions: <path to eval script or "none">
```

Save to `.autoresearch-config` in project root if user approves.
