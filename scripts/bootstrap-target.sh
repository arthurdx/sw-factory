#!/usr/bin/env bash
# Copy the factory template (and optional per-project overlay) into a target repo working tree.
# Does NOT commit or push. Existing files are skipped unless --force is given.
#
# Usage: scripts/bootstrap-target.sh <target-dir> [--profile <name>] [--force]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET=""; PROFILE=""; FORCE=0

while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE="${2:?--profile needs a name}"; shift 2 ;;
    --force)   FORCE=1; shift ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    -*)        echo "unknown option: $1" >&2; exit 2 ;;
    *)         TARGET="$1"; shift ;;
  esac
done

[ -n "$TARGET" ] || { echo "usage: $0 <target-dir> [--profile <name>] [--force]" >&2; exit 2; }
[ -d "$TARGET/.git" ] || { echo "error: $TARGET is not a git working tree" >&2; exit 1; }
if [ -n "$PROFILE" ] && [ ! -d "$ROOT/targets/$PROFILE" ]; then
  echo "error: no overlay at targets/$PROFILE" >&2; exit 1
fi

copy_tree() {  # copy_tree <src-dir> ; preserves relative paths under $TARGET
  local src="$1" f rel dest
  while IFS= read -r -d '' f; do
    rel="${f#"$src"/}"; dest="$TARGET/$rel"
    if [ -e "$dest" ] && [ "$FORCE" -ne 1 ]; then
      echo "skip   $rel (exists)"
    else
      mkdir -p "$(dirname "$dest")"; cp "$f" "$dest"; echo "copy   $rel"
    fi
  done < <(find "$src" -type f -print0)
}

copy_tree "$ROOT/template"
[ -n "$PROFILE" ] && copy_tree "$ROOT/targets/$PROFILE"

# Point the project's AGENTS.md at the factory rules (idempotent).
if [ -f "$TARGET/AGENTS.md" ]; then
  if ! grep -q 'AGENTS.factory.md' "$TARGET/AGENTS.md"; then
    printf '\n## Factory workflow\n\nIssue/PR workflow, hard limits and definition of done: see `AGENTS.factory.md`. Both files apply.\n' >> "$TARGET/AGENTS.md"
    echo "append AGENTS.md -> pointer to AGENTS.factory.md"
  fi
else
  echo "note: $TARGET/AGENTS.md missing; create one with build/test commands"
fi

echo "done. review with: git -C '$TARGET' status && git -C '$TARGET' diff"
