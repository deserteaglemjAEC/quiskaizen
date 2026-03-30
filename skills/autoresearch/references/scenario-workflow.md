# Scenario Workflow Protocol

Systematic edge case exploration across 12 dimensions.

## Setup

Collect via `AskUserQuestion`:
1. Target — what system/feature/plan to stress-test
2. Domain — software, marketing, sales, research, operations
3. Output format — narrative, test cases, checklist (default: checklist)

## The 12 Dimensions

For each dimension, generate 2-5 specific, concrete scenarios.

### 1. Happy Path
- What does the ideal user journey look like?
- What's the most common use case?
- What does success look like end-to-end?

### 2. Error Handling
- What happens when the database is down?
- What if the API returns 500?
- What if the network drops mid-operation?

### 3. Edge Cases
- Empty input, null, undefined
- Maximum length strings
- Boundary values (0, -1, MAX_INT)
- Unicode, emoji, RTL text

### 4. Abuse / Misuse
- What if someone sends 10,000 requests per second?
- What if input contains SQL injection or XSS?
- What if someone submits the form 100 times?

### 5. Scale
- 10x current load
- 100x current load
- 1000x current load
- What breaks first?

### 6. Concurrency
- Two users editing the same record simultaneously
- Race condition on create + read
- Distributed lock contention

### 7. Temporal
- Clock skew between servers
- Daylight saving time transitions
- Leap year edge cases
- Operations spanning midnight

### 8. Data Variation
- Null fields in required positions
- Extremely long values
- Special characters: `<>&"'\;\|\`
- Mixed encodings (UTF-8, Latin-1)

### 9. Permissions
- Unauthenticated access attempt
- Authenticated but unauthorized (wrong role)
- Expired token
- Admin accessing user-scoped data

### 10. Integrations
- External API returns unexpected schema
- Webhook delivery fails
- Third-party service is rate-limiting you
- SSL certificate expired on external service

### 11. Recovery
- System crash during write operation
- Power loss and restart
- Partial migration (half the data migrated)
- Rollback after failed deployment

### 12. State Transitions
- Invalid state sequence (e.g., "shipped" before "paid")
- Duplicate state transitions
- Concurrent state changes
- Orphaned records from interrupted workflows

## Output Format

### Checklist (default)
```
## Dimension: Error Handling
- [ ] [HIGH] API returns 500 during checkout — user sees generic error, cart preserved
- [ ] [MED] Database timeout on search — fallback to cached results
- [ ] [LOW] Image CDN down — placeholder images shown
```

### Test Cases
```
describe('Error Handling', () => {
  it('should preserve cart when API returns 500 during checkout', () => {
    // Setup: mock API to return 500
    // Act: attempt checkout
    // Assert: cart items still present, error message shown
  });
});
```

### Narrative
Full prose description of each scenario with expected behavior and failure impact.

## Severity Rating

| Level | Criteria |
|-------|----------|
| Critical | Data loss, security breach, complete outage |
| High | Feature broken, degraded experience for many users |
| Medium | Edge case failure, workaround exists |
| Low | Cosmetic, rare conditions, minimal impact |
