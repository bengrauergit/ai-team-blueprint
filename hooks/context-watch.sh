#!/usr/bin/env sh
# UserPromptSubmit hook: estimate how full the context window is and, above a
# threshold, inject a directive telling the model to STOP and put an explicit
# choice to the user: keep going, or checkpoint + hand over to a fresh session.
#
# Why this shape: sessions degrade well before they die. Auto-compaction is a
# lossy summarization pass that happens silently at the worst moment (when
# context is already bloated); by then quality has been sliding for a while.
# The hook is the mechanical half (measure, compare, warn); presenting the
# choice and authoring the handover is judgment, which belongs to the model
# (see skills/session-handover). The DECISION belongs to the user: a hook that
# silently resets a session would throw away live state nobody reviewed.
#
# How it measures: every hook receives a JSON payload on stdin that includes
# transcript_path, the session's JSONL log. Each assistant message entry
# carries a usage block; input_tokens + cache_read_input_tokens +
# cache_creation_input_tokens of the LATEST one approximates current context
# occupancy. This is an estimate, not an API reading, but it is a measured
# estimate, better than the model guessing from vibes.
#
# UNVERIFIED against your Claude Code version; confirm before trusting:
#   - the payload field is `transcript_path` and the usage fields sit at
#     .message.usage in transcript entries (dump stdin + one transcript line
#     to a scratch file once and look);
#   - UserPromptSubmit stdout is injected as context (documented behaviour,
#     but verify the warning actually appears: ask the model "what did the
#     context-watch hook just tell you?").
#
# Fail-open on every uncertainty (missing python3, unreadable transcript,
# unexpected JSON): a broken watcher must never block prompting. CI does not
# backstop this hook; its failure mode is "no warning", which is exactly the
# status quo without it.
set -eu

# Capture stdin FIRST, and hand it to python via env, not a pipe: the heredoc
# below redirects python's stdin to the script itself, so a piped payload
# would be silently discarded. (Caught by testing the warn case, exactly as
# hooks/README.md rule 2 demands; its rule 4 warned about this precise trap.)
STDIN_JSON=$(cat)

command -v python3 >/dev/null 2>&1 || exit 0

CW_PAYLOAD="$STDIN_JSON" python3 - <<'PY' || exit 0
import json, os, sys

THRESHOLD = int(os.environ.get("CONTEXT_WATCH_THRESHOLD", "120000"))
REWARN_STEP = 25000  # after the first warning, warn again only per this much growth

try:
    payload = json.loads(os.environ.get("CW_PAYLOAD", "{}"))
    transcript = payload.get("transcript_path", "")
    session_id = payload.get("session_id", "unknown")
    if not transcript or not os.path.isfile(transcript):
        sys.exit(0)

    tokens = 0
    # Scan the whole file but keep only the last usage block seen; transcripts
    # are append-only JSONL so the last one is the current state.
    with open(transcript, "r", errors="replace") as f:
        for line in f:
            try:
                entry = json.loads(line)
            except ValueError:
                continue
            usage = (entry.get("message") or {}).get("usage")
            if usage:
                tokens = (
                    usage.get("input_tokens", 0)
                    + usage.get("cache_read_input_tokens", 0)
                    + usage.get("cache_creation_input_tokens", 0)
                )

    if tokens < THRESHOLD:
        sys.exit(0)

    stamp = os.path.join("/tmp", f"context-watch-{session_id}")
    last_warned = 0
    try:
        with open(stamp) as s:
            last_warned = int(s.read().strip() or 0)
    except (OSError, ValueError):
        pass
    if last_warned and tokens - last_warned < REWARN_STEP:
        sys.exit(0)
    try:
        with open(stamp, "w") as s:
            s.write(str(tokens))
    except OSError:
        pass

    print(
        f"CONTEXT-WATCH: estimated context occupancy ~{tokens:,} tokens "
        f"(threshold {THRESHOLD:,}). Session quality degrades and cost rises "
        f"as context grows, and auto-compaction is a lossy pass that will "
        f"eventually fire silently. BEFORE doing anything else this turn, put "
        f"an explicit choice to the user: (a) continue in this session, or "
        f"(b) run the session-handover skill: commit a checkpoint, author "
        f"HANDOVER.md, push, then reset context in place with /clear (or a "
        f"fresh session where /clear is unavailable). Recommend (b) unless "
        f"the current task is nearly done. Be clear that /clear wipes memory "
        f"as completely as a new session would; the handover doc is what "
        f"carries the state across, in both cases. Do not decide silently; "
        f"the call is the user's."
    )
except Exception:
    sys.exit(0)
PY

exit 0
