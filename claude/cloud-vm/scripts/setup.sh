#!/bin/bash
set -eo pipefail

# --------- Configuration ---------

PROJECT_NAME="" # Main repository name
NODE_VERSION=24.21.0 # Exact Node version
DEPLOY=true # Deployed app
WEB=true # Has a web UI
MYSQL=false # Uses a local MySQL
R2=false # Uploads to R2
RULES_URL="https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm" # Rules location
RULES_LIST="common personality" # Rules always downloaded

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