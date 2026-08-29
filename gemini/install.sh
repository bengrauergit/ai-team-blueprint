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
  for path in GEMINI.md BACKLOG.md .gemini/agents docs/agents/context.md; do
    if [ -e "$TARGET/$path" ]; then
      printf 'Refusing to overwrite %s. Merge manually or rerun with --force.\n' "$TARGET/$path" >&2
      exit 1
    fi
  done
fi

cp -R "$TEMPLATE"/. "$TARGET"/
printf 'Installed the Gemini CLI project template into %s\n' "$TARGET"
printf '%s\n' 'Next: adapt docs/agents/context.md, scripts/hooks/pre-commit-check.sh, CI, and the data-steward role.'
printf '%s\n' 'Also confirm two unverified details against your installed Gemini CLI version before relying on the hooks:'
printf '%s\n' '  1. The BeforeTool matcher in .gemini/settings.json assumes a shell-tool name; confirm it against your CLI.'
printf '%s\n' '  2. The project-root env var the hook scripts read; confirm it is actually exported to hook subprocesses.'
