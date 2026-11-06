---
name: 3d-printing
description: 'Design-for-printing rules and printer setup for parts printed on my Bambu Lab A1. Use when designing or checking a part that will be 3D printed, choosing clearances, walls, orientation, materials, screws or how a board is held, or picking print settings. For building the FreeCAD model itself, use 3d-modelling too.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# 3D Printing

Design parts that print well on my printer and fit on the first print.

## My printer

- Bambu Lab A1: 256 × 256 × 256 mm build volume, stock 0.4 mm nozzle, 0.2 mm layers by default, sliced in Bambu Studio. 4 walls for parts with screw posts.
- The A1 moves the bed back and forth, so tall, thin parts wobble and print badly: orient them as low and wide as possible, or add a brim.
- I mostly print in PLA, so design for it unless I say otherwise. PLA is brittle and softens around 55 °C: keep parts away from hot spots (voltage regulators, chargers, batteries, direct sun, a car in summer). Avoid ABS and ASA, which warp and crack without an enclosure.
- Closing: M3 x 8 socket cap screws straight into the print (heat-set inserts only for parts opened often or under load). No snap fits.

## Design for printing

- Never guess a dimension: use my measurements or the datasheet of the exact part, and ask when one is missing. Identify the part first (a socket cap screw's hex key gives its thread: 1.5 mm M2, 2 mm M2.5, 2.5 mm M3).
- Design each part in its print orientation, visible faces on the bed. Try to avoid supports: faces at 45° or less, and 45° gussets under features that would start in mid-air.
- Keep every part within the build volume; split larger parts and design how the pieces join.
- Clearance per side, by type of fit: about 0.1 mm for press fits, 0.25 mm for parts that slide in or out, and 0.5 mm for loose fits.
- Structural walls (enclosures, anything holding a screw or an insert) are at least 1.2 mm thick (3 perimeters with the 0.4 mm nozzle).
- For a part we have never printed, test its fits first on a small piece cut from it.

## Details that make prints good

- **Holes:** printed holes come out smaller than modelled, small ones more: add about 0.2 mm to holes that need a precise fit (0.3 mm under 4 mm), and give horizontal holes a teardrop or flat top, or make them a notch closed by the mating part.
- **Screw holes:** a pilot as wide as the thread (3.0 mm for M3), the screw biting 2 × its diameter, 1 mm of extra depth, a 0.4 mm 45° lead-in, and 2 mm of wall around it. Stop the screw when snug.
- **Boards:** guide them where they have no pins, with crush ribs (0.6 mm wide, 0.15 mm past the board) for no play, and stops that take the plugging force off the solder joints. Keep antennas on plastic, away from metal.
- **First layer:** keep bed edges sharp with the slicer's elephant foot compensation, and chamfer them 0.4 mm only if a print shows a lip. Round the corners of large flat parts, so they don't lift.
- **Rounded edges:** a rounding on the bed overhangs: put it on top, or end it with a thin 45° strip at the bed.
- **Strength:** parts are weakest between layers. Orient each part so the load runs along the layers, not across them, avoid thin pegs and clips standing upright, and add fillets to inside corners that carry a load.
- **Small features:** non-structural walls and ribs are at least 0.8 mm (2 lines), and embossed or engraved text at least 0.6 mm wide and 0.4 mm deep.
- **Bridges:** keep unsupported horizontal spans short (about 10 mm or less) and end them on solid walls.
- **Heat-set inserts:** size the holes from the insert's datasheet, and keep at least 2 mm of wall around them.

## Handing a part over

A valid model only proves the geometry, not the fit. When you finish a part, give me a 3MF plate for Bambu Studio (Bambu Handy can't slice), and tell me which settings to use (layer height, walls, infill, supports), what to check on it, and which clearances you used, so I know what to tweak if a fit is off.
