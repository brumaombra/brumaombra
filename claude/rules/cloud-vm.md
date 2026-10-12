# Claude Cloud VM (Nuxt + MySQL)

You are running in a Claude Code cloud session: a VM in the cloud, not my machine. Each project has its own cloud environment and one long-lived session. The project is a Nuxt app that needs a MySQL database, and the database runs locally on this VM.

## The VM

- Ubuntu 24.04, and you are root (no `sudo` needed).
- The environment's setup script installs the Node version the project needs and links it in `/root/.local/bin`, ahead of the preinstalled Node 22. Check with `node -v`.
- Docker is installed, but its daemon is not running. Don't use Docker for the database unless I ask.

### What survives and what doesn't

- **Setup script:** the environment's setup script installs Node and MySQL, creates the dev database and users, and downloads these rules. It runs once, then the VM's disk is snapshotted and reused, so it doesn't run again at the start of later sessions.
- **Pauses:** after a few minutes without activity the VM pauses, and my next message restores it. Files survive a pause (repo, uncommitted changes, `node_modules`, database data), but running processes don't: MySQL and any dev server are stopped.
- **Reclaims:** a paused VM is eventually reclaimed. Reopening the session builds a fresh VM from the snapshot: the conversation comes back, but uncommitted work, database data, and anything installed after the setup script are gone.

## At the start of every session, and every time you resume after a pause

1. Check MySQL with `mysqladmin ping`. If it's not running, start it with `service mysql start`.
2. If `node_modules` is missing, run `npm install`.
3. If the database has no tables, create the schema the way the project does it (for example a schema file, or migrations from scratch). Otherwise run the project's pending migrations.
4. Restart any dev server you need: earlier ones were stopped by the pause.

If MySQL isn't installed at all (`mysqladmin: command not found`), stop and tell me. The environment's setup script is missing or failed, and I'll fix it in the environment settings. Don't install it yourself.

## MySQL

- Root connects with `mysql` (socket auth, no password).
- The database name, users, and password come from the environment's variables (`MYSQL_*` or `DATABASE_URL`, depending on the project). The setup script creates them with the same values. If they don't exist, create them as root with the values from the environment.
- MySQL listens on `127.0.0.1:3306`.
- These credentials are for local development on this VM only. Never connect to the test or production databases from here.

## Keeping work

- Anything that isn't pushed can be lost when the VM is reclaimed. Don't leave work unpushed for long.
- Schema, migrations, and seed data live in the repo, never only in the local database.
- Never rely on data you entered by hand in the database: it's gone after a reclaim.

## Other options

Only if I ask:

- **Docker:** start the daemon with `dockerd &` and run MySQL in a container.
- **Hosted MySQL:** connect to an external database. The environment's network policy must allow outbound access to that host.
