#!/bin/sh
# Gemini CLI AfterAgent hook, registered in .gemini/settings.json.
# Appends one JSONL line per subagent run to docs/agents/usage-log.jsonl.
#
# WHY: agent rosters grow on vibes and never shrink. This log is the cheap
# observability primitive that lets a retro decide, on evidence, which agent
# seats actually earn their place. Collect ~2 weeks before acting on it.
#
# UNVERIFIED, confirm against your installed Gemini CLI version: this script
# assumes the AfterAgent payload carries an agent-name field analogous to
# Claude Code's SubagentStop `agent_type` field. The exact field name on
# Gemini's AfterAgent payload has not been confirmed in this port -- if the
# script below logs nothing, read the raw payload (temporarily `cat` it to a
# scratch file instead of parsing) and fix the field name.
#
# CAUTION (learned in production, on the Claude Code version of this hook):
# if multiple parallel sessions COMMIT this file to a shared branch, their
# pushes race. Fix: add a .gitattributes line
#   docs/agents/usage-log.jsonl merge=union
# (append-only JSONL, line order irrelevant), or keep the log local-only and
# roll it up daily from one stream. Defensive: never blocks anything.
PAYLOAD=$(cat)
LOG="${GEMINI_PROJECT_DIR:-.}/docs/agents/usage-log.jsonl"
export PAYLOAD LOG
python3 -c '
import json, os, datetime
try:
    d = json.loads(os.environ.get("PAYLOAD", "") or "{}")
except Exception:
    d = {}
keep = {k: v for k, v in d.items()
        if isinstance(v, (str, int, float, bool)) and len(str(v)) < 300}
# Only log REAL team agents: harness-internal helpers may fire AfterAgent with
# a blank or missing agent-name field and inflate roster metrics. Field name
# below (agent_type) is UNVERIFIED for Gemini -- see the header comment.
if not keep.get("agent_type"):
    raise SystemExit(0)
keep["ts"] = datetime.datetime.now().astimezone().isoformat(timespec="seconds")
os.makedirs(os.path.dirname(os.environ["LOG"]), exist_ok=True)
with open(os.environ["LOG"], "a") as f:
    f.write(json.dumps(keep, ensure_ascii=False) + "\n")
' 2>/dev/null
exit 0
