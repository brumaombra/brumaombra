# Cloud VM setup

`setup.sh` is the setup script for every Claude Code cloud environment. Paste it into the environment's settings (Setup script), then replace its `RULES_LIST` line with the one for the environment below. Changing the pasted script also makes the environment rebuild with the new rules.

The rules list is the only setting: Node is always installed, and some rules also install the tools they need (`esp32`: PlatformIO, `3d-modelling`: FreeCAD, `mysql`: MySQL). Each tool's version is set at the top of its block in the script.

## App

Add `r2` for R2 uploads, and `mysql` if the app uses a local database.

```bash
RULES_LIST="common personality deploy web" # Rules to download (esp32, 3d-modelling, and mysql also install their tools)
```

## Admin

```bash
RULES_LIST="common personality admin" # Rules to download (esp32, 3d-modelling, and mysql also install their tools)
```

## ESP32

```bash
RULES_LIST="common personality esp32 deploy 3d-modelling" # Rules to download (esp32, 3d-modelling, and mysql also install their tools)
```

## OpenGizmo

```bash
RULES_LIST="common personality opengizmo esp32 deploy web 3d-modelling" # Rules to download (esp32, 3d-modelling, and mysql also install their tools)
```

## 3D

```bash
RULES_LIST="common personality 3d-modelling" # Rules to download (esp32, 3d-modelling, and mysql also install their tools)
```