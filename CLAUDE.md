# my-plugin

Claude Code plugin: one skill, one subagent, one slash command, and a PreToolUse hook that blocks destructive Bash commands. See `README.md` for usage.

## Layout

- `.claude-plugin/plugin.json`: manifest. Only the manifest goes inside `.claude-plugin/`.
- `skills/<name>/SKILL.md`: skills. Each needs `name` and `description` frontmatter.
- `agents/<name>.md`: subagents. Frontmatter sets `name`, `description`, `tools`.
- `commands/<name>.md`: slash commands. Frontmatter sets `description`, `argument-hint`, `allowed-tools`.
- `hooks/hooks.json`: hook registration.
- `.mcp.json`: bundled MCP servers under `mcpServers`. Never put secrets in it; use `${ENV_VAR}` expansion.
- `scripts/`: hook scripts, referenced as `${CLAUDE_PLUGIN_ROOT}/scripts/...`.

Components live at the plugin root, not inside `.claude-plugin/`.

## Testing

- Load: `claude --plugin-dir ./my-plugin` (run from the parent directory).
- Check `/skills`, `/agents`, `/hooks`.
- Run the hook tests: `bash tests/test-block-dangerous-bash.sh`. Exit 0 means all cases pass.
- When you add a pattern to `scripts/block-dangerous-bash.sh`, add a blocked case and an allowed near-miss case to the test file.

## Conventions

- Hook scripts must not depend on `jq`. They read JSON from stdin and match with `grep -E`.
- A blocking hook exits 2 and writes the reason to stderr.
- Hook commands must work from Git Bash on Windows and from a POSIX shell.
- Keep `/review` read-only. Do not add edit tools to its `allowed-tools`.
- When adding or removing a component, update the layout and component sections in `README.md`.
- Record every user-visible change under `[Unreleased]` in `CHANGELOG.md`. On release, move it under a new version heading and bump `version` in `.claude-plugin/plugin.json`.

## Notes

- This file guides work inside the plugin directory. Users who install the plugin do not receive it as context.
- The blocklist in `scripts/block-dangerous-bash.sh` is a guardrail, not a security boundary.
