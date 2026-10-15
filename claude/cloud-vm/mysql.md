# MySQL

The project uses a local MySQL database on this VM. The setup script only installs MySQL: you create the database and its users from the `MYSQL_*` environment variables.

## At the start of every session, and every time you resume after a pause

1. If `mysqladmin ping` fails, start MySQL with `service mysql start`.
2. As root (`mysql`, socket auth, no password), make sure the database and both users exist and match the environment variables:

   ```sql
   CREATE DATABASE IF NOT EXISTS `<MYSQL_DATABASE>`;

   CREATE USER IF NOT EXISTS '<MYSQL_USER>'@'localhost' IDENTIFIED BY '<MYSQL_PASSWORD>';
   ALTER USER '<MYSQL_USER>'@'localhost' IDENTIFIED BY '<MYSQL_PASSWORD>';
   GRANT SELECT, INSERT, UPDATE, DELETE ON `<MYSQL_DATABASE>`.* TO '<MYSQL_USER>'@'localhost';
   
   CREATE USER IF NOT EXISTS '<MYSQL_ADMIN_USER>'@'localhost' IDENTIFIED BY '<MYSQL_ADMIN_PASSWORD>';
   ALTER USER '<MYSQL_ADMIN_USER>'@'localhost' IDENTIFIED BY '<MYSQL_ADMIN_PASSWORD>';
   GRANT ALL ON `<MYSQL_DATABASE>`.* TO '<MYSQL_ADMIN_USER>'@'localhost';
   ```

   Read the values from the environment variables in the shell; don't print the passwords. If a variable is missing, stop and tell me.
3. If the database has no tables, create the schema the way the project does it (for example a schema file, or migrations from scratch). Otherwise run the project's pending migrations.

## Connection

- The app connects as `MYSQL_USER`, which can only read and write data.
- Migrations and schema changes run as `MYSQL_ADMIN_USER`, which has full rights on the database.

## Data

Schema, migrations, and seed data live in the repo, never only in the local database: anything entered by hand is lost when the VM is rebuilt.