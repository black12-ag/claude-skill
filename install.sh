#!/usr/bin/env bash
# ============================================================
# Claude Code — Full Skill & Plugin Restore Script
# Run this on any new machine after installing Claude Code:
#   bash install.sh
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }

# ── 1. Add marketplaces ────────────────────────────────────
info "Adding marketplaces..."

add_marketplace() {
  local name="$1" repo="$2"
  if claude plugins marketplace list 2>/dev/null | grep -q "$name"; then
    warn "Marketplace '$name' already exists, skipping"
  else
    info "  Adding marketplace: $name ($repo)"
    claude plugins marketplace add "github:$repo" --name "$name" || warn "  Failed to add $name"
  fi
}

# claude-plugins-official is built-in, skip it
add_marketplace "thedotmack"     "thedotmack/claude-mem"
add_marketplace "superpowers-dev" "obra/superpowers"
add_marketplace "career-ops"     "santifer/career-ops"
add_marketplace "cwb-plugins"    "Code-with-Beto/skills"
add_marketplace "impeccable"     "pbakaus/impeccable"
add_marketplace "taste-skills"   "Leonxlnx/taste-skill"
add_marketplace "ruflo"          "ruvnet/ruflo"

info "Updating all marketplaces..."
claude plugins marketplace update || warn "Marketplace update had issues"

# ── 2. Install plugins ─────────────────────────────────────
info "Installing plugins..."

install_plugin() {
  local plugin="$1"
  info "  Installing: $plugin"
  claude plugins install "$plugin" --yes 2>/dev/null || warn "  Failed (may already be installed): $plugin"
}

install_plugin "frontend-design@claude-plugins-official"
install_plugin "swift-lsp@claude-plugins-official"
install_plugin "superpowers@claude-plugins-official"
install_plugin "context7@claude-plugins-official"
install_plugin "code-review@claude-plugins-official"
install_plugin "Notion@claude-plugins-official"
install_plugin "claude-code-setup@claude-plugins-official"
install_plugin "coderabbit@claude-plugins-official"
install_plugin "playground@claude-plugins-official"
install_plugin "plugin-dev@claude-plugins-official"
install_plugin "security-guidance@claude-plugins-official"
install_plugin "supabase@claude-plugins-official"
install_plugin "claude-mem@thedotmack"
install_plugin "superpowers@superpowers-dev"
install_plugin "impeccable@impeccable"
install_plugin "ts@taste-skills"
install_plugin "50@ruflo"

# ── 3. Copy custom skill files (.md) ──────────────────────
info "Copying custom skill files to ~/.claude/skills/ ..."
mkdir -p "$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "$SCRIPT_DIR/claude-skills" ]; then
  cp -r "$SCRIPT_DIR/claude-skills/." "$HOME/.claude/skills/"
  info "  Copied claude-skills → ~/.claude/skills/"
else
  warn "  No claude-skills/ folder found — skipping"
fi

# ── 4. Copy agent skills (directory-based) ────────────────
info "Copying agent skills to ~/.agents/skills/ ..."
mkdir -p "$HOME/.agents/skills"

if [ -d "$SCRIPT_DIR/agent-skills" ]; then
  cp -r "$SCRIPT_DIR/agent-skills/." "$HOME/.agents/skills/"
  info "  Copied agent-skills → ~/.agents/skills/"
else
  warn "  No agent-skills/ folder found — skipping"
fi

# ── 5. Copy CLAUDE.md if present ──────────────────────────
if [ -f "$SCRIPT_DIR/CLAUDE.md" ]; then
  info "Copying CLAUDE.md → ~/CLAUDE.md ..."
  cp "$SCRIPT_DIR/CLAUDE.md" "$HOME/CLAUDE.md"
fi

info "Done! Restart Claude Code for changes to take effect."
