# Routines: the ceremonies, anchored to a clock instead of a memory

Hooks stop you doing the wrong thing. Routines make sure the right thing
happens at all. Both exist for the same reason: a rule that depends on someone
remembering it is not a rule, it is a hope.

## Why this layer exists (the measured finding)

The ceremony layer was the weakest part of this system for weeks, and not
because the ceremonies were wrong. They were simply memory-anchored: they
happened when the owner remembered them, which meant late or not at all.

Two observations from a real project, both recorded the day they were found:

- The morning standup ran at **17:10**. A ceremony whose entire job is to plan
  the day is worthless when it fires after the day is over.
- End-of-day reviews were **being skipped entirely**, so slices shipped with
  nobody reading whether their measure of success moved.

Neither was a discipline problem. Both were a design problem, and the fix is
the same one the enforcement layer already applies to rules: if it must not
slip, do not leave it to memory. Anchor it to a clock.

## The distinction worth keeping

| | Fires on | Job |
|---|---|---|
| **Hook** | An action you take (commit, push) | BLOCK the wrong thing |
| **Routine** | A time you set (07:45, Friday 17:30) | TRIGGER the right thing |

A system with only hooks is safe but inert: it never starts anything. A system
with only routines is busy but unguarded. You want both.

## The five rules that keep a routine useful

Learned by getting these wrong first.

1. **Prepare, don't decide.** A routine assembles inputs; the human (with the
   main session) makes the call. The morning brief says what shipped, what is
   waiting, and what is blocked. It does NOT plan the day. The moment a routine
   starts deciding, you stop reading it, because it is no longer telling you
   anything you have to think about.

2. **Read-only by default.** Routines run unattended, so they do not commit, do
   not merge, and do not modify code. A routine that writes a report file is
   fine. A routine that pushes is a robot with your credentials and no
   supervision.

3. **Build from repo state, never from memory.** The routine has no memory of
   yesterday and should not pretend otherwise. Everything it reports comes from
   `git log`, open PRs, the backlog file, CI status. Same rule the whole
   blueprint runs on: the repo is the only thing that persists.

4. **Close a loop, or do not exist.** Every routine names what comes back
   around and who reads it. A routine that generates output nobody acts on is a
   queue draining into the owner's attention, which is the scarcest resource in
   a solo system. (See `../loops.md`: loops must CLOSE and must EXIT.)

5. **Silent no-op when there is nothing to say.** No groomed stories, nothing
   shipped, nothing blocked: say nothing. Routines that speak every day
   regardless of signal train you to ignore them, and then the one that matters
   gets ignored too.

## The four routines

Copy the ones that fit; delete the rest. Each is a template with the
project-specific parts marked.

| Routine | When | What it does |
|---|---|---|
| [`morning-brief.md`](morning-brief.md) | Weekday morning, before your first session | Assembles shipped / awaiting you / next / blocked from repo state |
| [`eod-review-nudge.md`](eod-review-nudge.md) | End of the working day | Checks whether the review ran; if not, delivers a pre-filled draft |
| [`evening-observer.md`](evening-observer.md) | Evening, after work stops | Reviews the day's sessions for friction and process drift, writes a dated report |
| [`weekly-outcome-review.md`](weekly-outcome-review.md) | End of the week | Reads whether shipped slices moved their metrics, the horizon a one-day sprint cannot see |

Start with the morning brief and the end-of-day nudge. Those two directly fix
the memory-anchoring problem, and they are cheap. The observer is the most
valuable and the most expensive; add it once the first two are habitual.

## The loop that closed

Worth stating plainly, because it is the argument for the whole layer: the
evening observer produced the finding that the standup was running at 17:10.
That finding created the morning brief and the end-of-day nudge. A routine
observed the system, and the system changed as a result.

That is a loop that closes, which is the test `loops.md` sets for whether a
loop is real or just a generator pointed at your inbox.

## Measure them, then cut

Routines are cheap to add and easy to accumulate, which is exactly the pattern
that produced the roster-proliferation problem the rules warn about. Apply the
same discipline:

- **Check they actually ran.** A scheduled task that silently stopped firing is
  worse than no task, because you believe it is covering you. Look at the last
  run time, not the config.
- **Check you read the output.** If the last three reports went unread, the
  routine is not earning its slot. Delete it or change it.
- **Never let a routine grow into a workday.** If a routine's output needs more
  than a few minutes of attention, it has stopped preparing and started
  generating work.

An honest example from the project this came from: the weekly outcome review
was scheduled and enabled, and had **never fired a single run** by the time
this was written. Scheduling a routine is not the same as it working. Check.
