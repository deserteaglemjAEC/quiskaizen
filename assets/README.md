# QuisKaizen Visual Assets

## 5-Phase Research Workflow

The core research pipeline. Each phase builds on the last. The evaluation loop at the end ensures quality — if the artifact scores below 18/20 on binary assertions, iterate until it passes.

```mermaid
%%{ init: { 'theme': 'base', 'themeVariables': { 'primaryColor': '#1a1a2e', 'primaryTextColor': '#e0e0e0', 'primaryBorderColor': '#16213e', 'lineColor': '#0f3460', 'secondaryColor': '#16213e', 'tertiaryColor': '#0f3460' } } }%%

flowchart TD
    START([Research Topic]) --> P1

    P1["Phase 1: DISCOVER
    Find WHO is talking, map landscape
    --------------------------------
    4+ web searches
    8-12 sources identified"]

    P1 --> P2

    P2["Phase 2: READ PRIMARIES
    Read what experts actually wrote
    --------------------------------
    Fetch top 6-8 sources
    Extract key claims + data"]

    P2 --> P3

    P3["Phase 3: SYNTHESIZE
    Cross-reference, find consensus + gaps
    --------------------------------
    Comparison tables
    Inline citations for every claim"]

    P3 --> P4

    P4["Phase 4: CROSS-EXAMINE
    Challenge claims, test assumptions
    --------------------------------
    3-5 counter-questions
    Multi-model synthesis"]

    P4 --> P5

    P5["Phase 5: DISTILL
    Write artifact, run evaluator
    --------------------------------
    20 binary assertions
    Target: 18+/20"]

    P5 --> EVAL{Score >= 18/20?}

    EVAL -->|Yes| DONE([Research Artifact Complete])
    EVAL -->|No| ITERATE["Iterate: Fix failing assertions
    Re-run evaluator"]
    ITERATE --> P5

    style START fill:#0f3460,stroke:#e94560,color:#e0e0e0
    style DONE fill:#0f3460,stroke:#53d769,color:#e0e0e0
    style P1 fill:#1a1a2e,stroke:#e94560,color:#e0e0e0
    style P2 fill:#1a1a2e,stroke:#e94560,color:#e0e0e0
    style P3 fill:#1a1a2e,stroke:#e94560,color:#e0e0e0
    style P4 fill:#1a1a2e,stroke:#e94560,color:#e0e0e0
    style P5 fill:#1a1a2e,stroke:#e94560,color:#e0e0e0
    style EVAL fill:#16213e,stroke:#e94560,color:#e0e0e0
    style ITERATE fill:#16213e,stroke:#f5a623,color:#e0e0e0
```

## Mental Model: 3-Question Router

The decision framework. Start with an idea, route through three questions, validate each path differently, then flow into the three stacking layers: Research, Execute, Improve.

```mermaid
%%{ init: { 'theme': 'base', 'themeVariables': { 'primaryColor': '#1a1a2e', 'primaryTextColor': '#e0e0e0', 'primaryBorderColor': '#16213e', 'lineColor': '#0f3460', 'secondaryColor': '#16213e', 'tertiaryColor': '#0f3460' } } }%%

flowchart TD
    IDEA([Idea in your head]) --> Q1

    subgraph ROUTER["3-Question Router"]
        Q1{"Q1: Do I understand
        the problem?"}

        Q1 -->|No| RESEARCH["RESEARCH
        /research-workflow
        /last30days, Firecrawl
        Goal: Learn what you don't know"]

        Q1 -->|Yes| Q2{"Q2: Do I know
        what to build?"}

        Q2 -->|No| PLAN["PLAN
        /autoresearch:plan
        brainstorming
        Goal: Design the solution"]

        Q2 -->|Yes| Q3{"Q3: Have I built
        this before?"}

        Q3 -->|No| BUILD["BUILD SMALL, SHIP FAST
        Domain skills, TDD
        autoresearch
        Goal: Real-world data ASAP"]

        Q3 -->|Yes| JUSTDOIT["JUST DO IT
        No workflow needed"]
    end

    subgraph VALIDATION["Validation Layer for Each Path"]
        V_RESEARCH["Binary assertions
        20 true/false checks
        Score threshold: 18+/20"]

        V_PLAN["Manual review
        Plan approval before execution"]

        V_BUILD["Tests + metrics
        Coverage, pass rate, assertions"]

        V_JUSTDOIT["State change
        Done when shipped"]
    end

    RESEARCH --> V_RESEARCH
    PLAN --> V_PLAN
    BUILD --> V_BUILD
    JUSTDOIT --> V_JUSTDOIT

    subgraph LAYERS["3 Layers (stack, don't choose)"]
        direction TB
        L1["Layer 1: RESEARCH
        'What should we do?'
        Discover - Read - Synthesize
        Cross-Examine - Distill"]

        L2["Layer 2: EXECUTE
        'Do the work.'
        Domain skills informed by research"]

        L3["Layer 3: IMPROVE
        'Make it better over iterations.'
        Autoresearch: modify - test - keep/revert"]

        L1 --> L2 --> L3
        L3 -.->|Feed data back| L1
    end

    V_RESEARCH --> L1
    V_PLAN --> L2
    V_BUILD --> L2
    V_JUSTDOIT --> L2

    style IDEA fill:#0f3460,stroke:#e94560,color:#e0e0e0
    style Q1 fill:#16213e,stroke:#e94560,color:#e0e0e0
    style Q2 fill:#16213e,stroke:#e94560,color:#e0e0e0
    style Q3 fill:#16213e,stroke:#e94560,color:#e0e0e0
    style RESEARCH fill:#1a1a2e,stroke:#53d769,color:#e0e0e0
    style PLAN fill:#1a1a2e,stroke:#f5a623,color:#e0e0e0
    style BUILD fill:#1a1a2e,stroke:#4fc3f7,color:#e0e0e0
    style JUSTDOIT fill:#1a1a2e,stroke:#e0e0e0,color:#e0e0e0
    style V_RESEARCH fill:#16213e,stroke:#53d769,color:#e0e0e0
    style V_PLAN fill:#16213e,stroke:#f5a623,color:#e0e0e0
    style V_BUILD fill:#16213e,stroke:#4fc3f7,color:#e0e0e0
    style V_JUSTDOIT fill:#16213e,stroke:#e0e0e0,color:#e0e0e0
    style L1 fill:#1a1a2e,stroke:#53d769,color:#e0e0e0
    style L2 fill:#1a1a2e,stroke:#4fc3f7,color:#e0e0e0
    style L3 fill:#1a1a2e,stroke:#f5a623,color:#e0e0e0
    style ROUTER fill:#0d1117,stroke:#e94560,color:#e0e0e0
    style VALIDATION fill:#0d1117,stroke:#f5a623,color:#e0e0e0
    style LAYERS fill:#0d1117,stroke:#4fc3f7,color:#e0e0e0
```
