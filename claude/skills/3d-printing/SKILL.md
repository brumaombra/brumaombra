---
name: 3d-printing
description: 'Design-for-printing rules and printer setup for parts printed on my Bambu Lab A1. Use when designing or checking a part that will be 3D printed, choosing clearances, walls, orientation, or materials, or picking print settings. For building the FreeCAD model itself, use 3d-modelling too.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# 3D Printing

Design parts that print well on my printer and fit on the first print.

## My printer

- Bambu Lab A1: 256 × 256 × 256 mm build volume, stock 0.4 mm nozzle, 0.2 mm layers by default, sliced in Bambu Studio.
- The A1 moves the bed back and forth, so tall, thin parts wobble and print badly: orient them as low and wide as possible, or add a brim.
- I mostly print in PLA, so design for it unless I say otherwise. PLA is brittle and softens around 55 °C: keep parts away from hot spots (voltage regulators, chargers, batteries, direct sun, a car in summer). Avoid ABS and ASA, which warp and crack without an enclosure.
- Closing: heat-set inserts with screws, not snap fits.

## Design for printing

- Never guess a dimension: use my measurements or the datasheet of the exact part, and ask when one is missing.
- Design each part in its print orientation, flat on the bed, without supports when possible (chamfer overhangs steeper than 45°).
- Keep every part within the build volume; split larger parts and design how the pieces join.
- Clearance per side, by type of fit: about 0.1 mm for press fits, 0.25 mm for parts that slide in or out, and 0.5 mm for loose fits.
- Structural walls (enclosures, anything holding a screw or an insert) are at least 1.2 mm thick (3 perimeters with the 0.4 mm nozzle).

## Details that make prints good

- **Holes:** printed holes come out smaller than modelled. Add about 0.2 mm to the diameter of holes that need a precise fit, and give horizontal holes a teardrop or flat top, so they print without supports.
- **First layer:** add a 0.4–0.5 mm chamfer to the edges that touch the bed, against elephant's foot. Round the corners of large flat parts, so they don't lift.
- **Strength:** parts are weakest between layers. Orient each part so the load runs along the layers, not across them, avoid thin pegs and clips standing upright, and add fillets to inside corners that carry a load.
- **Small features:** non-structural walls and ribs are at least 0.8 mm (2 lines), and embossed or engraved text at least 0.6 mm wide and 0.4 mm deep.
- **Bridges:** keep unsupported horizontal spans short (about 10 mm or less) and end them on solid walls.
- **Heat-set inserts:** size the holes from the insert's datasheet, and keep at least 2 mm of wall around them.

## Handing a part over

A valid model only proves the geometry, not the fit. When you finish a part, tell me what to print, with which material and settings (layer height, infill, supports), what to check on it, and which clearances you used, so I know what to tweak if a fit is off.