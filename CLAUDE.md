# QuisKaizen — Project Context for Claude Code

## What This Is

QuisKaizen is a **methodology repo** — not software. It contains a 5-phase research workflow, a mental model for AI-assisted work, and an evaluation system. There is no application code, no build system, no package.json.

## File Map

| File | Purpose |
|------|---------|
| `README.md` | The 5-phase research workflow with detailed instructions per phase |
| `MENTAL-MODEL.md` | The broader framework: 3-Question Router, 3 Layers, Validation Chain |
| `eval-research-artifact.sh` | 20 binary assertions that evaluate research artifact quality |
| `artifact-template.md` | Template for the output of Phase 5 (distill) |
| `CONTRIBUTING.md` | How to contribute to the methodology |
| `LICENSE` | MIT |

## Standards

- **Markdown style:** Direct, practical, no marketing speak. Tables for comparisons. ASCII diagrams for terminal readability (no Mermaid).
- **Eval assertions:** Must be mechanical (shell command), binary (pass/fail), and justified (explain why it matters).
- **Research workflow changes:** Propose via issue first. Changes affect the whole framework.

## Running the Eval

```bash
bash eval-research-artifact.sh <path-to-artifact.md>
# Target: 20/20 passing
```

## What NOT To Do

- Do NOT add application code, build systems, or package managers
- Do NOT add tool-specific integrations (the methodology is tool-agnostic)
- Do NOT use Mermaid diagrams (ASCII only for terminal compatibility)
- Do NOT reframe as "software" or "plugin" — it's a methodology
- Do NOT claim "5x improvement" or "bilevel autoresearch" in current-state descriptions — those are roadmap items

## Roadmap Context

- **Shipped:** Research workflow, mental model, eval script, Claude Code skill
- **Building:** Self-improving skill loop (autoresearch on the workflow itself)
- **Planned:** Bilevel autoresearch wrapper (outer loop for failure mode detection)

The bilevel wrapper is NOT built yet. Don't reference it as a current feature.
