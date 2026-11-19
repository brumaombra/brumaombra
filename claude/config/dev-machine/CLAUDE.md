# Development Machine

This machine runs several remote-controlled Claude sessions in parallel, each one dedicated to a single project. You are a professional developer in charge of the project assigned to your session.

## Your project

- The session name contains the slug of your project.
- Your working directory is `~/projects/{project-slug}`.
- Other projects in `~/projects/` belong to other agents: don't modify them.

## Git workflow

Projects use three main branches:

| Branch | Purpose |
|---|---|
| `main` | Production (a push triggers a deployment) |
| `test` | Staging (a push triggers a deployment) |
| `develop` | Main development line |

Changes reach `develop` through pull requests, then flow up one step at a time:

```
develop → test → main
```

Never skip a step: for example, `develop` is never merged directly into `main`.

Every task gets its own branch:

- **One branch per feature or fix, never one per commit.** A branch holds a whole task: keep using it for every change of that task, including the follow-ups I ask for. Only start a new branch when I give you a new task.
- Create the branch from the latest `develop`, named `<type>/<short-name>`, for example `feat/dark-mode` or `fix/trade-rounding`.
- When the task is done, open a pull request into `develop`. Don't merge it unless I ask you to deploy.
- Don't change `develop`, `test`, or `main` directly unless I explicitly ask.

When I ask you to **deploy to test** or **deploy to production**, merge the task's pull request into `develop`, then run the flow up to that branch, merging and pushing each branch along the way. The request itself is my approval for those merges and pushes:

- **Deploy to test:** merge the pull request into `develop`, then merge `develop` into `test` and push.
- **Deploy to production:** the same, then also merge `test` into `main` and push.

If the task's branch has uncommitted changes, ask me before committing them. If a merge has conflicts, stop and tell me.

- Never commit or push without my explicit approval. Ask first every time.
- Never run destructive git commands (`reset --hard`, `push --force`, rebasing shared branches, deleting branches) without asking.

## Before making changes

- Check the available skills before every change; there may be one that covers the task.
- Follow the code style guidelines defined in the skills for all the code you write or edit.
- Ask before installing new dependencies, and explain why each one is needed.

## Shared environment

- Don't change global npm or Node versions, system packages, the Cloudflare tunnel configuration, or anything outside your project folder without asking.
- The production database is read-only: never run migrations or write queries against it. The test (staging) database is fine to use.

## Dev server

- A Cloudflare tunnel exposes port `3000`. To show me the app, start the standard local dev server on port `3000` (no Nuxt network sharing / `--host` option needed).
- Other agents may already be using port `3000`. Check before starting, and use a random free port for servers only you need.

## Resources

- This machine has limited resources: don't run a full production build unless strictly necessary.
- Stop the processes you started (dev servers, watchers, Playwright browsers) when you no longer need them.
- If a task is hard enough that you need more than 10 parallel subagents, run them on the Sonnet model to save usage.

## Hosting

- **Static apps** are hosted on Cloudflare Pages.
- **Non-static apps** are hosted on a VPS managed with Coolify.

## Tools

- **Playwright MCP:** use it to open and check the app in the browser.
- **Sentry MCP:** every non-static project has a Sentry project attached. Use it to check errors and the app status when relevant.
- **Coolify MCP:** for non-static apps, use it to check the status of applications, deployments, and logs. Only read from it: don't deploy, restart, or stop anything through it unless I explicitly ask (deployments are triggered by pushes to `test` and `main`).

## UI changes

- After any visual change to the UI, send me screenshots of both the desktop and the mobile layout.

## Wrapping up

- End every task with a short summary: what changed, what was tested, and what's left to do.