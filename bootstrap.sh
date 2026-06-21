#!/usr/bin/env bash
# ================================================================
#  One-liner bootstrap — run on any Mac:
#
#  curl -fsSL https://raw.githubusercontent.com/black12-ag/claude-skill/main/bootstrap.sh | bash
#
#  Fetches the pack, then hands off to the interactive installer
#  (which asks WHICH tool and WHICH skills you want).
# ================================================================
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'
info() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

echo -e "${BOLD}Claude Skill Pack${NC} — fetching black12-ag/claude-skill..."

INSTALL_DIR="$HOME/.claude-skill-setup"
REPO="https://github.com/black12-ag/claude-skill.git"
TARBALL="https://github.com/black12-ag/claude-skill/archive/refs/heads/main.tar.gz"

rm -rf "$INSTALL_DIR"

# Pick a git that can actually clone. Some shells shadow `git` with a shim that
# lacks the https remote helper ("git: 'remote-https' is not a git command").
# Prefer real binaries; PATH git last. If none can clone, fall back to a tarball.
GIT=""
for cand in /usr/bin/git /opt/homebrew/bin/git /usr/local/bin/git "$(command -v git 2>/dev/null)"; do
  [ -n "$cand" ] && [ -x "$cand" ] && { GIT="$cand"; break; }
done

fetched=0
if [ -n "$GIT" ] && "$GIT" clone --depth 1 "$REPO" "$INSTALL_DIR" 2>/dev/null; then
  fetched=1
  info "Cloned to $INSTALL_DIR (git: $GIT)"
fi

if [ "$fetched" != "1" ]; then
  warn "git clone unavailable — downloading tarball instead"
  mkdir -p "$INSTALL_DIR"
  if curl -fsSL "$TARBALL" | tar -xz -C "$INSTALL_DIR" --strip-components=1 2>/dev/null; then
    fetched=1
    info "Downloaded to $INSTALL_DIR"
  fi
fi

[ "$fetched" = "1" ] || { err "Could not fetch the pack. Check your internet connection and try again."; exit 1; }

# Run the interactive installer (reads your choices from the terminal).
chmod +x "$INSTALL_DIR/install.sh"
bash "$INSTALL_DIR/install.sh"
