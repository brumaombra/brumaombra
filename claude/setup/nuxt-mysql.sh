#!/bin/bash
# Setup script for a Claude Code cloud environment: Nuxt app + local MySQL.
# Paste it into the environment's settings (Setup script) and adjust the values below.
# It runs once per environment cache (about every 7 days, or when the script changes).
set -e

# --- Per-project values ---------------------------------------------------
NODE_MAJOR=24                                  # Node major version the project needs
DB_NAME="${MYSQL_DATABASE:-app}"               # Database name
DB_USER="${MYSQL_USER:-app}"                   # User the app connects with
DB_ADMIN_USER="${MYSQL_ADMIN_USER:-$DB_USER}"  # User migrations run with (can be the same)
DB_PASSWORD="${MYSQL_PASSWORD:-app}"           # Local dev password for both users
RULES_URL="https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/rules"
RULES="cloud-vm cloud-git"                     # Rule files to install in ~/.claude/rules
# ---------------------------------------------------------------------------

# Node: install the latest release of NODE_MAJOR and put it ahead of the preinstalled Node 22
NODE_DIR="/opt/node$NODE_MAJOR"
if [ ! -x "$NODE_DIR/bin/node" ]; then
    NODE_VERSION=$(curl -fsSL https://nodejs.org/dist/index.json | python3 -c "import json, sys; print(next(r['version'] for r in json.load(sys.stdin) if r['version'].startswith('v$NODE_MAJOR.')))")
    mkdir -p "$NODE_DIR"
    curl -fsSL "https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz" | tar -xJ -C "$NODE_DIR" --strip-components=1
fi
mkdir -p /root/.local/bin
for bin in node npm npx corepack; do
    ln -sf "$NODE_DIR/bin/$bin" "/root/.local/bin/$bin"
done

# MySQL: install, start, and create the dev database and users
if ! command -v mysqld >/dev/null 2>&1; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
fi
mysqladmin ping >/dev/null 2>&1 || service mysql start
mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
CREATE USER IF NOT EXISTS '$DB_ADMIN_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
GRANT ALL ON \`$DB_NAME\`.* TO '$DB_ADMIN_USER'@'localhost';
SQL

# Claude rules for cloud sessions (a failed download doesn't block the session)
mkdir -p /root/.claude/rules
for rule in $RULES; do
    curl -fsSL "$RULES_URL/$rule.md" -o "/root/.claude/rules/$rule.md" || echo "Could not download the $rule rules"
done
