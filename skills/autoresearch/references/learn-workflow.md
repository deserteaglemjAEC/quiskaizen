# Learn Workflow Protocol

Autonomous documentation engine. 4 modes: init, update, check, summarize.

## Setup

Collect via `AskUserQuestion`:
1. Mode: init / update / check / summarize (default: init)
2. Scope: whole repo, specific directory, single feature

## Mode: init — Generate from Scratch

### Step 1: Scout
- Read directory structure (`find . -type f | head -100`)
- Identify entry points (main files, index files, app files)
- Read package.json / pyproject.toml / Cargo.toml / go.mod
- Read existing README (if any)
- Read CI/CD config

### Step 2: Map Architecture
Determine pattern:
- Monolith, microservices, monorepo, library, CLI tool, API server
- Language(s) and framework(s)
- Key directories and their purposes
- Data flow (entry point → processing → output)

### Step 3: Generate Documentation
Create (or update) these files:

**README.md:**
- What it does (1-2 sentences)
- Quick start (install + run in 3 commands)
- Architecture overview (ASCII diagram)
- Key decisions and trade-offs
- Contributing guide pointer

**Architecture doc (if complex):**
- Component diagram
- Data flow
- Key abstractions
- Extension points

**API reference (if applicable):**
- Endpoints with request/response examples
- Authentication requirements
- Error codes

### Step 4: Validate
- Every file reference in docs → verify file exists
- Every function reference → verify function exists with correct signature
- Every command → verify it runs (or note if it requires setup)
- All links → verify they resolve

## Mode: update — Refresh Existing Docs

### Step 1: Diff
- `git diff <last-doc-update>..HEAD` — what changed in code?
- Read current docs
- Identify gaps: new files not documented, changed APIs not reflected

### Step 2: Patch
- Update ONLY what changed (minimal edits)
- Don't rewrite sections that are still accurate
- Add documentation for new features
- Remove documentation for deleted features

### Step 3: Validate
Same as init Step 4.

## Mode: check — Audit Accuracy

### Step 1: Read all documentation files

### Step 2: Verify every claim
- File paths mentioned → `test -f <path>`
- Function signatures → grep for actual definition
- Command examples → attempt to run (dry-run if destructive)
- Links → check if they resolve
- Version numbers → compare against package config

### Step 3: Report
```
Accuracy: 47/52 claims verified (90.4%)
Stale: 3 (function renamed, endpoint removed, config key changed)
Missing: 2 (new module undocumented, new env var not listed)
```

### Step 4: Fix (up to 3 rounds)
- Fix stale claims
- Add missing documentation
- Re-verify after each round
- Stop after 3 rounds even if not perfect (log remaining issues)

## Mode: summarize — Quick Overview

### Step 1: Read entry points only
- README, main/index file, key config files

### Step 2: Output 1-page summary
- What it does
- How to run it
- Key decisions / design choices
- Gotchas / known issues
- Where to look for more detail
