#!/bin/bash
set -eo pipefail

# --------- Configuration ---------

FREECAD_VERSION=1.1.3 # Exact FreeCAD version from conda-forge
RULES_URL="https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm" # Rules location
RULES_LIST="personality 3d-modelling" # Rules always downloaded

# --------- Setup ---------

# Install micromamba if not already installed
MAMBA_DIR="/opt/micromamba"
if [ ! -x "$MAMBA_DIR/bin/micromamba" ]; then
    mkdir -p "$MAMBA_DIR"
    curl -fsSL "https://micro.mamba.pm/api/micromamba/linux-64/latest" | tar -xj -C "$MAMBA_DIR" bin/micromamba
fi

# FreeCAD: create the freecad environment with FREECAD_VERSION (and matplotlib for the previews) if it doesn't have it yet
FREECAD_ENV="$MAMBA_DIR/envs/freecad"
if ! "$MAMBA_DIR/bin/micromamba" list -p "$FREECAD_ENV" 2>/dev/null | grep -E "^ *freecad +$FREECAD_VERSION " >/dev/null; then
    rm -rf "$FREECAD_ENV"
    MAMBA_ROOT_PREFIX="$MAMBA_DIR" "$MAMBA_DIR/bin/micromamba" create -y -q -n freecad -c conda-forge "freecad=$FREECAD_VERSION" matplotlib
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