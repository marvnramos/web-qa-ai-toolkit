# Changelog

## 0.2.0

The agents are now thin runtime containers over their project skills.

- Each agent sets only its tools and hard limits; the workflow, severity rules and output
  format come from the project's `qa-*` skill, which the agent reads first
- The probers write findings JSON plus a manifest line (they now have `Write`, limited to
  their own output files) instead of returning a YAML bug list
- `qa-happy-path` gains `browser_run_code_unsafe`
- `qa-bug-fixer` commits on the brief's `run_branch` (checked before any edit) and never pushes

## 0.1.0

Initial release: the user-level QA agents, made project-agnostic.

- `qa-happy-path`: golden-path API prober that can also drive UI flows with Playwright MCP
- `qa-chaos-monkey`: adversarial API prober (validation, auth, idempotency, error semantics, observability)
- `qa-bug-fixer`: applies one focused fix for a reported bug
- `scripts/install.sh`: installs the agents into a project or `~/.claude/agents`
