#!/bin/bash
# eval-research-artifact.sh — Binary assertion evaluator for research artifacts
# Usage: bash eval-research-artifact.sh <path-to-artifact.md>
# Output: SCORE: N / 15 and PASS RATE: N%
#
# Assertions derived from autoresearch:plan wizard (2026-03-28)
# Trust criteria: claims must have sources, official source must be cited
# Usefulness criteria: actionable checklist, specific names, comparison tables, time estimates
# Rigor criteria: surprises noted, contradictions documented, methodology transparent

ARTIFACT="$1"
if [ -z "$ARTIFACT" ] || [ ! -f "$ARTIFACT" ]; then
  echo "Usage: bash eval-research-artifact.sh <artifact.md>"
  exit 1
fi

PASS=0
TOTAL=20

# === TRUST (sourcing & citations) ===

# 1. Sources referenced inline
if grep -qi 'source\|per @\|per r/\|Anthropic\|official' "$ARTIFACT"; then ((PASS++)); echo "1. PASS — Sources referenced"; else echo "1. FAIL — No source citations found"; fi

# 2. Official/vendor source cited
if grep -qi 'code.claude.com\|official.*doc\|vendor.*doc\|Anthropic.*doc' "$ARTIFACT"; then ((PASS++)); echo "2. PASS — Official source cited"; else echo "2. FAIL — No official source"; fi

# 3. Numbered Sources section exists
if grep -q '## Sources' "$ARTIFACT"; then ((PASS++)); echo "3. PASS — Sources section exists"; else echo "3. FAIL — No Sources section"; fi

# === USEFULNESS (actionability) ===

# 4. Action checklist with checkboxes (>= 3 items)
COUNT4=$(grep -c '\- \[ \]' "$ARTIFACT" 2>/dev/null || echo 0)
if [ "$COUNT4" -ge 3 ]; then ((PASS++)); echo "4. PASS — $COUNT4 action items found"; else echo "4. FAIL — Only $COUNT4 action items (need >= 3)"; fi

# 5. Specific tool/product names (>= 5 unique names)
COUNT5=$(grep -oiE '[A-Z][a-z]+[A-Z][a-z]+|NotebookLM|Firecrawl|Karpathy|Claude Code|Gemini|Anthropic' "$ARTIFACT" | sort -u | wc -l | tr -d ' ')
if [ "$COUNT5" -ge 5 ]; then ((PASS++)); echo "5. PASS — $COUNT5 specific names found"; else echo "5. FAIL — Only $COUNT5 specific names (need >= 5)"; fi

# 6. At least 1 comparison table (>= 3 table rows)
COUNT6=$(grep -c '|.*|.*|.*|' "$ARTIFACT" 2>/dev/null || echo 0)
if [ "$COUNT6" -ge 3 ]; then ((PASS++)); echo "6. PASS — $COUNT6 table rows found"; else echo "6. FAIL — Only $COUNT6 table rows (need >= 3)"; fi

# 7. Time estimates present
if grep -qi 'min\b\|hour\|minutes\|seconds\|5 min\|10 min\|15 min\|30 min' "$ARTIFACT"; then ((PASS++)); echo "7. PASS — Time estimates present"; else echo "7. FAIL — No time estimates"; fi

# === STRUCTURAL (format quality) ===

# 8. Single file (always passes if we got here)
((PASS++)); echo "8. PASS — Single file"

# 9. Table of Contents
if grep -q '## Table of Contents' "$ARTIFACT"; then ((PASS++)); echo "9. PASS — Table of Contents exists"; else echo "9. FAIL — No Table of Contents"; fi

# 10. Length < 500 lines (dense, not bloated)
LINES=$(wc -l < "$ARTIFACT" | tr -d ' ')
if [ "$LINES" -lt 500 ]; then ((PASS++)); echo "10. PASS — $LINES lines (< 500)"; else echo "10. FAIL — $LINES lines (>= 500, too long)"; fi

# === RIGOR (research depth) ===

# 11. All content sections have at least some attribution
SECTIONS_WITHOUT_CITE=0
IN_SECTION=0
SECTION_NAME=""
HAS_CITE=0
while IFS= read -r line; do
  if echo "$line" | grep -q '^## '; then
    if [ $IN_SECTION -eq 1 ] && [ $HAS_CITE -eq 0 ] && [ "$SECTION_NAME" != "Table of Contents" ] && [ "$SECTION_NAME" != "Sources" ] && [ "$SECTION_NAME" != "The Ideal Structure" ]; then
      ((SECTIONS_WITHOUT_CITE++))
    fi
    SECTION_NAME=$(echo "$line" | sed 's/^## //')
    IN_SECTION=1
    HAS_CITE=0
  fi
  if echo "$line" | grep -qi 'source\|per @\|per r/\|Anthropic\|official\|community\|cross-exam\|Gemini\|NotebookLM'; then
    HAS_CITE=1
  fi
done < "$ARTIFACT"
if [ $SECTIONS_WITHOUT_CITE -eq 0 ]; then ((PASS++)); echo "11. PASS — All content sections have citations"; else echo "11. FAIL — $SECTIONS_WITHOUT_CITE sections lack citations"; fi

# 12. Surprise/unexpected findings explicitly noted
if grep -qi 'surpris\|changed.*mind\|unexpected\|counter.?intuitive\|didn.t expect\|what we were wrong about\|turned out to be wrong' "$ARTIFACT"; then ((PASS++)); echo "12. PASS — Surprise findings noted"; else echo "12. FAIL — No explicit surprise findings"; fi

# 13. Cross-examination with specific corrections (>= 3)
CORRECTIONS=$(grep -c '^### [0-9]' "$ARTIFACT" 2>/dev/null || echo 0)
if [ "$CORRECTIONS" -ge 3 ]; then ((PASS++)); echo "13. PASS — $CORRECTIONS specific corrections"; else echo "13. FAIL — Only $CORRECTIONS corrections (need >= 3)"; fi

# 14. Contradictions/debates documented
if grep -qi '## Debate\|contradict\|disagree\|sources.*contradict' "$ARTIFACT"; then ((PASS++)); echo "14. PASS — Contradictions documented"; else echo "14. FAIL — No contradictions section"; fi

# 15. Research methodology documented
if grep -qi 'Research method\|5-phase\|Phase 1.*Discover\|workflow.*Discover.*Read' "$ARTIFACT"; then ((PASS++)); echo "15. PASS — Methodology documented"; else echo "15. FAIL — No methodology section"; fi

# === DEPTH (tightened assertions — added step 2) ===

# 16. Multiple models used in synthesis (not just one AI)
MODELS=$(grep -oi 'NotebookLM\|Gemini\|Claude\|GPT\|Haiku\|Sonnet\|Opus' "$ARTIFACT" | sort -u | wc -l | tr -d ' ')
if [ "$MODELS" -ge 2 ]; then ((PASS++)); echo "16. PASS — $MODELS distinct models referenced"; else echo "16. FAIL — Only $MODELS model referenced (need >= 2 for cross-model synthesis)"; fi

# 17. Source count >= 10 unique sources in Sources section
SOURCE_COUNT=$(sed -n '/## Sources/,$ p' "$ARTIFACT" | grep -c '^[0-9]' 2>/dev/null || echo 0)
if [ "$SOURCE_COUNT" -ge 10 ]; then ((PASS++)); echo "17. PASS — $SOURCE_COUNT sources listed"; else echo "17. FAIL — Only $SOURCE_COUNT sources (need >= 10)"; fi

# 18. "What we didn't research" or acknowledged limitations
if grep -qi 'didn.t research\|limitation\|out of scope\|not covered\|gap.*remain\|we haven.t\|still missing\|one gap' "$ARTIFACT"; then ((PASS++)); echo "18. PASS — Limitations acknowledged"; else echo "18. FAIL — No limitations or gaps acknowledged"; fi

# 19. Date/freshness indicator (research date + source recency)
if grep -qi '202[56]-[0-9][0-9]\|March 202[56]\|last 30 days\|as of' "$ARTIFACT"; then ((PASS++)); echo "19. PASS — Freshness/date indicators present"; else echo "19. FAIL — No date or freshness markers"; fi

# 20. Actionable items have priority or sequencing (not just a flat list)
if grep -qi 'Phase 1\|Phase 2\|Phase 3\|Step 1\|Step 2\|ordered by impact\|priority\|first.*then' "$ARTIFACT"; then ((PASS++)); echo "20. PASS — Actions are sequenced/prioritized"; else echo "20. FAIL — Action items lack sequencing or priority"; fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SCORE: $PASS / $TOTAL"
echo "PASS RATE: $(( PASS * 100 / TOTAL ))%"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
