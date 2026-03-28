# Contributing to QuisKaizen

QuisKaizen is a methodology, not software. Contributions look different here than in a typical code repo.

## Ways to Contribute

### Improve the Research Workflow

The 5-phase workflow (Discover > Read Primaries > Synthesize > Cross-Examine > Distill) is the core of QuisKaizen. If you've used it and found a phase that could be better:

1. Open an issue describing what happened, what you expected, and what would improve it
2. If you have a concrete improvement, open a PR modifying the relevant section in `README.md`

### Add Eval Assertions

The eval script (`eval-research-artifact.sh`) uses 20 binary assertions to mechanically measure research artifact quality. If you've found a quality signal the eval misses:

1. Open an issue with: the assertion you'd add, why it matters, and a grep/wc command that checks it
2. Or open a PR adding the assertion directly to `eval-research-artifact.sh`

Assertions must be:
- **Mechanical** — checkable by a shell command (grep, wc, etc.)
- **Binary** — pass or fail, no subjective judgment
- **Justified** — explain why this assertion catches real quality problems

### Share Your Research Artifacts

Used QuisKaizen to research something? We'd love to see it.

- Open a [Discussion](https://github.com/deserteaglemjAEC/quiskaizen/discussions) (not an issue or PR)
- Share what you researched, your eval score, and what surprised you
- This helps others see the methodology in action

### Improve the Mental Model

The [Mental Model](MENTAL-MODEL.md) (3-Question Router, 3 Layers, Validation Chain) is a living document. If you've found a better way to explain a concept or discovered a gap:

1. Open an issue first — let's discuss before changing the model
2. Changes to the mental model affect the whole framework, so they need more discussion than workflow tweaks

## What We Don't Accept (Yet)

- **Software features** — QuisKaizen is a methodology repo. The bilevel autoresearch wrapper is on the roadmap but not ready for contributions yet.
- **Tool-specific integrations** — The workflow is designed to be tool-agnostic. Don't add hard dependencies on specific MCP servers or plugins.
- **Unrelated content** — Stay focused on the research workflow and mental model.

## Style Guide

- Markdown only (no HTML in docs)
- ASCII diagrams over Mermaid (for terminal readability)
- Tables for structured comparisons
- Code blocks for commands and examples
- Keep language direct and practical — no marketing speak

## Process

1. Open an issue or discussion first for anything non-trivial
2. Fork the repo
3. Make your changes on a branch
4. Open a PR with a clear description of what changed and why
5. Maintainer reviews within 48 hours

## Code of Conduct

Be respectful, be constructive, be specific. If you disagree with a methodology choice, explain why with evidence — "I tried this and it didn't work because..." is more useful than "this is wrong."

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
