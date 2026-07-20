# DESIGN.md: a design-system spec your agents can build from

A markdown design-system brief an agent loads BEFORE generating UI, so new
screens come out consistent with your system instead of reinvented per prompt.
This is a GENERATION-time scaffold: its proven use is one-shot scaffolding of
new UI from a written spec. It can also serve as a review reference, but only
after you adapt it with your app's REAL tokens (see the honesty note at the
end).

Format credit: the 9-section structure comes from
voltAgent/awesome-claude-design (github.com/voltAgent/awesome-claude-design),
which curates brand-inspired examples of this format. Write your own; do not
import a brand's.

## The nine sections

Copy this skeleton into `DESIGN.md` at your repo root and fill each section.
Concrete values beat adjectives everywhere: "16px base, 1.5 line height" not
"comfortable spacing".

```markdown
# DESIGN.md

## 1. Visual theme and atmosphere
One paragraph: the feel (calm, dense, playful), the references, what it is NOT.

## 2. Colour palette and roles
Every colour as a token with a ROLE, not just a hex: background, surface,
primary action, destructive action, success, warning, muted text. State the
contrast expectations (e.g. body text >= 4.5:1).

## 3. Typography rules
Families, the size scale, weights, line heights, and where each level is used.

## 4. Component stylings
Buttons (each variant), inputs, cards, tables, badges: corner radius, borders,
padding, hover/focus/disabled states.

## 5. Layout principles
Grid, spacing scale, max widths, alignment rules, density.

## 6. Depth and elevation
Shadows, layering, what floats and what sits flat.

## 7. Do's and don'ts
The explicit taste rules an agent cannot infer: "never centre body text",
"one primary action per view".

## 8. Responsive behaviour
Breakpoints and what changes at each; touch target minimums.

## 9. Agent prompt guide
Instructions TO the agent using this file: which sections are law vs
suggestion, what to do when a needed token is missing (ask, do not invent),
and the order to apply rules in.
```

## How to use it

- **Generating new UI:** the builder (or designer) loads DESIGN.md before any
  UI work, and the new screen inherits the system. This is where the format
  has proven value.
- **Reviewing UI (only after adaptation):** to review diffs against it, first
  replace aspirational values with your app's REAL tokens (export them from
  your actual CSS variables or theme module) and add your accessibility rules.
  A generation scaffold reviewed against literally will flag your real app as
  "wrong"; adapt first.

## The honesty note (learned by measuring, not guessing)

Before adopting this as a REVIEW contract, check whether you need one: if your
design system already lives in legible code (typed theme modules, CSS
variables), the code IS the contract and a markdown copy of it will drift.
When we measured our own reference project, a month of heavy UI churn showed
zero design-token rework a contract would have prevented; what it DID surface
was a forked palette between the web theme and hand-rolled email styles, and
the fix for that was a shared token module, not a document. Measure your own
churn before writing a contract for it.
