#!/usr/bin/env bash
# ================================================================
#  One-liner bootstrap — run on any new Mac:
#
#  curl -fsSL https://raw.githubusercontent.com/black12-ag/claude-skill/main/bootstrap.sh | bash
# ================================================================
set -e

GREEN='\033[0;32m'; BOLD='\033[1m'; NC='\033[0m'
info() { echo -e "${GREEN}[✓]${NC} $1"; }

echo -e "${BOLD}Claude Code Bootstrap${NC} — cloning black12-ag/claude-skill..."

INSTALL_DIR="$HOME/.claude-skill-setup"
REPO="https://github.com/black12-ag/claude-skill.git"

# Remove previous clone if exists
rm -rf "$INSTALL_DIR"

# Clone the repo
git clone --depth 1 "$REPO" "$INSTALL_DIR"
info "Repo cloned to $INSTALL_DIR"

# Run the installer
chmod +x "$INSTALL_DIR/install.sh"
bash "$INSTALL_DIR/install.sh"
