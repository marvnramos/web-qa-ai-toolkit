#!/usr/bin/env bash
# Copy the agents into a target repo's .claude/agents/ (or ~/.claude/agents with --user).
# Never overwrites an existing file.
#   bash scripts/install.sh [TARGET_DIR | --user]
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${1:-}" == "--user" ]]; then
  DEST="$HOME/.claude/agents"
else
  DEST="$(cd "${1:-.}" && pwd)/.claude/agents"
fi
mkdir -p "$DEST"

for src in "$HERE"/agents/*.md; do
  name="$(basename "$src")"
  if [[ -e "$DEST/$name" ]]; then
    echo "skip   $DEST/$name (exists)"
  else
    cp "$src" "$DEST/$name"
    echo "added  $DEST/$name"
  fi
done

if [[ "${1:-}" != "--user" ]]; then
  root="$(dirname "$(dirname "$DEST")")"
  [[ -f "$root/.qa/config.yml" ]] || echo "note   no .qa/config.yml in $root (your qa-* skills may read it)"
  [[ -f "$root/.qa/test-plan.md" ]] || echo "note   no .qa/test-plan.md in $root (briefs usually name its sections)"
fi
