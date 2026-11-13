# B738 QUICK LEGS – Compact. Reliable. Always in Sight.

**A compact FMC LEGS display for the Zibo Boeing 737-800 in X-Plane.**

Keep the Captain's FMC LEGS page visible in a small window without covering a
large part of your cockpit. Ideal for checking upcoming waypoints, distances,
turns and altitude/speed restrictions during departure, arrival and approach.
The cockpit's normal CDU remains available for full FMC operation.

This program intentionally has only **two touch/click controls:**
**PREV PAGE** and **NEXT PAGE**. It is not a full-size FMC popup.

## Status and compatibility

- **Clean standalone TEST build:** v0.3.16 CLEAN TEST.
- The preceding *commented-out* QUICK LEGS-only version has been successfully
  flight-tested in **X-Plane 11 with the Zibo 737-800**, including page changes.
- This cleaned version retains the active rendering and control logic, but
  **still needs its own final X-Plane verification before public release**.
- **X-Plane 12 has not been verified. XP12 beta testers welcome!**
- Requires the Zibo 737-800, FlyWithLua with floating ImGui window support,
  and the relevant Zibo FMC DataRefs/commands.

## Installation

1. Back up your working `B738_FMC_Popup.lua` and previous QUICK LEGS files
   **outside** the active FlyWithLua `Scripts` directory.
2. Copy `B738_Quick_LEGS_ONLY.lua` and `B738_Quick_LEGS.png` to:
   `X-Plane 11/Resources/plugins/FlyWithLua/Scripts/`.
3. **Do not run the old B738_FMC_Popup.lua at the same time.**
4. Load the Zibo 737-800 and reload FlyWithLua scripts (or restart X-Plane).
5. Press **Alt+L** on Windows (**Option+L** on macOS), as appropriate for your
   established FlyWithLua key mapping, to open/close QUICK LEGS.
6. Use the two on-screen buttons to change LEGS pages.

## User-created skins / custom PNG

The supplied `B738_Quick_LEGS.png` is the default QUICK LEGS artwork. To use
another image, replace it with your own PNG using the **same filename**, or
change the image filename in the Lua source. At the very top of the script
there is a well-marked **CUSTOM SKIN / MOUSE HOT AREAS** section:

```lua
local QUICK_PREV_X, QUICK_PREV_Y, QUICK_PREV_W, QUICK_PREV_H = 145, 387, 72, 60
local QUICK_NEXT_X, QUICK_NEXT_Y, QUICK_NEXT_W, QUICK_NEXT_H = 280, 387, 73, 60
```

These coordinates refer to the top-left of the *ImGui content area*; X and Y
are the position of the invisible clickable region; W and H are its size.
The default coordinates preserve the proven button placement. A completely
new PNG layout may additionally need changes to the `imgui.Image` dimensions,
text rendering offsets, and the floating-window size.
There is deliberately no multi-skin system or separate config file.

## Credits and acknowledgements

**Heartfelt thanks and sincere respect to Chris (GitHub: ChrisInUT).**
His original B738 FMC Popup source code and CDU design are the foundation
on which this small derivative was developed. Please visit and credit his
original project: https://github.com/ChrisInUT/B738-FMC-Popup

The compact QUICK LEGS concept was developed and tested through real-world
simulator use; its new QUICK LEGS PNG artwork was created with the assistance
of ChatGPT (OpenAI), based on the inherited CDU visual concept. This artwork
should **not** be attributed to Chris as if he created this new PNG.

The original project is MIT licensed. This distribution retains the original
**Copyright (c) 2022 ChrisInUT** notice and a copy of its MIT **LICENSE**.

## Testing and feedback

Especially welcome: X-Plane 12 / Zibo beta testers who can report whether
FlyWithLua, the LEGS DataRefs, the PREV/NEXT commands, and the compact graphics
work without modifications. Include X-Plane and Zibo versions and screenshots
when reporting issues.

## Limitations

This is a display convenience, not an autopilot or navigation source.
Verify flight information in the aircraft's primary instruments and FMC.
There is no network access, external iPad FMC, or support for other aircraft.
