# ai-team-blueprint (Gemini CLI extension)

A packaged Gemini CLI extension version of the [ai-team-blueprint](https://github.com/bengrauergit/ai-team-blueprint):
13 specialist subagents, an always-loaded operating-rules file, enforcement
hooks, and 17 invocable skills for running a disciplined AI software delivery
team, solo or on a small team.

Gemini's `gemini-extension.json` manifest has no field for the metadata below
(author, license, category, example prompts), unlike the equivalent Codex
plugin manifest, hence this README carries it instead.

- **Author:** Ben Grauer ([github.com/bengrauergit](https://github.com/bengrauergit))
- **License:** MIT
- **Homepage / repository:** https://github.com/bengrauergit/ai-team-blueprint
- **Category:** Productivity
- **Capabilities:** Interactive, Write (the `builder` and `documentation`
  agents write; every other agent is read-only, enforced via each agent's
  `tools:` allow-list)

## Example prompts

- "Run standup and choose today's thinnest valuable slice."
- "Route this product idea through the product-owner intake gate."
- "Run the bounded build loop for this story." (invokes the `run-build-loop` skill)

## Install

```
gemini extensions install <path-or-github-url-to-this-directory>
```

This copies the extension into `~/.gemini/extensions/`. `gemini extensions update`
picks up changes on future releases.

## Before you install: two things to trust-review

1. **`hooks/hooks.json`** registers a `BeforeTool` hook that can DENY a shell
   command (the commit gate) and an `AfterAgent` hook that logs subagent usage.
   Read `scripts/pre-commit-check.sh` and `scripts/subagent-log.sh` before
   installing an extension whose hooks you have not reviewed; this is good
   practice for any extension, not specific to this one.
2. **Two hook-config details are unverified against a live Gemini CLI
   install**, carried over from the raw project-template port: the exact
   `BeforeTool` matcher string for the shell-execution tool, and whether
   `${extensionPath}` substitution actually resolves inside `hooks.json`
   commands (confirmed for `mcpServers`, not separately confirmed here). If
   the hooks silently don't fire after install, start there.

## Known gaps

See the parent repo's `docs/gemini-setup-guide.md` for the full list. In short:
no native scheduler exists for the clock-anchored ceremonies the canonical
Claude Code blueprint calls "routines" (external cron/CI is still required);
the `run-build-loop` skill has no schema-validated tester verdict or live
token-budget floor, both losses relative to Claude Code's native Workflow
tool, and both named explicitly in the skill body; and the `agents/` directory
bundled in this extension is a Gemini CLI PREVIEW feature; if your installed
CLI version doesn't yet load extension-bundled agents, copy the same files
from `gemini/project-template/.gemini/agents/*.md` into your project directly
instead (the tested, non-preview path).

**Do not install both this extension AND the raw `gemini/project-template/`
into the same project.** Both carry a full copy of the operating rules in
`GEMINI.md`; installing both loads that content twice into every session.
Pick one.
