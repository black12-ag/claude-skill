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

# Marketplace name is taken from each repo's .claude-plugin/marketplace.json
# ("name" field) — the CLI has no --name flag. The $name arg below must match
# that manifest name so the "already added" check works and plugin@marketplace
# references resolve.
add_marketplace() {
  local name="$1" repo="$2"
  if claude plugin marketplace list 2>/dev/null | grep -q "$name"; then
    warn "Marketplace '$name' already added, skipping"
  else
    info "  Adding: $name ($repo)"
    claude plugin marketplace add "$repo" 2>/dev/null \
      || warn "  Could not add $name (may need manual add)"
  fi
}

add_marketplace "thedotmack"      "thedotmack/claude-mem"
add_marketplace "superpowers-dev" "obra/superpowers"
add_marketplace "career-ops"      "santifer/career-ops"
add_marketplace "cwb-plugins"     "Code-with-Beto/skills"
add_marketplace "impeccable"      "pbakaus/impeccable"
add_marketplace "taste-skill"     "Leonxlnx/taste-skill"
add_marketplace "ruflo"           "ruvnet/ruflo"

info "Updating all marketplace indexes..."
claude plugin marketplace update 2>/dev/null || warn "Marketplace update had issues (continuing)"

# ── Step 3: Install Plugins ───────────────────────────────────
header "Step 3: Plugins (20 total)"

install_plugin() {
  local plugin="$1"
  if claude plugin list 2>/dev/null | grep -q "${plugin%%@*}"; then
    warn "  Already installed: $plugin"
  else
    info "  Installing: $plugin"
    claude plugin install "$plugin" 2>/dev/null \
      || warn "  Failed: $plugin (try: claude plugin install $plugin)"
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
install_plugin "vercel@claude-plugins-official"

# 3rd-party plugins
install_plugin "claude-mem@thedotmack"
install_plugin "superpowers@superpowers-dev"
install_plugin "impeccable@impeccable"
install_plugin "taste-skill@taste-skill"
install_plugin "ruflo-core@ruflo"
install_plugin "ruflo-goals@ruflo"
install_plugin "ruflo-sparc@ruflo"
install_plugin "ruflo-swarm@ruflo"

# ── Step 3.5: Graphify (knowledge-graph CLI + skill) ─────────
header "Graphify"
if command -v uv >/dev/null 2>&1; then
  info "Installing graphify from git (latest)..."
  if uv tool install --force "graphifyy @ git+https://github.com/safishamsi/graphify.git@v8" 2>/dev/null; then
    command -v graphify >/dev/null 2>&1 && graphify install 2>/dev/null
    info "graphify installed"
  else
    warn "graphify install failed (continuing)"
  fi
else
  warn "uv not found — skipping graphify. Install uv first: curl -LsSf https://astral.sh/uv/install.sh | sh"
fi

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

# ── Step 7: Auto-Update (self-updating, no manual work) ───────
header "Step 7: Auto-Update"
chmod +x "$SCRIPT_DIR/update.sh" 2>/dev/null
if [ "$(uname)" = "Darwin" ]; then
  # macOS: a LaunchAgent runs update.sh daily at 10:00.
  PLIST="$HOME/Library/LaunchAgents/com.claude-skill.update.plist"
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$PLIST" <<PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.claude-skill.update</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$SCRIPT_DIR/update.sh</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict><key>Hour</key><integer>10</integer><key>Minute</key><integer>0</integer></dict>
  <key>StandardOutPath</key><string>$SCRIPT_DIR/update.log</string>
  <key>StandardErrorPath</key><string>$SCRIPT_DIR/update.log</string>
</dict>
</plist>
PLISTEOF
  launchctl unload "$PLIST" 2>/dev/null || true
  if launchctl load "$PLIST" 2>/dev/null; then
    info "Auto-update ON — runs daily @ 10:00 (log: $SCRIPT_DIR/update.log)"
    info "  Disable: launchctl unload $PLIST"
  else
    warn "Could not load LaunchAgent — enable manually: launchctl load $PLIST"
  fi
else
  # Linux/other: cron entry (idempotent).
  CRON_LINE="0 10 * * * /bin/bash $SCRIPT_DIR/update.sh >> $SCRIPT_DIR/update.log 2>&1"
  if ( crontab -l 2>/dev/null | grep -v 'claude-skill.*update.sh'; echo "$CRON_LINE" ) | crontab - 2>/dev/null; then
    info "Auto-update ON via cron — runs daily @ 10:00"
  else
    warn "Could not set cron. Run manually anytime: bash $SCRIPT_DIR/update.sh"
  fi
fi
info "Update now anytime with: bash $SCRIPT_DIR/update.sh"

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
echo "  /graphify    — code knowledge graph"
echo ""
echo "  Self-updates daily — or run now: bash ~/.claude-skill-setup/update.sh"
echo ""
