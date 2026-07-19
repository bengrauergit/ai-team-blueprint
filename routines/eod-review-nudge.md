# Routine: end-of-day review nudge

**Schedule:** end of the working day, early enough that acting on it does not
mean working late. (The original runs at 18:15.)

**Job:** make closing the day cost one confirmation instead of one decision.

**Why it exists:** end-of-day reviews were being skipped, which meant slices
shipped and nobody ever read whether their measure of success moved. Skipping
was not laziness: the review was memory-anchored, and by 18:00 the memory is
spent.

---

## The prompt

> You are the end-of-day review nudge for `<PROJECT NAME>` at `<ABSOLUTE
> PATH>`. A sprint is ONE DAY.
>
> 1. Check whether today's review already ran (look for today's entry in the
>    sprint notes or review log). If it did, say so in one line and STOP. Do
>    not produce a second review.
> 2. If it did not, assemble the draft from repo state:
>    - What shipped today, from the commit log and merged PRs.
>    - For each shipped slice: does it carry its receipt (evidence from the
>      real runtime), or is it a claim?
>    - The measure of success named this morning: can it be read yet, and what
>      does it say?
>    - What was planned and did not ship, and why.
> 3. Deliver the draft pre-filled, so closing the day is a confirmation rather
>    than a writing task. Keep it under 250 words.
>
> Label every claim MEASURED (with the receipt) or INFERENCE. Do not modify
> files, commit, or merge.

---

## Adapt this

- The check in step 1 depends on where your reviews land. Point it at the real
  file.
- Adjust the sprint length if a sprint is not one day for you. The nudge only
  makes sense at the cadence your review actually runs.
- If your project has no measure-of-success convention yet, that is the gap to
  fix before adding this routine, not something the routine can paper over.

## The trap

A nudge that fires when the review already ran is noise, and noise is how a
routine teaches you to ignore it. Step 1 exists to make the routine shut up.
Every routine needs its version of step 1.
