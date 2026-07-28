---
name: orchestrate-team
description: When a slice decomposes, recommend how to split it across top-level agent invocations, track it, unblock, and flag a mismatch to the human. Leans on the build loop.
---

# orchestrate-team

Lightweight downward orchestration. The engineering lead is primarily the single
builder; invoke this only when a slice GENUINELY decomposes into independent
parts (non-overlapping files, an isolated audit), not to manufacture a team.

**Platform constraint that changes this skill versus the canonical Claude Code
blueprint: Gemini CLI subagents cannot invoke further subagents.** Whichever
agent reaches this skill (typically the builder, via its "Team capability and
orchestration" pillar) cannot spawn nested helpers itself. This skill produces
a decomposition PLAN; only the MAIN SESSION actually dispatches the parts, each
as its own top-level `@agent_name` invocation.

## Steps

1. **Break the work down** (see `estimate-work`) into parts that can run without
   stepping on each other. Name the hazard files that force sequencing.
2. **Recommend an assignment** for each part: which top-level agent should run
   it, with a tight brief and its completion criteria. Hand this plan back to
   the main session rather than spawning anything yourself.
3. **The main session dispatches** each part as a top-level `@agent_name` call
   (or, for a build-shaped part, invokes `run-build-loop`), collects the
   outputs, and returns them to you for tracking and synthesis.
4. **Track and unblock:** review the collected outputs, clear blockers, keep
   every part to the quality bar before it merges.
5. **Bound it.** Each build-shaped part runs `run-build-loop` with its own
   5-pass cap; escalate at the cap with the honest state rather than looping
   forever.
6. **Flag a mismatch** to the human: if a part is repeatedly wrong for the
   agent assigned to it, that is a routing or capability decision for a
   person, not something to paper over.

## Leans on

`run-build-loop` (the engine each build-shaped part runs), the non-overlapping-
file-ownership rule, and the human gate for irreversible steps. True lateral
peer teams (agents messaging each other directly) are not available on this
platform; the recommend-then-main-session-dispatches pattern above is the
working approach today.

## Output

A decomposition plan (parts, hazard files, assignments, completion criteria)
for the main session to dispatch, plus — once those dispatches return — work
tracked to the quality bar, blockers cleared or escalated, and any capability
mismatch flagged for a human decision.
