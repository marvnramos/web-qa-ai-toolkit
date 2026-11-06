# web-qa-ai-toolkit

An independent AI toolkit for **web and API QA**. It ships three Claude Code subagents.
Two of them are read-only probers that check a locally running API (and, optionally, UI
flows). The third is a fixer that takes one reported bug and applies the smallest fix.

Each agent is a runtime container. The detailed playbook lives in the target project's
skill, which the agent finds with the glob `.claude/skills/**/<agent-name>/SKILL.md`.
Targets come from the project's `.qa/config.yml` and `.qa/test-plan.md`.

Sibling toolkit for on-device mobile QA:
[mobile-qa-ai-toolkit](https://github.com/marvnramos/mobile-qa-ai-toolkit).

## What's inside

```text
agents/qa-happy-path.md     golden-path prober: API endpoints, plus UI flows with Playwright MCP tools
agents/qa-chaos-monkey.md   adversarial prober: validation, auth/authz, idempotency, error semantics
agents/qa-bug-fixer.md      fixes one reported bug, re-runs its repro, returns a fix summary
scripts/install.sh          copies the agents into a project (or ~/.claude/agents)
```

| Agent | Tools | Writes code |
|---|---|---|
| `qa-happy-path` | Bash, Read, Grep, Glob, WebFetch, Playwright MCP browser tools | No |
| `qa-chaos-monkey` | Bash, Read, Grep, Glob | No |
| `qa-bug-fixer` | Bash, Read, Edit, Write, Grep, Glob | Yes: the fix only. It never commits, installs packages, or touches tests, migrations or CI |

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

```text
@agent-qa-happy-path cover the "Invoices" section of .qa/test-plan.md
@agent-qa-chaos-monkey try to break the endpoints touched by this branch
```

Or dispatch them from a `qa-orchestrator` skill, which passes `base_url`, `sections`, and
optionally the PR diff.

The probers return a YAML list of bugs, and an empty list means everything passed:

```yaml
- title: <verb-led, one line>
  severity: BLOCKER | HIGH | MEDIUM | LOW
  endpoint: <method + path>
  repro: |
    <minimal curl invocation>
  expected: <what should happen>
  actual: <what did happen>
  path_hint: <file path or null>
```

## Safety

- Both probers **refuse to run against a non-local `base_url`**. Only `localhost`,
  `127.0.0.1`, and `host.docker.internal` are allowed.
- The probers have no `Edit` / `Write` tools.
- A probe the agent can't run comes back as a `LOW` bug titled `probe gap: <reason>`. It
  is never skipped silently.

## Requirements

- A project with `.qa/config.yml` (`api.base_url`, `api.health_path`) and `.qa/test-plan.md`
- A `qa-happy-path` / `qa-chaos-monkey` / `qa-bug-fixer` skill under the project's `.claude/skills/`
- For UI flows: the Playwright MCP plugin (`mcp__plugin_playwright_playwright__*` tools)
