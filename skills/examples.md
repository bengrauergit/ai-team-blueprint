# Ceremony Skills: Examples

These are example skill definitions for the ceremonies referenced in the blueprint. Create them in your project's `.claude/skills/` directory.

**Two ceremonies a day, not four.** We started with standup, sprint planning, sprint review, and retro as separate daily rituals. Measured over a few weeks: the retro never ran, and standup and planning were the same five-minute conversation held twice. A solo owner does not amortize four daily ceremonies. So: a merged morning ceremony (sync AND plan), an evening close, and a retro that fires only on a real lesson. If you have a team rather than a solo owner, splitting them again may earn its cost; measure before you assume it does.

## Standup (the morning ceremony: sync AND plan the day)

**File:** `.claude/skills/standup/SKILL.md`

```markdown
# Standup + plan the day

Run at the start of each working session. Build everything from repo state, never from memory. The default morning briefs zero agents.

## 1. Gather state
- `git fetch`, then read the log for what merged since the last session. Never trust a stale local snapshot: in a multi-stream setup, assume the world moved.
- List branches and open PRs: what is in flight, what awaits review.
- Read `BACKLOG.md` (keep it short: current sprint plus a "next up" queue of about ten; everything older lives in an archive file you grep, not read).
- Check for uncommitted work: ephemeral containers make it a standing risk.

## 2. Report: shipped / next / blocked
- **Shipped**: what merged, each with its receipt status (verified on the real runtime, or "verified through hop N, unverified beyond").
- **Next**: the one thing to do first, as a thin slice with its measure of success.
- **Blocked**: anything waiting on the owner, each with the exact ask.

## 3. Plan the day
- Propose the day's slices from carry-overs and the queue: each with an outcome, a measure of success, and acceptance criteria including degenerate cases.
- **P1-first guardrail:** if a signed-off P1 is open, it is slice #1. Meta or process work scheduled ahead of it needs an explicit "defer the P1" from the owner, recorded in the sprint notes.
- **Prior-art check:** before committing to build any new deliverable, grep the repo and list branches for an existing version. Parallel streams collide otherwise.
- **Grooming gate:** work enters the sprint only as a groomed story (standard format, checkable acceptance criteria, named outcome). An ungroomed entry goes back to grooming, not into the sprint.
- Brief an advisor only on a named trigger, one lens per question: priorities genuinely unclear → product-owner; entry fuzzy → business-analyst; anything hard to reverse → red-teamer; new paid service or send volume → data-analyst.

## 4. Sign off, then document
Write the agreed plan into `BACKLOG.md` and commit it. The plan is repo memory, not chat memory.
```

## Sprint Review (the evening close)

**File:** `.claude/skills/sprint-review/SKILL.md`

```markdown
# Sprint Review

Run at the end of each working day. The standard is the last-hop rule: a story is "shipped" only with a receipt from the real runtime; otherwise report it as "merged, unverified beyond hop N" and name the missing probe.

1. Diff the sprint plan against reality (`git log`, merged PRs). Per story: shipped-with-receipt / merged-but-unverified / not shipped (carried, cut, or blocked, with why).
2. **Read the measures of success against real numbers.** Run the read-only queries yourself; at small scale these are hand-countable. A measure that turns out never to have been instrumented is a finding: report it and add the instrumentation to the backlog.
3. **Report two workflow-health ratios** (this is how the process stays honest about itself):
   - **Sprint-goal hit rate to date**: goals met versus sprints reviewed, as a running tally. A run of misses means the planning step is broken, not the building step.
   - **Process-vs-product commit split**: commits touching agent/process/config files versus total. A high process share flags a day that built machinery instead of product. We measured 51% on a real week; it was invisible until someone counted.
4. **Read your database's advisors** (security and performance lints): report new ones only, each as a proposed backlog entry.
5. Capture every piece of owner feedback durably in `BACKLOG.md` immediately. Feedback that lives only in chat is lost.

Output: shipped with receipts / carried with reasons / measures read / the two ratios.
```

## Weekly outcome review (the product owner leads)

**File:** `.claude/skills/outcome-review/SKILL.md`

```markdown
# Weekly outcome review

Run once a week. A one-day sprint reads "did it ship"; it cannot read "did it move the needle," which takes longer. This ceremony closes that gap, and it is the product owner's, not a repeat of the daily review.

1. List the slices shipped in the last week that named an outcome metric (not just a done-signal).
2. For each, pull the ACTUAL number for the outcome metric over the week (live query, not recall). Compare against the baseline and the success threshold that was set when the slice was planned.
3. Verdict per slice: moved the needle / no movement / too early (name the date to re-read). A slice that shipped but never moved its metric is a learning, not a success.
4. Feed the verdicts back into prioritisation: kill or pivot what is not working, double down on what is, and re-rank the backlog against the new evidence.

Output: outcomes read against thresholds, and prioritisation adjusted on the evidence. This is the "reflect" half of the intake rhythm at a horizon the daily sprint cannot see.
```

## Retro (event-driven, not ritual)

**File:** `.claude/skills/retro/SKILL.md`

```markdown
# Retro

Run after a day that produced a real process learning or a painful episode. NOT every evening: a retro without a lesson produces ceremony, not process.

1. What worked? What did not? What did we learn about HOW we work (the process, not the feature)?
2. **Land every learning in a durable home, the same day.** A rule that lives only in chat or in one scoped doc does not exist: the next consolidation drops it silently. Two homes count: the always-loaded rules file, and a gate. Prefer both.
3. **Prefer the gate.** If the learning can be a hook, a CI check, or a permission, build that instead of writing a sentence. Prose rules decay; shell scripts do not.
4. Route the rest: process change → the rules file or an agent definition; work → the backlog; facts about external state → your infrastructure docs.

Output: learnings landed in the repo, ideally as enforcement rather than prose.
```

## How to create a skill

1. Create the directory: `mkdir -p .claude/skills/<skill-name>`
2. Create `SKILL.md` inside it with the skill definition
3. Invoke it in Claude Code with `/<skill-name>`

Skills are project-specific: they live in the repo and are available to anyone working in it.
