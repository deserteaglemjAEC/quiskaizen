---
name: autoresearch
description: >
  Autonomous improvement engine. Modify -> verify -> keep/revert -> repeat.
  Triggered by: "autoresearch", "improve this", "optimize", "iterate on",
  "make this better", "run the loop", "autonomous improvement"
argument-hint: <goal or metric to optimize>
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - WebSearch
  - WebFetch
  - Agent
  - AskUserQuestion
---

# QuisKaizen Autoresearch

> Constraint + mechanical metric + autonomous iteration = compounding gains.

Inspired by [Karpathy's autoresearch](https://github.com/karpathy/autoresearch).
Improved with failure mode detection, bilevel correction, and domain-agnostic design.

## How It Works

```
SET goal + metric + scope
  |
  v
ESTABLISH baseline (run verify command, record number)
  |
  v
+---> READ state (git log, files in scope, past iterations)
|     |
|     v
|     DECIDE next change (informed by what worked, what failed, what's untried)
|     |
|     v
|     MODIFY (one focused change)
|     |
|     v
|     COMMIT: "experiment: <description>"
|     |
|     v
|     VERIFY (run metric command + guard command)
|     |
|     v
|     CLASSIFY:
|     |  improved  -> KEEP (log: keep)
|     |  regressed -> REVERT (git revert HEAD, log: revert)
|     |  crashed   -> FIX or SKIP (log: crash)
|     |  unchanged -> KEEP if simpler, else REVERT (log: neutral)
|     |
|     v
|     LOG iteration to TSV
|     |
|     v
|     CHECK failure modes (bilevel detection - see below)
|     |
|     v
+---- REPEAT (or stop if iteration limit reached)
```

## The 8 Critical Rules

1. **Loop until done.** Unbounded by default. Stop on `ctrl+c` or iteration limit.
2. **Read before write.** Understand full context before changing anything.
3. **One change per iteration.** Atomic, traceable, reversible.
4. **Mechanical verification only.** Numbers, not opinions. Exit codes, not vibes.
5. **Automatic rollback.** Failed changes revert instantly. No negotiation.
6. **Simplicity wins.** Equal metric + less code = keep the simpler version.
7. **Git as memory.** Every experiment committed. Reverts preserve history. Prefix: `experiment:`.
8. **When stuck, think harder.** Re-read context, combine near-misses, try radical changes. Don't repeat what failed.

## Bilevel Failure Mode Detection (QuisKaizen Innovation)

After every 5 iterations, run the inner failure mode checker. This is what separates QuisKaizen from basic autoresearch.

Reference: `references/failure-mode-detection.md`

| FM-ID | Failure Mode | Detection Signal | Auto-Correction |
|-------|-------------|-----------------|-----------------|
| FM-001 | TRIVIAL CONVERGENCE | >50% metric gain in iteration 1 | Inject L3+ assertions (structural, statistical) |
| FM-002 | METRIC GAMING | Score rises but output quality stagnates | Add output-level assertions, human spot-check prompt |
| FM-003 | CLUSTERING | All changes follow same structural pattern | Inject diversity objective, penalize repetition |
| FM-004 | REPETITION | Same change attempted 2+ times | Log to `tried-approaches.json`, inject "already tried" context |
| FM-005 | LOCAL OPTIMUM | <1% improvement over 5 consecutive iterations | Perturbation: revert to best-3 iterations ago, try orthogonal approach |
| FM-006 | IDEA EXHAUSTION | Only cosmetic edits remaining | Inject external knowledge (competitor analysis, reference library, user prompt) |

## 9 Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/autoresearch` | Core improvement loop | You have a NUMBER to improve |
| `/autoresearch:plan` | Setup wizard — define goal, metric, assertions | BEFORE any loop |
| `/autoresearch:fix` | Iterative error resolution | Build/test failures |
| `/autoresearch:debug` | Scientific bug hunting | Cause unknown |
| `/autoresearch:scenario` | 12-dimension edge case generation | Before shipping |
| `/autoresearch:predict` | Multi-persona expert analysis (3-8 personas) | Before big decisions |
| `/autoresearch:security` | STRIDE + OWASP + red team (4 hostile personas) | Security-sensitive code |
| `/autoresearch:ship` | 8-phase universal shipping workflow | Ready to publish |
| `/autoresearch:learn` | Autonomous documentation engine | New codebase or stale docs |

### Optimal Sequence

```
plan -> autoresearch -> scenario -> predict -> security -> ship
```

Not all steps required. Use what fits.

## Results Logging

Every iteration logged to TSV. Format:

```
iteration  commit   metric  delta  status     description
0          abc123   72      0.0    baseline   initial measurement
1          def456   75      +3     keep       added edge case tests for auth module
2          ghi789   74      -1     revert     refactored helper — broke coverage
3          jkl012   78      +3     keep       added integration tests for payment flow
```

Progress summary every 10 iterations. Include: best score, trend, failure modes detected, strategy shifts.

## Reference Protocols

Detailed workflows for each command:

- `references/autonomous-loop-protocol.md` — The 8-phase core cycle
- `references/core-principles.md` — 7 universal rules with rationale
- `references/plan-workflow.md` — Setup wizard protocol
- `references/security-workflow.md` — STRIDE + OWASP protocol
- `references/ship-workflow.md` — 8-phase shipping workflow
- `references/debug-workflow.md` — 7-technique bug hunting
- `references/fix-workflow.md` — Iterative error resolution
- `references/scenario-workflow.md` — 12-dimension edge case generation
- `references/predict-workflow.md` — Multi-persona consensus analysis
- `references/learn-workflow.md` — 4-mode documentation engine
- `references/results-logging.md` — TSV format and progress tracking
- `references/failure-mode-detection.md` — Bilevel wrapper protocol

## Crash Recovery

| Crash Type | Response |
|------------|----------|
| Syntax error | Auto-revert, log, move to next idea |
| Runtime error | Check if test-related or code-related. Fix if simple, skip if complex. |
| Resource exhaustion | Reduce scope (smaller batch, fewer files). Log and continue. |
| Timeout | Kill process, revert, try simpler approach |
| External dependency | Skip iteration, log as "blocked", continue with next idea |

## Integration with Research Workflow

QuisKaizen includes a separate research skill (`skills/research-workflow/SKILL.md`) for the 5-phase research methodology. Use it when:
- You need to UNDERSTAND before you OPTIMIZE
- The autoresearch loop needs domain knowledge to make informed changes
- You're improving content/research artifacts (not just code metrics)

Sequence: `/research-workflow <topic>` -> `/autoresearch:plan` -> `/autoresearch`
