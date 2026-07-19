# Routine: evening observer

**Schedule:** evening, after work has stopped. (The original runs at 19:30.)

**Job:** watch how the system is actually being used, and report what is
costing time. This is the routine that improves the other routines.

**Why it exists:** every other part of this blueprint reviews the PRODUCT (is
the code right, did the slice ship, did the metric move). Nothing was reviewing
the PROCESS while it ran. Friction is invisible from inside a session: you feel
it, then you forget it by tomorrow.

This is the most valuable routine here and the most expensive to run. Add it
once the cheap two are habitual.

---

## The prompt

> You are the evening observer for `<PROJECT NAME>` at `<ABSOLUTE PATH>`. Run
> this review autonomously; the owner reads the output later.
>
> 1. **OBSERVE the day's work:**
>    - The commit log since this morning, and the working tree for strays.
>    - The agent usage log: how many subagents ran, which types, and any waste
>      signals (three advisors asked the same question, a panel where one lens
>      would do).
>    - Today's session transcripts: extract the owner's actual prompts,
>      corrections ("no, I meant..."), rework, and blocked waits. Sample and
>      grep these; never read whole transcript files. Delegate this to a
>      subagent to keep context lean.
>    - Process adherence against the SOP: did the ceremonies run, was the review
>      gate used before merges, were receipts produced, was the staffing rule
>      respected?
> 2. **RESEARCH (delegate, background):** search for changes in the tooling's
>    best practices from the last few months that are relevant to this setup.
>    Surface only what is NEW versus prior reports.
> 3. **CHECK PRIOR REPORTS** in `<REPORTS DIR>`: read the most recent, track
>    whether earlier recommendations were adopted, and do not repeat an
>    un-adopted recommendation verbatim more than twice. List it as "still
>    open" instead.
> 4. **DELIVER:** write a dated markdown report to `<REPORTS DIR>`. Do NOT
>    commit it; the owner decides what lands. Structure: TL;DR (3 bullets) →
>    what happened today (measured) → top 3 to 5 recommendations, each with its
>    evidence and a concrete first step → tooling news worth adopting →
>    recurring and still-open items. Lead with the single highest-leverage
>    change. Keep it under ~1200 words.
>
> Be specific and evidence-backed; no generic advice. Label MEASURED versus
> INFERENCE.

---

## Adapt this

- `<REPORTS DIR>`: a dated directory like `docs/observations/`. Dated files,
  not one growing file, so trends are readable.
- The usage log only exists if you wired the subagent-logging hook. Drop that
  input if you have not.
- Transcript paths are tool-specific. If your tool does not expose them, the
  routine still works on commits, PRs, and the usage log alone.

## The two rules that keep it honest

**Do not let it commit.** It writes a report; the owner decides what lands in
the repo. An observer that edits the thing it observes has stopped being an
observer.

**Track adoption, and cap repetition.** Step 3 is what stops the report
becoming a monthly newsletter of ignored advice. If a recommendation goes
un-adopted twice, either it is wrong or it is unimportant. Either way, stop
repeating it and say it is still open.

## The receipt

This routine is why the other routines exist. It produced the finding that the
standup was firing at 17:10, which created the morning brief and the end-of-day
nudge. That is a loop that closed: the system observed itself and changed.
