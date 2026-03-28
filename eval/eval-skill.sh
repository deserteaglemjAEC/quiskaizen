#!/bin/bash
# eval-skill.sh — Binary assertion evaluator for the research-workflow SKILL.md
# Usage: bash eval-skill.sh
# Checks the SKILL.md and resource files for completeness and quality

SKILL="$HOME/.claude/skills/research-workflow/SKILL.md"
RESOURCES="$HOME/.claude/skills/research-workflow/resources"
PASS=0
TOTAL=35

echo "=== SKILL.md EVALUATION ==="

# === YAML FRONTMATTER ===

# 1. Has YAML frontmatter with name
if grep -q '^name:' "$SKILL"; then ((PASS++)); echo "1. PASS — name field present"; else echo "1. FAIL — no name in frontmatter"; fi

# 2. Has description > 50 chars (specific enough for activation)
DESC_LEN=$(sed -n '/^description:/,/^[a-z]/p' "$SKILL" | head -5 | wc -c | tr -d ' ')
if [ "$DESC_LEN" -ge 50 ]; then ((PASS++)); echo "2. PASS — description is $DESC_LEN chars (>= 50)"; else echo "2. FAIL — description only $DESC_LEN chars (need >= 50)"; fi

# 3. Description includes trigger phrases (when to activate)
if grep -qi 'research this\|deep dive\|what do experts say\|help me understand\|compare.*with.*data' "$SKILL"; then ((PASS++)); echo "3. PASS — trigger phrases in description"; else echo "3. FAIL — no trigger phrases"; fi

# 4. Has allowed-tools defined
if grep -q 'allowed-tools' "$SKILL"; then ((PASS++)); echo "4. PASS — allowed-tools defined"; else echo "4. FAIL — no allowed-tools"; fi

# === PHASE COVERAGE ===

# 5. All 5 phases present
PHASES=$(grep -c '## Phase' "$SKILL")
if [ "$PHASES" -ge 5 ]; then ((PASS++)); echo "5. PASS — $PHASES phases found"; else echo "5. FAIL — only $PHASES phases (need 5)"; fi

# 6. Each phase has a Goal statement
GOALS=$(grep -c '^\*\*Goal:\*\*' "$SKILL")
if [ "$GOALS" -ge 5 ]; then ((PASS++)); echo "6. PASS — $GOALS goal statements"; else echo "6. FAIL — only $GOALS goals (need 5)"; fi

# 7. Each phase has an Output statement
OUTPUTS=$(grep -c '^\*\*Output:\*\*' "$SKILL")
if [ "$OUTPUTS" -ge 4 ]; then ((PASS++)); echo "7. PASS — $OUTPUTS output statements"; else echo "7. FAIL — only $OUTPUTS outputs (need 4)"; fi

# === FALLBACK CHAINS ===

# 8. Phase 1 has a fallback for zero results
if grep -qi 'fallback\|<3 results\|returns.*0\|no results' "$SKILL"; then ((PASS++)); echo "8. PASS — Phase 1 fallback documented"; else echo "8. FAIL — no Phase 1 fallback"; fi

# 9. Phase 2 has a fallback chain for blocked sites
if grep -qi 'fallback.*chain\|Firecrawl.*gemini\|blocked\|unavailable' "$SKILL"; then ((PASS++)); echo "9. PASS — Phase 2 fallback chain documented"; else echo "9. FAIL — no Phase 2 fallback chain"; fi

# 10. Phase 3 has a fallback for NotebookLM unavailable
if grep -qi 'NotebookLM unavailable\|Gemini Deep Research\|separate.*session\|fresh context' "$SKILL"; then ((PASS++)); echo "10. PASS — Phase 3 fallback documented"; else echo "10. FAIL — no Phase 3 fallback"; fi

# === RESOURCE FILES ===

# 11. discovery-guide.md exists
if [ -f "$RESOURCES/discovery-guide.md" ]; then ((PASS++)); echo "11. PASS — discovery-guide.md exists"; else echo "11. FAIL — discovery-guide.md missing"; fi

# 12. source-hierarchy.md exists
if [ -f "$RESOURCES/source-hierarchy.md" ]; then ((PASS++)); echo "12. PASS — source-hierarchy.md exists"; else echo "12. FAIL — source-hierarchy.md missing"; fi

# 13. cross-examination-prompts.md exists
if [ -f "$RESOURCES/cross-examination-prompts.md" ]; then ((PASS++)); echo "13. PASS — cross-examination-prompts.md exists"; else echo "13. FAIL — cross-examination-prompts.md missing"; fi

# 14. artifact-template.md exists
if [ -f "$RESOURCES/artifact-template.md" ]; then ((PASS++)); echo "14. PASS — artifact-template.md exists"; else echo "14. FAIL — artifact-template.md missing"; fi

# === QUALITY SIGNALS ===

# 15. SKILL.md < 500 lines
LINES=$(wc -l < "$SKILL" | tr -d ' ')
if [ "$LINES" -lt 500 ]; then ((PASS++)); echo "15. PASS — SKILL.md is $LINES lines (< 500)"; else echo "15. FAIL — SKILL.md is $LINES lines (>= 500)"; fi

# 16. All resource files < 500 lines
OVERSIZED=0
for f in "$RESOURCES"/*.md; do
  RLINES=$(wc -l < "$f" | tr -d ' ')
  if [ "$RLINES" -ge 500 ]; then ((OVERSIZED++)); fi
done
if [ "$OVERSIZED" -eq 0 ]; then ((PASS++)); echo "16. PASS — all resource files < 500 lines"; else echo "16. FAIL — $OVERSIZED resource files >= 500 lines"; fi

# 17. References resource files with relative links
REFS=$(grep -c '\[.*\](resources/' "$SKILL")
if [ "$REFS" -ge 3 ]; then ((PASS++)); echo "17. PASS — $REFS resource file references"; else echo "17. FAIL — only $REFS resource refs (need >= 3)"; fi

# 18. Mentions eval script
if grep -qi 'eval.*script\|eval-research-artifact\|CLAUDE_SKILL_DIR.*scripts' "$SKILL"; then ((PASS++)); echo "18. PASS — eval script referenced"; else echo "18. FAIL — no eval script reference"; fi

# 19. Prerequisites check section exists
if grep -qi 'prerequisite\|verify.*tools\|minimum viable' "$SKILL"; then ((PASS++)); echo "19. PASS — prerequisites documented"; else echo "19. FAIL — no prerequisites section"; fi

# 20. Multi-model principle stated (use different model for synthesis)
if grep -qi 'different model\|same.*bias\|cross-model\|DIFFERENT.*model' "$SKILL"; then ((PASS++)); echo "20. PASS — multi-model principle stated"; else echo "20. FAIL — no multi-model principle"; fi

# === INSTRUCTION DEPTH (derived from Run 0 failure modes) ===

# 21. Context budget/window management guidance
if grep -qi 'context.*budget\|token.*limit\|context.*window\|context.*exhaust\|context.*pressure' "$SKILL"; then ((PASS++)); echo "21. PASS — context budget guidance present"; else echo "21. FAIL — no context budget/window management guidance"; fi

# 22. Source diversity requirement (different platforms/domains)
if grep -qi 'divers\|different.*platform\|multiple.*source.*type\|vary.*source\|mix.*source' "$SKILL"; then ((PASS++)); echo "22. PASS — source diversity requirement present"; else echo "22. FAIL — no source diversity guidance"; fi

# 23. Topic scoping guidance (handle too broad or too narrow)
if grep -qi 'too broad\|narrow.*scope\|scope.*topic\|refine.*topic\|decompos\|narrow.*down' "$SKILL"; then ((PASS++)); echo "23. PASS — topic scoping guidance present"; else echo "23. FAIL — no topic scoping guidance"; fi

# 24. Quality gate / checkpoint between phases
if grep -qi 'gate\|checkpoint\|verify.*before.*next\|check.*before.*proceed\|phase.*complete\|before.*moving' "$SKILL"; then ((PASS++)); echo "24. PASS — quality gate between phases"; else echo "24. FAIL — no quality gate between phases"; fi

# 25. Anti-patterns or warnings in SKILL.md itself (not just resource files)
WARNINGS=$(grep -ci 'anti-pattern\|common mistake\|warning\|do not\|avoid\|don.t skip' "$SKILL")
if [ "$WARNINGS" -ge 2 ]; then ((PASS++)); echo "25. PASS — $WARNINGS warnings/anti-patterns in SKILL.md"; else echo "25. FAIL — only $WARNINGS warnings (need >= 2 in SKILL.md)"; fi

# === ARTIFACT QUALITY DRIVERS (instructions that produce better artifacts) ===

# 26. Instruction to document surprises/unexpected findings
if grep -qi 'surpris\|unexpected\|changed.*mind\|assumption.*wrong\|what.*wrong.*about' "$SKILL"; then ((PASS++)); echo "26. PASS — surprise documentation instruction"; else echo "26. FAIL — no instruction to document surprises"; fi

# 27. Instruction to document limitations/gaps
if grep -qi 'limitation\|gap.*research\|acknowledge.*scope\|what.*not.*cover\|what.*miss' "$SKILL"; then ((PASS++)); echo "27. PASS — limitations documentation instruction"; else echo "27. FAIL — no instruction to document limitations"; fi

# 28. Correction classification system in SKILL.md (not just in resource file)
if grep -qi 'valid correction\|valid nuance\|overstated\|classify.*correction\|categorize.*challenge' "$SKILL"; then ((PASS++)); echo "28. PASS — correction classification in SKILL.md"; else echo "28. FAIL — correction classification only in resource file, not SKILL.md"; fi

# 29. Explicit instruction to READ/consult resource files during execution
if grep -qi 'read.*resource\|consult.*guide\|follow.*guide\|see.*guide.*for\|refer.*to.*resource' "$SKILL"; then ((PASS++)); echo "29. PASS — explicit instruction to read resource files"; else echo "29. FAIL — resource files linked but no instruction to read them"; fi

# 30. Research variant guidance (comparison vs landscape vs how-to)
if grep -qi 'comparison.*research\|decision.*research\|landscape.*research\|type.*research\|variant\|research.*type\|X vs Y\|versus' "$SKILL"; then ((PASS++)); echo "30. PASS — research variant guidance present"; else echo "30. FAIL — no research variant guidance (one-size-fits-all)"; fi

# === OPERATIONAL ROBUSTNESS (handle failure gracefully) ===

# 31. Context exhaustion recovery plan
if grep -qi 'context.*exhaust.*\|running.*out.*context\|fresh.*session\|split.*session\|new.*session.*continu\|overflow\|save.*progress' "$SKILL"; then ((PASS++)); echo "31. PASS — context exhaustion recovery plan"; else echo "31. FAIL — no context exhaustion recovery plan"; fi

# 32. Phase failure handling (what if a phase produces nothing)
if grep -qi 'phase.*fail\|no.*result\|empty.*result\|skip.*phase\|nothing.*found\|produce.*nothing\|zero.*result' "$SKILL"; then ((PASS++)); echo "32. PASS — phase failure handling present"; else echo "32. FAIL — no phase failure handling"; fi

# 33. Parallel execution mentioned >= 2 times (not just Phase 2 scraping)
PARALLEL_COUNT=$(grep -ci 'parallel\|concurrent\|simultaneous' "$SKILL")
if [ "$PARALLEL_COUNT" -ge 2 ]; then ((PASS++)); echo "33. PASS — parallel execution mentioned $PARALLEL_COUNT times"; else echo "33. FAIL — parallel only mentioned $PARALLEL_COUNT time(s) (need >= 2)"; fi

# 34. Total source target across all phases
if grep -qi 'total.*source\|minimum.*[0-9].*source.*across\|combined.*source\|overall.*[0-9].*source\|aim.*for.*[0-9].*source' "$SKILL"; then ((PASS++)); echo "34. PASS — total source target specified"; else echo "34. FAIL — no total source target across phases"; fi

# 35. Template verification instruction (not just linking the template)
if grep -qi 'verify.*template\|check.*against.*template\|match.*template\|compare.*artifact.*template\|ensure.*follow.*template' "$SKILL"; then ((PASS++)); echo "35. PASS — artifact template verification instruction"; else echo "35. FAIL — template linked but no verification instruction"; fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SCORE: $PASS / $TOTAL"
echo "PASS RATE: $(( PASS * 100 / TOTAL ))%"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
