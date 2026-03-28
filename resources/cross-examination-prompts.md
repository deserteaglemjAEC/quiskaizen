# Cross-Examination Prompts — Phase 4

## Primary Devil's Advocate Prompt

Send to Gemini Pro (or any model DIFFERENT from your synthesis model):

```
I'm about to [act on / publish / implement] research on [TOPIC].
Below is my current synthesis from [N] sources.

I need you to act as a devil's advocate. Tell me:
1. What am I wrong about?
2. What am I missing?
3. What would an expert disagree with?
4. What assumptions am I making that could be dangerous?

HERE IS MY SYNTHESIS:

[paste synthesis]
```

## Domain-Specific Cross-Examination Prompts

### For technology/architecture decisions:
```
Add to the base prompt:
5. What would fail in production that looks fine in theory?
6. What's the cost (tokens, latency, money) I'm underestimating?
7. In 6 months, which of these recommendations will be outdated?
```

### For market/competitive research:
```
Add to the base prompt:
5. What competitor or alternative am I not seeing?
6. Which trend am I overweighting because it's recent?
7. What would someone who disagrees with my conclusion say?
```

### For process/workflow design:
```
Add to the base prompt:
5. Where will a first-time user get stuck?
6. What's the weakest link in the chain?
7. What happens when the primary tool is unavailable?
```

## How to Process Cross-Examination Results

1. For each challenge, classify:
   - **Valid correction** — update the synthesis
   - **Valid nuance** — add a caveat, don't change the conclusion
   - **Overstated concern** — note it but don't act on it
   - **Wrong** — the cross-examiner is wrong, explain why

2. Document corrections in the artifact under "## Corrections"

## Anti-Patterns

- Using the SAME model that did synthesis (same biases, same blind spots)
- Accepting all challenges without evaluating (cross-exam can be wrong too)
- Skipping this phase because "the synthesis looks solid" (confirmation bias)
