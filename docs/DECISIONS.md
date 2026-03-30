# Key Decisions & Cross-Session Context

This file captures design decisions, rejected alternatives, and context that
future Claude Code sessions need to work effectively on QuisKaizen.

Last updated: 2026-03-30

---

## Project Evolution

### claude-kaizen -> QuisKaizen
- **claude-kaizen** (old repo) was a Claude Code plugin that auto-graded responses
  via Haiku (5 dimensions x 20 pts, threshold 80/100) and learned across sessions
  (error registry, skillbook, solution library). Python-based, hook-driven.
- **QuisKaizen** started as a methodology-only repo (research workflow + mental model)
  then evolved into a full plugin with autoresearch capabilities.
- The name combines "Quis" (Latin: who/what) + "Kaizen" (continuous improvement).

### Why we moved away from claude-kaizen's approach
- Hook-based grading was brittle and added latency to every session
- Haiku grading another model's output was clever but expensive at scale
- The real value was in the METHODOLOGY, not the automation wrapper
- QuisKaizen keeps the methodology-first approach but adds automation incrementally

## Autoresearch Architecture

### Inspiration chain
1. **Karpathy's autoresearch** (github.com/karpathy/autoresearch) — the original.
   Single file, single metric (val_bpb), 5-min experiments, ~100 overnight.
   42k stars in first week. Shopify got 53% faster rendering from 120 experiments.
2. **Udit Goenka's fork** (github.com/uditgoenka/autoresearch) — generalized to
   any domain. 9 commands, 8-phase loop, guard commands, crash recovery. Claude
   Code skill format.
3. **QuisKaizen** — matches Udit's command structure, adds bilevel failure mode
   detection (our key differentiator), integrates 5-phase research workflow.

### The 9-command architecture (decided 2026-03-30)
Matches Udit's structure for familiarity, but each command references our own
protocol documents with QuisKaizen-specific improvements:

| Command | Key improvement over Udit's version |
|---------|-------------------------------------|
| `/autoresearch` | Bilevel failure mode detection every 5 iterations |
| `/autoresearch:plan` | L1/L2/L3 assertion levels, FM-001 prevention |
| `/autoresearch:security` | Same (STRIDE + OWASP + 4 personas) |
| `/autoresearch:ship` | Same (8-phase universal shipping) |
| `/autoresearch:debug` | Same (7 techniques, hypothesis protocol) |
| `/autoresearch:fix` | Same (priority ordering, stuck protocol) |
| `/autoresearch:scenario` | Same (12 dimensions) |
| `/autoresearch:predict` | Same (5 default personas, synthesis matrix) |
| `/autoresearch:learn` | Same (4 modes: init/update/check/summarize) |

### Why bilevel failure mode detection matters
Standard autoresearch loops break down predictably:
- **FM-001 (Trivial Convergence):** Observed 100% of runs. Easy assertions = trivial loop.
- **FM-002 (Metric Gaming):** Observed 67%. Score rises, quality doesn't.
- **FM-003 (Clustering):** Observed 33%. Agent repeats one strategy endlessly.
- **FM-004-006:** Hypothesized for longer runs (repetition, local optima, idea exhaustion).

Neither Karpathy nor Udit address these. Our outer loop detects and auto-corrects.
This is documented in `failure-modes.md` (empirical data) and
`skills/autoresearch/references/failure-mode-detection.md` (protocol).

## Plugin Structure Decisions

### Directory layout (decided 2026-03-30)
```
commands/           <- Command registration (what users invoke)
skills/autoresearch/ <- Skill + reference protocols (how commands work)
skills/research-workflow/ <- Research skill (separate from autoresearch)
```

**Why separate commands/ from skills/:** Commands are thin (what to do + pointer
to skill). Skills are deep (full protocol). This matches Claude Code plugin
conventions and keeps commands scannable.

**Why keep research-workflow separate:** It's a standalone skill that works
without autoresearch. The sequence is: research -> plan -> autoresearch.
Not everything needs the loop.

### Version bumped to 4.0.0
- v1-2: Research workflow iterations
- v3.0.0: Plugin packaging, CI, visual assets
- v4.0.0: Full autoresearch command suite + bilevel detection

## Research Workflow Decisions

### The 5-phase workflow is stable
Discover -> Read Primaries -> Synthesize -> Cross-Examine -> Distill.
This hasn't changed since v1.0 and shouldn't change without strong reason.

### Multi-model requirement is non-negotiable
Phase 3 (Synthesize) MUST use a different model than Phase 1-2. Same-model
synthesis amplifies blind spots. This is baked into assertions.

### Eval assertions are the real product
Key insight from Run 2: "The eval script design is where the real value lives,
not the autoresearch loop. Easy assertions make the loop trivial. Hard assertions
produce meaningful iterations."

## What's NOT Built Yet

- Automated bilevel wrapper execution (protocol is defined, not automated)
- Plugin marketplace distribution
- Cross-session learning persistence (beyond git + memory)
- Community skill contributions framework

## Rejected Alternatives

- **Mermaid diagrams:** Rejected for ASCII. Terminal compatibility matters more.
- **Application code / build system:** This is methodology + skill definitions.
  No package.json, no Python dependencies, no runtime.
- **Single monolithic SKILL.md:** Rejected for modular references/ directory.
  Each protocol can be loaded independently, reducing context usage.
