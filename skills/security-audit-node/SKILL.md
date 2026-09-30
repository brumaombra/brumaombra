---
name: security-audit-node
description: 'Security audit for Node.js / JavaScript backends (Express, Fastify, Koa, Nitro/h3, plain http, workers, CLIs). Maps the attack surface, traces untrusted input to dangerous sinks, and reports scored findings with severity, CWE/OWASP reference, exploit path, evidence, and a concrete fix. Use when asked to audit, security-review, pentest, harden, or find vulnerabilities in Node.js code, or before shipping auth, payments, uploads, webhooks, or LLM features. Also the base methodology for framework-specific audit skills.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Node.js Security Audit

Audit like a senior application-security engineer: combine SAST-style coverage with human reasoning about reachability and business logic. Report only issues an attacker can realistically exploit, or bad practices with real risk. Every finding needs evidence and a concrete fix.

References: OWASP Top 10:2025, OWASP Top 10 for LLM Applications 2025, CWE Top 25, OWASP ASVS.

## Workflow

Follow these steps in order. Read the code; don't guess from file names.

1. **Map the attack surface.** List every entry point: HTTP routes, webhooks, SSE/WebSocket endpoints, background jobs and schedulers, queue consumers, CLI/admin commands, file upload/download, outbound HTTP calls, email/notification triggers, and LLM features. For each one, note the trust boundary, who controls the input, and the high-impact sinks it reaches (DB writes, shell, file system, auth decisions, money or state changes).
2. **Audit the critical paths first**: authentication, authorization, injection sinks, and secrets.
3. **Trace tainted data** from source → parsing → validation → transformation → sink. Treat as untrusted: params, query, body, headers, cookies, file names, content and metadata, webhook payloads, queue messages, third-party API responses, and LLM output. Check that decoding and normalization happen *before* validation, and look for injection introduced after transformation or templating.
4. **Verify exploitability** of each suspect: attacker control, reachability of the sink, missing neutralization, and a realistic payload that leads to impact. Discard anything that fails.
5. **Review business logic, availability, and dependencies** (see the checklist).
6. **Report** in the output format below.

## Checklist

### Access control (A01) and authentication (A07)
- Every protected route and every internal service it calls enforces auth. Watch for routes that are guarded while the underlying service is callable unguarded.
- Ownership and tenant checks on **every** read, update, and delete, not just reads (IDOR, CWE-639). Admin or bypass flags must not be reachable from user input.
- Tokens: signature, `exp`, `iss`, and `aud` verified. Algorithm pinned (reject `alg: none` and HS/RS confusion). Revocation honored where it matters.
- Cookies: `HttpOnly`, `Secure`, `SameSite`. CSRF protection on state-changing endpoints that use cookie auth. No session fixation.
- Passwords are hashed with argon2, bcrypt, or scrypt. Secret comparisons use `crypto.timingSafeEqual`. Login, reset, and OTP flows are rate-limited and don't allow user enumeration.
- Open redirects: redirect targets taken from input must be allow-listed (CWE-601).

### Injection (A05)
- SQL: raw queries or string interpolation in query builders or ORMs (`knex.raw`, `whereRaw`, `sequelize.query`) with user input. Identifiers such as sort and column names must be allow-listed.
- NoSQL: operator injection (`$where`, `$ne`, `$gt`) from request objects merged directly into queries.
- Command execution: `exec`, `execSync`, or `spawn` with `shell: true`, or unescaped arguments (CWE-78). Prefer `execFile` with an argument array.
- Code execution: `eval`, `new Function`, `vm`, dynamic `require`/`import` of user-controlled paths, and unsafe deserialization (`node-serialize`, YAML `load`) (CWE-94, CWE-502).
- Templates: server-side template injection, unescaped HTML output (XSS, CWE-79), and header or response splitting.
- Path traversal (CWE-22): `path.join` with user input and no resolve-and-prefix check; zip slip; symlinks.
- Log injection: unsanitized newlines or control characters in logs (CWE-117).

### JavaScript-specific
- **Prototype pollution** (CWE-1321): deep merges or `Object.assign` of request data, or `obj[userKey] = value` with keys like `__proto__`, `constructor`, or `prototype`. Also check vulnerable versions of merge/clone libraries.
- **ReDoS** (CWE-1333): catastrophic-backtracking regexes run on user input.
- **Mass assignment** (CWE-915): request bodies spread into DB inserts or updates without a field allow-list (`role`, `balance`, `userId`, `isAdmin`).
- **Type confusion**: arrays or objects where strings are expected (`?id[]=1`, `{ "$gt": "" }`). The validation schema must enforce types.

### SSRF (CWE-918)
- Outbound requests to user-supplied URLs (webhooks, image fetchers, link previews, imports). They need an allow-list, blocking of private, loopback, link-local, and metadata IPs (`169.254.169.254`) *after* DNS resolution, redirect limits, and timeouts.

### Secrets and cryptography (A04)
- No hardcoded keys, tokens, or passwords, and no committed `.env` files or credentials in CI config. Check git history when relevant.
- No secrets in logs, error messages, client bundles, or startup output.
- No MD5 or SHA-1 for security purposes, no `Math.random()` for tokens (use `crypto.randomBytes` or `randomUUID`), no homemade crypto, and no static IVs.
- Webhook signatures are verified against the **raw** body with a timing-safe comparison, plus replay protection (timestamp or event ID).

### Configuration (A02)
- CORS: no `*` with credentials and no reflected `Origin`.
- Security headers: CSP, HSTS, `X-Content-Type-Options`, `frame-ancestors` (Helmet or equivalent).
- No debug mode, stack traces, or source maps exposed in production. No exposed `.env`, admin, metrics, or health endpoints that leak internals.
- Proxy trust: client IP taken from `X-Forwarded-For` only behind a trusted proxy. Otherwise rate limits and IP bans can be bypassed by spoofing the header.

### Files and uploads
- Size, count, and time limits; extension *and* content (magic-byte) checks; server-generated file names; storage outside the web root; safe archive extraction; temp files cleaned up.

### Business logic and integrity (A06, A08)
- Race conditions and TOCTOU around balances, quotas, inventory, and one-time actions. Look for missing transactions, missing row locks, and read-then-write sequences.
- Double-spend and replay: idempotency keys, one-time tokens and links, and stale events.
- Multi-step flows that can be reordered or skipped, and state transitions that grant privileges.
- Partial failure followed by a retry with manipulated state.

### Availability
- Rate limiting on sensitive and expensive endpoints, keyed sensibly (user plus IP).
- Body-size limits, pagination caps, and query cost limits.
- Timeouts on outbound calls. Caps on concurrent connections (SSE/WebSocket), queue backpressure, and bounded retries.
- Unhandled promise rejections or exceptions that crash the process.

### Supply chain (A03)
- Run or recommend `npm audit` and check for known-vulnerable versions.
- A lockfile is committed and CI uses `npm ci`.
- Look for suspicious or typosquatted packages, `postinstall` scripts, git or URL dependencies, and abandoned packages in security-critical paths.

### Errors and logging (A09, A10)
- Internal errors, stack traces, and SQL or schema details are not sent to clients.
- Code fails closed: an exception in an auth or validation check must deny, not allow.
- Auth failures and suspicious activity are logged, with no tokens or PII in the logs.
- Critical operations leave an audit trail.

### LLM features (OWASP LLM Top 10)
- Prompt injection, direct and indirect (through fetched content, documents, or tool results).
- Model output used in SQL, shell, HTML, or tool calls without validation (improper output handling).
- Excessive agency: tools with broader permissions than the user has.
- System prompt or secret leakage, and sensitive data sent to the model.
- Unbounded consumption: token and cost limits, and rate limits per user.

## Severity

- **Critical**: RCE, auth bypass, cross-user data access at scale, or theft of secrets or credentials.
- **High**: account takeover, privilege escalation, IDOR on sensitive data, stored XSS, SSRF to internal services, or money/state manipulation.
- **Medium**: exploitation needs preconditions, or the impact is limited (reflected XSS, missing rate limits on sensitive actions, information leakage).
- **Low**: defense-in-depth gaps with little direct impact.
- **Informational**: hardening suggestions.

## Output

Always output these sections, in this order.

**0. Security score**, followed by a one-sentence rationale:

```
**Security Score**: XX / 100 - [Excellent 90-100 | Good 75-89 | Fair 55-74 | Poor 35-54 | Critical Risk 0-34]
```

Start at 100 and deduct 20 per Critical, 10 per High, 5 per Medium, and 2 per Low finding (0 for Informational), with a minimum of 0.

**1. Summary**: `X findings total (Y Critical, Z High, A Medium, B Low, C Informational)`

**2. Critical and High findings**, Critical first, each in full format:

```
---
**Severity**: Critical | High | Medium | Low | Informational
**CWE / OWASP**: e.g. CWE-89, OWASP A05:2025 Injection
**Location**: file path + line range or function
**Vulnerability**: short name (e.g. SQL injection via whereRaw interpolation)
**Description**: plain-English explanation of the flaw
**Exploit path**: step-by-step realistic attacker scenario
**Impact**: what the attacker gains
**Evidence**: the relevant code snippet
**Fix**: concrete corrected code or diff
**Confidence**: High | Medium | Low
---
```

**3. Medium, Low, and Informational findings**, in the same format but more concise.

**4. Positives**: security practices already done well (validation, parameterized queries, rate limiting, headers).

**5. Recommendations**: cross-cutting hardening, such as centralized validation, a secrets manager, security headers, automated scanning (`npm audit`, Semgrep, Snyk, OWASP ZAP), and tests for authorization and concurrency.

If nothing serious is found, say so plainly, then still list the positives and hardening suggestions.