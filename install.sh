#!/usr/bin/env bash
# ================================================================
#  Claude Code — Full Setup & Restore Script
#  Repo: https://github.com/black12-ag/claude-skill
#
#  One-command install on any new Mac:
#    curl -fsSL https://raw.githubusercontent.com/black12-ag/claude-skill/main/bootstrap.sh | bash
#
#  Or after cloning:
#    bash install.sh
# ================================================================

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'
info()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
header()  { echo -e "\n${BOLD}${GREEN}━━ $1 ━━${NC}"; }
err()     { echo -e "${RED}[✗]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BOLD}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   Claude Code — Full Skill Installer     ║"
echo "  ║   github.com/black12-ag/claude-skill     ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"

# ── Step 0: Install Claude Code if missing ───────────────────
header "Step 0: Claude Code"
if command -v claude &>/dev/null; then
  info "Claude Code already installed ($(claude --version 2>/dev/null || echo 'unknown version'))"
else
  warn "Claude Code not found. Installing..."
  if command -v npm &>/dev/null; then
    npm install -g @anthropic-ai/claude-code
    info "Claude Code installed via npm"
  else
    err "npm not found. Install Node.js first: https://nodejs.org"
    err "Then re-run this script."
    exit 1
  fi
fi

# ── Step 1: Claude Login ──────────────────────────────────────
header "Step 1: Claude Login"
if claude auth status &>/dev/null 2>&1; then
  info "Already logged in to Claude"
else
  warn "Not logged in. Starting Claude login..."
  echo ""
  echo "  → A browser window will open. Log in with your Anthropic account."
  echo "  → After login, return here and press Enter to continue."
  echo ""
  claude login || warn "Login skipped — run 'claude login' manually if needed"
fi

# ── Step 2: Add Marketplaces ──────────────────────────────────
header "Step 2: Marketplaces"

add_marketplace() {
  local name="$1" repo="$2"
  if claude plugins marketplace list 2>/dev/null | grep -q "^$name"; then
    warn "Marketplace '$name' already added, skipping"
  else
    info "  Adding: $name ($repo)"
    claude plugins marketplace add "github:$repo" --name "$name" 2>/dev/null \
      || warn "  Could not add $name (may need manual add)"
  fi
}

add_marketplace "thedotmack"      "thedotmack/claude-mem"
add_marketplace "superpowers-dev" "obra/superpowers"
add_marketplace "career-ops"      "santifer/career-ops"
add_marketplace "cwb-plugins"     "Code-with-Beto/skills"
add_marketplace "impeccable"      "pbakaus/impeccable"
add_marketplace "taste-skills"    "Leonxlnx/taste-skill"
add_marketplace "ruflo"           "ruvnet/ruflo"

info "Updating all marketplace indexes..."
claude plugins marketplace update 2>/dev/null || warn "Marketplace update had issues (continuing)"

# ── Step 3: Install Plugins ───────────────────────────────────
header "Step 3: Plugins (17 total)"

install_plugin() {
  local plugin="$1"
  if claude plugins list 2>/dev/null | grep -q "${plugin%%@*}"; then
    warn "  Already installed: $plugin"
  else
    info "  Installing: $plugin"
    claude plugins install "$plugin" --yes 2>/dev/null \
      || warn "  Failed: $plugin (try: claude plugins install $plugin)"
  fi
}

# Official plugins
install_plugin "superpowers@claude-plugins-official"
install_plugin "frontend-design@claude-plugins-official"
install_plugin "context7@claude-plugins-official"
install_plugin "code-review@claude-plugins-official"
install_plugin "security-guidance@claude-plugins-official"
install_plugin "supabase@claude-plugins-official"
install_plugin "plugin-dev@claude-plugins-official"
install_plugin "playground@claude-plugins-official"
install_plugin "claude-code-setup@claude-plugins-official"
install_plugin "coderabbit@claude-plugins-official"
install_plugin "swift-lsp@claude-plugins-official"
install_plugin "Notion@claude-plugins-official"

# 3rd-party plugins
install_plugin "claude-mem@thedotmack"
install_plugin "superpowers@superpowers-dev"
install_plugin "impeccable@impeccable"
install_plugin "ts@taste-skills"
install_plugin "50@ruflo"

# ── Step 4: Copy Custom Skill Files ──────────────────────────
header "Step 4: Custom Skills"
mkdir -p "$HOME/.claude/skills"
mkdir -p "$HOME/.agents/skills"

if [ -d "$SCRIPT_DIR/claude-skills" ]; then
  cp -r "$SCRIPT_DIR/claude-skills/." "$HOME/.claude/skills/"
  count=$(ls "$SCRIPT_DIR/claude-skills/" | wc -l | tr -d ' ')
  info "Copied $count skill files → ~/.claude/skills/"
else
  warn "No claude-skills/ folder found"
fi

if [ -d "$SCRIPT_DIR/agent-skills" ]; then
  cp -r "$SCRIPT_DIR/agent-skills/." "$HOME/.agents/skills/"
  count=$(ls "$SCRIPT_DIR/agent-skills/" | wc -l | tr -d ' ')
  info "Copied $count agent skills → ~/.agents/skills/"
else
  warn "No agent-skills/ folder found"
fi

# ── Step 5: CLAUDE.md (Global Instructions) ───────────────────
header "Step 5: Global Instructions"
if [ -f "$SCRIPT_DIR/CLAUDE.md" ]; then
  cp "$SCRIPT_DIR/CLAUDE.md" "$HOME/CLAUDE.md"
  info "Installed CLAUDE.md → ~/CLAUDE.md"
fi

# ── Step 6: Apply Settings Template ──────────────────────────
header "Step 6: Settings"
SETTINGS_FILE="$HOME/.claude/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
  warn "settings.json already exists — merging plugin list only"
  # Just copy template as reference; don't overwrite user settings
  cp "$SCRIPT_DIR/settings-template.json" "$HOME/.claude/settings-template.json"
  info "Template saved to ~/.claude/settings-template.json (review manually)"
else
  cp "$SCRIPT_DIR/settings-template.json" "$SETTINGS_FILE"
  info "Created ~/.claude/settings.json from template"
fi

# ── Done ──────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║  ✓ Setup complete! Restart Claude Code now.      ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo "  Quick commands after restart:"
echo "  /help        — see all commands"
echo "  /menu        — browse all skills"
echo "  /auto <task> — smart skill picker"
echo "  /seo         — SEO tools"
echo "  /build       — build something"
echo "  /ship        — deploy & ship"
echo "  /review      — code review"
echo "  /qa          — run tests"
echo ""
