#!/bin/bash
set -e

# --------- Configuration ---------

NODE_VERSION=24.21.0 # Exact Node version the project needs
MYSQL=true # Whether to install MySQL and its rules (needs the MYSQL_* environment variables)
RULES_URL="https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm" # URL to download the rules from
RULES_LIST="common" # List of rules to download (space-separated, without the .md extension)

# --------- Setup ---------

# Node: install NODE_VERSION and put it ahead of the preinstalled Node 22
NODE_DIR="/opt/node-v$NODE_VERSION"
if [ ! -x "$NODE_DIR/bin/node" ]; then
    mkdir -p "$NODE_DIR"
    curl -fsSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar -xJ -C "$NODE_DIR" --strip-components=1
fi
mkdir -p /root/.local/bin
for bin in node npm npx corepack; do
    ln -sf "$NODE_DIR/bin/$bin" "/root/.local/bin/$bin"
done

# MySQL: install, start, and create the dev database and user
if [ "$MYSQL" = true ]; then
    # Stop if any MySQL environment variable is missing
    for var in MYSQL_IP MYSQL_PORT MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD; do
        if [ -z "${!var}" ]; then
            echo "Missing MySQL environment variable: $var" >&2
            exit 1
        fi
    done

    # Add MySQL rules to the list of rules to download
    RULES_LIST="$RULES_LIST mysql"

    # Install MySQL if not already installed, and start the service and create the DB
    if ! command -v mysqld >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
    fi
    mysqladmin ping >/dev/null 2>&1 || service mysql start
    mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'localhost';
SQL
fi

# Claude rules for cloud sessions (a failed download doesn't block the session)
mkdir -p /root/.claude/rules
for rule in $RULES_LIST; do
    curl -fsSL "$RULES_URL/$rule.md" -o "/root/.claude/rules/$rule.md" || echo "Could not download the $rule rules"
done