#!/usr/bin/env bash
# sync-claude-mirror.sh - copy agents/ and skills/ into .claude/ (full tree)
set -euo pipefail

PROFILE="${1:-}"
PROFILE_ROOT="${PROFILE_ROOT:-!profiles}"

if [[ -z "$PROFILE" ]]; then
    echo "Usage: ./sync-claude-mirror.sh <profile-name>" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$REPO_ROOT/$PROFILE_ROOT/$PROFILE"

if [[ ! -d "$PROFILE_DIR" ]]; then
    echo "Profile '$PROFILE' not found at $PROFILE_DIR" >&2
    exit 1
fi

CLAUDE_AGENTS="$PROFILE_DIR/.claude/agents"
CLAUDE_SKILLS="$PROFILE_DIR/.claude/skills"
CANON_AGENTS="$PROFILE_DIR/agents"
CANON_SKILLS="$PROFILE_DIR/skills"

mkdir -p "$CLAUDE_AGENTS"
if [[ -d "$CANON_AGENTS" ]]; then
    for f in "$CANON_AGENTS"/*.md; do
        [[ -e "$f" ]] || continue
        cp -f "$f" "$CLAUDE_AGENTS/$(basename "$f")"
        echo "mirrored agent: $(basename "$f")"
    done
fi

mkdir -p "$CLAUDE_SKILLS"
if [[ -d "$CANON_SKILLS" ]]; then
    for d in "$CANON_SKILLS"/*/; do
        [[ -d "$d" ]] || continue
        name="$(basename "$d")"
        target="$CLAUDE_SKILLS/$name"
        rm -rf "$target"
        cp -r "$d" "$target"
        count="$(find "$target" -type f | wc -l)"
        echo "mirrored skill: $name/ ($count files)"
    done
fi

echo "Done."