---
name: generate-roadmap
description: Turn a ranked backlog into audience-specific roadmap views, surfacing dependencies and risks so nothing blindsides anyone.
---

# generate-roadmap

A roadmap is a communication tool, and different audiences need different views
of the same ranked backlog. Translate, do not just dump the backlog.

## The three views

- **Executive / owner:** business outcomes and rough timelines. What changes for
  the business and roughly when. Not tickets.
- **Engineering:** technical dependencies, constraints, and sequencing. What
  must land before what, and why.
- **Customer / user-facing:** how their problems get solved, in their language.
  No internal jargon, no dates you cannot keep.

## Steps

1. Start from the ranked backlog (see `score-initiatives`).
2. For each initiative, map: the problem it solves, the outcome it drives, its
   dependencies, and its risks.
3. Render each audience view from that mapping, at the altitude that audience
   needs.
4. Surface dependencies and risks explicitly. A roadmap that hides a known risk
   is how a slip blindsides people.

## Output

The requested view(s), each at the right altitude, with dependencies and risks
made explicit rather than buried.
