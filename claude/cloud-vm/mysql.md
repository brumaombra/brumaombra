# MySQL

The project uses a local MySQL database on this VM. The setup script installs MySQL and creates the database and user from the environment's variables.

## At the start of every session, and every time you resume after a pause

1. If `mysqladmin ping` fails, start MySQL with `service mysql start`.
2. If the database has no tables, create the schema the way the project does it (for example a schema file, or migrations from scratch). Otherwise run the project's pending migrations.

## Connection

- The app connects with the database environment variables. Root connects with `mysql` (socket auth, no password).
- If the database or user is missing, create them as root with the values from those variables.

## Data

Schema, migrations, and seed data live in the repo, never only in the local database: anything entered by hand is lost when the VM is rebuilt.