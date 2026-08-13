# Variant: stlaaaag

Seven agents: six of the roles in `agents/templates/` after being merged back
against your current versions, plus one new seat with no upstream equivalent.
Includes what the usage log says about them and what the merge turned up.

Nothing here replaces anything. These are additive copies for cherry-picking.
Where your template is ahead of this variant, that is said below.

## Provenance and scope

Taken from a pre-publication copy of these templates around 8 July 2026, which
is before this repo's first commit on 14 July. It ran independently for five
weeks, then on 13 August it was merged back against the current templates. So
this is a fork that diverged and came home, not a parallel invention.

The context is largely non-software: documents, strategy decisions and small web
interfaces rather than a codebase with a running test suite. So the evidence
below is strongest on prose, decisions and UI, and weakest on the parts of the
blueprint that assume tests, CI and a deploy pipeline.

Naming: each template was given a human first name, because "@jackson red-team
this" is a thing you type without thinking and "@red-teamer" is not. One carries
a prefix rather than a bare first name. Its original name collided with a human
who appeared in the same prompts and it was ambiguous within a day, so prefix
any agent whose name could also belong to someone in the room.

## What the log says

53 invocations between 8 July and 10 August, reconstructed by parsing local
session transcripts and de-duplicating. That reconstruction was only necessary
because `hooks/subagent-log.sh` was not installed. The rule in `rules.md`
("measure before you elaborate the roster") is correct and this variant learned
it the slow way. The hook is installed now.

| Variant | Template | Calls | Share |
|---|---|---:|---:|
| jackson | red-teamer | 22 | 42% |
| bens-nikhil | behavioural-scientist | 18 | 34% |
| sylvia | product-owner | 9 | 17% |
| brendan | builder | 3 | 6% |
| taichi | growth-hacker | 1 | 2% |
| glyndon | data-steward | 0 | 0% |
| hannah | (new) | n/a | added 13 Aug |

Two seats do three quarters of the work.

## The finding worth reading: the gatekeeper starves without a rival

`rules.md` carries a measured lesson from this repo's own running system: zero
product-owner invocations in the rule's first week, because an unscoped "at most
one advisor, multi-agent is expensive" economy rule beat the routing rule every
tie, so the gatekeeper silently never spawned.

This variant reproduces the starvation independently, with no economy rule
written down anywhere. The product owner took 17% of 53 calls against the
red-teamer's 42%. The pattern is consistent: work arrived already framed as a
thing to critique, and the seat that frames work got skipped in favour of the
seat that attacks it. Nobody decided this. It is just that "pressure-test this"
is an easier thought to have than "should this exist".

So the failure mode does not need a competing economy rule to appear. A cheap,
obvious, satisfying seat outcompetes the gatekeeper on its own. The receipt
requirement in `rules.md` (her framing, from her own spawn, quoted in the story)
looks like the right fix and it is stronger than anything this variant had.

## A trap worth documenting, even though your files avoid it

If a template with a restrictive `tools:` line tells the agent to invoke a skill,
`Skill` must be in that list or the instruction is silently inert. This variant
added "invoke the `/minto` skill" to five advisors over several weeks and never
added the tool, so Minto never once ran. No error, no warning: the agent just
writes something Minto-shaped by hand and nobody notices.

Your current templates do not have this bug. `product-owner` lists `Skill`
explicitly, and `builder` and `reviewer` have no `tools:` line so they inherit
it. But the two facts that make the trap live are both true here: skills are a
first-class part of the design, and most templates carry a restrictive tools
list. The next template that gains a skill reference is one line away from it.

Suggestion: a line in `rules.md` under the enforcement section, something like
"a skill reference in a template with a `tools:` line is dead unless `Skill` is
in that list; grep for it when you add one." Cheap, and it is exactly the
"rules need landing spots and gates" pattern already in that file.

## What the merge took from you

**sylvia (product-owner).** This variant was 7.5KB against your 9.6KB and was
straightforwardly behind. It has been rebuilt on your current template and now
carries adversarial-by-default, the GTD intake rhythm, the eight pillars, the
orchestration hub, and the scale-matched prioritisation toolkit. That last one
is the best thing in the file: refusing RICE and A/B significance on thin data,
and saying so, rather than manufacturing false confidence. Kept from the
variant: the thin-slice framing, acceptance criteria that include the degenerate
cases (empty list, missing name, zero items), the explicit cut list with where
each cut item is parked, and the disambiguating-query rule.

**brendan (builder).** Took red-before-green (encode the reproduction as a
failing check before fixing), trade-off transparency, the six pillars,
scale-aware-not-scale-obsessed, and the bounded five-pass escalation. Kept from
the variant: the concrete runtime map with the measured sagas behind each entry,
and the production access rules below.

## What this variant has that yours does not

**An explicit production access boundary (in brendan).** Your builder says "you
have production read access, use your MCP connectors". This variant draws the
line as a section: read-only SQL, logs, advisors and deployment metadata are
free and should be used proactively as verification receipts; writes, remote
migrations, env vars and dashboard settings are never direct; schema changes go
on a branch first with sign-off; never merge to main, never force-push without
narrow authorisation. Worth pulling back as a block.

**A "say so when you are the wrong lens" section, on every advisor.** Measured
failure: pointed at a routine cleanup with nothing in it to argue with, the
red-teamer still returned a confident verdict, and the reaction was that this
was a bad use of the seat. An advisor will always be ABLE to produce its
artifact. That is not the same as the artifact being worth its cost, and the
agent is the only one positioned to say so before the tokens are spent. Each
advisor now has a short section telling it to lead with "this doesn't need me,
it needs X" and stop. Taichi's version leans on his own scale gate; glyndon's
tells him to say when a project has no domain data to steward at all.

**hannah, a data analyst for file-based evidence.** Your `data-analyst` assumes
live prod SQL ("always SELECT from production, never quote a number from a
doc"). That is right for a product with a database and wrong for anyone whose
data arrives as exports: CSVs, workbooks, vendor PDFs, accounting statements.
Hannah keeps the spirit and inverts the mechanic: go to the primary export
rather than a summary or a previous analysis, inspect distinct values and
normalise before aggregating, check the basis before comparing two sources
(bookkeeping versus cash, gross versus net, order date versus dispatch date, a
90-day window versus a year), never report revenue without units or a
percentage without its denominator, run the counterfactual before concluding,
and never fill a gap with a plausible number. She keeps your FILE-BASED versus
LIVE labelling rule verbatim, because it is the right rule in both worlds.

## Deliberate non-adoption, and why

You have six roles this variant did not install: reviewer, designer, tester,
security, business-analyst, documentation. All were read, none were taken. The
log above says two seats do 75% of the work and one has never run at all, so
adding six idle seats is the exact failure `rules.md` warns about. Only hannah
went in, because the log showed a real unserved question rather than an
unoccupied role. Recording the non-adoption because "we read them and chose not
to" is more useful to you than silence.

## The tuning lesson that cost the most

The red-teamer is slow and token-hungry. Opus at high effort, and a real
red-team is minutes. The obvious fix was tried and it was wrong: cap him at the
top two to four assumptions, cap output around 600 words, drop the Minto skill.
The user's response, which is the useful part:

> I think you nerfed him too hard. He is known for being really thorough. He'd
> do the deep research and check all the documents. But yes, efficiently.

The rule that came out of it:

> Buy speed with mechanics, never with coverage. Parallel tool calls, skim the
> structure then deep-read only what matters, do not re-verify a fact that
> arrives with a receipt, weight depth by stakes times doubt. Never cap the
> number of assumptions checked and never cap output length.

The cost dial that does work is model tier. Sonnet for routine passes, Opus for
decisions that matter. That costs no coverage.

## One more, undocumented anywhere

Adjudicating someone else's review comments. Given a few dozen review comments
across two documents, the red-teamer sorted them into accept, push back and
defer with a reason each. It turned a demoralising pile into a tracker that was
worked through in one sitting. This is one of his best uses and it appears in no
description field, so nothing routes to it.

## Note on style

These copies were converted to this repo's house style: em-dashes replaced with
commas, colons and full stops so `scripts/copy-style-check.sh` passes on the
whole tree. The conversion was verified programmatically to change punctuation
only, by normalising both versions and comparing.
