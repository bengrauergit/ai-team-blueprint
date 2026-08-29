#!/bin/sh
# Gemini CLI BeforeTool hook, registered in .gemini/settings.json.
# When the command about to run is a `git commit`, run your check command
# first and DENY the tool call if it fails. All other shell commands pass
# through.
#
# ADAPT: set CHECK/CHECK_ARGS to your project's fast gate (typecheck, lint,
# quick tests). Keep it under ~30s; slow gates belong in CI, not here.
#
# UNVERIFIED, confirm against your installed Gemini CLI version before relying
# on this hook (ported from Claude Code's equivalent script; the two platforms
# are NOT guaranteed to share these details):
#   1. The exact field path for the shell command inside the BeforeTool JSON
#      payload on stdin. This script assumes `tool_input.command`, matching
#      Claude Code's shape; Gemini's may differ.
#   2. The env var exposing the project root to hook subprocesses. This
#      script assumes $GEMINI_PROJECT_DIR (by analogy with Claude Code's
#      $CLAUDE_PROJECT_DIR); confirm the real name and fix the fallback below.
#   3. The exact decision keyword Gemini expects for a deny. Documented as
#      "deny" (NOT Claude's "block"); verify before trusting this in
#      production.
#
# Hardening notes (carried over from the Claude Code version, still apply):
# - The hook environment is NOT your interactive shell: cd explicitly, call
#   binaries by path, don't rely on npx/PATH resolution.
# - Capture stdin BEFORE any heredoc; `python3 -` takes its program from
#   stdin and will silently eat your payload.
# - This hook fails OPEN if the check binary is missing (fresh container
#   before install) because CI backstops the same check. If you have no CI,
#   flip it to fail closed.
# - Print ONLY the final JSON decision to stdout; route any diagnostic or log
#   text to stderr instead, or Gemini's JSON parser will choke on it.
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("tool_input",{}).get("command",""))
except Exception: print("")' 2>/dev/null)

case "$CMD" in
  *"git commit"*)
    cd "${GEMINI_PROJECT_DIR:-.}" || exit 0
    CHECK="./node_modules/.bin/tsc"          # ADAPT: your check binary
    CHECK_ARGS="--noEmit"                    # ADAPT: its arguments
    if [ ! -x "$CHECK" ]; then
      printf '{"decision":"allow","reason":"pre-commit-check: check binary not found; SKIPPED (CI is the backstop)."}\n'
      exit 0
    fi
    if ! OUT=$("$CHECK" $CHECK_ARGS 2>&1); then
      ERRS=$(printf '%s' "$OUT" | tail -8 | tr '"' "'" | tr '\n' ' ')
      printf '{"decision":"deny","reason":"pre-commit check failed. Fix before committing: %s"}\n' "$ERRS"
      exit 0
    fi
    ;;
esac
exit 0
