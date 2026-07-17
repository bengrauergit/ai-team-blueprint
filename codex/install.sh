#!/bin/sh
set -eu

FORCE=0
if [ "${1:-}" = "--force" ]; then
  FORCE=1
  shift
fi

TARGET=${1:-.}
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TEMPLATE="$SCRIPT_DIR/project-template"

if [ ! -d "$TARGET" ]; then
  printf 'Target directory does not exist: %s\n' "$TARGET" >&2
  exit 1
fi

if [ "$FORCE" -ne 1 ]; then
  for path in AGENTS.md BACKLOG.md .codex/agents docs/agents/context.md; do
    if [ -e "$TARGET/$path" ]; then
      printf 'Refusing to overwrite %s. Merge manually or rerun with --force.\n' "$TARGET/$path" >&2
      exit 1
    fi
  done
fi

cp -R "$TEMPLATE"/. "$TARGET"/
printf 'Installed the Codex project template into %s\n' "$TARGET"
printf '%s\n' 'Next: adapt docs/agents/context.md, .codex/fast-check.sh, CI, and the data-steward role.'
