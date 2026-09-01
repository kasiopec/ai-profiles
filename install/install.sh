#!/usr/bin/env bash
# install.sh - drop a profile router into the consumer's project root
set -euo pipefail

PROFILE="${1:-}"
SUBMODULE_PATH="${SUBMODULE_PATH:-.ai/profiles}"
ROUTER_NAME="${ROUTER_NAME:-AGENTS.md}"

if [[ -z "$PROFILE" ]]; then
    echo "Usage: ./install.sh <profile-name>" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$REPO_ROOT/!profiles/$PROFILE"

if [[ ! -d "$PROFILE_DIR" ]]; then
    echo "Profile '$PROFILE' not found at $PROFILE_DIR" >&2
    exit 1
fi

CONSUMER_ROOT="$(pwd)"
SUBMODULE_FULL="$CONSUMER_ROOT/$SUBMODULE_PATH"

if [[ ! -f "$SUBMODULE_FULL/!profiles/$PROFILE/AGENTS.md" ]]; then
    echo "Expected profile not visible at $SUBMODULE_FULL/!profiles/$PROFILE/AGENTS.md" >&2
    echo "Did you run 'git submodule update --init --recursive' ?" >&2
    exit 1
fi

ROUTER_PATH="$CONSUMER_ROOT/$ROUTER_NAME"
RELATIVE_PROFILE="$SUBMODULE_PATH/!profiles/$PROFILE/AGENTS.md"

cat > "$ROUTER_PATH" <<EOF
# AI Assistant Router

This project uses the AI profiles submodule. All conventions, agents, and skills
live in \`$RELATIVE_PROFILE\`. Do not duplicate them here.

Full Android profile entry point: \`$RELATIVE_PROFILE\`
EOF

echo "Wrote $ROUTER_PATH -> $RELATIVE_PROFILE"