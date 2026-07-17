# Setup Guide: Codex

This is the Codex-native implementation of the AI Team Blueprint. It preserves
the product gate, single-builder rule, independent review, bounded delivery
loops, last-hop evidence, and enforcement-first philosophy without relying on
Claude Code agent or Workflow APIs.

## What maps where

| Blueprint concept | Codex surface |
|---|---|
| Always-loaded operating rules | `AGENTS.md` |
| Standing specialist roles | `.codex/agents/*.toml` custom agents |
| Ceremonies and judgment workflows | Plugin skills |
| External systems and production evidence | MCP servers and app connectors |
| Builder/tester orchestration | Codex subagents, directed by `run-build-loop` |
| Command and agent lifecycle enforcement | Plugin hooks and Git hooks |
| Mechanical merge gate | CI and branch protection |

## 1. Install the project template

From this repository, run:

```sh
sh codex/install.sh /absolute/path/to/your/project
```

The installer refuses to overwrite an existing `AGENTS.md`, `BACKLOG.md`, agent
directory, or context document. Merge those files manually when the target
already has project guidance. `--force` exists for a deliberate replacement,
but review the target first.

The template installs:

- the concise always-loaded rules;
- the full thirteen-role roster as project-scoped Codex custom agents;
- conservative subagent limits (`max_threads = 4`, `max_depth = 1`);
- project context and backlog templates;
- a fast local commit-gate stub;
- a direct-push guard and adaptable CI template;
- the production-readiness checklist.

## 2. Adapt the project facts before invoking agents

Fill in `docs/agents/context.md` with the real stack, runtime chain, verification
commands, deployment target, known hazards, and important paths. Do not leave
the runtime and verification maps generic: the last-hop rule depends on them.

Then adapt:

1. `.codex/fast-check.sh` to a deterministic check that normally finishes in
   under 30 seconds.
2. `.github/workflows/ci.yml` to the production build and real test commands.
3. `.codex/agents/data-steward.toml` to the project's domain, or remove it.
4. Role MCP configuration for any production data, GitHub, deployment, browser,
   or analytics tools the role genuinely needs.

Advisors default to a read-only sandbox. The builder and documentation agent
have workspace access. The tester has workspace access because test runners may
create caches, but its instructions prohibit source edits and require an empty
post-test diff.

## 3. Install the plugin

The distributable plugin lives at `codex-plugin/ai-team-blueprint`. It contains
the original thirteen product and engineering judgment skills plus four
Codex-native skills:

- `run-standup`
- `run-sprint-review`
- `run-retro`
- `run-build-loop`

It also bundles two optional hooks:

- a `PreToolUse` commit gate that runs the project's executable
  `.codex/fast-check.sh` before `git commit`;
- a `SubagentStop` usage logger stored in the plugin's writable data directory.

Add the plugin through your Codex plugin development or marketplace workflow,
then review and trust its hooks. Codex intentionally does not trust new or
changed non-managed hooks automatically.

## 4. Wire Git enforcement

Per clone, enable the direct-push guard:

```sh
git config core.hooksPath .githooks
```

Test the failure case. Attempt a dry-run push from the default branch and
confirm the hook blocks it. Configure branch protection where the GitHub plan
supports it; without protection, CI is advisory and the person merging remains
the final gate.

## 5. Start with the minimum team

Although the complete roster is included, begin with:

- `product-owner` for all product input;
- `builder` as the only application-code writer;
- `red-teamer` for significant or difficult-to-reverse decisions.

Add `reviewer`, `tester`, and `security` next. Add other seats only after the
usage log shows a repeated need. Default to the main Codex thread, builder, and
at most one advisor.

## 6. Run the daily loop

1. Invoke `run-standup` from current repository and backlog evidence.
2. Route product input through `product-owner` and choose one groomed slice.
3. Use `run-build-loop` to alternate builder and independent tester, capped at
   five passes.
4. Use the reviewer before merge and security for auth, payments, permissions,
   secrets, migrations, or data access.
5. Open a draft PR with the evidence block and runtime receipts.
6. Invoke `run-sprint-review` at the end of the day.
7. Invoke `run-retro` only after a real learning, and land the learning in
   `AGENTS.md`, a skill, or preferably a mechanical gate.

## Model and nesting choices

Agent files intentionally inherit the parent model so installations do not
pin a model unavailable to the user's account. They do pin reasoning effort by
job shape. Set a demanding available model for product-owner, builder,
red-teamer, reviewer, security, and behavioural-scientist when you want explicit
model control; use a faster model for narrow read-heavy roles.

The template keeps `max_depth = 1`, so the main thread orchestrates every role.
This is cheaper and easier to inspect. Raise it to `2` only if you deliberately
want a child such as product-owner to spawn its own specialists, and accept the
additional cost and fan-out risk.
