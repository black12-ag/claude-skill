#!/usr/bin/env bash
# ============================================================
# Snapshot current Claude skills into this repo.
# Run whenever you add/update skills and want to commit them.
#   bash snapshot.sh
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Snapshot ~/.claude/skills/ (flat .md files) ───────
info "Snapshotting ~/.claude/skills/ ..."
rm -rf "$SCRIPT_DIR/claude-skills"
mkdir -p "$SCRIPT_DIR/claude-skills"

# Only copy .md files that are NOT the giant automation stubs
# (automation files are fetched from Composio on install — no need to store them)
find "$HOME/.claude/skills" -maxdepth 1 -name "*.md" \
  ! -name "*-automation.md" \
  -exec cp {} "$SCRIPT_DIR/claude-skills/" \;

count=$(ls "$SCRIPT_DIR/claude-skills/" | wc -l | tr -d ' ')
info "  Copied $count custom skill files (automation stubs excluded)"

# ── 2. Snapshot ~/.agents/skills/ (directories + files) ──
info "Snapshotting ~/.agents/skills/ ..."
rm -rf "$SCRIPT_DIR/agent-skills"
mkdir -p "$SCRIPT_DIR/agent-skills"

# Copy everything (directories and lone files), skip CONTRIBUTING.md/README.md
rsync -a --exclude='README.md' --exclude='CONTRIBUTING.md' \
  "$HOME/.agents/skills/" "$SCRIPT_DIR/agent-skills/"

count=$(ls "$SCRIPT_DIR/agent-skills/" | wc -l | tr -d ' ')
info "  Copied $count agent skill entries"

# ── 3. Copy CLAUDE.md ────────────────────────────────────
if [ -f "$HOME/CLAUDE.md" ]; then
  cp "$HOME/CLAUDE.md" "$SCRIPT_DIR/CLAUDE.md"
  info "Updated CLAUDE.md"
fi

info "Snapshot complete. Now run: git add -A && git commit -m 'snapshot skills'"
