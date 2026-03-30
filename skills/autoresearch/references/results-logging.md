# Results Logging Protocol

Standard format for tracking autoresearch iterations. Every command logs here.

## TSV Format

File: `autoresearch-results.tsv` (in project root or `data/` directory)

```
iteration	commit	metric	delta	status	description
```

| Column | Type | Description |
|--------|------|-------------|
| iteration | int | 0-indexed. 0 = baseline measurement. |
| commit | string | Short commit hash (7 chars). `-` if no commit (baseline). |
| metric | number | The measured value after this iteration. |
| delta | number | Change from previous iteration. `+3`, `-1`, `0.0` for baseline. |
| status | enum | `baseline`, `keep`, `revert`, `neutral-keep`, `neutral-revert`, `crash`, `skip`, `blocked` |
| description | string | What was attempted. Keep concise (under 80 chars). |

## Status Definitions

| Status | Meaning |
|--------|---------|
| `baseline` | Initial measurement before any changes. Always iteration 0. |
| `keep` | Metric improved. Change retained. |
| `revert` | Metric regressed or guard failed. Change reverted via `git revert`. |
| `neutral-keep` | Metric unchanged but code is simpler. Change retained. |
| `neutral-revert` | Metric unchanged and code is more complex. Change reverted. |
| `crash` | Verify command failed to execute. Change reverted. |
| `skip` | Iteration skipped (blocked dependency, stuck on same error 3x). |
| `blocked` | Error persists after 3 attempts. Flagged for human review. |

## Progress Summaries

Output every 10 iterations:

```
=== Progress Summary (iterations 0-10) ===
Best score:    78 (iteration 7)
Current score: 76 (iteration 10)
Trend:         improving (6 keeps, 3 reverts, 1 crash)
Failure modes: FM-001 not detected, FM-004 detected (repeated attempt at iter 8-9)
Strategy:      Continue with integration test additions. Avoid auth module (3 reverts).
Next target:   80 (need +4 from current)
===
```

## Multiple Metrics

If tracking more than one metric (e.g., coverage + test count):

```
iteration	commit	metric_1	metric_2	delta_1	delta_2	status	description
```

Primary metric determines keep/revert. Secondary metrics are informational.

## File Location

Default: `./autoresearch-results.tsv`
If `data/` directory exists: `./data/autoresearch-results.tsv`

Add to `.gitignore` if results are ephemeral. Commit if results are part of the project record (like QuisKaizen's own iteration data).
