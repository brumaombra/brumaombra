#!/bin/bash
set -eo pipefail

# See README.md for what each preset does

# --------- Configuration ---------

PRESET="app-developer" # app-developer, apps-manager, esp32-developer, opengizmo-manager, 3d-designer, or video-creator
EXTRA_RULES="" # Optional add-ons: r2, mysql

# --------- Setup ---------

# Rules of each preset
case "$PRESET" in
    app-developer) RULES_LIST="common deploy web" ;;
    apps-manager) RULES_LIST="common deploy web apps-manager" ;;
    esp32-developer) RULES_LIST="common esp32-developer deploy 3d-modelling" ;;
    opengizmo-manager) RULES_LIST="common esp32-developer deploy 3d-modelling web opengizmo-manager" ;;
    3d-designer) RULES_LIST="common 3d-modelling" ;;
    video-creator) RULES_LIST="common" ;;
    *)
        echo "Unknown PRESET: $PRESET" >&2
        exit 1
        ;;
esac
RULES_LIST="$RULES_LIST $EXTRA_RULES"

# Check if a rule is in RULES_LIST
has_rule() {
    case " $RULES_LIST " in
        *" $1 "*) return 0 ;;
        *) return 1 ;;
    esac
}

# Node: install NODE_VERSION and put it ahead of the preinstalled Node 22
NODE_VERSION=24.21.0 # Exact Node version
NODE_DIR="/opt/node-v$NODE_VERSION"
if [ ! -x "$NODE_DIR/bin/node" ]; then
    mkdir -p "$NODE_DIR"
    curl -fsSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar -xJ -C "$NODE_DIR" --strip-components=1
fi
mkdir -p /root/.local/bin
for bin in node npm npx corepack; do
    ln -sf "$NODE_DIR/bin/$bin" "/root/.local/bin/$bin"
done

# PlatformIO (esp32-developer rules): install PLATFORMIO_VERSION in its own venv, put its commands on the PATH, and preinstall the platforms
if has_rule esp32-developer; then
    PLATFORMIO_VERSION=6.2.0 # Exact PlatformIO version
    PLATFORMS="espressif32" # PlatformIO platforms to preinstall

    # Python venv: needed to install PlatformIO without touching the system Python
    if ! python3 -c "import ensurepip" >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y python3-venv
    fi

    # Install PlatformIO if not already installed
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

    # Preinstall the platforms so the first build is faster (a failed download doesn't block the session)
    for platform in $PLATFORMS; do
        if ! "$PIO_DIR/bin/pio" pkg install --global --platform "$platform"; then
            echo "Could not install the $platform platform"
        fi
    done
fi

# FreeCAD (3d-modelling rules): install FREECAD_VERSION (with matplotlib for the previews) in its own micromamba environment
if has_rule 3d-modelling; then
    FREECAD_VERSION=1.1.3 # Exact FreeCAD version

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

# MySQL (mysql rules): install it if not already installed (the database and users are created at session start)
if has_rule mysql; then
    if ! command -v mysqld >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
    fi
fi

# Chatterbox TTS weights (video-creator preset): the house voice tts.py loads from the Hugging Face cache (~3.5 GB, a failed download doesn't block the session)
if [ "$PRESET" = "video-creator" ]; then
    CHATTERBOX_REPO="ResembleAI/chatterbox" # Hugging Face model repository
    CHATTERBOX_FILES="ve.safetensors t3_cfg.safetensors s3gen.safetensors tokenizer.json conds.pt" # Files ChatterboxTTS.from_pretrained loads
    if ! uvx --from huggingface_hub hf download "$CHATTERBOX_REPO" $CHATTERBOX_FILES >/dev/null; then
        echo "Could not download the Chatterbox weights"
    fi
fi

# Claude rules for cloud sessions, replaced on every run (a failed download doesn't block the session)
RULES_URL="https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm" # Rules location
RULES_DIR="/root/.claude/rules"
rm -rf "$RULES_DIR"
mkdir -p "$RULES_DIR"
for rule in $RULES_LIST; do
    if ! curl -fsSL "$RULES_URL/$rule.md" -o "$RULES_DIR/$rule.md"; then
        rm -f "$RULES_DIR/$rule.md"
        echo "Could not download the $rule rules"
    fi
done