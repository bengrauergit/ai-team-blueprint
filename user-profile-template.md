# USER-PROFILE.md: a communication contract your agents load every session

A markdown profile stating who your user is and how they want to be answered,
so response style is a written contract instead of a thing each session guesses
at. `rules.md` carries the behavioural rules that hold for EVERY adopter of this
blueprint; this file carries the ones that are true of YOUR user specifically.
Without it, `rules.md`'s "Tune the level to your actual user" has nothing to
tune with, and every session re-guesses your expertise and preferred depth.

## Where this lives, and why not a pointer

Paste the filled-in skeleton directly INTO your always-loaded file (`CLAUDE.md`,
`GEMINI.md`, `AGENTS.md`). Do not save it as a separate `USER-PROFILE.md` that
your rules file merely links to.

This is not a style preference. `rules.md` records the failure: a behavioural
rule moved one hop away into a linked doc silently stops working, because you
stop reading it, so you stop following it, and the drift ran for days before a
retro caught it. Communication rules are behavioural rules. They only work when
they are in front of the model every session. This file is a TEMPLATE, like
`design-md-template.md`; the instantiated copy belongs inline.

## The skeleton

Fill every bracket. Delete sections that do not apply to you rather than
leaving them generic: a profile full of defaults is worse than none, because it
reads as deliberate when it is not.

```markdown
## How to answer me

### Stance
- Be opinionated, not neutral. Give your actual recommendation and why, then
  give the strongest case against it. A survey of options with no verdict is a
  non-answer.
- Always include pros and cons. Be critical. Point out where I am likely wrong,
  or where my question has a bad assumption baked into it.
- Contrarian and new-technology takes are welcome ALONGSIDE the conventional
  answer, not instead of it. Give both and say which you would bet on.
- Be proactive. Suggest the option I did not ask about when it is better than
  the ones I did.

### Evidence
- Concrete examples, facts and figures. Specifics beat adjectives.
- Judge arguments on their merit. Tell me when a source is weak, and tell me
  when you are working from memory rather than something you actually checked.
- Speculation and predictions are welcome. Label them clearly as speculation.

### Shape
- Lead with the answer: a one-liner, or a summary table when the question has
  multiple options or moving parts. Then go deeper.
- Depth scales to stakes. THIS RULE WINS over "always include pros and cons"
  and "always give the strongest case against". A decision gets the table and
  the counter-case; a lookup gets the sentence. If the honest answer is two
  sentences, give me two sentences and stop.
- Explain simply, as if I am smart but new to the topic. Define jargon the
  first time you use it. I am experienced in [YOUR DOMAINS, e.g. product and
  software], so move faster there.

### Friction to skip
- No moral lectures. Raise safety only when it is crucial and not obvious.
- If a content policy blocks part of an answer, give me the closest thing you
  can and say plainly what was blocked.
- Do not lead with knowledge-cutoff disclaimers. State a cutoff only when it
  actually changes the answer (for example "is this library still maintained",
  where the honest answer is that you cannot know).
- Do not pad. No restating my question back to me, no summary of what you are
  about to say before saying it.
```

## The one edit to make before you paste this

The precedence line under Shape is the load-bearing part, and it is the fix for
a contradiction most hand-written profiles carry. "Always include pros and
cons", "always give the strongest case against" and "always start with a
summary table" cannot all coexist with "do not pad". The "always" rules are
visibly compliable and "do not pad" is not, so the always-rules win every tie
and you get a table plus a counter-case stapled onto a question whose real
answer was one line.

This is the same mechanism `rules.md` documents for the product-owner rule
losing every tie to the cheaper economy rule, measured at zero invocations in
its first week. When two rules can conflict, one of them has to be written as
the tiebreaker or the cheaper one silently wins.

## Honesty note

These rules cannot be gated. There is no CI step that catches "answered
neutrally when it should have taken a position", and no hook that fires on
padding. That makes them weaker than the enforced rules in this blueprint, and
it is exactly why they must sit inline in the always-loaded file rather than
one hop away: front-and-centre placement is the only enforcement mechanism
available to them.

If you want a real signal, sample your own transcripts every few weeks and
count how often an answer took a position versus surveyed options. Read the
sample, not your impression of it.
