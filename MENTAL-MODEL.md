# The 3-Question Decision Router

**How to approach any idea, task, or problem using AI agents.**

This mental model emerged from building a research workflow, applying autoresearch to improve it, and stress-testing it with scenarios, multi-persona review, and a security audit — all in one session. It's not theoretical. It's extracted from doing.

---

## The Router

Every task starts with three questions. Ask them in order. The answer tells you which tool to reach for.

```
IDEA IN YOUR HEAD
     |
     v
Q1: "Do I understand the problem?"
     |
     ├── NO  → RESEARCH
     |         Tools: /research-workflow, /last30days, Firecrawl
     |         Goal: Learn what you don't know
     |         Time: 40-55 min
     |         Output: Research artifact with consensus,
     |                 debates, surprises, and action checklist
     |
     └── YES →
                Q2: "Do I know what to build?"
                     |
                     ├── NO  → PLAN
                     |         Tools: /autoresearch:plan, brainstorming, grill-me
                     |         Goal: Design the solution
                     |         Output: Plan with scope, metric, direction, verify
                     |
                     └── YES →
                                Q3: "Have I built this before?"
                                     |
                                     ├── NO  → BUILD SMALL, SHIP FAST, MEASURE
                                     |         Tools: Domain skills, TDD, autoresearch
                                     |         Goal: Get to real-world data as fast as possible
                                     |
                                     └── YES → JUST DO IT
                                               No workflow needed. You already know.
```

---

## The Three Systems

Research, execution, and improvement are layers that stack — not alternatives to choose between.

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│  LAYER 1: RESEARCH                                     │
│  "What should we do?"                                  │
│                                                        │
│  Discover → Read Primaries → Synthesize                │
│  → Cross-Examine → Distill                             │
│                                                        │
│  Output: knowledge you can act on                      │
│                                                        │
├────────────────────────────────────────────────────────┤
│                                                        │
│  LAYER 2: EXECUTE                                      │
│  "Do the work."                                        │
│                                                        │
│  Domain skills informed by research.                   │
│  Copywriting, SEO, ad creative, code, whatever         │
│  the task requires.                                    │
│                                                        │
├────────────────────────────────────────────────────────┤
│                                                        │
│  LAYER 3: IMPROVE                                      │
│  "Make it better over iterations."                     │
│                                                        │
│  Autoresearch: modify → test → keep/revert → repeat    │
│  Can improve the output, the skill, or the workflow    │
│  itself.                                               │
│                                                        │
└────────────────────────────────────────────────────────┘
```

**The chain for any project:**

```
Research (learn what's working)
     |
     v
Execute (use skills informed by research)
     |
     v
Ship (get to real-world outcomes)
     |
     v
Measure (did it work?)
     |
     v
Feed data back into skills
     |
     v
Autoresearch (improve skills with REAL metrics)
     |
     v
Repeat
```

---

## The Validation Chain

Every layer of quality judgment is validated by the layer below it. The chain terminates at reality.

```
Layer 4:  "Is my output good?"          ← judged by skills
Layer 3:  "Are my skills reliable?"     ← judged by autoresearch
Layer 2:  "Is my research correct?"     ← judged by cross-model synthesis
Layer 1:  "Is my workflow good?"        ← judged by eval assertions
Layer 0:  REAL-WORLD OUTCOMES           ← the chain STOPS here
          Only reality can judge.
```

**Key insight:** Every layer above Layer 0 is theory validated by more theory. The recursion breaks at real-world outcomes.

**What this means in practice:**
- Don't try to perfect every layer before shipping
- Ship on theory, improve on data
- The first version of everything is a hypothesis
- Real metrics (conversion rate, revenue, engagement) > predicted metrics
- After you ship and measure, feed Layer 0 data back into your skills — THAT's when autoresearch becomes powerful, because it's iterating on empirical assertions, not theoretical ones

---

## Binary Assertions: The Bridge

The hardest part of autoresearch is defining what "better" means mechanically. Binary assertions solve this.

**The problem:**
```
"Is this headline good?"     ← subjective, not a metric
"Does this code work?"       ← too binary, not nuanced
```

**The solution:** Turn quality into 20 true/false checks that a command can verify.

```
Example assertions for a research artifact:
  [ ] Every claim has a source citation           (grep-based)
  [ ] Official source was found and cited          (grep-based)
  [ ] Action checklist with >= 3 items             (grep -c)
  [ ] At least 1 comparison table                  (grep pipe rows)
  [ ] Time estimates present                       (grep for "min")
  [ ] Surprise findings noted                      (grep "surpris")
  [ ] Limitations acknowledged                     (grep "limitation")
  [ ] Length under 500 lines                       (wc -l)
```

**Pass rate = assertions passed / total.** That's your number. Autoresearch can optimize against it.

**Where assertions come from:** Don't guess. Use `/autoresearch:plan` — it asks you "what makes you NOT trust this?" and "what makes this USEFUL?" Your answers become the assertions.

---

## When to Use Each Autoresearch Skill

```
SKILL                     USE WHEN
────────────────────────  ──────────────────────────────────────

/autoresearch:plan        FIRST — before any loop. Defines the metric.
/autoresearch             You have a number to improve.
/autoresearch:fix         You have errors to eliminate.
/autoresearch:debug       You have a bug with unknown cause.
/autoresearch:scenario    Before shipping — stress-test edge cases.
/autoresearch:predict     Before big decisions — get expert perspectives.
/autoresearch:security    Before shipping — STRIDE + OWASP audit.
/autoresearch:ship        When ready to publish — structured 8-phase.
/autoresearch:learn       When entering an unfamiliar codebase.
```

**The optimal sequence:**

```
plan → autoresearch → scenario → predict → security → ship
```

---

## Origin

This framework was developed during a single Claude Code session (March 28, 2026) that started with "make an ASCII of my ~/.claude/ directory" and evolved into:

1. Mapping a 5.9 GB, 27,455-file directory
2. Researching optimal structure across 14 sources (official docs, YouTube, Reddit, GitHub)
3. Cross-model synthesis via NotebookLM (Gemini) + cross-examination via Gemini Pro
4. Building a 5-phase research workflow
5. Publishing it to GitHub
6. Creating 20 binary eval assertions
7. Stress-testing with 10 scenarios
8. Multi-persona review (4 experts, 12 findings)
9. Security audit
10. Converting the workflow into a Claude Code skill
11. Running autoresearch to self-improve the skill

The mental model emerged from the work. It wasn't planned — it was extracted.

---

## License

MIT — Use freely.
