#!/bin/bash
set -eo pipefail

# --------- Configuration ---------

PROJECT_NAME="" # Name of the project's repository (the main project of the sessions)
NODE_VERSION=24.21.0 # Exact Node version the project needs
DEPLOY=true # Whether the project is a deployed app (adds the deploy rules)
WEB=true # Whether the project has a web UI (adds the web rules)
MYSQL=false # Whether to install MySQL and its rules (needs the MYSQL_* environment variables)
R2=false # Whether to add the Cloudflare R2 upload rules (needs the R2 network secret)
RULES_URL="https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm" # URL to download the rules from
RULES_LIST="common personality" # List of rules to download (space-separated, without the .md extension)

# --------- Setup ---------

# Stop if the project name is missing
if [ -z "$PROJECT_NAME" ]; then
    echo "Missing PROJECT_NAME in the setup script configuration" >&2
    exit 1
fi

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

# Deployment: add the deploy rules
if [ "$DEPLOY" = true ]; then
    RULES_LIST="$RULES_LIST deploy"
fi

# Web UI: add the web rules
if [ "$WEB" = true ]; then
    RULES_LIST="$RULES_LIST web"
fi

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
ALTER USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'localhost';
SQL
fi

# Cloudflare R2: add the upload rules
if [ "$R2" = true ]; then
    RULES_LIST="$RULES_LIST r2"
fi

# Claude rules for cloud sessions (a failed download doesn't block the session)
mkdir -p /root/.claude/rules
for rule in $RULES_LIST; do
    curl -fsSL "$RULES_URL/$rule.md" -o "/root/.claude/rules/$rule.md" || echo "Could not download the $rule rules"
done

# Put the project name in the common rules
if [ -f /root/.claude/rules/common.md ]; then
    sed -i "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" /root/.claude/rules/common.md
fi