---
name: supertest
description: 'Manual, user-like testing of a whole app with parallel subagents, from common cases to extreme edge cases. Use when asked to supertest, test everything, stress-test, battle-test, or find as many bugs as possible before a release. Not for writing automated test suites, and not the supertest npm library.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Supertest

Test an app in two waves of parallel subagents that behave **exactly like real users**: common cases first, then extreme edge cases once the basics work.

## Rules (for you and every subagent)

- **Use the app like a user.** Web apps through a real browser (Playwright MCP, Chrome, or whatever is available): click, type, navigate, edit the URL, use back and refresh, open tabs, resize to mobile, go offline, change timezone or language. Other apps through their real interface (CLI commands, API requests from a client).
- **No test files, automated tests, or scripts.** Don't touch the database, call internal endpoints, or run console scripts. Reading code is fine for planning and for locating a bug's cause.
- **Local or test environments only**, never production or real third-party accounts (payments, emails, SMS).
- **Don't change app code**: report bugs, don't fix them. Screenshots go in a temp folder, not the project.
- **Don't collide:** share one dev server, but give each subagent its own test accounts and a data prefix (for example `wave1-search-`).
- **Clean up:** close browsers and stop servers you started.

## 1. Analyze the app

Read the README, routes, pages, API handlers, and data model, then build a test map:

- how to reach the app: URL, dev server command, test accounts, seed data
- 3–8 independent feature areas (for example login, payments, search, profile, admin), each with its pages, user flows, and riskiest logic (money, permissions, deletions)

Show me the map in a few lines, then start Wave 1 unless something is unclear or risky.

## 2. Wave 1: common cases

Spawn one subagent per area, **all in parallel in a single message**. Prompts must be self-contained: the area, its URLs and flows, the accounts and data prefix, the rules above, and the report format. Tell them to test:

- the main happy paths, forms with typical mistakes, what logged-out and other users see, and empty, single-item, and many-item states
- on every screen, on desktop and mobile: correct content, working links and buttons, clear errors, no broken layout, no console errors

**Gate:** if any common case fails, stop, report, and ask whether to fix first. Edge cases on a broken foundation only produce noise. If all pass, continue.

## 3. Wave 2: extreme edge cases

Spawn a new parallel wave, one subagent per area, with the Wave 1 summary for that area. Tell each to act like the most unpredictable, impatient, or malicious user, and to try to prove the app wrong, covering the categories that apply:

| Category | What a user can do |
|---|---|
| Inputs | Empty or whitespace-only fields, huge pastes, emoji, RTL and zero-width characters, HTML, script, or SQL-looking text, negative, zero, decimal, or letter values in number fields |
| Boundaries | Exactly at, one below, and one above every limit (lengths, quotas, balances) |
| Impatience | Double-click submit, the same form from two tabs, refresh while saving |
| Navigation | Back and forward mid-flow, skipping steps via the URL, reusing old or one-time links |
| Permissions | Other users' IDs in the URL, private pages while logged out, logging out in one tab and acting in another, expired sessions |
| Time and locale | Other timezones and languages, midnight, DST, leap days, past and far-future dates, long translations |
| Devices and network | Tiny and huge viewports, rotation, 200% zoom, offline mid-action, slow connection |
| Data and state | Empty and huge accounts, duplicate names, special characters, acting on something another tab deleted or changed |

## 4. Reports

Each subagent returns:

```
Area: <name>
Tested: <n> scenarios (<n> desktop, <n> mobile)
Passed: <short list>
Failed:
  - <title>
    Severity: Critical | High | Medium | Low
    Steps: <user steps from a URL>
    Expected / Actual: <...>
    Evidence: <screenshot, on-screen error, console error>
    Suspected cause: <file:line, if found>
Not testable: <what and why>
```

Merge them into one final report: a one-sentence **verdict**, the **bugs** deduplicated and sorted by severity (with steps, screenshot, and suspected location), **coverage** per wave including what couldn't be tested, and **next steps**.

Don't fix bugs unless I ask. Then fix one at a time and re-check each in the browser with its original steps.