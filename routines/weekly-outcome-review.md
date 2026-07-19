# Routine: weekly outcome review

**Schedule:** end of the working week. (The original is set for Friday 17:30.)

**Job:** read whether the things you shipped actually moved anything. This is
the horizon a one-day sprint cannot see.

**Why it exists:** a daily review answers "did it ship". It cannot answer "did
it matter", because most metrics need more than a day to say anything. Without
this routine, the measure of success gets named at planning time and then
never read, which quietly turns it into paperwork.

Owned by the product owner, not the builder. This is a value question.

---

## The prompt

> Run the weekly outcome review for `<PROJECT NAME>` at `<ABSOLUTE PATH>`. This
> is the product-owner ceremony that reads whether recently shipped slices
> MOVED their outcome metrics. It is NOT a repeat of the daily review.
>
> 1. List the slices that shipped this week, from merged PRs.
> 2. For each, recover the measure of success named when it was planned. If a
>    slice shipped without one, say so plainly: that is a grooming defect worth
>    more than any number in this report.
> 3. Read each measure against real data (query the product's own data, read
>    the analytics, count the real events). Distinguish "moved", "did not
>    move", and "cannot tell yet", and be honest about which. At small user
>    counts, "cannot tell yet" is the most common correct answer and saying it
>    is not a failure.
> 4. Feed the verdicts back into backlog priority: what deserves a follow-up
>    slice, what should be reverted or cut, what was a dead end worth stopping.
> 5. Deliver a short report. Lead with anything that should change what gets
>    built next week.
>
> Label MEASURED (with the query or receipt) versus INFERENCE. Do not modify
> the backlog directly; propose the reordering and let the owner apply it.

---

## Adapt this

- Point step 3 at your real data source, with read-only access. A routine that
  runs unattended should not hold write credentials to your production
  database.
- If you have very few users, keep step 3's honesty clause. A weekly review
  that manufactures signal from six data points is worse than one that says
  "too early".

## The trap, and an honest confession

The trap is a review that reports activity instead of outcomes: "shipped 6
slices, 400 lines" tells you nothing about whether any of it mattered.

## Weekly routines are structurally fragile. Design around it.

In the project this came from, this routine was scheduled and enabled, and had
still never produced a single run. The diagnosis is worth more than the fact:

It had been live for exactly one of its scheduled slots, and the machine was
not running at that moment. The daily routines survived the same outage because
the scheduler caught them up on next launch. The weekly one did not: its missed
slot was two days back by then, and it simply rolled forward to next week.

That is not bad luck, it is arithmetic. A daily routine gets 365 chances a year
and self-heals, because a miss is at most a day old and tomorrow comes quickly.
A weekly routine gets 52, and a single miss costs a whole cycle. Any routine
that fires rarely needs to be **cheap to miss and easy to retry**, not merely
scheduled and hoped for.

**The fix, using a pattern already in this directory:** schedule it DAILY and
put a guard at step 0, so the schedule provides the chances and the guard
provides the discipline. Two conditions, both required to proceed:

1. **Not already done.** No review recorded in the last 6 days. Check the
   backlog file on the main branch AND open PRs, because a routine that opens a
   PR rather than pushing will not show up on main the next morning.
2. **Not too late to be useful.** Only proceed on the intended day or the few
   days after it (Friday through Monday, in the original). A review of last
   week written on a Wednesday is stale, and the next Friday is close enough to
   wait for.

That is four chances instead of one, idempotent by construction, and silent on
the days it has nothing to do. It is the same shape `eod-review-nudge.md` uses,
and it is the right shape for anything that must happen once per period rather
than at one exact instant.

The second condition matters as much as the first. Without it, "catch up a
miss" quietly becomes "run whenever", and a ceremony that fires on an arbitrary
day is one nobody trusts the cadence of.
