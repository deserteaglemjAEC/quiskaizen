---
name: research-workflow
description: >
  Run a 5-phase research workflow that produces expert-level understanding of any topic.
  Phases: Discover > Read Primaries > Synthesize > Cross-Examine > Distill.
  Use when researching a topic deeply, comparing options with evidence, or building
  a research artifact that scores 18+/20 on the binary assertion evaluator.
allowed-tools: Bash, Read, Write, Glob, Grep, WebSearch, WebFetch, Agent
argument-hint: "<topic or research question>"
---

# QuisKaizen Research Workflow

Run a structured 5-phase research pipeline that produces actionable, source-backed artifacts.

## Usage

`/quiskaizen:research-workflow <topic>`

## The 5 Phases

### Phase 1: Discover
- Run 4+ web searches from different angles (concept, comparison, implementation, edge cases)
- Collect 8-12 candidate sources
- Prioritize: official docs > peer-reviewed > reputable blogs > community forums

### Phase 2: Read Primary Sources
- Fetch and read top 6-8 sources
- Extract claims, data points, and specific recommendations
- Note contradictions between sources

### Phase 3: Synthesize
- Cross-reference findings across sources
- Build consensus view with specific citations
- Create comparison tables where applicable
- Note actionable recommendations with time estimates

### Phase 4: Cross-Examine
- Challenge 3-5 key claims with specific counter-questions
- Test assumptions against edge cases
- Document surprises and contradictions

### Phase 5: Distill
- Write final artifact following `${CLAUDE_SKILL_DIR}/resources/artifact-template.md`
- Include: Table of Contents, sourced claims, comparison tables, implementation checklist
- Include: Consensus/Contradictions/Surprises section, Limitations section, Sources list

## Evaluation

After writing the artifact, run the evaluator:

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/eval-research-artifact.sh <artifact.md>
```

Target: 18+/20 (90%+). The evaluator checks 20 binary assertions across trust, usefulness, and rigor dimensions.

## Mental Model

Before starting, consult the 3-Question Router (see MENTAL-MODEL.md in repo root):
1. Is this a research question or an execution task?
2. What's the validation layer?
3. What does "done" look like?

## Resources

- Artifact template: `${CLAUDE_SKILL_DIR}/resources/artifact-template.md`
- Evaluation script: `${CLAUDE_SKILL_DIR}/scripts/eval-research-artifact.sh`
- Mental model: See repo root `MENTAL-MODEL.md`
- Failure modes: See repo root `failure-modes.md`
