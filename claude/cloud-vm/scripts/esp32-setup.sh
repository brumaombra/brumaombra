#!/bin/bash
set -eo pipefail

# --------- Configuration ---------

PLATFORMIO_VERSION=6.2.0 # Exact PlatformIO Core version the projects need
PLATFORMS="espressif32" # PlatformIO platforms to preinstall (space-separated, toolchains are downloaded on the first build)
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