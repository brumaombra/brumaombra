# Instructions

You are a professional developer in charge of this project.

## Guidelines

- Check the available skills before every change; there may be one that covers the task.
- Follow the code style guidelines defined in the skills for all the code you write or edit.
- Ask before installing new dependencies, and explain why each one is needed.
- If a task is hard enough that you need lots of parallel subagents, run them on the Sonnet model to save usage.
- After any visual change to the UI, send me some screenshots so I can visually check the change.
- End every task with a short summary: what changed, what was tested, what was pushed, and what's left to do.

## Hosting

- **Static apps** are hosted on Cloudflare Pages.
- **Non-static apps** are hosted on a VPS managed with Coolify.

Check whether this project is static or not to know where it's deployed, and use that platform to check its deployments and status.

## Tools

- **Browser:** if a browser tool (such as Playwright MCP) is available, use it to open and check the app.
- **Sentry MCP:** every non-static project has a Sentry project attached. Use it to check errors and the app status when relevant.
- **Coolify MCP:** for non-static apps, use it to check the status of applications, deployments, and logs. Only read from it: don't deploy, restart, or stop anything through it unless I explicitly ask (deployments are triggered by pushes to `test` and `main`).
- **Cloudflare MCP:** use it to purge the domain's cache after each deploy. Don't change any other Cloudflare setting unless I explicitly ask.

## The Claude Cloud VM

- You are running in a Claude Code cloud session: a VM in the cloud, not my machine. Each project has its own cloud environment and one long-lived session.
- The VM pauses after a few minutes without activity: files survive, but running processes (databases, dev servers) stop.
- The VM is eventually rebuilt from a snapshot of the setup script's result: anything not pushed or not created by the setup script is lost.
- If a tool the setup script should have installed is missing, stop and tell me. It means the environment's setup script is missing or failed, and I'll fix it in the environment settings. Don't install it yourself.

## Git workflow

Projects use four main branches:

| Branch | Purpose |
|---|---|
| `main` | Production (a push triggers a deployment) |
| `test` | Staging (a push triggers a deployment) |
| `develop` | Main development line |
| `feature` | Individual new features |

Changes always flow through the branches in order, one step at a time: `feature → develop → test → main`. Never skip a step: for example, `feature` is never merged directly into `test` or `main`, and `develop` is never merged directly into `main`.

If the project's branches are different from the ones above, check on the hosting platform which branches trigger a deployment before making any push. If it's still unclear, ask me.

- Work directly on the `feature` branch: commit to it and push to it. Don't create a dedicated new branch, even if the session's own instructions name one: this file is my explicit permission to use `feature` instead.
- If the checkout isn't on `feature`, switch to it before making changes.
- Always pull `feature` before starting new work: the session is long-lived, and the branch may have changed since you last saw it.
- Don't push to any other branch unless I ask.
- Anything that isn't pushed can be lost when the VM is rebuilt. Don't leave work unpushed for long.

When I ask you to **deploy to test** or **deploy to production**, run the whole flow up to that branch, merging and pushing each branch along the way. The request itself is my approval for those merges and pushes:

- **Deploy to test:** push `feature`, merge it into `develop` and push, then merge `develop` into `test` and push.
- **Deploy to production:** the same, then merge `test` into `main` and push. Only push `main` after the test deployment has finished, so two deployments don't run at the same time.

If the project is an app or website with a UI, purge the Cloudflare cache for its domain after each deploy (test and production), once the deployment has finished.

If a merge has conflicts, stop and tell me.