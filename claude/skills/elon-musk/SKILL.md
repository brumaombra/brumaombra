---
name: elon-musk
description: 'Find everything a codebase can live without or simplify, following Musk''s "the best part is no part" philosophy. Use when asked to simplify, slim down, cut bloat, remove dead code, or reduce complexity. Not for security audits or performance tuning.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Elon Musk

Review the codebase like an engineer who believes **the best part is no part**: every file, dependency, feature, option, and abstraction is a cost (to read, build, test, update, and secure) until it proves it pays for itself. The goal is an app that does the same job with less.

## The mindset

Apply Musk's algorithm in this order. Never skip ahead: optimizing something that shouldn't exist is the most common mistake.

1. **Question every requirement.** Each feature, setting, and edge case was added by someone for a reason that may no longer hold. Ask who needs it and what breaks without it. "We've always had it" is not a reason.
2. **Delete.** Remove parts and processes before improving them. If you never have to add anything back, you weren't aggressive enough: aim for a list where a few items get rejected.
3. **Simplify.** Only what survives deletion gets simplified: fewer layers, fewer files, fewer branches, fewer options.
4. **Speed up and automate last.** Mention slow builds or manual steps only after the first three steps, and only if they still matter.

## Rules

- **Analyze, don't change.** This is a review: don't delete or edit anything until I approve the items.
- **Evidence, not guesses.** Every candidate needs proof it's unused or redundant: search for all its references before listing it. Watch for things used indirectly: file-based routes, components and pages resolved by name, auto-imports, dynamic imports, i18n keys built from strings, config and environment variables read by tools, CI workflows, scripts in `package.json`, migrations, and things other repositories or external services call (webhooks, public APIs, cron jobs).
- **Never cut safety.** Validation, auth and permission checks, error handling, security headers, backups, migrations already run, and tests that guard real behavior are not fat. Neither is accessibility.
- **Same behavior.** A simplification must keep what users see and do the same, unless it's explicitly a feature removal I have to approve.
- **Follow the project's conventions** and the available skills: a simpler version still has to match the codebase style.

## Workflow

1. **Map the app.** Read the README, the entry points, routes, pages, API handlers, data model, `package.json` (or the equivalent), config files, and CI workflows. List the features and how they connect. For big codebases, split the review by area and run the areas in parallel subagents.
2. **Question the requirements.** For each feature, write down who it serves and what would happen without it. Flag the ones that look unused, half-finished, duplicated, or built for a case that never happened.
3. **Hunt for parts to delete**, using the checklist below.
4. **Hunt for simplifications** in what's left.
5. **Verify each candidate**: search its references, check how it's reached, and look at its git history when it helps (why it was added, when it was last touched).
6. **Report** in the output format below, then wait for my choices.

## Checklist

### Delete
- **Dead code:** unused files, exports, functions, components, composables, stores, routes, API endpoints, CSS classes, i18n keys, assets, and environment variables.
- **Dependencies:** packages that are unused, used for one tiny thing a few lines of code or the platform can do (native `fetch`, `Intl`, `structuredClone`, CSS features), or duplicates of another package already installed.
- **Features:** unused, half-finished, or duplicated features; settings nobody changes; feature flags that are always on or always off.
- **Data:** tables, columns, and stored fields that nothing reads anymore.
- **Config and tooling:** config files that only repeat the defaults, unused `package.json` scripts, redundant CI steps, leftover tooling from a migration.
- **Docs:** outdated docs and comments that describe code that no longer exists.

### Simplify
- **Abstractions:** wrappers, helpers, and layers with a single caller, or that only pass data through; generic code with one real use; options and parameters nobody ever passes.
- **Duplication:** the same logic in several places that can live in one.
- **Reinvented wheels:** custom code for something the framework or the platform already does.
- **Control flow:** deep nesting, long conditionals, and state that can be derived instead of stored.
- **Structure:** one feature spread over many tiny files, or folders with a single file.

## Output

**1. Verdict:** one or two sentences on how lean the app is and where the biggest win is.

**2. Questions about requirements:** features or behaviors you think could go, but only I can decide. For each one: what it is, why you doubt it, and what removing it would save.

**3. Parts to delete**, sorted by impact, each as:

```
**What**: short name
**Location**: files, packages, or tables
**Evidence**: why it's unused or redundant (searches, references, history)
**Saves**: lines, files, dependencies, bundle size, or maintenance
**Risk**: what could break, and how to check it
**Confidence**: High | Medium | Low
```

**4. Simplifications**, in the same format, with a short before and after sketch for each one.

**5. Plan:** the order you'd apply them in, starting with the highest-confidence, lowest-risk deletions.

If the app is already lean, say so plainly, and still list the few small wins.

## After my approval

Apply the approved items one at a time. After each one, build the app, run the tests, and check the affected feature still works, so if something breaks we know exactly which removal caused it. Commit each item separately.