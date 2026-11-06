# Changelog

## 0.1.0

Initial release: the user-level QA agents, made project-agnostic.

- `qa-happy-path`: golden-path API prober that can also drive UI flows with Playwright MCP
- `qa-chaos-monkey`: adversarial API prober (validation, auth, idempotency, error semantics, observability)
- `qa-bug-fixer`: applies one focused fix for a reported bug
- `scripts/install.sh`: installs the agents into a project or `~/.claude/agents`
