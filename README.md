# QuisKaizen

[![GitHub stars](https://img.shields.io/github/stars/deserteaglemjAEC/quiskaizen?style=flat-square)](https://github.com/deserteaglemjAEC/quiskaizen/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/deserteaglemjAEC/quiskaizen?style=flat-square)](https://github.com/deserteaglemjAEC/quiskaizen/releases)
[![Last commit](https://img.shields.io/github/last-commit/deserteaglemjAEC/quiskaizen?style=flat-square)](https://github.com/deserteaglemjAEC/quiskaizen/commits/main)

> **Research. Execute. Improve. Validate against reality.**

**QuisKaizen** (Quis + 改善 Kaizen) — a methodology for approaching any task with AI agents. Includes a 5-phase research workflow, a mental model for AI-assisted work, and a mechanical evaluation system.

Born from real-world use optimizing Claude Code infrastructure across marketing, e-commerce, and engineering projects. This replaces the "Google it and summarize" approach with a structured pipeline that produces artifacts you can actually act on.

If you find this useful, [star the repo](https://github.com/deserteaglemjAEC/quiskaizen) and [share it on X](https://twitter.com/intent/tweet?text=QuisKaizen%20%E2%80%94%20a%20research%20methodology%20for%20AI%20agents%20that%20actually%20produces%20artifacts%20you%20can%20act%20on.%20Research.%20Execute.%20Improve.%20Validate%20against%20reality.&url=https%3A%2F%2Fgithub.com%2FdeserteaglemjAEC%2Fquiskaizen).

**[Read the Mental Model](MENTAL-MODEL.md)** — the 3-Question Router, the 3 Layers, and the Validation Chain.

## Quick Start

```bash
# 1. Read the mental model (5 min)
#    Understand the 3-Question Router before using any tools
cat MENTAL-MODEL.md

# 2. Run the research workflow on any topic (40-55 min)
#    Follow the 5 phases below — or use the Claude Code skill:
#    ~/.claude/skills/research-workflow/

# 3. Evaluate your artifact
bash eval-research-artifact.sh your-artifact.md
# Target: 20/20 assertions passing
```

## Prerequisites

Before running the workflow, ensure you have:

| Tool | Required? | What it does | Setup |
|------|-----------|-------------|-------|
| [/last30days](https://github.com/the-dim/last30days-skill) | Recommended | Multi-platform discovery (Reddit, X, YouTube, TikTok, HN) | `npx skills add the-dim/last30days-skill` |
| [Firecrawl](https://firecrawl.dev) | Recommended | Web scraping of primary sources | `npm i -g firecrawl-cli && firecrawl login --browser` |
| [NotebookLM](https://notebooklm.google.com) | Recommended | Cross-model synthesis with Gemini | Free Google account + [NotebookLM MCP](https://github.com/jmagar/notebooklm-mcp) |
| Gemini API | Optional | Cross-examination (Phase 4) | API key or Gemini MCP server |
| Claude Code | Required | Orchestration + artifact generation | Already installed if you're reading this |

**Time estimate:** 40-55 minutes with tools pre-configured. First-time tool setup adds 15-30 minutes.

**Minimum viable workflow (no external tools):** WebSearch → manual reading → Claude synthesis → Claude self-cross-examination → artifact. Works without any API keys — just Claude Code itself.

## The Problem

Most AI-assisted research stops at Phase 1: run a search, get a summary, call it done. This produces **summaries of summaries** — you feel informed but you're working from someone else's synthesis, inheriting their biases and blind spots.

## The Solution

A 5-phase workflow that escalates from discovery through cross-examination, using multiple AI models and tools to produce **stress-tested understanding** compressed into actionable artifacts.

## The Workflow

```
Phase 1: DISCOVER          Find WHO is talking and map the landscape
     |
     v
Phase 2: READ PRIMARIES    Read what experts ACTUALLY wrote
     |
     v
Phase 3: SYNTHESIZE        Push everything into a second brain, find consensus + gaps
     |
     v
Phase 4: CROSS-EXAMINE     Stress-test with a different model or devil's advocate
     |
     v
Phase 5: DISTILL           Compress into ONE actionable artifact
```

### Total time: 40-55 minutes for expert-level understanding of any topic.

---

## Phase 1: Discover (5 min)

**Goal:** Find WHO is talking and WHAT the landscape looks like.

**Tool:** [/last30days](https://github.com/the-dim/last30days-skill) or any multi-platform search tool

Run ONE broad query to map the terrain. You're not trying to learn everything — you're trying to find:
- The **top 3-5 voices** (who has the most engagement?)
- The **primary sources** they reference (repos, docs, posts)
- The **vocabulary** (what do experts call this thing?)

**Output:** A list of PEOPLE and SOURCES to go deeper on.

**If /last30days returns <3 results:** Topic is too niche for social platforms. Fallback to: `firecrawl search "[topic] best practices"` + `WebSearch "[topic] guide"`. Use web results as your discovery source instead.

**Example:**
```
/last30days "Claude Code .claude directory structure"

Found:
  - Matt Pocock (194K views, linked his skill repo)
  - Simon Scrapes (179K combined views, Karpathy autoresearch applied to skills)
  - Complete Guide V4 on r/ClaudeAI (82 comments = community corrections)
  - Official Anthropic docs at code.claude.com/docs/en/claude-directory
```

---

## Phase 2: Read Primary Sources (15-30 min)

**Goal:** Read what the experts ACTUALLY wrote, not summaries of it.

**Tool:** [Firecrawl](https://firecrawl.dev) scrape (parallel)

Phase 1 gave you names and URLs. Now scrape the originals:

| Source Type | Why It Matters |
|---|---|
| **Official documentation** | The vendor's own docs are the ground truth |
| **Top-cited repos** | Actual code, not descriptions of code |
| **High-engagement posts WITH comments** | Comments are where corrections live |
| **Video transcripts** | Already extracted in Phase 1 — read carefully |

```bash
# Scrape 3-5 primary sources in parallel
firecrawl scrape https://official-docs.com/page -o .firecrawl/docs.md &
firecrawl scrape https://github.com/expert/repo -o .firecrawl/repo.md &
firecrawl scrape https://reddit.com/r/sub/post -o .firecrawl/post.md &
wait
```

**DO NOT** run more discovery queries. Diminishing returns.
**DO** read the sources that Phase 1 pointed you to.

**Fallback chain if Firecrawl blocks a site:** Firecrawl → `gemini-analyze-url` MCP → Context7 MCP (for library docs) → GitHub MCP (for repos) → ask user to paste content manually.

> This is where most people stop. They do Phase 1 and think they're done. They have SUMMARIES. They don't have KNOWLEDGE.

---

## Phase 3: Synthesize with a Second Brain (10 min)

**Goal:** Find what every source agrees on, where they contradict, and what's missing.

**Tool:** [NotebookLM](https://notebooklm.google.com) (or Gemini Deep Research as lighter alternative)

Push ALL Phase 1 + Phase 2 material into NotebookLM:
- /last30days raw output (`.md` saved to `~/Documents/Last30Days/`)
- Scraped docs (`.firecrawl/` files)
- Any repo READMEs or code you scraped

Then ask NotebookLM these **four questions:**

| # | Question | What It Reveals |
|---|----------|-----------------|
| 1 | "What does EVERY source agree on?" | Consensus — the safe bets |
| 2 | "Where do sources contradict each other?" | Debates — where you need judgment |
| 3 | "What's in official docs that nobody discusses?" | Hidden gems — underused features |
| 4 | "What's the community doing that isn't documented?" | Innovations — cutting edge |

**Why NotebookLM and not just Claude?**

Claude already synthesized in Phase 1. Asking Claude again with the same material = same biases, same blind spots. NotebookLM uses Gemini — different model, different training, different synthesis patterns. **The VALUE is the disagreement between the two syntheses.**

**If NotebookLM is unavailable:** Use Gemini Deep Research as the synthesis engine. Or open a SEPARATE Claude session (fresh context, no prior bias) and paste the raw material. The key is using a DIFFERENT model or context — not the same one that did Phase 1.

---

## Phase 4: Cross-Examine (5 min)

**Goal:** Stress-test the synthesis. Find what you're still wrong about.

**Tool:** Gemini Deep Research OR Claude with explicit devil's advocate prompt

Take your synthesis and ask:

> "Here is my current understanding of [topic]. What am I wrong about? What am I missing? What would an expert disagree with?"

This is the step that separates "I researched this" from "I actually understand this." Most research workflows skip it.

---

## Phase 5: Distill to Actionable Artifact (5 min)

**Goal:** Compress everything into the ONE artifact you'll actually use.

The output of research is NOT a report. It's one of:

| Artifact Type | When to Use |
|---|---|
| **Reference document** | You need ongoing lookups (e.g., ideal directory structure) |
| **Checklist** | You need to do N things in order |
| **Template** | You need a reusable starting point |
| **Decision** | You need to pick between options |

> If you can't compress your research into a single artifact, you haven't finished researching — you've finished collecting.

---

## Anti-Patterns

| What People Do | Why It Fails |
|---|---|
| Run /last30days 5 times with different prompts | Same corpus, same top voices, diminishing returns after first run |
| Read only summaries, never primary sources | Summaries inherit the summarizer's biases. Primary sources have the nuance. |
| Synthesize with only ONE model | Every model has blind spots. Claude + Gemini see different things. The disagreements are the most valuable signal. |
| End with "I learned a lot" instead of an artifact | Knowledge without compression is just entertainment. The artifact forces you to commit. |
| Skip the cross-examine step | Confirmation bias. You'll believe your synthesis because you built it. |

---

## Tools Used

| Tool | Phase | Purpose |
|---|---|---|
| [/last30days](https://github.com/the-dim/last30days-skill) | 1 | Multi-platform discovery (Reddit, X, YouTube, TikTok, HN, Polymarket) |
| [Firecrawl](https://firecrawl.dev) | 2 | Parallel web scraping of primary sources |
| [NotebookLM](https://notebooklm.google.com) | 3 | Cross-model synthesis with Gemini |
| Gemini Deep Research / Claude | 4 | Cross-examination and stress testing |
| Claude Code | 5 | Artifact generation and compression |

---

## Mental Model

Beyond the 5-phase workflow, there's a broader framework for approaching ANY task with AI agents: the 3-Question Decision Router, the Validation Chain, and how Research + Execution + Improvement work as layers.

**[Read the full Mental Model](MENTAL-MODEL.md)**

---

## What This Is (and Isn't)

**This IS:**
- A methodology you can follow right now in Claude Code
- A mental model for thinking about AI-assisted work
- An eval script that turns subjective "is this good?" into a mechanical number
- A Claude Code skill you can install and use today

**This is NOT:**
- A software tool you install and run
- An automated pipeline (yet — see Roadmap)
- A wrapper around autoresearch (yet)

The methodology is the product right now. The automation is coming.

---

## Roadmap

| Status | What |
|--------|------|
| **Shipped** | 5-phase research workflow |
| **Shipped** | Mental model (3-Question Router, 3 Layers, Validation Chain) |
| **Shipped** | Eval script (20 binary assertions) |
| **Shipped** | Claude Code skill (`~/.claude/skills/research-workflow/`) |
| **Building** | Self-improving skill (autoresearch loop on the workflow itself) |
| **Planned** | Bilevel autoresearch wrapper — outer loop that detects failure modes (idea exhaustion, local optima, metric gaming) and injects strategy corrections. Based on [arXiv 2603.23420](https://arxiv.org/abs/2603.23420). |

---

## Limitations

- The eval script measures **structure, not accuracy**. It checks for citations, comparison tables, and action checklists — but can't judge whether your research conclusions are correct. Only real-world outcomes (Layer 0) can do that.
- Phase 3 (synthesis) works best with NotebookLM or Gemini. Using Claude to synthesize Claude's own research = same biases. The workflow explicitly requires a different model.
- Time estimates assume tools are pre-configured. First-time setup adds 15-30 minutes.
- The methodology was developed for Claude Code. It can be adapted to other AI tools, but the specific tool recommendations are Claude-centric.

---

## Origin

This workflow was developed during a single Claude Code session (March 28, 2026) that started with "make an ASCII of my `~/.claude/` directory" and evolved into mapping 27,455 files, researching optimal structure across 14 sources, building a 5-phase methodology, stress-testing it with scenarios and multi-persona review, and publishing it.

The methodology emerged from the work. It wasn't planned — it was extracted.

---

## License

MIT — Use freely in your projects, commercial or personal.
