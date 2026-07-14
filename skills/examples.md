# Ceremony Skills — Examples

These are example skill definitions for the Agile ceremonies referenced in the blueprint. Create them in your project's `.claude/skills/` directory.

## Standup

**File:** `.claude/skills/standup/SKILL.md`

```markdown
# Standup

Run at the start of each working session. Build the status from repo state — never from memory.

1. **Shipped** — read `git log` for commits since the last standup (or the last working day). Summarise what shipped.
2. **Next** — read `BACKLOG.md` → Current sprint section. What's the next priority?
3. **Blocked** — check for: failing CI, open review comments, unmerged dependencies, missing env vars, undocumented infra state.

Output: a short summary (shipped / next / blocked) and a proposed priority for today. Ask for confirmation before proceeding.
```

## Sprint Planning

**File:** `.claude/skills/sprint-planning/SKILL.md`

```markdown
# Sprint Planning

Run each morning after standup. A sprint is one working day.

1. Read `BACKLOG.md` — the prioritised backlog.
2. Pick the top-priority item that's ready (has acceptance criteria). If the top item is fuzzy, invoke the business-analyst to groom it first.
3. Confirm the **measure of success** — the signal that tells us this slice worked.
4. Confirm the **acceptance criteria** — including degenerate cases.
5. For non-trivial slices, invoke the red-teamer to pressure-test the plan before committing.
6. Write the day's commitment to the Current sprint section of `BACKLOG.md`.

Output: the day's one thin slice, with outcome, measure, and acceptance criteria confirmed.
```

## Sprint Review

**File:** `.claude/skills/sprint-review/SKILL.md`

```markdown
# Sprint Review

Run at the end of each working day.

1. Read `git log` for today's commits. What shipped?
2. For each shipped slice, check: does it have the receipt (evidence from the last hop)?
3. Read the measure of success from this morning's planning. Can we read the measure yet? If so, what does it say?
4. Note carry-overs — what was planned but didn't ship, and why.
5. Update `BACKLOG.md` — tick shipped entries, note carry-overs.

Output: shipped (with receipts) / carried over (with reasons) / measures read.
```

## Retro

**File:** `.claude/skills/retro/SKILL.md`

```markdown
# Retro

Run after a day with a real process learning — not ritually every evening.

1. What worked well today? (Keep doing)
2. What didn't work? (Stop or change)
3. What did we learn about the process? (The learning, not the feature)
4. What action items come out of this? Route each to the right place:
   - Process change → update `CLAUDE.md` or agent definitions
   - New rule → add to `rules.md` / `CLAUDE.md`
   - Backlog item → append to `BACKLOG.md`
   - Documentation → hand to the documentation agent

Output: learnings landed in the repo (not just discussed).
```

## How to create a skill

1. Create the directory: `mkdir -p .claude/skills/<skill-name>`
2. Create `SKILL.md` inside it with the skill definition
3. Invoke it in Claude Code with `/<skill-name>`

Skills are project-specific — they live in the repo and are available to anyone working in it.
