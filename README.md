# web-qa-ai-toolkit

An independent AI toolkit for **web and API QA**. It ships three Claude Code subagents.
Two of them are probers that check a locally running API (and, optionally, UI flows). The
third is a fixer that takes one reported bug and applies the smallest fix.

Each agent is a short **runtime container**: it sets the agent's tools and hard limits,
and nothing else. The workflow, severity rules and output format live in the target
project's skill, which the agent finds with the glob
`.claude/skills/**/<agent-name>/SKILL.md` and reads before it does anything.

Sibling toolkit for on-device mobile QA:
[mobile-qa-ai-toolkit](https://github.com/marvnramos/mobile-qa-ai-toolkit).

## What's inside

```text
agents/qa-happy-path.md     golden-path prober: API endpoints, plus UI flows with Playwright MCP tools
agents/qa-chaos-monkey.md   adversarial prober: backend only
agents/qa-bug-fixer.md      fixes one reported finding and commits it on the run branch
scripts/install.sh          copies the agents into a project (or ~/.claude/agents)
```

| Agent | Tools | Writes |
|---|---|---|
| `qa-happy-path` | Bash, Read, Write, Grep, Glob, WebFetch, Playwright MCP browser tools (including `browser_run_code_unsafe`) | Only its findings JSON, the manifest line and evidence, at the paths the brief gives it |
| `qa-chaos-monkey` | Bash, Read, Write, Grep, Glob | Only its findings JSON, the manifest line and evidence, at the paths the brief gives it |
| `qa-bug-fixer` | Bash, Read, Edit, Write, Grep, Glob | The fix. It commits only on the brief's `run_branch`, never pushes, and never installs packages or touches tests, migrations or CI |

## Install

**As a Claude Code plugin:**

```bash
/plugin marketplace add marvnramos/web-qa-ai-toolkit
/plugin install web-qa@web-qa-ai-toolkit
```

**Or copy the agents in** (existing files are never overwritten):

```bash
bash scripts/install.sh /path/to/your/repo   # into <repo>/.claude/agents/
bash scripts/install.sh --user               # into ~/.claude/agents/
```

## Use

Dispatch the agents from a `qa-orchestrator` skill, which hands each one a brief: the base
URL, the test-plan sections to cover, where to write findings and, for the fixer, the
`run_branch` and the finding file to fix. You can also call one directly:

```text
@agent-qa-happy-path cover the "Invoices" section of .qa/test-plan.md
@agent-qa-chaos-monkey try to break the endpoints touched by this branch
```

## Safety

- Both probers **refuse to run against a non-local base URL**. Only `localhost`,
  `127.0.0.1`, and `host.docker.internal` are allowed. They write one BLOCKER finding
  titled `refused: non-local base_url` and stop.
- The probers' `Write` access is limited to their own output files. They never write
  product code.
- The fixer checks it is on `run_branch` before any edit.

## Requirements

- A `qa-happy-path` / `qa-chaos-monkey` / `qa-bug-fixer` skill under the project's
  `.claude/skills/`, defining the workflow, severity rules and findings format. **The
  agents carry none of that themselves**, so without the skills they have nothing to follow.
- A `.qa/` directory for the test plan and findings (`.qa/findings/<run-id>/`)
- For UI flows: the Playwright MCP plugin (`mcp__plugin_playwright_playwright__*` tools)
