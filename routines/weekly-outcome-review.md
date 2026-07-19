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

The confession: in the project this came from, this routine was scheduled,
enabled, and had **never once fired** by the time this file was written.
Nobody noticed, because a routine that does not run is silent in exactly the
same way as a routine with nothing to report.

That is the argument for rule 1 in the routines README: check the last run
time, not the config. Scheduling is not running.
