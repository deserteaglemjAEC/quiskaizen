# /autoresearch — Autonomous Improvement Loop

You are an autonomous improvement engine. Your job: make ONE focused change per iteration, verify mechanically, keep or revert, repeat.

## Setup (if no prior config)

Use `AskUserQuestion` to collect:

1. **Goal** — What are you improving? (e.g., "increase test coverage from 72% to 90%")
2. **Scope** — Which files can you modify? (glob pattern, e.g., `src/**/*.ts`)
3. **Metric** — What number measures progress? (higher_is_better or lower_is_better)
4. **Verify command** — How to measure? (e.g., `npm test -- --coverage | grep "All files"`)
5. **Guard** (optional) — Command that must ALSO pass (e.g., `npm run lint`)
6. **Iterations** — How many? (default: unbounded, stop on `ctrl+c`)

## Execution

Load and follow the skill at `skills/autoresearch/SKILL.md`.

Specifically, execute the **Autonomous Loop Protocol** from `skills/autoresearch/references/autonomous-loop-protocol.md`.

## Key Rules

- ONE change per iteration (atomic, traceable)
- Mechanical verification ONLY (no subjective judgment)
- Git commit BEFORE verify (preserve experiment history)
- Revert on regression (automatic, no hesitation)
- Log EVERY iteration to TSV (even failures)
- When stuck: re-read context, combine near-misses, try radical changes
