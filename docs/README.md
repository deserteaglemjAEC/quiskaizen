# Research Workflow Skill — Documentation

## Overview

A 5-phase research methodology for Claude Code that produces expert-level research artifacts from any topic. Transforms a user question into a sourced, cross-examined, actionable document.

**Phases:** Discover → Read Primaries → Synthesize → Cross-Examine → Distill

**Time:** 40-55 minutes with all tools configured. Works with zero external tools (minimum viable path).

## File Structure

```
research-workflow/
├── SKILL.md                          # Main skill instructions (130 lines)
├── resources/
│   ├── discovery-guide.md            # Phase 1 query strategies + fallback chains
│   ├── source-hierarchy.md           # Phase 2 source quality ranking
│   ├── cross-examination-prompts.md  # Phase 4 devil's advocate templates
│   └── artifact-template.md          # Phase 5 output template (10 sections)
├── scripts/
│   └── eval-research-artifact.sh     # Artifact quality eval (20 assertions)
├── eval/
│   └── eval-skill.sh                 # SKILL.md quality eval (41 assertions)
└── docs/
    └── README.md                     # This file
```

## How It Works

### Phase 1: Discover (5 min)
Uses `/last30days` skill to find who's talking about the topic. Extracts top voices, primary source URLs, and key vocabulary. Falls back to Firecrawl search → WebSearch if /last30days fails.

### Phase 2: Read Primaries (15-30 min)
Scrapes 3-7 primary sources in parallel via Firecrawl. Prioritizes official docs > repos > expert posts > video transcripts. Saves raw material to `.firecrawl/`.

### Phase 3: Synthesize (10 min)
Pushes all material to NotebookLM (or Gemini Deep Research fallback). Asks 4 structured questions about consensus, contradictions, hidden gems, and community innovations. Uses a DIFFERENT model than Phase 1 to avoid bias amplification.

### Phase 4: Cross-Examine (5 min)
Sends synthesis to Gemini Pro with devil's advocate prompt. Documents corrections classified as: valid correction, valid nuance, overstated, or wrong.

### Phase 5: Distill (5 min)
Compresses everything into one artifact following the template. Includes Table of Contents, Sources section with numbered list, inline citations per section, Surprises section, and Limitations section. Runs eval-research-artifact.sh targeting 20/20.

## Eval System

### eval-skill.sh (41 assertions)
Tests SKILL.md document quality across 5 categories:
- **YAML frontmatter** (4): name, description, triggers, allowed-tools
- **Phase coverage** (3): all 5 phases, goals, outputs
- **Fallback chains** (3): Phase 1-3 fallbacks documented
- **Resource files** (4): all 4 resource files exist
- **Quality signals** (6): line limits, references, eval mention, prerequisites, multi-model
- **Instruction depth** (5): context budget, diversity, scoping, quality gates, warnings
- **Artifact quality drivers** (5): surprises, limitations, corrections, read resources, variants
- **Operational robustness** (5): context recovery, phase failure, parallel, source target, template verify
- **Artifact structure** (6): ToC, Sources section, official source, inline citations, numbered corrections, min source count

### eval-research-artifact.sh (20 assertions)
Tests output artifact quality across 4 categories:
- **Trust** (3): source citations, official source, Sources section
- **Usefulness** (4): action checklist, specific names, comparison tables, time estimates
- **Structural** (3): single file, Table of Contents, length < 500 lines
- **Rigor** (10): section citations, surprises, corrections, contradictions, methodology, multi-model, source count, limitations, freshness, action sequencing

## Tool Dependencies

| Tool | Required? | Used In | Fallback |
|------|-----------|---------|----------|
| /last30days | No | Phase 1 | Firecrawl search → WebSearch |
| Firecrawl | No | Phase 1-2 | gemini-analyze-url → Context7 → GitHub MCP |
| NotebookLM MCP | No | Phase 3 | Gemini Deep Research → separate Claude session |
| Gemini MCP | No | Phase 4 | Claude self-cross-examination |

**Minimum viable:** All phases work with just WebSearch + Claude's native capabilities.

## Running Evals

```bash
# Test SKILL.md quality (should be 41/41)
bash ~/.claude/skills/research-workflow/eval/eval-skill.sh

# Test an artifact (target: 20/20)
bash ~/.claude/skills/research-workflow/scripts/eval-research-artifact.sh path/to/artifact.md
```

## Version History

- **v1.0** (2026-03-28): Initial 5-phase skill, 20/20 eval
- **v1.1** (2026-03-28): Hardened eval to 35 assertions, autoresearch improvements (context budget, source diversity, topic scoping, quality gates, warnings, surprise/limitation instructions, phase failure handling, parallel guidance, template verification)
- **v1.2** (2026-03-28): Added 6 artifact-derived assertions (ToC, Sources, official citation, inline citations, numbered corrections, min source count). Total: 41 assertions.
