#!/bin/sh
# Claude Code PreToolUse hook (matcher: Bash), registered in .claude/settings.json.
# When the command about to run is a `git commit`, run your check command first
# and BLOCK the commit if it fails. All other Bash commands pass through.
#
# ADAPT: set CHECK_CMD to your project's fast gate (typecheck, lint, quick
# tests). Keep it under ~30s; slow gates belong in CI, not here.
#
# Hardening notes (each of these bit us):
# - The hook environment is NOT your interactive shell: cd explicitly, call
#   binaries by path, don't rely on npx/PATH resolution.
# - Capture stdin BEFORE any heredoc; `python3 -` takes its program from
#   stdin and will silently eat your payload.
# - This hook fails OPEN if the check binary is missing (fresh container
#   before install) because CI backstops the same check. If you have no CI,
#   flip it to fail closed.
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("tool_input",{}).get("command",""))
except Exception: print("")' 2>/dev/null)

case "$CMD" in
  *"git commit"*)
    cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
    CHECK="./node_modules/.bin/tsc"          # ADAPT: your check binary
    CHECK_ARGS="--noEmit"                    # ADAPT: its arguments
    if [ ! -x "$CHECK" ]; then
      printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"pre-commit-check: check binary not found; SKIPPED (CI is the backstop)."}}\n'
      exit 0
    fi
    if ! OUT=$("$CHECK" $CHECK_ARGS 2>&1); then
      ERRS=$(printf '%s' "$OUT" | tail -8 | tr '"' "'" | tr '\n' ' ')
      printf '{"decision":"block","reason":"pre-commit check failed. Fix before committing: %s"}\n' "$ERRS"
    fi
    ;;
esac
exit 0
