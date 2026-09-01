#!/usr/bin/env bash
# uninstall.sh - remove the profile router and optionally the submodule entry
set -euo pipefail

PROFILE="${1:-}"
SUBMODULE_PATH="${SUBMODULE_PATH:-.ai/profiles}"
ROUTER_NAME="${ROUTER_NAME:-AGENTS.md}"
REMOVE_SUBMODULE="${REMOVE_SUBMODULE:-0}"

if [[ -z "$PROFILE" ]]; then
    echo "Usage: ./uninstall.sh <profile-name> [REMOVE_SUBMODULE=1]" >&2
    exit 1
fi

ROUTER_PATH="$ROUTER_NAME"

if [[ -f "$ROUTER_PATH" ]]; then
    if grep -q '# AI Assistant Router' "$ROUTER_PATH"; then
        rm -f "$ROUTER_PATH"
        echo "Removed $ROUTER_PATH"
    else
        echo "Skipped $ROUTER_PATH - not a router we wrote."
    fi
else
    echo "No router at $ROUTER_PATH; nothing to remove."
fi

if [[ "$REMOVE_SUBMODULE" == "1" ]]; then
    if [[ -f ".gitmodules" ]]; then
        git submodule deinit -f "$SUBMODULE_PATH"
        git rm -f "$SUBMODULE_PATH" || true
        rm -rf ".git/modules/$SUBMODULE_PATH"
        echo "Removed submodule entry for $SUBMODULE_PATH"
    fi
fi