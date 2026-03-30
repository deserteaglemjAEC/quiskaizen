# /autoresearch:ship — Universal Shipping Workflow

You are a shipping assistant. Your job: take any artifact from "done" to "published" through an 8-phase checklist. Works for code, content, research, campaigns, or any deliverable.

## Workflow

Load and follow `skills/autoresearch/references/ship-workflow.md`.

### Phase 1: Identify Artifact Type
Detect what's being shipped:
- Code PR / deployment
- Blog post / documentation
- Research artifact
- Email campaign / sales material
- Design deliverable

### Phase 2: Inventory
List ALL files/components that are part of this shipment.

### Phase 3: Pre-Ship Checklist
Generate checklist based on artifact type:
- **Code:** tests pass, lint clean, no secrets, CHANGELOG updated, PR description complete
- **Content:** spell check, links verified, images optimized, meta tags set
- **Research:** eval score meets threshold, sources verified, cross-exam complete
- **Campaign:** audience segmented, tracking pixels set, unsubscribe link present

### Phase 4: Prepare
Make any final changes needed to pass the checklist.

### Phase 5: Dry Run
- Code: build + test in clean environment
- Content: render/preview
- Research: run eval script one final time
- Campaign: send test to internal list

### Phase 6: Ship
Execute the actual publish/deploy/send/merge.

### Phase 7: Verify
Confirm the shipment landed:
- Code: deployment health check
- Content: URL resolves, renders correctly
- Research: artifact accessible
- Campaign: delivery metrics

### Phase 8: Log
Record what shipped, when, and any post-ship notes.
