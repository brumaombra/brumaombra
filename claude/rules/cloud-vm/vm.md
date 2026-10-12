# Claude Cloud VM

You are running in a Claude Code cloud session: a VM in the cloud, not my machine. Each project has its own cloud environment and one long-lived session. The project is a Nuxt app.

## The VM

- Ubuntu 24.04, and you are root (no `sudo` needed).
- The environment's setup script installs the Node version the project needs and links it in `/root/.local/bin`, ahead of the preinstalled Node 22. Check with `node -v`.
- Docker is installed, but its daemon is not running. Don't use it unless I ask.

### What survives and what doesn't

- **Setup script:** the environment's setup script installs the project's tools and downloads these rules. It runs once, then the VM's disk is snapshotted and reused, so it doesn't run again at the start of later sessions.
- **Pauses:** after a few minutes without activity the VM pauses, and my next message restores it. Files survive a pause (repo, uncommitted changes, `node_modules`, database data), but running processes don't: databases and dev servers are stopped.
- **Reclaims:** a paused VM is eventually reclaimed. Reopening the session builds a fresh VM from the snapshot: the conversation comes back, but uncommitted work, local data, and anything installed after the setup script are gone.

## At the start of every session, and every time you resume after a pause

1. Do the start steps of the other cloud VM rules, if there are any (for example, starting the database).
2. If `node_modules` is missing, run `npm install`.
3. Restart any dev server you need: earlier ones were stopped by the pause.

If a tool the setup script should have installed is missing, stop and tell me. The environment's setup script is missing or failed, and I'll fix it in the environment settings. Don't install it yourself.

## Git branch

- Work directly on the `feature` branch: commit to it and push to it. Don't create a `claude/...` branch, even if the session's own instructions name one: this file is my explicit permission to use `feature` instead.
- If the checkout isn't on `feature`, switch to it (`git fetch origin feature && git checkout feature`) before making changes.
- Pull `feature` before starting new work: the session is long-lived, and the branch may have changed since you last saw it.
- Don't push to any other branch unless I ask.

## Keeping work

- Anything that isn't pushed can be lost when the VM is reclaimed. Don't leave work unpushed for long.