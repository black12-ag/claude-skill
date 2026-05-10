# Claude Code — Full Skill Setup
> My personal Claude Code skill pack. One command installs everything on any new Mac.

## ⚡ Install on a New Mac (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/black12-ag/claude-skill/main/bootstrap.sh | bash
```

This will:
1. Install Claude Code (if missing)
2. Log you into your Anthropic account
3. Add all marketplaces (superpowers, taste-skills, impeccable, claude-mem, ruflo, etc.)
4. Install all 17 plugins
5. Copy all custom skill files
6. Set up global `~/CLAUDE.md` instructions
7. Apply settings template

---

## 📦 What Gets Installed

### Plugins (17 total)

| Plugin | Marketplace | What it does |
|--------|-------------|--------------|
| `superpowers` | claude-plugins-official | Core skill system (auto, brainstorm, TDD, debugging) |
| `superpowers` | superpowers-dev | Latest dev version of superpowers |
| `frontend-design` | claude-plugins-official | Frontend/UI component design |
| `context7` | claude-plugins-official | Live library documentation fetcher |
| `code-review` | claude-plugins-official | Automated code review |
| `coderabbit` | claude-plugins-official | AI-powered PR review |
| `security-guidance` | claude-plugins-official | Security best practices |
| `supabase` | claude-plugins-official | Supabase DB workflows |
| `plugin-dev` | claude-plugins-official | Build Claude plugins |
| `playground` | claude-plugins-official | Interactive sandboxes |
| `claude-code-setup` | claude-plugins-official | Setup recommendations |
| `swift-lsp` | claude-plugins-official | Swift language server |
| `Notion` | claude-plugins-official | Notion integration |
| `claude-mem` | thedotmack | Persistent memory across sessions |
| `impeccable` | impeccable | UI/UX audit & frontend polish |
| `ts` | taste-skills | Design taste + visual refinement |
| `50` | ruflo | Multi-agent swarm (Claude-Flow) |

### Marketplaces Added

| Name | GitHub Repo |
|------|-------------|
| `thedotmack` | thedotmack/claude-mem |
| `superpowers-dev` | obra/superpowers |
| `career-ops` | santifer/career-ops |
| `cwb-plugins` | Code-with-Beto/skills |
| `impeccable` | pbakaus/impeccable |
| `taste-skills` | Leonxlnx/taste-skill |
| `ruflo` | ruvnet/ruflo |

---

## 🎮 All Commands & How Skills Appear in Claude

When you open Claude Code, type `/` to see all available commands. Here's every command and what it does:

### Core Navigation
| Command | What it does |
|---------|-------------|
| `/help` | Show all available commands |
| `/menu` | Browse all installed skills visually |
| `/clear` | Clear the conversation |
| `/config` | Open Claude Code settings |
| `/status` | Show current session status |
| `/memory` | View/manage Claude's memory |
| `/cost` | Show token usage for this session |
| `/doctor` | Diagnose Claude Code issues |
| `/reset` | Reset project memory |

### Skill Commands (type these to activate)
| Command | Plugin | What it does |
|---------|--------|-------------|
| `/auto <task>` | superpowers | Smart skill router — describes task, picks best skills automatically |
| `/seo` | custom | Full SEO toolkit (audit, content, schema, sitemap, images) |
| `/build` | custom | Build coordination skill |
| `/ship` | superpowers | Ship/deploy a feature end-to-end |
| `/review` | code-review | Code review with suggestions |
| `/qa` | superpowers | Quality assurance & testing |
| `/qa-only` | superpowers | Run tests without changing code |
| `/brainstorm` | superpowers | Structured brainstorming session |
| `/plan` | superpowers | Create implementation plan |
| `/investigate` | superpowers | Deep investigation / debugging |
| `/guard` | superpowers | Safety check before risky actions |
| `/freeze` | superpowers | Pause all actions (safety mode) |
| `/unfreeze` | superpowers | Resume from freeze |
| `/context-save` | superpowers | Save current context to memory |
| `/context-restore` | superpowers | Restore saved context |
| `/retro` | superpowers | Run a retrospective on work done |
| `/health` | superpowers | Check project health |
| `/canary` | superpowers | Canary deploy workflow |
| `/land-and-deploy` | superpowers | Land branch + deploy |
| `/office-hours` | superpowers | Idea/design review session |
| `/scrape <url>` | superpowers | Scrape a website |
| `/browse <url>` | superpowers | Browse a webpage |
| `/make-pdf` | superpowers | Generate a PDF document |
| `/benchmark` | superpowers | Performance benchmark |
| `/security-review` | security-guidance | Full security audit |
| `/security-best-practices` | security-guidance | Security pattern check |
| `/ui` | impeccable/frontend-design | UI component design |
| `/uiux` | impeccable | UX audit & improvement |
| `/dg` | superpowers | Motion/animation design |
| `/50` | ruflo | Launch multi-agent swarm |
| `/supabase` | supabase | Supabase DB operations |
| `/firebase-basics` | superpowers | Firebase setup |
| `/context7 <lib>` | context7 | Fetch live docs for any library |
| `/playground` | playground | Interactive code sandbox |

### SEO Sub-commands
| Command | What it does |
|---------|-------------|
| `/seo` | Master SEO skill |
| `/seo-audit` | Full site SEO audit |
| `/seo-technical` | Technical SEO check |
| `/seo-content` | Content optimization |
| `/seo-schema` | Structured data / JSON-LD |
| `/seo-sitemap` | Sitemap generation |
| `/seo-images` | Image SEO optimization |
| `/seo-page` | Single page SEO |
| `/seo-geo` | Local/geo SEO |
| `/seo-hreflang` | Multilingual hreflang |
| `/seo-competitor-pages` | Competitor analysis |
| `/seo-programmatic` | Programmatic SEO |

### Memory Commands (claude-mem plugin)
| Command | What it does |
|---------|-------------|
| `/learn-codebase` | Deep-learn entire repo into memory |
| `/mem-search <query>` | Search memory |
| `/timeline-report` | Timeline of project work |
| `/smart-explore` | Smart codebase exploration |
| `/how-it-works` | Explain how claude-mem works |

### Superpowers Workflow Commands
| Command | What it does |
|---------|-------------|
| `/write-plan` | Write an implementation plan |
| `/execute-plan` | Execute a written plan |
| `/test-driven-development` | TDD workflow |
| `/systematic-debugging` | Step-by-step debugging |
| `/requesting-code-review` | Prepare & request code review |
| `/receiving-code-review` | Process received review feedback |
| `/dispatching-parallel-agents` | Run multiple agents in parallel |
| `/subagent-driven-development` | Delegate to sub-agents |
| `/finishing-a-development-branch` | Branch completion checklist |
| `/using-git-worktrees` | Git worktree workflow |
| `/verification-before-completion` | Pre-completion verification |

### Plugin Management
| Command | What it does |
|---------|-------------|
| `claude plugins list` | See all installed plugins |
| `claude plugins install <name>` | Install a plugin |
| `claude plugins update <name>` | Update a plugin |
| `claude plugins marketplace list` | See all marketplaces |
| `claude plugins marketplace add github:<repo>` | Add a marketplace |
| `claude plugins marketplace update` | Refresh all marketplace indexes |

---

## 🔄 How Skills Appear in Claude

When you type `/` in Claude Code, you'll see a dropdown of all available commands. Skills appear in different ways:

**As slash commands** — type `/skill-name` to invoke directly:
```
/auto build me a landing page
/ship
/review
```

**As suggestions** — Claude proactively invokes skills when relevant. For example:
- Start working on UI → Claude auto-activates `impeccable` + `ts:taste-skill`
- Ask to deploy → Claude invokes `ship` + `guard`
- Ask about a library → Claude calls `context7` to fetch live docs

**Via `/auto`** — the smart router picks the right skill:
```
/auto I need to build a Stripe payment form
→ activates: frontend-design + security-best-practices + supabase
```

---

## 🔁 Keeping Skills Updated

```bash
# On your main Mac — after adding/changing skills:
cd ~/Desktop/skill
bash snapshot.sh
git add -A && git commit -m "update skills"
git push

# On any other Mac — pull latest:
cd ~/.claude-skill-setup
git pull
bash install.sh
```

---

## 📁 Repo Structure

```
claude-skill/
├── bootstrap.sh          ← one-liner: curl | bash
├── install.sh            ← full installer (run after cloning)
├── snapshot.sh           ← capture current skills into repo
├── CLAUDE.md             ← global agent instructions
├── settings-template.json ← Claude settings (no secrets)
├── claude-skills/        ← custom .md skill files (52 files)
│   ├── auto.md
│   ├── seo.md
│   ├── superpowers/
│   └── ...
└── agent-skills/         ← plugin directories (128 entries)
    ├── brainstorming/
    ├── superpowers/
    ├── frontend-design/
    └── ...
```

---

## 🔑 After Install — Add Your API Keys

Some features need environment variables. Add to `~/.zshrc` or `~/.bash_profile`:

```bash
# Claude / Anthropic
export ANTHROPIC_API_KEY="your-key-here"

# GitHub (for gh commands)
export GITHUB_TOKEN="your-token-here"

# Supabase
export SUPABASE_URL="your-url"
export SUPABASE_ANON_KEY="your-key"
```

Then run: `source ~/.zshrc`

---

## 📞 Support

- Claude Code docs: https://docs.anthropic.com/claude-code
- Issues with this setup: open an issue at https://github.com/black12-ag/claude-skill
