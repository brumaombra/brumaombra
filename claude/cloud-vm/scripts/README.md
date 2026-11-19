# Cloud VM setup

`setup.sh` is the setup script for every Claude Code cloud environment. Paste it into the environment's settings (Setup script), then set its `PRESET` to the one for the environment below. Changing the pasted script also makes the environment rebuild with the new rules.

## Presets

Each preset sets who the agent is, and downloads the rules for that role. Node is always installed, and some rules also install the tools they need (`esp32-developer`: PlatformIO, `3d-modelling`: FreeCAD, `mysql`: MySQL).

| Preset | Who the agent is | Rules |
|---|---|---|
| `app-developer` | Developer of a single app repository | `common personality deploy web` |
| `apps-admin` | Admin who keeps all my apps aligned | `common personality apps-admin` |
| `esp32-developer` | Firmware developer for my ESP32 repositories | `common personality esp32-developer deploy 3d-modelling` |
| `opengizmo-manager` | Manager of the whole OpenGizmo brand | `common personality opengizmo-manager esp32-developer deploy web 3d-modelling` |
| `3d-designer` | Designer of 3D parts | `common personality 3d-modelling` |

## Add-ons

List them in `EXTRA_RULES`, separated by spaces:

- `r2`: the app uploads files to Cloudflare R2 (needs the R2 network secret).
- `mysql`: the app uses a local MySQL database (installs MySQL, needs the `MYSQL_*` environment variables).

```bash
PRESET="app-developer" # app-developer, apps-admin, esp32-developer, opengizmo-manager, or 3d-designer
EXTRA_RULES="r2 mysql" # Optional add-ons: r2, mysql
```