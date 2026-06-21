#!/usr/bin/env bash
# ================================================================
#  Claude Skill Pack — Multi-IDE Installer
#  Repo: https://github.com/black12-ag/claude-skill
#
#  One command on any Mac:
#    curl -fsSL https://raw.githubusercontent.com/black12-ag/claude-skill/main/bootstrap.sh | bash
#
#  Installs the pack into the editor / CLI you choose — Claude Code,
#  Codex CLI, Gemini CLI, or Antigravity (or all of them). Skills live
#  in the universal ~/.agents/skills (every tool reads it); each tool
#  also gets its own instructions file. Everything self-updates daily.
#
#  Non-interactive override:  CLAUDE_SKILL_TARGETS="claude,codex" bash install.sh
# ================================================================
set -uo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
info()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn()   { echo -e "${YELLOW}[!]${NC} $1"; }
err()    { echo -e "${RED}[✗]${NC} $1"; }
header() { echo -e "\n${BOLD}${GREEN}━━ $1 ━━${NC}"; }
has()    { command -v "$1" >/dev/null 2>&1; }
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GRAPHIFY_GIT="git+https://github.com/safishamsi/graphify.git@v8"

echo -e "${BOLD}${GREEN}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║   Claude Skill Pack — Multi-IDE Installer    ║"
echo "  ║   github.com/black12-ag/claude-skill         ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# ── Detect which tools are present ────────────────────────────
det() { has "$1" && echo "on" || echo "off"; }
D_CLAUDE=$(det claude); D_CODEX=$(det codex); D_GEMINI=$(det gemini)
if has agy || [ -d "$HOME/.gemini/antigravity" ] || [ -d "$HOME/.antigravity" ]; then D_AGY="on"; else D_AGY="off"; fi

# ── Choose install targets (works under curl|bash via /dev/tty) ─
header "Where should the skills go?"
echo -e "  ${DIM}Detected:${NC}  Claude Code[$D_CLAUDE]  Codex[$D_CODEX]  Gemini CLI[$D_GEMINI]  Antigravity[$D_AGY]"
echo ""
echo "    1) Claude Code   — plugins + skills + graphify + CLAUDE.md"
echo "    2) Codex CLI     — skills + graphify + AGENTS.md"
echo "    3) Gemini CLI    — skills + graphify + GEMINI.md"
echo "    4) Antigravity   — skills + graphify"
echo "    5) All of them   (recommended)"
echo ""

CHOICE="${CLAUDE_SKILL_TARGETS:-}"
if [ -z "$CHOICE" ] && [ -r /dev/tty ]; then
  printf "  Pick one or more (e.g. \"1 3\") or 5 for all [5]: "
  read -r CHOICE < /dev/tty || CHOICE=""
fi
CHOICE="${CHOICE:-5}"

TARGETS=""
if echo "$CHOICE" | grep -qiE '(^|[^0-9])5([^0-9]|$)|all'; then
  TARGETS="claude codex gemini antigravity"
else
  echo "$CHOICE" | grep -qiE '(^|[^0-9])1([^0-9]|$)|claude'      && TARGETS="$TARGETS claude"
  echo "$CHOICE" | grep -qiE '(^|[^0-9])2([^0-9]|$)|codex'       && TARGETS="$TARGETS codex"
  echo "$CHOICE" | grep -qiE '(^|[^0-9])3([^0-9]|$)|gemini'      && TARGETS="$TARGETS gemini"
  echo "$CHOICE" | grep -qiE '(^|[^0-9])4([^0-9]|$)|antigravity|agy' && TARGETS="$TARGETS antigravity"
fi
TARGETS="$(echo "$TARGETS" | xargs)"
[ -z "$TARGETS" ] && TARGETS="claude codex gemini antigravity"
info "Installing for: ${BOLD}$TARGETS${NC}"

# ── Choose which skills/plugins (simple — default is everything) ─
# The 128 shared skills are always copied (tiny text files). This picks the
# heavier Claude Code plugins. Override non-interactively with CLAUDE_SKILL_PACKS.
ALL_PLUGINS="superpowers@claude-plugins-official frontend-design@claude-plugins-official context7@claude-plugins-official code-review@claude-plugins-official security-guidance@claude-plugins-official supabase@claude-plugins-official plugin-dev@claude-plugins-official playground@claude-plugins-official claude-code-setup@claude-plugins-official coderabbit@claude-plugins-official swift-lsp@claude-plugins-official vercel@claude-plugins-official claude-mem@thedotmack superpowers@superpowers-dev impeccable@impeccable taste-skill@taste-skill ruflo-core@ruflo ruflo-goals@ruflo ruflo-sparc@ruflo ruflo-swarm@ruflo"
PLUGINS_TO_INSTALL="$ALL_PLUGINS"
if echo "$TARGETS" | grep -q claude; then
  header "Which skills?"
  echo "    1) Everything          — all 20 plugins + 128 skills   (recommended)"
  echo "    2) Design & UI         — frontend-design, impeccable, taste-skill"
  echo "    3) Coding              — superpowers, plugin-dev, context7, swift-lsp"
  echo "    4) Review & Security   — code-review, coderabbit, security-guidance"
  echo "    5) Agents & Memory     — ruflo suite, claude-mem, superpowers-dev"
  echo "    6) Data & Deploy       — supabase, vercel"
  echo -e "    ${DIM}(all 128 skills are always included; this picks the plugins)${NC}"
  echo ""
  PACKS="${CLAUDE_SKILL_PACKS:-}"
  if [ -z "$PACKS" ] && [ -r /dev/tty ]; then
    printf "  Numbers (e.g. \"2 3\") or 1 for everything [1]: "
    read -r PACKS < /dev/tty || PACKS=""
  fi
  PACKS="${PACKS:-1}"
  if echo "$PACKS" | grep -qiE '(^|[^0-9])1([^0-9]|$)|all|every'; then
    PLUGINS_TO_INSTALL="$ALL_PLUGINS"
  else
    PLUGINS_TO_INSTALL="playground@claude-plugins-official claude-code-setup@claude-plugins-official"  # base
    echo "$PACKS" | grep -q 2 && PLUGINS_TO_INSTALL="$PLUGINS_TO_INSTALL frontend-design@claude-plugins-official impeccable@impeccable taste-skill@taste-skill"
    echo "$PACKS" | grep -q 3 && PLUGINS_TO_INSTALL="$PLUGINS_TO_INSTALL superpowers@claude-plugins-official plugin-dev@claude-plugins-official context7@claude-plugins-official swift-lsp@claude-plugins-official"
    echo "$PACKS" | grep -q 4 && PLUGINS_TO_INSTALL="$PLUGINS_TO_INSTALL code-review@claude-plugins-official coderabbit@claude-plugins-official security-guidance@claude-plugins-official"
    echo "$PACKS" | grep -q 5 && PLUGINS_TO_INSTALL="$PLUGINS_TO_INSTALL ruflo-core@ruflo ruflo-goals@ruflo ruflo-sparc@ruflo ruflo-swarm@ruflo claude-mem@thedotmack superpowers@superpowers-dev"
    echo "$PACKS" | grep -q 6 && PLUGINS_TO_INSTALL="$PLUGINS_TO_INSTALL supabase@claude-plugins-official vercel@claude-plugins-official"
  fi
  PLUGINS_TO_INSTALL="$(echo "$PLUGINS_TO_INSTALL" | xargs)"
  info "Plugins: $(echo "$PLUGINS_TO_INSTALL" | wc -w | tr -d ' ') selected"
fi

# ── Shared helpers ────────────────────────────────────────────

# Universal skills dir — read by Claude Code, Codex, Gemini CLI, Antigravity, Copilot.
sync_agent_skills() {
  [ -d "$SCRIPT_DIR/agent-skills" ] || { warn "no agent-skills/ in pack"; return; }
  mkdir -p "$HOME/.agents/skills"
  cp -R "$SCRIPT_DIR/agent-skills/." "$HOME/.agents/skills/"
  info "  Skills → ~/.agents/skills ($(ls "$SCRIPT_DIR/agent-skills" | wc -l | tr -d ' ') skills, read by all tools)"
}

# Append a managed block to a tool's instructions file (idempotent, backs up first).
write_instructions() {
  local file="$1" src="$SCRIPT_DIR/CLAUDE.md"
  [ -f "$src" ] || return 0
  mkdir -p "$(dirname "$file")"
  if [ -f "$file" ]; then
    cp "$file" "$file.bak" 2>/dev/null
    awk '/^# >>> claude-skill-pack >>>/{skip=1} !skip; /^# <<< claude-skill-pack <<</{skip=0}' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
  fi
  { echo ""; echo "# >>> claude-skill-pack >>>"; cat "$src"; echo "# <<< claude-skill-pack <<<"; } >> "$file"
  info "  Instructions → $file"
}

# graphify: a uv tool (CLI + MCP) usable from every editor. Install once.
GRAPHIFY_DONE=0
install_graphify() {
  [ "$GRAPHIFY_DONE" = "1" ] && return; GRAPHIFY_DONE=1
  if has uv; then
    info "  Installing graphify (from git)..."
    # /usr/bin first so uv's git clone uses system git, not a broken shim git.
    if PATH="/usr/bin:$HOME/.local/bin:$PATH" uv tool install --force "graphifyy @ $GRAPHIFY_GIT" >/dev/null 2>&1; then
      has graphify && PATH="/usr/bin:$HOME/.local/bin:$PATH" graphify install >/dev/null 2>&1
      info "  graphify ready"
    else
      warn "  graphify install failed (continuing)"
    fi
  else
    warn "  uv not found — skipping graphify. Install: curl -LsSf https://astral.sh/uv/install.sh | sh"
  fi
}

# ── Target: Claude Code (full — plugins + skills + graphify) ───
install_claude_code() {
  header "Claude Code"
  if ! has claude; then
    if has npm; then warn "claude not found — installing via npm"; npm install -g @anthropic-ai/claude-code >/dev/null 2>&1 || warn "npm install failed"
    else warn "claude + npm missing — install Node.js then re-run"; fi
  fi
  if has claude; then
    claude auth status >/dev/null 2>&1 || { warn "Not logged in — opening login"; claude login </dev/tty || warn "run 'claude login' manually"; }

    info "Adding marketplaces..."
    add_mp() { claude plugin marketplace list 2>/dev/null | grep -q "$1" || claude plugin marketplace add "$2" >/dev/null 2>&1 || warn "  add $1 failed"; }
    add_mp thedotmack      "thedotmack/claude-mem"
    add_mp superpowers-dev "obra/superpowers"
    add_mp career-ops      "santifer/career-ops"
    add_mp cwb-plugins     "Code-with-Beto/skills"
    add_mp impeccable      "pbakaus/impeccable"
    add_mp taste-skill     "Leonxlnx/taste-skill"
    add_mp ruflo           "ruvnet/ruflo"
    claude plugin marketplace update >/dev/null 2>&1 || true

    info "Installing $(echo "$PLUGINS_TO_INSTALL" | wc -w | tr -d ' ') plugins..."
    inst() { claude plugin list 2>/dev/null | grep -q "${1%%@*}" || { claude plugin install "$1" >/dev/null 2>&1 && echo "    ✓ $1"; } || warn "    failed: $1"; }
    for p in $PLUGINS_TO_INSTALL; do inst "$p"; done
  fi

  # custom flat-file skills are Claude-Code-specific → ~/.claude/skills
  mkdir -p "$HOME/.claude/skills"
  [ -d "$SCRIPT_DIR/claude-skills" ] && cp -R "$SCRIPT_DIR/claude-skills/." "$HOME/.claude/skills/" && \
    info "  Custom skills → ~/.claude/skills ($(ls "$SCRIPT_DIR/claude-skills"|wc -l|tr -d ' '))"
  sync_agent_skills
  write_instructions "$HOME/CLAUDE.md"
  # settings template (never clobber existing)
  if [ -f "$HOME/.claude/settings.json" ]; then
    cp "$SCRIPT_DIR/settings-template.json" "$HOME/.claude/settings-template.json" 2>/dev/null
  else
    cp "$SCRIPT_DIR/settings-template.json" "$HOME/.claude/settings.json" 2>/dev/null && info "  settings.json created"
  fi
  install_graphify
}

# ── Target: Codex CLI ─────────────────────────────────────────
install_codex() {
  header "Codex CLI"
  has codex || warn "codex not detected — installing skills anyway (Codex reads ~/.agents/skills)"
  sync_agent_skills
  write_instructions "$HOME/.codex/AGENTS.md"
  install_graphify
}

# ── Target: Gemini CLI ────────────────────────────────────────
install_gemini() {
  header "Gemini CLI"
  has gemini || warn "gemini not detected — installing skills anyway (Gemini reads ~/.agents/skills)"
  sync_agent_skills
  write_instructions "$HOME/.gemini/GEMINI.md"
  install_graphify
}

# ── Target: Antigravity ───────────────────────────────────────
install_antigravity() {
  header "Antigravity"
  sync_agent_skills            # Antigravity surfaces skills from ~/.agents/skills
  write_instructions "$HOME/.gemini/GEMINI.md"   # Antigravity (Gemini-based) shares GEMINI.md
  install_graphify
}

# ── Run chosen targets ────────────────────────────────────────
for t in $TARGETS; do
  case "$t" in
    claude)      install_claude_code ;;
    codex)       install_codex ;;
    gemini)      install_gemini ;;
    antigravity) install_antigravity ;;
  esac
done

# ── Auto-update (self-updating, no manual work) ───────────────
header "Auto-Update"
chmod +x "$SCRIPT_DIR/update.sh" 2>/dev/null
if [ "$(uname)" = "Darwin" ]; then
  PLIST="$HOME/Library/LaunchAgents/com.claude-skill.update.plist"
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$PLIST" <<PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.claude-skill.update</string>
  <key>ProgramArguments</key>
  <array><string>/bin/bash</string><string>$SCRIPT_DIR/update.sh</string></array>
  <key>StartCalendarInterval</key>
  <dict><key>Hour</key><integer>10</integer><key>Minute</key><integer>0</integer></dict>
  <key>StandardOutPath</key><string>$SCRIPT_DIR/update.log</string>
  <key>StandardErrorPath</key><string>$SCRIPT_DIR/update.log</string>
</dict>
</plist>
PLISTEOF
  launchctl unload "$PLIST" 2>/dev/null || true
  launchctl load "$PLIST" 2>/dev/null && info "Auto-update ON — daily @ 10:00 (disable: launchctl unload $PLIST)" || warn "load failed: launchctl load $PLIST"
else
  LINE="0 10 * * * /bin/bash $SCRIPT_DIR/update.sh >> $SCRIPT_DIR/update.log 2>&1"
  ( crontab -l 2>/dev/null | grep -v 'claude-skill.*update.sh'; echo "$LINE" ) | crontab - 2>/dev/null \
    && info "Auto-update ON via cron — daily @ 10:00" || warn "Run manually: bash $SCRIPT_DIR/update.sh"
fi

# ── Done ──────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║  ✓ Done! Restart your editor to load everything. ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo "  Installed for: $TARGETS"
echo "  Skills live in ~/.agents/skills (shared by every tool)."
echo "  Self-updates daily — or run now: bash $SCRIPT_DIR/update.sh"
echo ""
