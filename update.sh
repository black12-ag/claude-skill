#!/usr/bin/env bash
# ============================================================
# Claude Skill Pack — SELF-UPDATE
#
# Brings everything to the latest upstream version, with no
# manual work:
#   • pulls the latest pack repo (bundled skills + scripts)
#   • updates all marketplaces + every installed plugin
#   • updates graphify from its git
#   • re-syncs custom + agent skills onto the machine
#
# Run manually:           bash update.sh
# Runs automatically via the LaunchAgent/cron set up by install.sh
# ============================================================
set -uo pipefail   # best-effort: one failure must not abort the rest

# PATH so a headless launchd/cron job finds git/uv/claude/graphify.
# /usr/bin first => system git (avoids broken shim gits); user dirs next;
# original PATH appended so other machines keep their own tool locations.
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

SETUP_DIR="${CLAUDE_SKILL_DIR:-$HOME/.claude-skill-setup}"
REPO="https://github.com/black12-ag/claude-skill.git"
GRAPHIFY_GIT="git+https://github.com/safishamsi/graphify.git@v8"
GIT="/usr/bin/git"; [ -x "$GIT" ] || GIT="$(command -v git || echo git)"

echo "════ Claude Skill Pack — self-update $(date '+%Y-%m-%d %H:%M') ════"

# 1 ── Refresh the pack repo (latest bundled skills + this script) ──
if [ -d "$SETUP_DIR/.git" ]; then
  info "Pulling latest pack..."
  # ff-pull, else force-sync to origin (survives a dirty/diverged setup dir).
  "$GIT" -C "$SETUP_DIR" pull --ff-only 2>/dev/null \
    || { "$GIT" -C "$SETUP_DIR" fetch --depth 1 origin main 2>/dev/null \
         && "$GIT" -C "$SETUP_DIR" reset --hard origin/main 2>/dev/null \
         && info "force-synced to origin/main"; } \
    || warn "pack update skipped (kept current copy)"
else
  info "Cloning pack..."
  rm -rf "$SETUP_DIR"
  "$GIT" clone --depth 1 "$REPO" "$SETUP_DIR" 2>/dev/null || warn "clone failed"
fi

# 2 ── Update marketplaces + every installed plugin to latest ──
if command -v claude >/dev/null 2>&1; then
  info "Updating marketplaces..."
  claude plugin marketplace update >/dev/null 2>&1 || warn "marketplace update had issues"
  info "Updating installed plugins..."
  # Only real marketplace plugins. Skip @skills-dir (local skills — these are
  # synced by the copy step below, not installed from a marketplace).
  claude plugin list 2>/dev/null | grep -oE '[A-Za-z0-9_.-]+@[A-Za-z0-9_.-]+' \
    | grep -v '@skills-dir' | sort -u | while read -r p; do
    if claude plugin update "$p" >/dev/null 2>&1; then echo "    ✓ $p"; else warn "    could not update $p"; fi
  done
else
  warn "claude CLI not found — skipping plugin updates"
fi

# 3 ── Update graphify from its git, then sync its skill ──
if command -v uv >/dev/null 2>&1; then
  info "Updating graphify (from git)..."
  if uv tool install --force "graphifyy @ $GRAPHIFY_GIT" >/dev/null 2>&1; then
    command -v graphify >/dev/null 2>&1 && graphify install >/dev/null 2>&1
    info "  graphify -> $(uv tool list 2>/dev/null | awk '/graphifyy/{print $2; exit}')"
  else
    warn "  graphify update failed"
  fi
else
  warn "uv not found — skipping graphify (install uv: curl -LsSf https://astral.sh/uv/install.sh | sh)"
fi

# 4 ── Re-sync bundled skills from the refreshed pack ──
mkdir -p "$HOME/.claude/skills" "$HOME/.agents/skills"
[ -d "$SETUP_DIR/claude-skills" ] && cp -R "$SETUP_DIR/claude-skills/." "$HOME/.claude/skills/"  2>/dev/null && info "Custom skills synced"
[ -d "$SETUP_DIR/agent-skills"  ] && cp -R "$SETUP_DIR/agent-skills/."  "$HOME/.agents/skills/" 2>/dev/null && info "Agent skills synced"
[ -f "$SETUP_DIR/CLAUDE.md" ] && cp "$SETUP_DIR/CLAUDE.md" "$HOME/CLAUDE.md" 2>/dev/null

info "Self-update complete. Restart Claude Code to load changes."
