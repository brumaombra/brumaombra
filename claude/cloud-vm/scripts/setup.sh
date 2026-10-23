#!/bin/bash
set -eo pipefail

# --------- Configuration ---------

PROJECT_NAME="" # Name of the project's repository (the main project of the sessions)
NODE_VERSION=24.21.0 # Exact Node version the project needs
DEPLOY=true # Whether the project is a deployed app (adds the deploy rules)
WEB=true # Whether the project has a web UI (adds the web rules)
MYSQL=false # Whether to install MySQL and its rules (the database is created at session start from the MYSQL_* variables)
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

# MySQL: install it and add its rules
if [ "$MYSQL" = true ]; then
    # Add MySQL rules to the list of rules to download
    RULES_LIST="$RULES_LIST mysql"

    # Install MySQL if not already installed (the database and users are created at session start)
    if ! command -v mysqld >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
    fi
fi

# Cloudflare R2: add the upload rules
if [ "$R2" = true ]; then
    RULES_LIST="$RULES_LIST r2"
fi

# Claude rules for cloud sessions, replaced on every run (a failed download doesn't block the session)
RULES_DIR="/root/.claude/rules"
rm -rf "$RULES_DIR"
mkdir -p "$RULES_DIR"
for rule in $RULES_LIST; do
    if ! curl -fsSL "$RULES_URL/$rule.md" -o "$RULES_DIR/$rule.md"; then
        rm -f "$RULES_DIR/$rule.md"
        echo "Could not download the $rule rules"
    fi
done

# Put the project name in the common rules
if [ -f "$RULES_DIR/common.md" ]; then
    sed -i "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" "$RULES_DIR/common.md"
fi