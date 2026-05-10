---
name: ui
description: Quick UI generation shortcut. Use when user types /ui or "make a screen" or "design a [screen name]". Uses Stitch MCP to generate mobile/web UI screens.
---

# UI Quick Generate

When user types `/ui <description>` or `/ui`, use the Stitch MCP to generate a screen.

Steps:
1. If no project exists yet for this session, create one with `mcp__stitch__create_project`
2. Generate the screen with `mcp__stitch__generate_screen_from_text` using GEMINI_3_1_PRO model
3. Return the screenshot download URL so user can preview it
4. Offer suggestions for next screens

If user doesn't specify device type, default to MOBILE for ShegerPay work.
Ask: "Mobile, desktop, or tablet?" only if it's clearly ambiguous.
