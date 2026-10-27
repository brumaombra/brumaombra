#!/bin/bash
set -eo pipefail

# --------- Configuration ---------

NODE_VERSION=24.21.0 # Exact Node version
RULES_URL="https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm" # Rules location
RULES_LIST="personality admin" # Rules always downloaded

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