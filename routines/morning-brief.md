# Routine: morning brief

**Schedule:** weekday mornings, shortly before you normally start. (The
original runs at 07:45.)

**Job:** so your first session of the day starts primed instead of spending its
first ten minutes rediscovering where things are.

**Why it exists:** the standup was memory-anchored and ran at 17:10 one day,
which is a planning ceremony firing after the day it was meant to plan. This
routine anchors the inputs to a clock; the human still makes the plan.

---

## The prompt

> You prepare the morning standup BRIEF for `<PROJECT NAME>` at `<ABSOLUTE
> PATH>`. You prepare inputs. You do NOT plan the day: that decision belongs to
> the owner, made with the main session via the standup ceremony.
>
> Build the brief strictly from repo state, never from memory:
>
> 1. Fetch, then summarise what merged to the main branch since yesterday
>    morning.
> 2. List open PRs awaiting the owner. Flag any whose gate is passing and that
>    only need a merge click.
> 3. Read the current sprint section of `BACKLOG.md`: the goal, its stories,
>    and which acceptance criteria look met versus open. Verify claims against
>    the main branch; do not trust checkboxes.
> 4. Blockers and strays: dirty working-tree files, unmerged branches older
>    than two days, red CI on the main branch.
> 5. If a signed-off P1 exists in the sprint, lead with it.
>
> Deliver a message under 200 words in four parts: SHIPPED / AWAITING YOU /
> NEXT (the P1 or top story) / BLOCKED AND STRAYS. End by pointing at the
> standup ceremony to plan the day.
>
> Do not modify any files. Do not commit. Do not merge.

---

## Adapt this

- `<PROJECT NAME>` and `<ABSOLUTE PATH>`: routines run with no working
  directory context, so absolute paths are not optional.
- The main branch name, if it is not `main`.
- Your backlog file, if the sprint lives somewhere other than `BACKLOG.md`.
- The P1 convention, if your project does not use one.
- The word limit: 200 is deliberately tight. A brief you skim is a brief that
  works.

## The trap

The tempting next step is to let it plan the day, since it has all the inputs.
Resist it. The moment the brief starts deciding, you stop reading it critically
and start rubber-stamping, and you have swapped a thinking ritual for a
notification.
