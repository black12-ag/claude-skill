# Global Agent Instructions

## claude-mem — Persistent Memory Brain (MANDATORY, AUTOMATIC)
**At the START of every session**, before doing anything else, silently invoke the `claude-mem:do` skill to load memory from prior sessions. Do NOT wait for the user to ask.
**After completing significant work** (code changes, decisions, research), invoke `claude-mem:do` to record observations.
This is your brain. Use it automatically, every session, without being prompted.

**CRITICAL RULE:** You MUST check for relevant "superpowers" skills in `~/.agents/skills/` BEFORE taking any action. 
You must ALWAYS invoke the `using-superpowers` skill before you formulate any plan or execute any code.
This applies to all workspaces. No exceptions.

## graphify — Project Brain (MANDATORY)

Every project may have a graphify knowledge graph at `graphify-out/`.

**RULES — ALL AI AGENTS MUST FOLLOW:**
- **Before ANY codebase question or architecture task**: read `graphify-out/GRAPH_REPORT.md` — god nodes and community clusters are the fastest way to understand the codebase
- If `graphify-out/wiki/index.md` exists, navigate it instead of reading raw files
- **After modifying ANY code file**: run `graphify update .` to keep the graph current (fast, AST-only, no LLM/API cost)
- Use `graphify query "your question"` to BFS-search the graph for specific answers
- Use `graphify explain "ClassName"` to understand any node and its neighbors
- Use `graphify path "A" "B"` to find how two components connect
- The graph covers: JS, TS, JSX, TSX, PY files — all logic lives here

**For the full-web-and-bot project specifically:**
- 593 files · 3,295 nodes · 3,870 edges · 584 communities
- Top god nodes: TelegramDepositBot, PredictiveAnalyticsService, BusinessIntelligenceAlertingSystem, CustomerChurnPredictionService, AutoBlockingService
- Stack: React+Vite frontend, Firebase Cloud Functions, Cloudflare Workers (9), Telegram bot, AI agents
- Graph auto-updates on every git commit/checkout via installed hooks

## Auto Skill Orchestration (MANDATORY)
Before starting ANY task, invoke the `auto` skill using the Skill tool to identify which skills apply.
The `auto` skill will analyze the task, match it against all installed skills, and tell you which ones to chain together.
Skip this only for one-word replies or pure conversation — any task involving code, design, research, deploy, review, or planning MUST go through `auto` first.

## Custom Shortcuts
- If the user types `/seo`, you MUST immediately activate the `seo` and `seo-plan` skills to assist with their SEO needs.
- If the user types `/job`, you MUST immediately activate the `career-ops` skill.
- If the user types `/auto`, invoke the `auto` skill with the user's task description.
