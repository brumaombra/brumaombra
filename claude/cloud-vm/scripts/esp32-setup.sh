#!/bin/bash
set -eo pipefail

# --------- Configuration ---------

PLATFORMIO_VERSION=6.2.0 # Exact PlatformIO Core version the projects need
PLATFORMS="espressif32" # PlatformIO platforms to preinstall (space-separated, toolchains are downloaded on the first build)
MODELLING=true # Whether to install FreeCAD and the 3D modelling rules
FREECAD_VERSION=1.1.3 # Exact FreeCAD version from conda-forge
RULES_URL="https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm" # URL to download the rules from
RULES_LIST="personality esp32" # List of rules to download (space-separated, without the .md extension)

# --------- Setup ---------

# Python venv: needed to install PlatformIO without touching the system Python
if ! python3 -c "import ensurepip" >/dev/null 2>&1; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y python3-venv
fi

# PlatformIO: install PLATFORMIO_VERSION in its own venv and put its commands on the PATH
PIO_DIR="/opt/platformio-v$PLATFORMIO_VERSION"
if [ ! -x "$PIO_DIR/bin/pio" ]; then
    rm -rf "$PIO_DIR"
    python3 -m venv "$PIO_DIR"
    "$PIO_DIR/bin/pip" install --quiet "platformio==$PLATFORMIO_VERSION"
fi
mkdir -p /root/.local/bin
for bin in pio platformio; do
    ln -sf "$PIO_DIR/bin/$bin" "/root/.local/bin/$bin"
done
"$PIO_DIR/bin/pio" settings set enable_telemetry no >/dev/null

# PlatformIO platforms, preinstalled so the first build is faster (a failed download doesn't block the session)
for platform in $PLATFORMS; do
    if ! "$PIO_DIR/bin/pio" pkg install --global --platform "$platform"; then
        echo "Could not install the $platform platform"
    fi
done

# 3D modelling: install FreeCAD (with matplotlib for the previews) in its own micromamba environment, and add its rules
if [ "$MODELLING" = true ]; then
    # Add the 3D modelling rules to the list of rules to download
    RULES_LIST="$RULES_LIST 3d-modelling"

    # Install micromamba if not already installed
    MAMBA_DIR="/opt/micromamba"
    if [ ! -x "$MAMBA_DIR/bin/micromamba" ]; then
        mkdir -p "$MAMBA_DIR"
        curl -fsSL "https://micro.mamba.pm/api/micromamba/linux-64/latest" | tar -xj -C "$MAMBA_DIR" bin/micromamba
    fi

    # Create the freecad environment with FREECAD_VERSION if it doesn't have it yet
    FREECAD_ENV="$MAMBA_DIR/envs/freecad"
    if ! "$MAMBA_DIR/bin/micromamba" list -p "$FREECAD_ENV" 2>/dev/null | grep -E "^ *freecad +$FREECAD_VERSION " >/dev/null; then
        rm -rf "$FREECAD_ENV"
        MAMBA_ROOT_PREFIX="$MAMBA_DIR" "$MAMBA_DIR/bin/micromamba" create -y -q -n freecad -c conda-forge "freecad=$FREECAD_VERSION" matplotlib
    fi
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