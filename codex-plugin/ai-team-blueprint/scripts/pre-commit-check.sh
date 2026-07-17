#!/bin/sh
# Codex PreToolUse hook. When a shell command attempts `git commit`, run the
# project's opt-in fast gate at .codex/fast-check.sh. CI remains the backstop.
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("tool_input",{}).get("command",""))
except Exception: print("")' 2>/dev/null)

case "$CMD" in
  *"git commit"*)
    CWD=$(printf '%s' "$INPUT" | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("cwd", "."))
except Exception: print(".")' 2>/dev/null)
    ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null || printf '%s' "$CWD")
    CHECK="$ROOT/.codex/fast-check.sh"
    if [ ! -x "$CHECK" ]; then
      printf '%s\n' '{"systemMessage":"AI Team Blueprint: .codex/fast-check.sh is missing or not executable; the local commit gate was skipped. CI must backstop this check."}'
      exit 0
    fi
    if ! OUT=$(cd "$ROOT" && "$CHECK" 2>&1); then
      ERRS=$(printf '%s' "$OUT" | tail -8 | tr '"' "'" | tr '\n' ' ')
      printf '{"decision":"block","reason":"Fast commit gate failed: %s"}\n' "$ERRS"
    fi
    ;;
esac
exit 0
