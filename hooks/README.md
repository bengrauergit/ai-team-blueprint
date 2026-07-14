# Hooks — enforcement over prose

The single highest-leverage lesson from running this system: **a rule that
must never slip does not belong in prose. It belongs in a hook, a CI step, or
a database permission.** Models drift on written rules; shell scripts don't.

We learned this the hard way. An audit found the two hardest rules in our
CLAUDE.md — "never push straight to main" and "migrations need sign-off" —
were both silently unenforced: the git hook was never wired (`core.hooksPath`
unset), and the migration tool sat on an auto-approve allowlist. The prose
said one thing; the machine did another, for weeks.

## What's here

| File | Event | What it enforces |
|---|---|---|
| `settings-template.json` | — | Drop into `.claude/settings.json` (tracked in git!) — registers the hooks below and shows the allow/ask permission pattern |
| `pre-commit-check.sh` | PreToolUse (Bash) | Blocks `git commit` when your check command fails (default: `tsc --noEmit` — swap in your linter/tests) |
| `subagent-log.sh` | SubagentStop | Appends one JSONL line per subagent run — measure which agents earn their seats before restructuring the roster |
| `pre-push` | git pre-push | Blocks direct pushes to `main` — merges go through a PR + the review gate |

## Hard-won rules for hooks themselves

1. **Track `.claude/settings.json` in git.** A hook that lives on one machine
   is a guardrail that silently doesn't exist everywhere else (ephemeral
   containers, teammates, cloud sessions). Keep personal permission grants in
   `settings.local.json` (gitignored); keep enforcement in the tracked file.
2. **Verify the hook actually fires.** Run the failure case and watch it
   block. A guardrail you believe is on but isn't is worse than none — it
   buys false confidence. (Our pre-push hook needs
   `git config core.hooksPath .githooks` per clone — we wire it in
   `package.json`'s `postinstall` so `npm install` does it, and CI backstops
   the gap.)
3. **Decide fail-open vs fail-closed deliberately.** `pre-commit-check.sh`
   fails OPEN when the check binary is missing (fresh container before
   install) because CI backstops it; a hook with no backstop should fail
   CLOSED. Write the choice in a comment.
4. **Hook environments are not your interactive shell.** `cd` to the project
   dir explicitly, call binaries by path (`./node_modules/.bin/tsc`, not
   `npx tsc`), and capture stdin before any heredoc consumes it.
