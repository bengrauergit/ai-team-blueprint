# Setup Guide: Gemini CLI

This is the Gemini-CLI-native implementation of the AI Team Blueprint. It
preserves the product gate, single-builder rule, independent review, bounded
delivery loops, last-hop evidence, and enforcement-first philosophy without
relying on Claude Code's agent, hook, or Workflow APIs.

**Before you start, know the platform status.** As of this writing, classic
Gemini CLI (the tool this port targets) is in maintenance mode: Google
announced a transition to a new, closed-source tool ("Antigravity CLI") in
May 2026, and free/Pro/Ultra consumer access to Gemini CLI was cut the
following month. This port still targets classic Gemini CLI deliberately: it
remains available to enterprise/Cloud-licensed and paid-API-key users, and on
a feature-by-feature basis it is a strong match for this blueprint (see the
mapping table below). If you're on a plan Gemini CLI no longer serves, this
port isn't usable for you today; check whether Antigravity CLI's actual
config formats (unverified at the time this port was built) end up close
enough to adapt from here.

## What maps where

| Blueprint concept | Gemini CLI surface |
|---|---|
| Always-loaded operating rules | `GEMINI.md` (workspace root) |
| Standing specialist roles | `.gemini/agents/*.md` custom subagents |
| Ceremonies and judgment workflows | `.gemini/skills/*/SKILL.md`, discovered via `activate_skill` |
| Builder/tester orchestration | `run-build-loop` skill, invoking `@builder` / `@tester` |
| Command and agent lifecycle enforcement | `BeforeTool` / `AfterAgent` hooks in `.gemini/settings.json`, plus a native git `pre-push` hook |
| Mechanical merge gate | CI (`.github/workflows/ci.yml`) and branch protection |
| Packaged, one-command install | `gemini-plugin/ai-team-blueprint/` (a Gemini extension) |

## 1. Install the project template

From this repository, run:

```sh
sh gemini/install.sh /absolute/path/to/your/project
```

The installer refuses to overwrite an existing `GEMINI.md`, `BACKLOG.md`,
`.gemini/agents` directory, or `docs/agents/context.md`. Merge those files
manually when the target already has project guidance. `--force` exists for a
deliberate replacement, but review the target first.

The template installs:

- the full, uncondensed operating rules as `GEMINI.md` (see "Why the rules
  file is not condensed" below);
- the full thirteen-role roster as project-scoped `.gemini/agents/*.md` files;
- 17 skills (13 product/engineering judgment skills, 3 ceremony skills, and
  `run-build-loop`);
- optional `.gemini/commands/*.toml` slash-command shortcuts for the three
  ceremony skills;
- project context and backlog templates;
- a fast local commit-gate hook stub;
- a direct-push guard and adaptable CI template;
- the production-readiness checklist.

### Why the rules file is not condensed

This blueprint's own Codex port shipped a condensed `AGENTS.md` that silently
dropped whole rule categories, including the "Working with the user" section
`rules.md` itself explicitly says must never be demoted. This Gemini port
deliberately does not repeat that: `GEMINI.md` is a full port of every section
in the canonical `rules.md`. Gemini's memory model makes this the right call
anyway: `GEMINI.md` files at different levels (your personal
`~/.gemini/GEMINI.md`, this workspace file, any subdirectory-scoped files) are
concatenated together every session rather than overriding each other, so
there's no "make room" pressure the way a single-file-override model might
create. Do not re-condense this file to save space.

## 2. Adapt the project facts before invoking agents

Fill in `docs/agents/context.md` with the real stack, runtime chain,
verification commands, deployment target, known hazards, and important paths.
Do not leave the runtime and verification maps generic: the last-hop rule
depends on them.

Then adapt:

1. `scripts/hooks/pre-commit-check.sh`'s `CHECK`/`CHECK_ARGS` to a
   deterministic check that normally finishes in under 30 seconds.
2. `.github/workflows/ci.yml` to the production build and real test commands.
3. `.gemini/agents/data-steward.md` to the project's domain, or remove it.
4. Each agent's `tools:` list, if your installed Gemini CLI version uses
   different built-in tool names than the ones assumed here (see the
   "Unverified details" section below; check this before your first real
   session, not after something silently doesn't work).

Advisors (product-owner, red-teamer, reviewer, security,
behavioural-scientist, business-analyst, growth-hacker, designer,
data-analyst, data-steward, tester) get an explicit read-only `tools:`
allow-list with no write/edit capability. The builder has no `tools:` key at
all (full access, matching the Claude Code source). Documentation gets
`write_file`/`replace` but its write scope to `docs/` only is a stated
convention, not a mechanically enforced one; see the note in
`.gemini/agents/documentation.md`.

## 3. Install the plugin (optional alternative to step 1)

The distributable extension lives at `gemini-plugin/ai-team-blueprint`. It
repackages the same 13 agents, 17 skills, and 2 hooks as an installable Gemini
CLI extension:

```sh
gemini extensions install /path/to/gemini-plugin/ai-team-blueprint
```

**Do not install this AND the raw project template into the same project.**
Both carry a full copy of `GEMINI.md`; running both loads the operating rules
twice into every session. Pick one path, not both.

Before installing, read `hooks/hooks.json` and the two scripts it registers:
this extension can deny a shell command (the commit gate) and logs subagent
usage. Reviewing an extension's hooks before trusting them is good practice
regardless of source.

The extension also bundles a `.gemini/agents`-equivalent `agents/` directory
for turnkey install, but extension-bundled agents are a Gemini CLI **preview**
feature at the time of writing. If your installed CLI version doesn't load
them, fall back to step 1's raw template path, which uses the stable,
non-preview `.gemini/agents/*.md` mechanism.

## 4. Wire Git enforcement

Per clone, enable the direct-push guard:

```sh
git config core.hooksPath .githooks
```

Test the failure case. Attempt a dry-run push from the default branch and
confirm the hook blocks it:

```sh
git push --dry-run origin HEAD:main
```

Configure branch protection where your Git host's plan supports it; without
protection, CI is advisory and the person merging remains the final gate.

## 5. Start with the minimum team

Although the complete roster is included, begin with:

- `product-owner` for all product input;
- `builder` as the only application-code writer;
- `red-teamer` for significant or difficult-to-reverse decisions.

Invoke each manually with `@product-owner`, `@builder`, `@red-teamer` while
you're getting the hook and rules setup right; add `reviewer`, `tester`, and
`security` next. Add other seats only after the usage log
(`docs/agents/usage-log.jsonl`, populated by the `AfterAgent` hook) shows a
repeated need. Default to the main Gemini CLI session, the builder, and at
most one advisor.

## 6. Run the daily loop

1. Invoke the `run-standup` skill from current repository and backlog
   evidence (or type `/standup` if you kept the optional command wrapper).
2. Route product input through `@product-owner` and choose one groomed slice.
3. Use the `run-build-loop` skill to alternate `@builder` and independent
   `@tester`, capped at five passes.
4. Use `@reviewer` before merge and `@security` for auth, payments,
   permissions, secrets, migrations, or data access.
5. Open a draft PR with the evidence block and runtime receipts.
6. Invoke `run-sprint-review` at the end of the day.
7. Invoke `run-retro` only after a real learning, and land the learning in
   `GEMINI.md`, a `.gemini/agents/*.md` file, or preferably a mechanical gate.

## Known gaps versus the canonical Claude Code blueprint

Named explicitly, not silently absorbed:

- **No native scheduler.** Gemini CLI has no equivalent of a cron-triggered
  session (a GitHub feature request for this is closed/backlogged upstream).
  The canonical blueprint's clock-anchored "routines" (morning brief, EOD
  nudge, weekly outcome review) have no native home here; you need an
  external scheduler (cron, a CI schedule, or a harness-level trigger
  mechanism if you're running inside one) to fire them.
- **No schema-validated build-loop verdict.** The canonical blueprint's
  `workflows/build-loop.js` uses Claude Code's native Workflow tool to
  request a JSON-Schema-typed tester verdict, with the platform rejecting a
  malformed response. Gemini subagents return free text; `run-build-loop`
  substitutes a strict text convention instead, with no platform-level
  enforcement that the tester actually followed it.
- **No live token-budget escalation floor.** The same Workflow tool exposes a
  live `budget.remaining()` check the source build loop uses to escalate
  early. `run-build-loop` substitutes tightened `max_turns`/`timeout_mins` on
  the builder and tester agent files as a bounded-turns proxy, not a real
  budget check.
- **`GEMINI.md` composes additively, not by override.** Your personal
  `~/.gemini/GEMINI.md` and any subdirectory-scoped files get concatenated
  alongside this project's `GEMINI.md` every session. This project's rules
  are never the only content in context the way a single always-loaded file
  might be elsewhere.
- **Extension-bundled `agents/` is a preview feature** (see step 3).
- **Gemini subagents cannot invoke further subagents.** The canonical
  blueprint's `orchestrate-team` skill and the product-owner's "hub" pattern
  both originally assumed nested subagent spawning. Both were rewritten for
  this port: the relevant agent recommends a decomposition, and the MAIN
  SESSION dispatches each part as a top-level `@agent_name` call.

## Unverified details: confirm before you rely on the hooks

Two things in this port are stated as best-effort inference, not confirmed
fact, because no live Gemini CLI install was available while building it:

1. The `BeforeTool` matcher's shell-tool name in `.gemini/settings.json` and
   `hooks/hooks.json` (currently `run_shell_command`).
2. The `AfterAgent` payload's field name for the invoked agent's identity in
   `scripts/hooks/subagent-log.sh` (currently assumed to be `agent_type`, by
   analogy with Claude Code's own hook payload).
3. (Plugin only) Whether `${extensionPath}` substitution, confirmed for an
   extension's `mcpServers` block, also resolves inside `hooks.json` commands.

Run the failure case for each hook after install: attempt a commit that
should fail the gate and confirm it's actually denied, before trusting any
of this in a real session. This is the blueprint's own "verify every
guardrail actually fires" rule, applied to its own port.

## Model and nesting choices

Agent files intentionally leave `model:` unset so installations do not pin a
model unavailable to your account. The canonical blueprint's Opus/Sonnet/Haiku
tiering shows up as comments next to the relevant agents; set an explicit
`model:` per file if you want direct control. `temperature` is set low
(`0.2`–`0.3`) on the narrowest, most well-scoped roles (tester, documentation,
data-steward, red-teamer) where determinism is more valuable than variety;
leave it unset elsewhere.

Subagents cannot invoke further subagents on this platform (no `max_depth`
knob to raise, unlike the Codex port); orchestration stays with the main
session by design, not by a configurable limit. See "Known gaps" above.
