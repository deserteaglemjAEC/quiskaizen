# Autonomous Loop Protocol

The 8-phase core cycle. Execute exactly in this order. No shortcuts.

## Phase 1: Read State

```
- Read git log (last 10 commits) to understand recent changes
- Read all files in scope (glob pattern from config)
- Read TSV log (if exists) to see past iterations
- Read tried-approaches.json (if exists) to avoid repeating
```

**Output:** Mental model of current state + what's been tried.

## Phase 2: Decide Next Change

Pick ONE change based on this priority:

1. **Low-hanging fruit** — obvious improvements not yet tried
2. **Near-misses** — iterations that almost worked (reverted with small regression)
3. **Combinations** — merge ideas from 2+ successful iterations
4. **Orthogonal** — try a completely different approach from everything so far
5. **Radical** — challenge a core assumption (only when stuck)

**Output:** Clear description of what you'll change and why.

## Phase 3: Modify

- Make ONE focused change
- Keep the diff small and readable
- Don't refactor while optimizing (separate concerns)

## Phase 4: Commit

```bash
git add <changed files>
git commit -m "experiment: <description of change>"
```

Commit BEFORE verification. This preserves experiment history even for failures.

## Phase 5: Verify

Run the verify command from config:

```bash
<verify_command>  # Captures the metric number
<guard_command>   # Must also pass (if configured)
```

Extract the metric value. Compare against previous iteration.

## Phase 6: Classify

| Condition | Action | Log Status |
|-----------|--------|------------|
| Metric improved AND guard passed | Keep | `keep` |
| Metric improved BUT guard failed | Revert | `revert` |
| Metric unchanged, code simpler | Keep | `neutral-keep` |
| Metric unchanged, code more complex | Revert | `neutral-revert` |
| Metric regressed | Revert | `revert` |
| Verify command crashed | Fix if trivial, else revert | `crash` |

Revert command: `git revert HEAD --no-edit`

## Phase 7: Log

Append to TSV file:

```
<iteration>	<commit_hash>	<metric_value>	<delta>	<status>	<description>
```

Every 10 iterations, output a progress summary:
- Best score achieved (and which iteration)
- Current score
- Trend (improving / plateauing / oscillating)
- Failure modes detected (reference FM-IDs)
- Strategy for next 10 iterations

## Phase 8: Repeat

- If iteration limit reached → stop, output final summary
- If `ctrl+c` → stop gracefully, output what you have
- Every 5 iterations → run failure mode detection (see `failure-mode-detection.md`)
- Otherwise → return to Phase 1
