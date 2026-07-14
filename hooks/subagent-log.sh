#!/bin/sh
# Claude Code SubagentStop hook, registered in .claude/settings.json.
# Appends one JSONL line per subagent run to docs/agents/usage-log.jsonl.
#
# WHY: agent rosters grow on vibes and never shrink. This log is the cheap
# observability primitive that lets a retro decide, on evidence, which agent
# seats actually earn their place. Collect ~2 weeks before acting on it.
#
# CAUTION (learned in production): if multiple parallel sessions COMMIT this
# file to a shared branch, their pushes race. Let the log accumulate locally
# and commit it with the day's work from ONE stream, or gitignore it and
# aggregate another way. Defensive: never blocks anything.
PAYLOAD=$(cat)
LOG="${CLAUDE_PROJECT_DIR:-.}/docs/agents/usage-log.jsonl"
export PAYLOAD LOG
python3 -c '
import json, os, datetime
try:
    d = json.loads(os.environ.get("PAYLOAD", "") or "{}")
except Exception:
    d = {}
keep = {k: v for k, v in d.items()
        if isinstance(v, (str, int, float, bool)) and len(str(v)) < 300}
keep["ts"] = datetime.datetime.now().astimezone().isoformat(timespec="seconds")
os.makedirs(os.path.dirname(os.environ["LOG"]), exist_ok=True)
with open(os.environ["LOG"], "a") as f:
    f.write(json.dumps(keep, ensure_ascii=False) + "\n")
' 2>/dev/null
exit 0
