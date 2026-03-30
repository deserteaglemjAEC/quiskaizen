# Security Workflow Protocol

STRIDE + OWASP + Red Team audit. READ-ONLY by default.

## Phase 1: Asset Discovery (5 min)

Scan the codebase for:

| Asset Type | How to Find |
|------------|-------------|
| API endpoints | Grep for route definitions, `@Get`, `@Post`, `app.get`, `router.` |
| Auth flows | Grep for `auth`, `login`, `session`, `token`, `jwt`, `oauth` |
| Data stores | Grep for database connections, ORM models, `.env` database URLs |
| External integrations | Grep for `fetch`, `axios`, `http.get`, webhook URLs |
| Secrets handling | Grep for `API_KEY`, `SECRET`, `PASSWORD`, `.env`, credentials |
| File uploads | Grep for `multer`, `formidable`, `multipart`, file write operations |
| User input | Grep for `req.body`, `req.params`, `req.query`, form handlers |

Map trust boundaries:
```
User Input --> Validation --> Business Logic --> Data Store
                  |                |
                  v                v
            External APIs    Background Jobs
```

## Phase 2: STRIDE Analysis (10 min)

For EACH trust boundary crossing:

| Threat | Check | Severity |
|--------|-------|----------|
| **S**poofing | Is authentication enforced? Can tokens be forged? | Critical if auth bypass possible |
| **T**ampering | Is input validated? Can payloads be modified in transit? | High if data integrity at risk |
| **R**epudiation | Are actions logged with user identity + timestamp? | Medium if no audit trail |
| **I**nfo Disclosure | Can error messages leak internals? Are secrets in logs? | High if PII/secrets exposed |
| **D**enial of Service | Are there rate limits? Can large payloads crash the system? | High if no throttling |
| **E**levation of Privilege | Are role checks enforced per endpoint? IDOR possible? | Critical if privilege escalation |

## Phase 3: OWASP Top 10 (10 min)

| # | Category | What to Check |
|---|----------|---------------|
| A01 | Broken Access Control | Missing auth middleware, IDOR, path traversal |
| A02 | Cryptographic Failures | Weak hashing, plaintext secrets, missing TLS |
| A03 | Injection | SQL injection, command injection, XSS |
| A04 | Insecure Design | Missing rate limits, no abuse prevention |
| A05 | Security Misconfiguration | Default credentials, debug mode in prod, open CORS |
| A06 | Vulnerable Components | Known CVEs in dependencies |
| A07 | Auth Failures | Weak passwords, missing MFA, session fixation |
| A08 | Data Integrity Failures | Unsigned updates, unvalidated CI/CD pipelines |
| A09 | Logging Failures | Missing audit logs, sensitive data in logs |
| A10 | SSRF | User-controlled URLs passed to server-side fetch |

## Phase 4: Red Team — 4 Personas (15 min)

Each persona operates INDEPENDENTLY:

### Persona 1: External Attacker
- No credentials. Public surface only.
- Tries: port scanning, public endpoint fuzzing, auth bypass, error message harvesting

### Persona 2: Malicious Insider
- Valid credentials (lowest privilege role).
- Tries: privilege escalation, IDOR, accessing other users' data, API abuse

### Persona 3: Supply Chain Attacker
- Compromised a dependency or build step.
- Tries: injecting malicious code via dependency, build script manipulation, CI/CD poisoning

### Persona 4: Data Exfiltrator
- Goal: extract PII, secrets, or business data.
- Tries: SQL injection for bulk export, log file access, backup file discovery, memory dumps

## Output

### Threat Matrix
```
Asset          | S | T | R | I | D | E | Severity
---------------|---|---|---|---|---|---|----------
/api/login     | H | M | L | H | M | C | Critical
/api/users/:id | M | H | L | H | L | H | High
/api/upload    | L | H | M | M | H | M | High
```

### Findings List
For each finding:
- **ID:** SEC-NNN
- **Category:** STRIDE letter or OWASP number
- **File:Line:** exact location
- **Severity:** Critical / High / Medium / Low
- **Description:** what's wrong
- **Remediation:** how to fix

### Remediation Checklist
Prioritized by severity. If user says "fix", transition to `/autoresearch:fix` targeting security findings.
