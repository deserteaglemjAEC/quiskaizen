---
name: research-workflow
description: >
  5-phase research methodology for building expert-level understanding of any topic.
  Use when the user asks to research a topic deeply, compare options with evidence,
  understand a technology landscape, or produce a research artifact. Also use when the
  user says "research this", "deep dive on", "what do experts say about", "help me
  understand", "compare X vs Y with real data", or "I need to make an informed decision."
  NOT for quick lookups or simple factual questions — use for topics requiring
  multi-source synthesis.
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
---

# Research Workflow Skill

A 5-phase methodology: **Discover > Read Primaries > Synthesize > Cross-Examine > Distill.**

Total time: 40-55 minutes with tools pre-configured.

## Context Budget

**Warning:** This workflow consumes significant context window. Budget ~20% per phase (Discover + Read = 40%, Synthesize + Cross-Examine = 30%, Distill = 10%, overhead = 20%). If context pressure exceeds 70%, save progress and split into a fresh session to continue from Phase 3 onward. Context exhaustion mid-synthesis produces hollow artifacts — avoid by monitoring context window usage and offloading raw material to files early.

## Prerequisites Check

Before starting, verify tools are available:
1. `/last30days` skill — run `ls ~/.claude/plugins/marketplaces/last30days-skill/ 2>/dev/null`
2. Firecrawl — run `firecrawl --status`
3. NotebookLM MCP — check if `mcp__notebooklm-mcp__notebook_create` is available
4. Gemini MCP — check if `mcp__gemini-vision__gemini-query` is available

**Minimum viable (no external tools):** WebSearch > manual reading > Claude synthesis > Claude self-cross-examination > artifact. Works with zero API keys.

## Phase 1: Discover (5 min)

**Goal:** Find WHO is talking and map the landscape.

1. Run ONE broad /last30days query on the topic
2. From results, extract:
   - Top 3-5 voices (highest engagement)
   - Primary source URLs they reference
   - Key vocabulary/terminology
3. If /last30days returns <3 results: fallback to `firecrawl search "[topic]"` + WebSearch

**Aim for 8-12 total sources across all phases.** Ensure source diversity: mix source types (docs, repos, posts, videos) from different platforms and domains. Avoid clustering 3+ sources from the same site — it biases synthesis.

**Topic too broad?** Narrow down before starting: pick a specific angle, audience, or decision. "How to use Redis" is too broad. "Redis vs Memcached for session caching in Node.js" is scoped.

**Output:** A list of PEOPLE and SOURCES for Phase 2.

See [discovery-guide.md](resources/discovery-guide.md) for query strategies and fallback chains.

## Phase 2: Read Primary Sources (15-30 min)

**Goal:** Read what experts ACTUALLY wrote, not summaries.

1. Scrape 3-7 primary sources in PARALLEL using Firecrawl
2. Priority order:
   - Official documentation (vendor/creator docs)
   - Top-cited repositories (actual code via GitHub MCP)
   - High-engagement posts WITH comments
   - Video transcripts (already in /last30days output)

**Fallback chain:** Firecrawl > `gemini-analyze-url` > Context7 MCP > GitHub MCP > ask user to paste

**Output:** Raw material saved to `.firecrawl/` directory.

See [source-hierarchy.md](resources/source-hierarchy.md) for source quality ranking.

## Phase 3: Synthesize (10 min)

**Goal:** Find consensus, contradictions, and gaps across all sources.

1. Create a NotebookLM notebook for the topic
2. Push ALL Phase 1 + Phase 2 material as sources
3. Ask these 4 questions:
   - "What does EVERY source agree on?"
   - "Where do sources contradict each other?"
   - "What's in official docs that nobody discusses?"
   - "What's the community doing that isn't documented?"

**If NotebookLM unavailable:** Use Gemini Deep Research, or a SEPARATE Claude session with fresh context.

**Key principle:** Use a DIFFERENT model than Phase 1. Same model = same biases.

**Output:** 4 synthesis answers (consensus, contradictions, hidden gems, community innovations) + NotebookLM notebook link.

## Phase 4: Cross-Examine (5 min)

**Goal:** Stress-test the synthesis.

1. Send synthesis to Gemini Pro (or another model) with devil's advocate prompt
2. Document specific corrections
3. Adjust synthesis based on valid challenges

See [cross-examination-prompts.md](resources/cross-examination-prompts.md) for prompt templates.

**Output:** List of specific corrections with classification (valid correction / valid nuance / overstated / wrong).

**Warning:** Do not skip cross-examination because synthesis "looks solid" — confirmation bias is the #1 failure mode. Avoid using the same model for both synthesis and cross-examination.

**Before moving to Phase 5:** Verify the synthesis produced at least 3 consensus points and identified at least 1 contradiction. If not, the source material was too thin — go back to Phase 2 and add more sources before proceeding.

## Phase 5: Distill (5 min)

**Goal:** Compress everything into ONE actionable artifact.

1. Choose format: reference doc, checklist, template, or decision doc
2. Use the artifact template: [artifact-template.md](resources/artifact-template.md) — verify the artifact matches the template structure before finishing
3. Include a "Surprises" section: document what you assumed wrong or found unexpected during research
4. Include a "Limitations" section: acknowledge gaps in scope, what was not covered, and why
5. Run eval: `bash ${CLAUDE_SKILL_DIR}/scripts/eval-research-artifact.sh <artifact>`
6. Target: 20/20 assertions passing

**Output:** Single markdown file saved to `research/YYYY-MM-DD-[topic].md`
