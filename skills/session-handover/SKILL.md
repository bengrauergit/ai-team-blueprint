---
name: session-handover
description: Checkpoint the current session and hand over to a fresh one. Commit WIP, author HANDOVER.md from live context, push, and give the user the exact restart step. Run when the context-watch hook fires or when the user asks to reset the session.
---

# session-handover (checkpoint + fresh start)

Sessions degrade before they die: quality slides and cost rises as context
grows, and auto-compaction is a lossy summarization that fires silently at
the worst moment. This skill converts a bloated session into a durable
checkpoint plus a clean successor. The `context-watch` hook decides WHEN to
offer this; the user decides WHETHER; this skill is the HOW.

The one thing only the live session can do is step 2. A shell script can
commit files; it cannot know which decisions were live, what was tried and
rejected, or what the user was mid-way through deciding. Author the handover
while the context that knows those things still exists.

## 1. Checkpoint the work

- `git status`. Commit anything uncommitted, WIP included, on the current
  working branch, labelled as a checkpoint. Broken state is fine to commit
  here; the point is that nothing exists only in context.
- Do not fold unrelated WIP into one commit blindly: if the tree carries two
  distinguishable pieces of work, two commits.

## 2. Author HANDOVER.md (the judgment step)

Write `HANDOVER.md` at the repo root from live context, not from `git log`.
The log already survives; write down only what does NOT survive:

- **Task state:** what was in progress, exactly where it stopped, the very
  next action.
- **Live decisions:** choices made this session and WHY, especially ones not
  yet visible in code or docs.
- **Dead ends:** what was tried and rejected, and why, so the successor does
  not re-walk them.
- **Open questions:** anything awaiting the user's call, verbatim enough to
  re-ask.
- **Pointers:** branch name, open PR numbers, the commits this session
  produced.

Keep it under a page. A handover nobody reads is a checkpoint that failed;
length is the main reason handovers go unread.

## 3. Push

Push the branch (checkpoint commits and HANDOVER.md included). In an
ephemeral environment, unpushed work does not survive the container; on a
local machine this still makes the handover reachable from any other clone.

## 4. Hand the user the reset, exactly

The default is an in-place reset, not a new session. Never end at "start
fresh"; name the exact step for THIS environment:

- Local CLI (default): "run `/clear`". Same terminal, same directory, one
  command; the cleared context reads `HANDOVER.md` first (a SessionStart
  hook on the `clear` source can inject it automatically; see
  `hooks/README.md`). Be explicit with the user that `/clear` wipes
  conversation memory as completely as a new session would: that wipe is
  what recovers quality and cost, and `HANDOVER.md` is what carries the
  state across it. Never offer "clear" as if it preserved anything.
- Remote/web (where `/clear` may not exist): name the button or command
  that opens a new session against this repo and branch, and say to point
  it at `HANDOVER.md` in its first message. If the environment offers a way
  to spawn the successor session directly, offer to do it, with
  `HANDOVER.md` as its opening prompt.

## 5. Successor's first duty

The first action after the reset (cleared context or new session alike):
read `HANDOVER.md`, confirm the branch matches, then DELETE the file in the
first commit of real work. A stale handover is worse than none; the next
handover writes a fresh one.
