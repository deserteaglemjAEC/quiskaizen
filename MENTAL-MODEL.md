# The QuisKaizen Mental Model

**How to approach any idea, task, or problem using AI agents.**

> Research. Execute. Improve. Validate against reality.

This mental model emerged from building a research workflow, applying autoresearch to improve it, and stress-testing it with scenarios, multi-persona review, and a security audit — all in one session. It's not theoretical. It's extracted from doing.

---

## The 3-Question Router

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
                    |         Tools: /autoresearch:plan, brainstorming
                    |         Goal: Design the solution
                    |         Output: Plan with scope, metric, verify
                    |
                    └── YES →
                               Q3: "Have I built this before?"
                                    |
                                    ├── NO  → BUILD SMALL, SHIP FAST, MEASURE
                                    |         Tools: Domain skills, TDD, autoresearch
                                    |         Goal: Get to real-world data ASAP
                                    |
                                    └── YES → JUST DO IT
                                              No workflow needed.
```

---

## The Three Layers

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

**The chain:**

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

## When to Use Each Autoresearch Skill

```
SKILL                     WHAT IT DOES                   WHEN TO USE
────────────────────────  ─────────────────────────────  ──────────────────────
/autoresearch:plan        Interactive wizard. Defines     BEFORE any loop.
                          scope, metric, direction,       Asks YOU questions to
                          verify from a goal.             derive eval criteria.

/autoresearch             The core loop. Modify file →    When you have a NUMBER
                          run metric → keep/revert.       to improve. Code quality,
                          Runs autonomously.              pass rates, scores.

/autoresearch:fix         Fix errors one by one.          Build failures, test
                          Atomic. Auto-reverts on fail.   failures, lint errors.

/autoresearch:debug       Scientific method bug hunt.     When you have a bug
                          Finds ALL bugs, not just one.   and don't know the cause.

/autoresearch:scenario    Generates edge cases from a     Before shipping.
                          seed scenario. Failure modes.   Stress-test the design.

/autoresearch:predict     Multi-persona swarm. 3-8        Before big decisions.
                          experts debate independently.   Architecture, strategy.

/autoresearch:security    STRIDE + OWASP + red-team.      Before shipping anything
                          4 adversarial personas.         with security surface.

/autoresearch:ship        8-phase shipping workflow.      When ready to publish.
                          Validate → package → test →     Code, content, research,
                          document → review → publish.    anything.

/autoresearch:learn       Auto-documentation engine.      When you need to
                          Scout, learn, generate docs.    understand a new codebase.
```

**The optimal sequence for any project:**

```
plan → autoresearch → scenario → predict → security → ship
```

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

## Mechanical Metrics Are Required

Autoresearch CANNOT work without a number.

```
GOOD METRICS (mechanical, extractable by command)
──────────────────────────────────────────────────
- Assertion pass rate: 18/20 = 90%
- Line count: wc -l file.md = 391
- Error count: grep -c "error" output.log = 3
- Test coverage: 87.3%
- Word count: wc -w < 300

BAD METRICS (subjective, require human judgment)
──────────────────────────────────────────────────
- "Looks good"
- "Feels professional"
- "Compelling headline"
- "High quality"
- PASS / FAIL without a number
```

---

## Applied Example: Marketing

```
SITUATION                               WHAT TO USE
──────────────────────────────────────  ───────────────────────────

"What CTA patterns work in DTC?"        /research-workflow
                                        (Phase 1-5, produces knowledge)

"Write landing page copy for Undrdog"   /copywriting skill
                                        (executes, informed by research)

"My CTAs are weak — improve the skill"  /autoresearch
                                        Scope: copywriting SKILL.md
                                        Metric: assertion pass rate
                                        (improves the instructions)

"Ship the brief to creators"            /autoresearch:ship
                                        (structured shipping workflow)

"Did the brief actually convert?"       REAL-WORLD DATA (Layer 0)
                                        (validates everything above)

"Update skill based on what worked"     Feed Layer 0 data back into
                                        assertions. Run /autoresearch
                                        again with EMPIRICAL metrics.
```

---

## Key Principles

1. **Research → Execute → Improve.** Three layers, not three alternatives.
2. **Ship on theory, improve on data.** Don't wait for perfect knowledge.
3. **Binary assertions are the bridge** between "is this good?" and a mechanical metric.
4. **Use different models for synthesis.** Claude + Gemini catch different blind spots.
5. **20-30 skills max.** Fewer well-built skills >>> 500 generic ones.
6. **Every phase needs a fallback.** If the primary tool fails, what's plan B?
7. **The eval measures format, not quality.** Research accuracy still requires human judgment.
8. **Real-world outcomes are the only ground truth.** Everything else is prediction.

---

## Origin

This framework was developed during a single Claude Code session (March 28, 2026) that started with "make an ASCII of my ~/.claude/ directory" and evolved into:

1. Mapping a 5.9 GB, 27,455-file directory
2. Researching optimal structure across 14 sources (official docs, YouTube, Reddit, GitHub)
3. Cross-model synthesis via NotebookLM (Gemini) + cross-examination via Gemini Pro
4. Building a 5-phase research workflow
5. Publishing it to GitHub as [QuisKaizen](https://github.com/deserteaglemjAEC/quiskaizen)
6. Creating 20 binary eval assertions
7. Stress-testing with 10 scenarios + multi-persona review (4 experts, 12 findings) + security audit
8. Converting the workflow into a Claude Code skill
9. Running autoresearch to self-improve the skill

The mental model emerged from the work. It wasn't planned — it was extracted.

---

## License

MIT — Use freely.
