#!/bin/sh
# Copy-style gate: this repo publishes prose, and its house style bans
# em-dashes (an AI-writing tell). A written style rule with no gate WILL be
# violated in-tree; this repo eats its own cooking ("durable-by-test").
# The banned character is built from its UTF-8 bytes so this file cannot
# fail its own check.
BANNED=$(printf '\342\200\224')
HITS=$(grep -rn "$BANNED" . --exclude-dir=.git 2>/dev/null)
if [ -n "$HITS" ]; then
  echo "copy-style-check FAILED: em-dash found:" >&2
  echo "$HITS" >&2
  exit 1
fi
echo "copy-style-check: clean"
exit 0
