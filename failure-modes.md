# Failure Modes of Autoresearch Iteration Loops

> Phase 1 deliverable for QuisKaizen. This document IS the spec for the outer loop.
> Without firsthand failure mode data, the bilevel wrapper would be built blind.

## Status

- 3 runs completed (Run 0, Run 1, Run 2) as of 2026-03-28
- 3 modes directly observed, 3 hypothesized
- Run 6 (25+ iterations) needed to observe exhaustion and local optimum
- Next milestone: Runs 3-6 across varied subcommands and project types

---

## Taxonomy

### FM-001: TRIVIAL CONVERGENCE

| Field | Value |
|-------|-------|
| **ID** | FM-001 |
| **Name** | TRIVIAL CONVERGENCE |
| **Category** | Execution / Assertion Design Flaw |
| **Description** | Easy assertions (L1 keyword-presence checks) converge in 1-2 iterations. The autoresearch loop terminates before generating useful iteration data because the bar is too low to fail. |
| **Detection signal** | Score jumps from baseline to 100% within 1-3 iterations. `diff prev curr | grep '^>' | awk 'NF<5' | wc -l` returns high count (trivial insertions). |
| **Example** | **Run 0:** Autoresearch hit 20/20 in 1-2 iterations -- assertions were too easy. **Run 2 config eval:** master-prompt.md scored 13/18 to 18/18 in 2 iterations; keyword-presence checks (`grep -qi 'failure'`) are trivially satisfiable. |
| **Severity** | Critical |
| **Frequency** | 3/3 runs (100%) |
| **Root cause** | L1 assertions (keyword presence) have infinite degrees of freedom -- the AI can satisfy them by inserting a single word. No structural, statistical, or relational constraints force meaningful improvement. |
| **Intervention** | Outer loop detects rapid convergence (score delta > 50% in iteration 1) and injects L3+ assertion replacements. Replace keyword checks with structural constraints (Pattern 3: sentence length variance), statistical distributions (Pattern 4: code-to-prose ratio band), or relational invariants (Pattern 5: no repeated trigrams). See `02-hard-assertion-design.md` for the full assertion difficulty taxonomy. |
| **Status** | Observed |

---

### FM-002: METRIC GAMING

| Field | Value |
|-------|-------|
| **ID** | FM-002 |
| **Name** | METRIC GAMING |
| **Category** | Execution / Goodhart's Law |
| **Description** | The eval metric improves but the actual quality of the output does not. The AI optimizes the proxy measure while the true objective (usefulness, depth, accuracy) stagnates or degrades. |
| **Detection signal** | High eval score (90-100%) but human spot-check reveals shallow, formulaic, or mechanically-compliant output. Config assertions pass on keyword presence alone; content accuracy is unchecked. |
| **Example** | **Run 1:** Validation only checked file existence, link resolution, and file size -- not content accuracy. Score of 100% was trivially achievable. `changelog.md` (21 lines) and `project-overview-pdr.md` (49 lines) were thin despite passing all checks. **Run 2:** Config assertions checked keyword presence (e.g., "does the config mention failure stories?") but not whether the failure story guidance was actionable or well-written. |
| **Severity** | Critical |
| **Frequency** | 2/3 runs (Run 1 and Run 2; Run 0 converged too fast to exhibit gaming) |
| **Root cause** | Proxy-quality gap. When the measure becomes the target, it ceases to be a good measure (Goodhart's Law). Eval scripts check observable surface features (file exists, keyword present, line count met) rather than latent quality properties (accuracy, depth, coherence). Source: OpenAI "Measuring Goodhart's Law" (2022). |
| **Intervention** | Outer loop injects multi-dimensional scoring (Pattern 12: composite score with diminishing returns), human spot-check protocol at iteration 5/10/15, and output-level assertions that test generated artifacts rather than config keywords. The key insight from Run 2: "The eval script design is where the real value lives, not the autoresearch loop." |
| **Status** | Observed |

---

### FM-003: CLUSTERING

| Field | Value |
|-------|-------|
| **ID** | FM-003 |
| **Name** | CLUSTERING |
| **Category** | Execution / Mode Collapse |
| **Description** | The agent repeats the same approach category across iterations. All outputs converge to identical structure, vocabulary, and cross-reference patterns. Diversity of exploration collapses. |
| **Detection signal** | Cosine similarity between consecutive iteration outputs exceeds 0.85. All generated sections share identical structure. "Related Documents" blocks are copy-pasted across files. Trigram overlap across sections exceeds threshold (Pattern 5 detection). |
| **Example** | **Run 1:** All 8 generated docs shared identical structure. Formulaic cross-references appeared verbatim in every file. "Related Documents" sections were identical across all docs. The agent found one structural template that worked and applied it uniformly. |
| **Severity** | Medium |
| **Frequency** | 1/3 runs (Run 1 only; minor manifestation) |
| **Root cause** | The agent lacks a diversity objective. Once a structural pattern passes assertions, the agent has no incentive to vary its approach. Standard autoresearch optimizes for score, not for exploration breadth. |
| **Intervention** | Outer loop tracks approach categories per iteration (structural template, vocabulary distribution, section ordering) and injects a diversity constraint when clustering is detected: "Your last 3 iterations used identical document structure. Try a fundamentally different organization pattern." Pattern 5 (no repeated trigrams across sections) also directly penalizes clustering. |
| **Status** | Observed |

---

### FM-004: REPETITION

| Field | Value |
|-------|-------|
| **ID** | FM-004 |
| **Name** | REPETITION |
| **Category** | Execution / Memory Failure |
| **Description** | The agent retries approaches that were previously attempted and reverted, despite git history showing they failed. The agent lacks effective memory of what has already been tried. |
| **Detection signal** | `git log --oneline` shows revert-then-retry patterns. Diff between iteration N and iteration N+3 is near-zero (the agent circled back). Edit strategy descriptions in consecutive iterations share >80% similarity. |
| **Example** | Described in the known failure modes taxonomy (handoff file) but NOT directly witnessed in Runs 0-2. Runs were too short (1-5 iterations) to surface repetition -- it is expected to emerge at 10+ iterations when the agent's context window fills and earlier attempts scroll out of view. |
| **Severity** | High |
| **Frequency** | 0/3 runs (not yet observed) |
| **Root cause** | Context window limitations. As iterations accumulate, early attempts exit the visible context. The agent cannot consult git history unprompted. Without explicit "already tried" tracking, the agent treats each iteration as if starting fresh. |
| **Intervention** | Outer loop maintains a sidecar file (`tried-approaches.json`) logging every approach category, its score delta, and whether it was kept or reverted. Before each iteration, the outer loop injects: "These approaches have already been tried and failed: [list]. Do not retry them." |
| **Status** | Hypothesized |

---

### FM-005: LOCAL OPTIMUM

| Field | Value |
|-------|-------|
| **ID** | FM-005 |
| **Name** | LOCAL OPTIMUM |
| **Category** | Execution / Convergence Trap |
| **Description** | Score improvements shrink to negligible deltas (+/- 1-2 points) for 5+ consecutive iterations. The loop is stuck in a valley -- each change is too small to escape the current solution neighborhood, but the score is not high enough to terminate. |
| **Detection signal** | Score oscillates within a band of +/- 2 points for 5+ iterations. `score_history.json` shows a plateau pattern. Iteration diffs are small (< 20 changed lines) but score does not meaningfully improve. |
| **Example** | NOT directly witnessed in Runs 0-2. Runs terminated too quickly (1-5 iterations). Expected to manifest in Run 6 (25+ iterations on a project with hard assertions), where the agent should hit a ceiling around iteration 15-20. |
| **Severity** | High |
| **Frequency** | 0/3 runs (not yet observed) |
| **Root cause** | Gradient-free search in a rugged fitness landscape. The agent makes incremental edits (local moves) that cannot cross valleys to reach higher peaks. Without a mechanism for large structural jumps (analogous to simulated annealing or crossover in genetic algorithms), the agent converges on the nearest local maximum. |
| **Intervention** | Outer loop detects plateau (score variance < 2 over 5 iterations) and injects a "perturbation" strategy: "Your score has plateaued at N. Make a large structural change -- reorganize sections, switch the dominant pattern, or introduce a new dimension. Small edits will not improve from here." If perturbation fails after 2 attempts, the outer loop triggers a strategy reset (revert to best-scoring iteration and try a completely different approach category). |
| **Status** | Hypothesized |

---

### FM-006: IDEA EXHAUSTION

| Field | Value |
|-------|-------|
| **ID** | FM-006 |
| **Name** | IDEA EXHAUSTION |
| **Category** | Execution / Hypothesis Depletion |
| **Description** | The agent runs out of meaningful hypotheses after ~15 iterations and resorts to random, degenerate, or cosmetic changes (whitespace edits, comment rewording, synonym swaps) that do not affect the eval score. |
| **Detection signal** | Iteration diffs are cosmetic: whitespace changes, synonym substitutions, comment edits. Score delta is exactly 0 for 3+ consecutive iterations. Substantive line ratio (lines with >10 words in diff) drops below 30%. Pattern 10 (diff-based novelty check) fails. |
| **Example** | NOT directly witnessed in Runs 0-2. Per the bilevel paper (arXiv 2603.23420) and Karpathy's original autoresearch observations, exhaustion typically manifests at iteration 15-25 depending on problem complexity. Run 6 (25+ iterations, push until stuck) is specifically designed to observe this mode. |
| **Severity** | High |
| **Frequency** | 0/3 runs (not yet observed; need Run 6 at 25+ iterations) |
| **Root cause** | Finite hypothesis space within a single agent's reasoning capacity. The agent samples from a distribution of "things to try" that is bounded by its training data and current context. Once high-probability strategies are exhausted, the agent falls to low-probability noise. No external knowledge injection mechanism exists in standard autoresearch. |
| **Intervention** | Outer loop detects exhaustion (3+ iterations with score delta = 0 and low diff novelty) and injects new search directions from an external source: competitor analysis results, domain-specific patterns from a reference library, or entirely new assertion categories. The bilevel paper's key mechanism: the outer loop "generates new search mechanisms and injects them at runtime," effectively expanding the inner loop's hypothesis space. |
| **Status** | Hypothesized |

---

## Observations Log

### Run 0 (2026-03-28) -- ai-research-workflow repo

- **Subcommands exercised:** plan, core loop (2 iter), scenario (10 iter), predict (4 personas), security (5 iter), ship
- **Key finding:** Autoresearch hit 20/20 in 1-2 iterations. Assertions were too easy. This is FM-001 (TRIVIAL CONVERGENCE) in its purest form -- the loop had nothing to push against.
- **Secondary finding:** `/autoresearch:plan` wizard is critical for deriving eval criteria from user answers instead of guessing. Without it, assertions are subjective and default to L1.
- **Scenario subcommand found:** 2 CRITICAL failure modes (context exhaustion, hollow artifact detection) that the core loop would never find. Predict surfaced 3 must-fix issues that scenario missed.
- **Failure modes observed:** FM-001 (TRIVIAL CONVERGENCE). No others surfaced -- runs were too short.

### Run 1 (2026-03-28) -- kinetide-recon-guide (Vite + React + Tailwind)

- **Command:** `learn --mode init` (single-pass, not iterative)
- **Output:** 8 docs, 855 lines. Validation passed 100% first try. Zero fix iterations.
- **Key finding:** Init mode is deterministic, not iterative -- it does not exercise the autoresearch loop at all. Validation only checks file existence + link resolution + file size.
- **Failure modes observed:**
  - FM-002 (METRIC GAMING): 100% score was trivially achievable because validation checks existence, not content accuracy. Thin documents (`changelog.md` at 21 lines, `project-overview-pdr.md` at 49 lines) passed all checks.
  - FM-003 (CLUSTERING): All 8 docs shared identical structure with formulaic cross-references. "Related Documents" sections copied verbatim across files.
- **Issues encountered:** Vercel plugin false positives on Vite project; macOS `grep -P` incompatibility; missing `validate-docs.cjs` script (hardest validation check skipped entirely).

### Run 2 (2026-03-28) -- Tweet Builder system

- **Commands:** Autoresearch core loop, 2 sub-runs (config eval + output eval)
- **Config eval:** master-prompt.md 13/18 to 18/18 in 2 iterations. Added content sources, human-in-the-loop, line limits, failure story hooks.
- **Output eval:** `eval-tweet-output.sh` built from scratch (15 assertions + rubric). Baseline 91/100 to 100/100 in 5 iterations. Fixed eval bugs (quoting issues gave 4/15 false failures in v1).
- **Key findings:**
  - FM-001 (TRIVIAL CONVERGENCE): Config keyword checks converge in 1-2 iterations, same pattern as Run 0.
  - FM-002 (METRIC GAMING confirmed): Config assertions check keyword presence, not quality of content. "Does the config mention failure stories?" passes regardless of whether the guidance is useful.
  - Output eval was harder and more productive: tweet output eval caught real issues (long lines, missing hook patterns for failure stories) that config eval could never see.
- **Critical insight:** "The eval script design is where the real value lives, not the autoresearch loop. Easy assertions make the loop trivial. Hard assertions (checking generated output, not config keywords) produce meaningful iterations."
- **Eval bug lesson:** First eval script version had quoting issues causing 4/15 false failures. The eval script itself is high-leverage code that needs meta-testing (see `02-hard-assertion-design.md`, Meta-Testing Guide).

---

## Summary Table

| ID | Name | Category | Severity | Frequency | Status |
|----|------|----------|----------|-----------|--------|
| FM-001 | TRIVIAL CONVERGENCE | Assertion Design Flaw | Critical | 3/3 (100%) | Observed |
| FM-002 | METRIC GAMING | Goodhart's Law | Critical | 2/3 (67%) | Observed |
| FM-003 | CLUSTERING | Mode Collapse | Medium | 1/3 (33%) | Observed |
| FM-004 | REPETITION | Memory Failure | High | 0/3 (0%) | Hypothesized |
| FM-005 | LOCAL OPTIMUM | Convergence Trap | High | 0/3 (0%) | Hypothesized |
| FM-006 | IDEA EXHAUSTION | Hypothesis Depletion | High | 0/3 (0%) | Hypothesized |

---

## Next Steps

1. **Run 3-5:** Exercise `security`, `scenario`, and `predict --chain debug` with L3+ assertions to surface FM-004 (REPETITION) and FM-005 (LOCAL OPTIMUM).
2. **Run 6 (CRITICAL):** 25+ iterations on a project with hard assertions. Push until stuck. Primary target for observing FM-005 and FM-006.
3. **After 6+ runs:** Revisit this taxonomy. Promote hypothesized modes to observed (or discard if not seen after 25+ iterations). Add any new modes discovered.
4. **This document feeds Phase 2:** The outer loop's detection logic will be derived directly from the "Detection signal" fields. The intervention strategies become the outer loop's correction playbook.
