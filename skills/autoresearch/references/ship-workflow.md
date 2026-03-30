# Ship Workflow Protocol

8-phase universal shipping workflow. Works for any artifact type.

## Phase 1: Identify Artifact Type

Auto-detect from context:

| Type | Detection Signal |
|------|-----------------|
| Code PR | Git branch with changes, test files present |
| Deployment | Dockerfile, CI/CD config, infrastructure files |
| Blog/Docs | Markdown files, frontmatter, content directory |
| Research artifact | Artifact template structure, eval script reference |
| Email campaign | Subject lines, recipient lists, HTML templates |
| Sales material | Pitch decks, proposals, case studies |
| Design deliverable | Figma links, image assets, style guides |

If ambiguous, use `AskUserQuestion` to confirm.

## Phase 2: Inventory

List ALL components of the shipment:
- Files modified (git diff --stat)
- New files created
- Dependencies added/removed
- Config changes
- Documentation updates needed

## Phase 3: Pre-Ship Checklist

Generate based on artifact type:

### Code
- [ ] All tests pass (`npm test` / `pytest` / etc.)
- [ ] Lint clean (no warnings, no errors)
- [ ] No secrets in diff (grep for API_KEY, PASSWORD, SECRET)
- [ ] CHANGELOG updated
- [ ] PR description complete
- [ ] Breaking changes documented

### Content
- [ ] Spell check passed
- [ ] All links verified (no 404s)
- [ ] Images optimized and alt-tagged
- [ ] Meta tags / SEO set
- [ ] Mobile rendering checked

### Research Artifact
- [ ] Eval score meets threshold (target: 20/20)
- [ ] Sources verified (links resolve)
- [ ] Cross-examination complete
- [ ] Artifact template followed
- [ ] Date and methodology documented

## Phase 4: Prepare

Execute fixes for any failed checklist items. One fix at a time, verify after each.

## Phase 5: Dry Run

| Type | Dry Run |
|------|---------|
| Code | Build in clean env, run full test suite |
| Content | Preview/render, check in multiple browsers |
| Research | Run eval script one final time |
| Deployment | Deploy to staging, smoke test |

## Phase 6: Ship

Execute the publish action:
- Code: merge PR, deploy
- Content: publish post, send newsletter
- Research: save artifact, share link
- Deployment: promote staging to production

**Confirm with user before executing.** This is the point of no return.

## Phase 7: Verify

Confirm successful delivery:
- Code: health check endpoint returns 200
- Content: URL resolves, renders correctly
- Research: artifact accessible, eval score confirmed
- Deployment: monitoring dashboards green

## Phase 8: Log

Record:
- What shipped
- When (timestamp)
- Final metrics (test results, eval score, etc.)
- Post-ship notes (known issues, follow-ups)
