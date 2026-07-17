#!/bin/sh
# ADAPT to the project's fast, deterministic pre-commit gate (target <30s).
# Keep the production build and slower suites in CI.
set -eu

if [ -f package.json ] && command -v npm >/dev/null 2>&1; then
  npm test -- --runInBand
  exit 0
fi

printf '%s\n' "Adapt .codex/fast-check.sh for this project's stack." >&2
exit 1
