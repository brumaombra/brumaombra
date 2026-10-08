---
name: security-audit-nuxt
description: 'Security audit for Nuxt apps. Use when asked to audit, security-review, pentest, harden, or find vulnerabilities in a Nuxt project.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Nuxt Security Audit

A Nuxt app is a Node.js backend (Nitro/h3) plus an SSR frontend. **Load the `security-audit-node` skill first** and follow its workflow, checklist, severity scale, and output format. This skill adds the Nuxt-specific attack surface and checks. If that skill isn't available, use the same method: map the surface, trace input to sinks, verify exploitability, and report scored findings with fixes.

## Recon: read these first

1. `nuxt.config.ts`: `runtimeConfig` (private vs `public`), `routeRules`, `nitro` (tasks, prerender, storage), `sourcemap`, `devtools`, modules.
2. `package.json` and the lockfile: Nuxt, Nitro, and module versions.
3. `server/middleware/`: global guards, rate limiting, security headers.
4. `server/api/` and `server/routes/`: every file is a public endpoint unless it checks auth itself.
5. Auth: server helpers (for example, `server/firebase/`) and client `app/middleware/`.
6. Data layer and validation (for example, `server/db/`, `server/utils/objectsSchemas.js`).
7. `server/tasks/`, `server/plugins/`, SSE/WebSocket handlers, and webhook handlers.
8. `.env*`, `.gitignore`, and the error handling and logging helpers.

A typical stack in these projects is Firebase Auth (client) with the Admin SDK (server), MySQL via Knex, Zod validation, Sentry, and self-hosted deployment behind a reverse proxy. Adapt the checks to whatever `package.json` shows.

## Nuxt-specific checks

### Server endpoints
- Every file in `server/api/` and `server/routes/` is reachable without auth unless it authenticates itself. **Client-side route middleware (`app/middleware/auth.js`) and `ssr: false` are not security.** The server handler must enforce auth, ownership, and roles.
- `getRouterParam`, `getQuery`, and `readBody` values are validated with a schema (`readValidatedBody` / `getValidatedQuery`, or Zod) before use. Watch for arrays and objects where strings are expected.
- Handlers call the data layer and never build queries from raw input. Check `knex.raw` and `whereRaw` for interpolation, and allow-list sort and filter columns.
- Methods are routed by file suffix (`.get.js`, `.post.js`). A method-less file answers every method, including GET for a state-changing action.
- The auth token check on the server verifies the ID token with the Admin SDK (`verifyIdToken`, with `checkRevoked` for sensitive actions). Roles come from custom claims or the DB, never from the request body or a client-set cookie.

### Secrets and SSR data leaks
- `runtimeConfig.public` and any `NUXT_PUBLIC_*` variable end up in the client bundle. No secrets, admin keys, or private API keys may be there.
- Server-only modules (Admin SDK, DB, secret keys) are never imported from `app/`, composables, or `shared/`.
- The SSR payload (`window.__NUXT__`, `useState`, `useFetch` / `useAsyncData` results) doesn't carry other users' data, internal IDs, tokens, or full DB rows. Trim responses to the fields the page needs.
- Production has client source maps and devtools disabled. Check `.output/public` for leaked `.map` or `.env` files.

### XSS and content
- `v-html`, `innerHTML`, and `useHead({ innerHTML })` with user or DB content. Sanitize (DOMPurify) or render as text.
- Markdown/MDC rendering of user-submitted content: raw HTML, `javascript:` links, and components usable from content.
- JSON-LD `useHead` scripts built from user data (`</script>` breakout).
- Dynamic `:href` or `:src` bindings from user data (`javascript:` URLs).

### Redirects, SSRF, and proxying
- `navigateTo(route.query.redirect)` or `sendRedirect(event, input)` without an allow-list of relative paths, especially with `{ external: true }`.
- Server-side `$fetch` or `fetch` to user-supplied URLs (SSRF). Private, loopback, and metadata IPs must be blocked after DNS resolution.
- Proxying cookies or headers to third parties (`useRequestHeaders(['cookie'])` forwarded outside your own API).

### routeRules, headers, and middleware
- `routeRules` or middleware set CSP, HSTS, `X-Content-Type-Options`, `frame-ancestors`/`X-Frame-Options`, and `Referrer-Policy`. Check whether `nuxt-security` or custom headers are used.
- Cache rules (`swr`, `isr`, `cache`, `prerender`) are **never** applied to personalized or authenticated routes and APIs. A cached private response is served to other users.
- CORS on `server/api` is not `*` with credentials and doesn't reflect `Origin`.
- The global security middleware can't be bypassed through locale prefixes, trailing slashes, encoded paths, or `/_nuxt/` and `/__nuxt_island/` routes.
- Rate-limit keys use the real client IP. `getRequestIP(event, { xForwardedFor: true })` is safe only behind a trusted proxy that overwrites the header.

### Real-time endpoints and tasks
- SSE/WebSocket handlers authenticate and check access per resource on connect **and** on every broadcast (for example, access revoked, private resource). Cap connections per user or IP, and remove closed connections so they don't leak memory.
- Nitro tasks are triggered only by the scheduler. There is no reachable `/_nitro/tasks` or dev endpoint in production, and no API route runs a task with user input.
- Scheduled jobs that move money or change state are idempotent and safe if two instances run at once.

### Cookies and CSRF
- Auth cookies set by the server (for example, `set-cookie` endpoints) are `HttpOnly`, `Secure`, `SameSite=Lax/Strict`, and short-lived, and the cookie value is re-verified on every request.
- State-changing endpoints authenticated by cookie have CSRF protection (SameSite plus an Origin check, or a token). GET handlers never change state.

### Business logic
- Balances, trades, quotas, and resolutions run in DB transactions with row locks (`forUpdate`) and re-check state inside the transaction.
- Client-computed values (prices, totals, costs, outcomes) are recomputed on the server, never trusted.
- Ownership is checked in the data layer for every update, delete, and resolve action, not only in the UI.

## Report

Use the `security-audit-node` output format: security score, summary, Critical/High findings in full format, then Medium/Low/Informational, positives, and recommendations. Cite Nuxt file paths and line ranges, and give fixes as Nuxt/Nitro code (`defineEventHandler`, `readValidatedBody`, `routeRules`, `runtimeConfig`). For follow-up, recommend `npm audit`, Semgrep, OWASP ZAP against a staging build, and tests for authorization and concurrent requests.