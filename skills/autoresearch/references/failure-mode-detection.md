# Failure Mode Detection Protocol (Bilevel Wrapper)

This is QuisKaizen's core innovation. Standard autoresearch loops break down in
predictable ways. This protocol detects those failures and auto-corrects.

Based on empirical observations from QuisKaizen Runs 0-2 and the bilevel
autoresearch design (arXiv 2603.23420).

## When to Run

- **Every 5 iterations** during the core autoresearch loop
- **On plateau detection** (3+ iterations with <1% improvement)
- **On rapid convergence** (>50% of target achieved in iteration 1)

## The 6 Failure Modes

### FM-001: TRIVIAL CONVERGENCE
**Category:** Assertion Design Flaw
**Severity:** Critical
**Observed:** 100% of QuisKaizen runs

**Detection:**
```
IF iteration_1_delta > 50% of (target - baseline)
THEN FM-001 triggered
```

**Signal:** The loop hits near-perfect score in 1-2 iterations. Assertions are too
easy — L1 keyword-presence checks that any LLM can satisfy trivially.

**Auto-Correction:**
1. Flag current assertions as L1 (trivially satisfiable)
2. Inject L2 assertions (structural checks):
   - Count sections: `test $(grep -c "^##" file.md) -ge 5`
   - Check density: `test $(wc -l < file.md) -le 500`
   - Verify structure: section ordering, required sections present
3. Inject L3 assertions (statistical/relational checks):
   - Source diversity: `test $(grep -c "unique-domain" sources) -ge 8`
   - Cross-references: sections reference each other
   - Output-level: test the GENERATED artifact, not the config
4. Re-run baseline with new assertions
5. Resume loop

**Key insight:** "The eval script design is where the real value lives, not the
autoresearch loop. Easy assertions make the loop trivial."

---

### FM-002: METRIC GAMING (Goodhart's Law)
**Category:** Optimization Pathology
**Severity:** Critical
**Observed:** 67% of QuisKaizen runs

**Detection:**
```
IF metric_score > 90%
AND output_quality_heuristic < threshold
THEN FM-002 triggered
```

Output quality heuristics:
- File size suspiciously small (< 50 lines for a "comprehensive" artifact)
- Repetitive structure (>3 sections with identical format)
- Keywords present but context is shallow

**Signal:** Score rises but the actual output is thin, repetitive, or gaming the
assertions without delivering real value.

**Auto-Correction:**
1. Add output-level assertions that test generated artifacts:
   - Content depth: `test $(wc -w < artifact.md) -ge 1000`
   - Unique sentences: no copy-paste between sections
   - Actionable content: specific tool names, commands, file paths
2. Add composite scoring with diminishing returns:
   - First 10 assertions: 1 point each
   - Assertions 11-15: 0.5 points each (harder, more specific)
   - Assertions 16-20: 0.25 points each (output-quality checks)
3. Prompt human spot-check at iterations 5, 10, 15:
   - `AskUserQuestion: "Quick check — does iteration N's output actually look good to you?"`
4. Resume loop with harder assertions

---

### FM-003: CLUSTERING (Mode Collapse)
**Category:** Exploration Failure
**Severity:** Medium
**Observed:** 33% of QuisKaizen runs

**Detection:**
```
IF last_5_changes all modify same file/section
OR last_5_changes all follow same structural pattern
THEN FM-003 triggered
```

**Signal:** All changes are variations of the same idea. The agent found one
strategy that works and keeps repeating it instead of exploring.

**Auto-Correction:**
1. Log the dominant pattern: "Agent is stuck on [pattern]"
2. Inject diversity constraint: "Next change must target a DIFFERENT file/section than the last 3"
3. Suggest orthogonal approaches:
   - If agent is adding content → try restructuring
   - If agent is restructuring → try removing content
   - If agent is optimizing one metric → switch to a different dimension
4. Resume loop with diversity constraint active for 5 iterations

---

### FM-004: REPETITION (Memory Failure)
**Category:** Context Limitation
**Severity:** High
**Observed:** Hypothesized (expected at 10+ iterations)

**Detection:**
```
IF current_change_description matches any entry in tried-approaches.json
THEN FM-004 triggered
```

**Signal:** Agent attempts the same change it already tried (and reverted). This
happens when context window fills up and early iterations scroll out.

**Auto-Correction:**
1. Maintain `tried-approaches.json` sidecar file:
   ```json
   [
     {"iteration": 3, "description": "refactored auth middleware", "status": "revert", "reason": "broke session handling"},
     {"iteration": 5, "description": "added caching layer", "status": "revert", "reason": "stale data on update"}
   ]
   ```
2. Inject file contents at start of each iteration: "You already tried these approaches and they failed: [list]"
3. If repetition persists: `AskUserQuestion: "I'm running out of new ideas. Should I try a radically different approach, or stop here?"`

---

### FM-005: LOCAL OPTIMUM (Convergence Trap)
**Category:** Search Space Limitation
**Severity:** High
**Observed:** Hypothesized (expected at 15-20 iterations)

**Detection:**
```
IF best_score has not improved by >1% in last 5 iterations
AND at least 15 iterations completed
THEN FM-005 triggered
```

**Signal:** Score plateaus. Small tweaks no longer help. The agent is stuck on a
local maximum.

**Auto-Correction:**
1. **Perturbation strategy:**
   - Save current best state: `git tag best-score-iter-N`
   - Revert to state from 3 iterations ago (best-of-recent, not current)
   - Try orthogonal approach (different strategy entirely)
2. **Ensemble strategy:**
   - Take top 3 scoring iterations
   - Attempt to combine their changes
3. **Constraint relaxation:**
   - Temporarily remove 1-2 guard constraints
   - Optimize freely for 3 iterations
   - Re-add guards and verify
4. If plateau persists after 5 correction iterations:
   - `AskUserQuestion: "I've plateaued at [score]. Do you want me to try a radical restructure, or is this good enough?"`

---

### FM-006: IDEA EXHAUSTION (Hypothesis Depletion)
**Category:** Fundamental Limit
**Severity:** High
**Observed:** Hypothesized (expected at 15-25 iterations)

**Detection:**
```
IF last_3_changes are all cosmetic (formatting, comments, whitespace)
AND metric_delta for all 3 is 0 or negative
THEN FM-006 triggered
```

**Signal:** Agent has run out of meaningful ideas. Only making cosmetic changes
that don't affect the metric.

**Auto-Correction:**
1. **External knowledge injection:**
   - Search for competitor/reference implementations
   - Read documentation for tools/libraries in scope
   - Fetch best practices from web
2. **Strategy prompt:**
   - "What assumption about this system have you NOT questioned?"
   - "What would an expert in [domain] suggest?"
   - "What's the most controversial change you could make?"
3. **User consultation:**
   - `AskUserQuestion: "I've exhausted my ideas at [score]. Can you suggest a direction I haven't tried?"`
4. **Graceful termination:**
   - If user has no suggestions: stop the loop, output final summary
   - Tag final state: `git tag autoresearch-final-iter-N`

---

## Detection Implementation

Run this check after every 5th iteration:

```
function check_failure_modes(iterations, log):
    # FM-001: Trivial convergence
    if iterations[1].delta > 0.5 * (target - baseline):
        trigger(FM-001)

    # FM-002: Metric gaming
    if current_score > 0.9 * target:
        run output_quality_heuristics()

    # FM-003: Clustering
    last_5 = log[-5:]
    if all_same_pattern(last_5):
        trigger(FM-003)

    # FM-004: Repetition
    if current_description in tried_approaches:
        trigger(FM-004)

    # FM-005: Local optimum
    if iterations >= 15 and max_delta_last_5 < 0.01 * target:
        trigger(FM-005)

    # FM-006: Idea exhaustion
    if last_3_are_cosmetic(log[-3:]):
        trigger(FM-006)
```

## Key Principle

> The outer loop (failure mode detection) makes the inner loop (autoresearch)
> self-correcting. Without it, autoresearch degrades predictably. With it,
> autoresearch can push past the barriers that stop basic optimization loops.

This is the bilevel design: inner loop optimizes the metric, outer loop optimizes
the inner loop's strategy.
