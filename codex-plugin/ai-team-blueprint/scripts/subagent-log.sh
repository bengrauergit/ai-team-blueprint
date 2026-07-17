#!/bin/sh
# Codex SubagentStop hook. Logs real agent runs in plugin-owned writable data.
PAYLOAD=$(cat)
LOG="${PLUGIN_DATA:-${TMPDIR:-/tmp}}/agent-usage.jsonl"
export PAYLOAD LOG
python3 -c '
import datetime, json, os
try:
    data = json.loads(os.environ.get("PAYLOAD", "") or "{}")
except Exception:
    raise SystemExit(0)
if not data.get("agent_type"):
    raise SystemExit(0)
keep = {key: value for key, value in data.items()
        if isinstance(value, (str, int, float, bool)) and len(str(value)) < 300}
keep["ts"] = datetime.datetime.now().astimezone().isoformat(timespec="seconds")
os.makedirs(os.path.dirname(os.environ["LOG"]), exist_ok=True)
with open(os.environ["LOG"], "a", encoding="utf-8") as handle:
    handle.write(json.dumps(keep, ensure_ascii=False) + "\n")
' 2>/dev/null
exit 0
