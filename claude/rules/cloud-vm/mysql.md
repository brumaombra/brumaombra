# MySQL on the Cloud VM

The project uses a MySQL database that runs locally on this VM. The environment's setup script installs MySQL and creates the dev database and users.

## At the start of every session, and every time you resume after a pause

1. Check MySQL with `mysqladmin ping`. If it's not running, start it with `service mysql start`.
2. If the database has no tables, create the schema the way the project does it (for example a schema file, or migrations from scratch). Otherwise run the project's pending migrations.

If MySQL isn't installed at all (`mysqladmin: command not found`), stop and tell me: the setup script is missing or failed.

## Connection

- Root connects with `mysql` (socket auth, no password).
- The database name, users, and password come from the environment's variables (`MYSQL_*` or `DATABASE_URL`, depending on the project). The setup script creates them with the same values. If they don't exist, create them as root with the values from the environment.
- MySQL listens on `127.0.0.1:3306`.
- These credentials are for local development on this VM only. Never connect to the test or production databases from here.

## Data

- Schema, migrations, and seed data live in the repo, never only in the local database.
- Never rely on data you entered by hand: it's gone after a reclaim.
