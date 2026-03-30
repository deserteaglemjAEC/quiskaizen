# Predict Workflow Protocol

Multi-persona expert analysis. 3-8 independent perspectives, then synthesis.

## Setup

Collect via `AskUserQuestion`:
1. Decision/design to evaluate
2. Context (relevant files, constraints, goals)
3. Number of personas (default: 5, range: 3-8)
4. Custom personas (optional — override defaults)

## Default 5 Personas

### Persona 1: Software Architect
- **Focus:** System design, scalability, maintainability
- **Key questions:**
  - Will this scale to 10x current load?
  - Is the abstraction at the right level?
  - What's the migration path if requirements change?
  - How does this affect the dependency graph?

### Persona 2: Security Engineer
- **Focus:** Attack surface, data protection, compliance
- **Key questions:**
  - How can this be exploited?
  - What data is exposed?
  - Does this comply with regulations (GDPR, SOC2, HIPAA)?
  - What's the blast radius if compromised?

### Persona 3: Performance Engineer
- **Focus:** Latency, throughput, resource efficiency
- **Key questions:**
  - What's the expected p99 latency?
  - Where's the bottleneck?
  - What's the memory/CPU cost?
  - Does this create N+1 queries or hot paths?

### Persona 4: Reliability Engineer
- **Focus:** Failure modes, recovery, observability
- **Key questions:**
  - What breaks at 3am?
  - How do we detect it's broken?
  - What's the recovery procedure?
  - Are there single points of failure?

### Persona 5: Devil's Advocate
- **Focus:** Hidden assumptions, alternatives, contrarian view
- **Key questions:**
  - What if we're solving the wrong problem?
  - What's the simplest alternative we haven't considered?
  - What assumption, if wrong, makes this approach fail?
  - Who benefits from us NOT doing this?

## Execution Protocol

**Critical:** Each persona analyzes INDEPENDENTLY. Do not let one persona's analysis influence another.

For each persona:
1. State persona header and focus area
2. Read relevant files/context through that persona's lens
3. Analyze the decision from ONLY that perspective
4. Rate: **support** / **conditional support** / **oppose**
5. List top 3 concerns (specific, not vague)
6. Suggest 1-2 concrete modifications

## Synthesis

After all personas complete:

### Consensus Points
Where 4+ personas agree. These are high-confidence signals.

### Contested Points
Where opinions split (2-3 support, 2-3 oppose). These need more data.

### Blind Spots
What NO persona raised. You (the facilitator) identify these based on:
- Common failure patterns in similar systems
- Industry best practices not covered
- User experience considerations

### Final Recommendation

| Rating | Criteria |
|--------|----------|
| **GO** | 4+ support, no critical concerns, contested points are manageable |
| **GO with modifications** | Majority support, but 1-2 specific changes needed first |
| **STOP and rethink** | 3+ oppose, or 1+ critical concern that blocks progress |

Include confidence level: high (clear consensus) / medium (split opinions) / low (insufficient data).

## Chaining

- `/autoresearch:predict --chain debug` — Run expert analysis, then debug any concerns raised
- `/autoresearch:predict --chain scenario` — Run expert analysis, then generate scenarios for contested points
