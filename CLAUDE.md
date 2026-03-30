# QuisKaizen — Project Context for Claude Code

## What This Is

QuisKaizen is an **autonomous improvement plugin** for Claude Code. It provides 9 autoresearch commands (inspired by [Karpathy's autoresearch](https://github.com/karpathy/autoresearch)) plus a 5-phase research workflow, a mental model for AI-assisted work, and a binary assertion evaluation system.

The key innovation over other autoresearch implementations is **bilevel failure mode detection** — an outer loop that detects when the inner optimization loop breaks down (trivial convergence, metric gaming, clustering, repetition, local optima, idea exhaustion) and auto-corrects.

## File Map

| Path | Purpose |
|------|---------|
| `commands/autoresearch.md` | Main `/autoresearch` command (core improvement loop) |
| `commands/autoresearch/*.md` | 8 subcommands: plan, debug, fix, scenario, predict, security, ship, learn |
| `skills/autoresearch/SKILL.md` | Autoresearch skill definition (8-phase loop, bilevel detection, 9 commands) |
| `skills/autoresearch/references/` | 12 detailed protocol documents for each workflow |
| `skills/research-workflow/SKILL.md` | 5-phase research workflow skill |
| `README.md` | Project overview, installation, quick start |
| `MENTAL-MODEL.md` | 3-Question Router, 3 Layers, Validation Chain framework |
| `failure-modes.md` | Empirical failure mode analysis from Runs 0-2 |
| `scripts/eval-research-artifact.sh` | 20 binary assertions for research artifact quality |
| `eval/eval-skill.sh` | 41 binary assertions for SKILL.md quality |
| `resources/` | Discovery guide, source hierarchy, cross-exam prompts, artifact template |
| `CONTRIBUTING.md` | How to contribute |
| `LICENSE` | MIT |

## Plugin Architecture

```
quiskaizen/
├── .claude-plugin/plugin.json          Plugin manifest
├── commands/                           9 command registration files
│   ├── autoresearch.md                 /autoresearch (core loop)
│   └── autoresearch/                   Subcommands
│       ├── plan.md                     /autoresearch:plan
│       ├── debug.md                    /autoresearch:debug
│       ├── fix.md                      /autoresearch:fix
│       ├── scenario.md                 /autoresearch:scenario
│       ├── predict.md                  /autoresearch:predict
│       ├── security.md                 /autoresearch:security
│       ├── ship.md                     /autoresearch:ship
│       └── learn.md                    /autoresearch:learn
├── skills/
│   ├── autoresearch/                   Autoresearch skill
│   │   ├── SKILL.md                    Skill entry point
│   │   └── references/                 12 protocol documents
│   └── research-workflow/              Research workflow skill
│       ├── SKILL.md
│       ├── resources/
│       └── scripts/
├── eval/                               Evaluation scripts
├── scripts/                            Utility scripts
└── data/                               Iteration logs (TSV)
```

## Standards

- **Markdown style:** Direct, practical, no marketing speak. Tables for comparisons. ASCII diagrams for terminal readability (no Mermaid).
- **Eval assertions:** Must be mechanical (shell command), binary (pass/fail), and justified (explain why it matters).
- **Protocol documents:** Each command has a matching reference protocol in `skills/autoresearch/references/`.
- **Failure modes:** Document empirically. Reference FM-IDs. Include detection signals and auto-correction strategies.

## Running the Evals

```bash
# Research artifact quality (20 assertions)
bash scripts/eval-research-artifact.sh <path-to-artifact.md>

# SKILL.md quality (41 assertions)
bash eval/eval-skill.sh
```

## The 9 Commands

| Command | Purpose |
|---------|---------|
| `/autoresearch` | Core improvement loop — modify, verify, keep/revert, repeat |
| `/autoresearch:plan` | Setup wizard — define goal, metric, assertions |
| `/autoresearch:debug` | Scientific bug hunting (7 techniques) |
| `/autoresearch:fix` | Iterative error resolution (auto-revert on regression) |
| `/autoresearch:scenario` | 12-dimension edge case generation |
| `/autoresearch:predict` | Multi-persona expert analysis (3-8 personas) |
| `/autoresearch:security` | STRIDE + OWASP + red team (4 hostile personas) |
| `/autoresearch:ship` | 8-phase universal shipping workflow |
| `/autoresearch:learn` | Autonomous documentation engine (4 modes) |

## What NOT To Do

- Do NOT use Mermaid diagrams (ASCII only for terminal compatibility)
- Do NOT claim features that aren't implemented yet
- Do NOT add tool-specific hard dependencies (the plugin works with Claude Code; protocol documents are tool-agnostic)

## Roadmap Context

- **Shipped:** Research workflow, mental model, eval scripts, 9 autoresearch commands, bilevel failure mode detection protocol, plugin packaging
- **Building:** Self-improving skill loop (autoresearch on the workflow itself), automated bilevel wrapper execution
- **Planned:** Plugin marketplace distribution, community skill contributions, cross-session learning persistence
