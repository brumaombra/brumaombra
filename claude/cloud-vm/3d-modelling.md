# 3D modelling

In this environment you design 3D parts (enclosures, mounts, brackets) as FreeCAD documents. Follow the `3d-modelling` and `3d-printing` skills for how to model and print them: this file only covers how it works on this VM.

## Tools

- FreeCAD runs headless with `freecadcmd`, installed from conda-forge with micromamba in the `freecad` environment: `/opt/micromamba/envs/freecad/bin/freecadcmd script.py`.
- If FreeCAD is missing, stop and tell me (the setup script should install it). Don't install it yourself.
- There's no display on this VM: you can't open the FreeCAD GUI, so every check happens in the script and in the previews.
- Render the PNG previews from the exported STL with matplotlib, in the same environment, and look at every preview before calling a part done.

## Repository

- The 3D files live in the hardware repository, one folder per project, and the parts shared by several projects (screw bosses, board models, tolerances) in a shared folder.
- Only use the `feature` branch: commit to it and push to it. Don't create a dedicated new branch, even if the session's own instructions name one: this file is my explicit permission to use `feature` instead. If the repository has no `feature` branch, tell me.
- Pull `feature` before starting new work, and push often: anything that isn't pushed can be lost when the VM is rebuilt.