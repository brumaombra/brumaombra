# Claude Cloud VM (Nuxt + MySQL)

You are running in a Claude Code cloud session: a VM in the cloud, not my machine. Each project has its own cloud environment and one long-lived session. The project is a Nuxt app that needs a MySQL database, and the database runs locally on this VM.

## The VM

- Ubuntu 24.04, and you are root (no `sudo` needed).
- Node and npm are preinstalled. The project's environment may install a different Node version with its setup script.
- Docker is installed, but its daemon is not running. Don't use Docker for the database unless I ask.

### What survives and what doesn't

- **Setup script:** the environment's setup script installs MySQL (and any other toolchain the project needs) and creates the dev database and user. It runs once, then the VM's disk is snapshotted and reused, so it doesn't run again at the start of later sessions.
- **Pauses:** after a few minutes without activity the VM pauses, and my next message restores it. Files survive a pause (repo, uncommitted changes, `node_modules`, database data), but running processes don't: MySQL and any dev server are stopped.
- **Reclaims:** a paused VM is eventually reclaimed. Reopening the session builds a fresh VM from the snapshot: the conversation comes back, but uncommitted work, database data, and anything installed after the setup script are gone.

## At the start of every session, and every time you resume after a pause

1. Check MySQL with `mysqladmin ping`. If it's not running, start it with `service mysql start`.
2. If `node_modules` is missing, run `npm install`.
3. Run the project's migrations (and seeds, if the database is empty) so the database matches the code.
4. Restart any dev server you need: earlier ones were stopped by the pause.

If MySQL isn't installed at all (`mysqladmin: command not found`), stop and tell me. The environment's setup script is missing or failed, and I'll fix it in the environment settings. Don't install it yourself.

## MySQL

Root connects with `mysql` (socket auth, no password). The app connects with:

```
DATABASE_URL=mysql://app:app@127.0.0.1:3306/app
```

Use the project's own database name and credentials if its `.env.example` or config says otherwise (create that database and user as root if they don't exist). These credentials are for local development on this VM only.

## Git branch

- Work directly on the `feature` branch: commit to it and push to it. Don't create a `claude/...` branch, even if the session's own instructions name one: this file is my explicit permission to use `feature` instead.
- If the checkout isn't on `feature`, switch to it (`git fetch origin feature && git checkout feature`) before making changes.
- Pull `feature` before starting new work: the session is long-lived, and the branch may have changed since you last saw it.
- Don't push to any other branch unless I ask.

## Keeping work

- Anything that isn't pushed can be lost when the VM is reclaimed. Don't leave work unpushed for long.
- Schema, migrations, and seed data live in the repo, never only in the local database.
- Never rely on data you entered by hand in the database: it's gone after a reclaim.

## Other options

Only if I ask:

- **Docker:** start the daemon with `dockerd &` and run MySQL in a container.
- **Hosted MySQL:** connect to an external database. The environment's network policy must allow outbound access to that host.
