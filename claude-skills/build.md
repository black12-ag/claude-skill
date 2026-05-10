---
name: build
description: Quick full-feature build shortcut. Use when user types /build or "build [feature]". Runs the full development workflow: brainstorm → plan → execute with subagents.
---

# Build Quick Workflow

When user types `/build <feature description>`:

1. **Brainstorm** — quickly outline 2-3 approaches using `superpowers:brainstorming`
2. **Plan** — create a phased plan using `claude-mem:make-plan`  
3. **Execute** — run the plan using `superpowers:executing-plans` or `claude-mem:do`

If the feature is small (1-2 files), skip brainstorm and go straight to plan → execute.

Always ask: "Is this for the web dashboard, Flutter mobile app, or NestJS backend?" before starting — this determines which part of ShegerPay to touch.
