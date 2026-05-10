# Claude Code — Full Skill Setup
> My personal Claude Code skill pack. One command installs everything on any new Mac.

## ⚡ Install on a New Mac (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/black12-ag/claude-skill/main/bootstrap.sh | bash
```

This will automatically:
1. Install Claude Code (if missing)
2. Log you into your Anthropic account
3. Add all 7 marketplaces
4. Install all 17 plugins
5. Copy all 128 agent skills + 52 custom skills
6. Set up your global `~/CLAUDE.md` instructions
7. Apply settings template

---

## 🎮 Every Slash Command & What It Does

Type `/` in Claude Code to see all commands. Here is every single one:

### 🚀 Quick Shortcuts (type exactly these)

| Command | Purpose |
|---------|---------|
| `/auto <task>` | Smart skill router — describes your task, picks the best skills automatically |
| `/seo` | Activate full SEO toolkit (audit, content, schema, sitemap, images) |
| `/build <feature>` | Quick full-feature build shortcut — describe what to build |
| `/ui <description>` | Generate a UI screen or component from a text description |
| `/tv <symbol>` | TradingView analysis for any stock or crypto symbol |
| `/menu` | Show a visual menu of ALL installed skills grouped by category |
| `/50` | Launch multi-agent Claude-Flow swarm for complex parallel tasks |
| `/graphify` | Build or update a knowledge graph for the current project |

---

### 🧠 Planning & Thinking

| Command | Purpose |
|---------|---------|
| `/brainstorm` | Structured brainstorming — explores intent, requirements, and design before writing any code |
| `/plan` | Create a step-by-step implementation plan for a multi-step task |
| `/write-plan` | Write a detailed plan document before touching code |
| `/office-hours` | Idea validation and design review session |
| `/plan-eng-review` | Engineering-focused plan review |
| `/plan-ceo-review` | Strategy/CEO-level plan review |
| `/plan-design-review` | Design plan review |
| `/plan-devex-review` | Developer experience plan review |
| `/plan-tune` | Refine and tune an existing plan |

---

### 🏗️ Building & Coding

| Command | Purpose |
|---------|---------|
| `/build <feature>` | Full-feature build coordination skill |
| `/execute-plan` | Execute a written plan step by step |
| `/feature-dev` | Full feature development workflow |
| `/gstack` | Primary workflow manager for building in the Gstack stack |
| `/local-build` | Build a release APK + simulator .app locally for React Native Expo (no EAS needed) |
| `/laravel-boost` | Laravel-specific development boosts and best practices |
| `/stripe` | Best practices for Stripe payments, checkout, subscriptions, webhooks, Connect |
| `/mcp-builder` | Guide to building MCP (Model Context Protocol) servers for any external API |
| `/agent-sdk-dev` | Build Claude Agent SDK apps (Python/TypeScript) |
| `/remotion` | Create programmatic videos with React using Remotion |
| `/manim-video` | Create mathematical and technical animations using Manim |
| `/artifacts-builder` | Build elaborate multi-component HTML artifacts for claude.ai |

---

### 🎨 Design & UI

| Command | Purpose |
|---------|---------|
| `/ui <description>` | Generate a UI screen or component |
| `/uiux` | Full UI/UX audit — hierarchy, spacing, accessibility, cognitive load |
| `/ui-ux-pro-max` | Premium UX/UI design — color intelligence, motion, anti-patterns |
| `/impeccable` | Deep UI audit — redesign, polish, make bland designs bold |
| `/frontend-design` | Frontend component architecture and design |
| `/dg` | Motion & animation audit (Emil Kowalski, Jhey Tompkins style) |
| `/canvas-design` | Create posters, art, and static visual designs as PNG/PDF |
| `/brandkit` | Generate brand-kit boards, logo systems, identity decks |
| `/brand-guidelines` | Apply Anthropic brand colors and typography to any artifact |
| `/theme-factory` | Apply one of 10 preset themes (or custom) to slides, docs, HTML pages |
| `/redesign` | Upgrade existing websites/apps to premium quality without breaking functionality |
| `/stitch-skill` | Generate DESIGN.md files for Google Stitch design systems |
| `/ts:taste-skill` | Senior UI/UX taste check — overrides generic AI design biases |
| `/ts:minimalist-skill` | Minimalist style — warm monochrome, typographic contrast, editorial |
| `/ts:brutalist-skill` | Brutalist style — Swiss typography fused with military terminal aesthetics |
| `/ts:soft-skill` | Soft/agency style — high-end fonts, spacing, design system rules |
| `/ts:gpt-tasteskill` | Elite UX/UI + GSAP motion engineering |
| `/ts:redesign-skill` | Premium redesign from screenshot or description |
| `/ts:stitch-skill` | Design system generation for Stitch |
| `/ts:image-to-code-skill` | Convert image/screenshot into working code |
| `/ts:imagegen-frontend-web` | Generate premium web UI images |
| `/ts:imagegen-frontend-mobile` | Generate premium mobile app UI images |
| `/ts:output-skill` | Force complete output — no truncation |

---

### 📝 Content & Writing

| Command | Purpose |
|---------|---------|
| `/content-research-writer` | Research + write high-quality content with citations, hooks, and iteration |
| `/internal-comms` | Write internal communications — status reports, newsletters, incident reports |
| `/changelog-generator` | Auto-generate user-facing changelogs from git commit history |
| `/writing-plans` | Write plans before coding — enforces spec-first discipline |
| `/writing-skills` | Create or edit Claude skills with best practices |
| `/skill-creator` | Guide to creating new skills that extend Claude's capabilities |
| `/skill-share` | Create a skill and share it automatically to Slack |
| `/twitter-algorithm-optimizer` | Rewrite tweets to maximize reach using Twitter's open-source algorithm |
| `/sales-enablement` | Create pitch decks, one-pagers, objection handling docs, demo scripts |

---

### 🔍 Research & Investigation

| Command | Purpose |
|---------|---------|
| `/investigate` | Deep investigation and root-cause analysis |
| `/scrape <url>` | Scrape a website for content or data |
| `/browse <url>` | Browse a webpage interactively |
| `/lead-research-assistant` | Find high-quality leads — analyzes your business and searches for targets |
| `/competitive-ads-extractor` | Extract and analyze competitor ads from Facebook/LinkedIn ad libraries |
| `/developer-growth-analysis` | Analyze your Claude Code chat history for coding patterns and growth areas |
| `/meeting-insights-analyzer` | Analyze meeting transcripts for communication patterns and blind spots |
| `/greptile` | Search and understand large codebases with Greptile AI |
| `/langsmith-fetch` | Debug LangChain/LangGraph agents by fetching LangSmith traces |
| `/context7 <library>` | Fetch live up-to-date documentation for any library or framework |

---

### ✅ Review & Quality

| Command | Purpose |
|---------|---------|
| `/review` | Full code review with suggestions |
| `/coderabbit:code-review` | AI-powered automated PR review |
| `/coderabbit:autofix` | Auto-apply CodeRabbit review feedback safely with per-change approval |
| `/qa` | Quality assurance workflow |
| `/qa-only` | Run tests and QA without changing any code |
| `/webapp-testing` | Test local web apps with Playwright — verify UI, capture screenshots, check logs |
| `/playwright-cli` | Automate browser interactions and write Playwright tests |
| `/playwright` | Full Playwright testing workflow |
| `/retro` | Run a retrospective on completed work |
| `/health` | Check overall project health |
| `/verification-before-completion` | Pre-completion checklist before marking a task done |
| `/benchmark` | Run performance benchmarks |
| `/benchmark-models` | Compare Claude model performance |
| `/pr-review-toolkit` | Full PR review toolkit — comments, approvals, change requests |

---

### 🔐 Security

| Command | Purpose |
|---------|---------|
| `/security-review` | Full security audit of code |
| `/security-best-practices` | Check code against security patterns (OWASP, etc.) |
| `/security-guidance` | General security guidance for your architecture |
| `/guard` | Safety check before any risky or destructive action |

---

### 🚢 Shipping & Deploy

| Command | Purpose |
|---------|---------|
| `/ship` | End-to-end ship/deploy workflow |
| `/land-and-deploy` | Land a branch and deploy |
| `/canary` | Canary deployment workflow |
| `/setup-deploy` | First-time deployment setup |
| `/finishing-a-development-branch` | Branch completion checklist — merge, PR, or cleanup options |

---

### 🗄️ Databases

| Command | Purpose |
|---------|---------|
| `/supabase` | Supabase DB operations, schema, queries, Row Level Security |
| `/firebase-basics` | Firebase/Firestore setup and operations |
| `/firebase-auth-basics` | Firebase Authentication setup |
| `/stripe` | Stripe payments, checkout, subscriptions |

---

### 🔌 Integrations & Connections

| Command | Purpose |
|---------|---------|
| `/connect <app>` | Connect Claude to any app — send emails, create issues, post messages |
| `/connect-apps` | Connect to Gmail, Slack, GitHub, Notion and more |
| `/asana` | Asana task and project management |
| `/slack` | Slack messaging and workspace operations |
| `/github` | GitHub repo, issues, PR operations |
| `/gitlab` | GitLab operations |
| `/linear` | Linear issue tracking |
| `/stripe` | Stripe payment processing |
| `/hookify` | Create and configure automation hooks/rules |

---

### 🧠 Memory & Context

| Command | Purpose |
|---------|---------|
| `/learn-codebase` | Deep-learn entire repo into persistent memory (~5 min, optional) |
| `/mem-search <query>` | Search Claude's memory for past work and decisions |
| `/timeline-report` | View timeline of all project work done in memory |
| `/smart-explore` | Smart memory-backed codebase exploration |
| `/how-it-works` | Explain how the claude-mem memory system works |
| `/context-save` | Save current conversation context to memory |
| `/context-restore` | Restore a previously saved context |
| `/pathfinder` | Navigate the codebase using memory graph |
| `/knowledge-agent` | Query the memory knowledge graph |

---

### 🤖 Agent Workflows

| Command | Purpose |
|---------|---------|
| `/50` | Claude-Flow multi-agent swarm — parallel task execution with coordinator |
| `/pair-agent` | Pair programming with a second Claude agent |
| `/dispatching-parallel-agents` | Dispatch multiple Claude agents to work in parallel |
| `/subagent-driven-development` | Delegate sub-tasks to specialized sub-agents |
| `/systematic-debugging` | Step-by-step structured debugging workflow |
| `/receiving-code-review` | Process and respond to received code review feedback |
| `/requesting-code-review` | Prepare code and request a structured code review |
| `/using-git-worktrees` | Git worktree workflow for safe parallel branches |
| `/test-driven-development` | TDD workflow — write tests first, then implementation |

---

### 📊 Data & Documents

| Command | Purpose |
|---------|---------|
| `/make-pdf` | Generate a PDF document |
| `/pdf` | Full PDF manipulation — extract text, create, modify |
| `/docx` | Create/edit Word documents with tracked changes support |
| `/xlsx` | Create/edit spreadsheets with formulas and formatting |
| `/pptx` | Create/edit PowerPoint presentations |
| `/graphify` | Build a knowledge graph from code, docs, papers, or images |
| `/theme-factory` | Apply visual themes to any document or artifact |

---

### 💼 Career & Business

| Command | Purpose |
|---------|---------|
| `/career-ops` | Job search ops — scan portals, evaluate postings, track applications |
| `/tailored-resume-generator` | Generate ATS-friendly resumes tailored to a job description |
| `/lead-research-assistant` | Find and qualify leads for your product/service |
| `/sales-enablement` | Pitch decks, one-pagers, objection handling, demo scripts |
| `/invoice-organizer` | Organize invoices and receipts for tax prep — auto-rename and sort |
| `/domain-name-brainstormer` | Generate domain name ideas and check availability across TLDs |

---

### 🛠️ Dev Tools & Utilities

| Command | Purpose |
|---------|---------|
| `/app-icon` | Generate app icons for React Native Expo (iOS 26 support) |
| `/app-store-audit` | Audit iOS app for App Store rejection risks before submission |
| `/image-enhancer` | Improve image quality — resolution, sharpness, clarity |
| `/image-to-code` | Convert a design image into working website code |
| `/video-downloader` | Download YouTube videos in any quality/format or as MP3 |
| `/raffle-winner-picker` | Pick random winners from lists, spreadsheets, or Google Sheets |
| `/file-organizer` | Intelligently organize files and folders — find duplicates, suggest structure |
| `/slack-gif-creator` | Create animated GIFs optimized for Slack |
| `/tv <symbol>` | TradingView chart analysis for stocks and crypto |
| `/playground` | Interactive code sandbox for experimentation |

---

### 🔧 LSP Language Servers (code intelligence)

| Command | Purpose |
|---------|---------|
| `/swift-lsp` | Swift language server — autocomplete, diagnostics, go-to-definition |
| `/typescript-lsp` | TypeScript language server |
| `/clangd-lsp` | C/C++ language server |
| `/csharp-lsp` | C# language server |
| `/kotlin-lsp` | Kotlin language server |
| `/gopls-lsp` | Go language server |
| `/rust-analyzer-lsp` | Rust language server |
| `/pyright-lsp` | Python language server |
| `/jdtls-lsp` | Java language server |
| `/lua-lsp` | Lua language server |
| `/php-lsp` | PHP language server |

---

### 🔒 Safety Controls

| Command | Purpose |
|---------|---------|
| `/freeze` | Pause all Claude actions (safety mode — nothing executes) |
| `/unfreeze` | Resume from freeze mode |
| `/guard` | Safety check — confirm before any risky/destructive action |
| `/careful` | Enable extra-careful mode for sensitive operations |

---

### 📦 Plugin Management (terminal commands)

Run these in your terminal, not in Claude:

```bash
claude plugins list                              # See all installed plugins
claude plugins install <name@marketplace>        # Install a plugin
claude plugins update <name>                     # Update a plugin
claude plugins uninstall <name>                  # Remove a plugin
claude plugins marketplace list                  # See all marketplaces
claude plugins marketplace add github:<repo>     # Add a marketplace
claude plugins marketplace update                # Refresh marketplace indexes
```

---

## 🔄 How Skills Appear in Claude

**1. Slash commands** — type `/` and see the full list. Pick any and Claude activates it:
```
/brainstorm
/ship
/review
/auto build me a payment form
```

**2. Auto-activation** — Claude activates skills automatically based on context:
- Working on UI → `impeccable` + `ts:taste-skill` activate
- Asking about a library → `context7` fetches live docs
- About to deploy → `guard` checks safety first
- Writing code → `security-guidance` watches for vulnerabilities

**3. `/auto` smart routing** — describe what you want, Claude picks the right skill chain:
```
/auto I need to build a Stripe checkout page with Supabase
→ activates: stripe + supabase + frontend-design + security-best-practices
```

**4. Suggestions panel** — superpowers skills appear as inline suggestions when relevant

---

## 📦 What Gets Installed

### 17 Plugins

| Plugin | Marketplace | Purpose |
|--------|------------|---------|
| `superpowers` | claude-plugins-official | Core skill system |
| `superpowers` | superpowers-dev | Latest dev version |
| `frontend-design` | claude-plugins-official | UI/component design |
| `context7` | claude-plugins-official | Live library docs |
| `code-review` | claude-plugins-official | Code review |
| `coderabbit` | claude-plugins-official | AI PR review |
| `security-guidance` | claude-plugins-official | Security patterns |
| `supabase` | claude-plugins-official | Supabase workflows |
| `plugin-dev` | claude-plugins-official | Build plugins |
| `playground` | claude-plugins-official | Code sandboxes |
| `claude-code-setup` | claude-plugins-official | Setup guide |
| `swift-lsp` | claude-plugins-official | Swift LSP |
| `Notion` | claude-plugins-official | Notion integration |
| `claude-mem` | thedotmack | Persistent memory |
| `impeccable` | impeccable | UI audit & polish |
| `ts` | taste-skills | Design taste |
| `50` | ruflo | Multi-agent swarm |

### 7 Marketplaces

| Marketplace | GitHub Repo | Provides |
|------------|------------|---------|
| `claude-plugins-official` | anthropics/claude-plugins-official | All official plugins |
| `thedotmack` | thedotmack/claude-mem | claude-mem memory plugin |
| `superpowers-dev` | obra/superpowers | Dev superpowers builds |
| `career-ops` | santifer/career-ops | Career tools |
| `cwb-plugins` | Code-with-Beto/skills | Community skills |
| `impeccable` | pbakaus/impeccable | UI audit plugin |
| `taste-skills` | Leonxlnx/taste-skill | Design taste plugins |
| `ruflo` | ruvnet/ruflo | Claude-Flow swarm |

---

## 🔁 Keep Skills Updated

```bash
# On your main Mac — after adding/changing skills:
cd ~/Desktop/skill
bash snapshot.sh
git add -A && git commit -m "update skills"
git push

# On any other Mac — pull latest:
cd ~/.claude-skill-setup && git pull && bash install.sh
```

---

## 📁 Repo Structure

```
claude-skill/
├── bootstrap.sh            ← one-liner: curl | bash  (for new Mac)
├── install.sh              ← full installer
├── snapshot.sh             ← capture latest skills → commit
├── CLAUDE.md               ← global agent instructions
├── settings-template.json  ← Claude settings (no secrets)
├── claude-skills/          ← 52 custom .md skill files
└── agent-skills/           ← 128 plugin directories
```

---

## 🔑 Add Your API Keys (after install)

Add to `~/.zshrc`:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."    # Claude API
export GITHUB_TOKEN="ghp_..."           # GitHub CLI
export SUPABASE_URL="https://..."       # Supabase
export SUPABASE_ANON_KEY="eyJ..."       # Supabase anon key
```

Then: `source ~/.zshrc`
